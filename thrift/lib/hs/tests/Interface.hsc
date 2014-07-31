{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE CPP #-}
{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Interface
       ( SerializedResult(..)
       , c_serializeBinary
       , c_deserializeBinary
       , c_serializeCompact
       , c_deserializeCompact
       , c_serializeJSON
       , c_deserializeJSON
       , c_deleteSResult
       , c_newStructPtr
       , c_freeTestStruct
       ) where

import Data.Functor
import Data.Maybe
import Data.Text.Lazy.Encoding
import Foreign.C.String
import Foreign.C.Types
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array
import Foreign.Ptr
import Foreign.Storable
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as LBS
import qualified Data.HashMap.Strict as Map
import qualified Data.HashSet as Set
import qualified Data.Vector as Vector

import Hs_test_Types

data SerializedResult = SR CString Int
data CTestStruct

instance Storable SerializedResult where
  sizeOf _ = (#size SerializedResult)
  alignment = sizeOf
  peek ptr = do
    str <- (#peek SerializedResult, str) ptr
    CInt len <- (#peek SerializedResult, len) ptr
    return $ SR str (fromIntegral len)
  poke ptr (SR str len) = do
    (#poke SerializedResult, str) ptr str
    (#poke SerializedResult, len) ptr len

instance Storable Foo where
  sizeOf _ = (#size Foo)
  alignment = sizeOf
  peek fPtr = do
    CInt bar <- c_getFooBar fPtr
    CInt baz <- c_getFooBaz fPtr
    return $ Foo bar baz
  poke fPtr (Foo bar baz) = c_fillFoo fPtr (CInt bar) (CInt baz)

instance Storable CTestStruct where
  sizeOf _ = (#size CTestStruct)
  alignment = sizeOf
  peek _ = return undefined
  poke _ _ = return ()

instance Storable TestStruct where
  sizeOf _ = (#size TestStruct)
  alignment = sizeOf
  peek ptr = alloca $ \cStructPtr -> do
    c_readStruct cStructPtr ptr

    -- Get Primatives
    CSChar  bool    <- (#peek CTestStruct, f_bool)   cStructPtr
    CSChar  byte    <- (#peek CTestStruct, f_byte)   cStructPtr
    CShort  i16     <- (#peek CTestStruct, f_i16)    cStructPtr
    CInt    i32     <- (#peek CTestStruct, f_i32)    cStructPtr
    CLong   i64     <- (#peek CTestStruct, f_i64)    cStructPtr
    CFloat  float   <- (#peek CTestStruct, f_float)  cStructPtr
    CDouble double  <- (#peek CTestStruct, f_double) cStructPtr
    CInt    o_i32   <- (#peek CTestStruct, o_i32)    cStructPtr
    CSChar  o_isset <- (#peek CTestStruct, o_isset)  cStructPtr
    -- Get String
    chrPtr <- (#peek CTestStruct, f_string) cStructPtr
    string <- LBS.fromStrict <$> BS.packCString chrPtr

    -- Get List
    listPtr <- (#peek CTestStruct, f_list) cStructPtr
    CInt listLen <- (#peek CTestStruct, f_list_len) cStructPtr
    list <- map (\(CShort i) -> i) <$> peekArray (fromIntegral listLen) listPtr

    -- Get Map
    mapKeyPtr <- (#peek CTestStruct, f_map_keys) cStructPtr
    mapValPtr <- (#peek CTestStruct, f_map_vals) cStructPtr
    CInt mapLen <- (#peek CTestStruct, f_map_len) cStructPtr
    keys <- map (\(CShort i) -> i) <$> peekArray (fromIntegral mapLen) mapKeyPtr
    vals <- map (\(CInt i) -> i) <$> peekArray (fromIntegral mapLen) mapValPtr
    let themap = Map.fromList $ zip keys vals

    -- Get Set
    setPtr <- (#peek CTestStruct, f_set) cStructPtr
    CInt setLen <- (#peek CTestStruct, f_set_len) cStructPtr
    set <- map (\(CSChar i) -> i) <$> peekArray (fromIntegral setLen) setPtr

    -- Get Inner Struct
    foo <- (#peek CTestStruct, foo) cStructPtr >>= peek

    -- Pack Everything
    c_freeBuffers cStructPtr
    return TestStruct{
      testStruct_f_bool   = toEnum $ fromIntegral bool,
      testStruct_f_byte   = byte,
      testStruct_f_i16    = i16,
      testStruct_f_i32    = i32,
      testStruct_f_i64    = i64,
      testStruct_f_float  = float,
      testStruct_f_double = double,
      testStruct_f_string = decodeUtf8 string,
      testStruct_f_list   = Vector.fromList list,
      testStruct_f_map    = themap,
      testStruct_f_set    = Set.fromList set,
      testStruct_o_i32    = if toEnum $ fromIntegral o_isset
                              then Just o_i32
                              else Nothing,
      testStruct_foo      = foo
      }

  poke ptr TestStruct{..} =
    -- Allocate Temporary Struct
    alloca $ \cStructPtr ->
    -- Allocate CString
    BS.useAsCString (LBS.toStrict $ encodeUtf8 testStruct_f_string) $ \cStr ->
    -- Allocate List
    withArrayLen (map CShort $ Vector.toList testStruct_f_list) $ \vLen vec ->
    -- Allocate Map
    let (keys, vals) = unzip (Map.toList testStruct_f_map)
    in withArrayLen (map CShort keys) $ \mapLen mapKeys ->
    withArray (map CInt vals) $ \mapVals ->
    -- Allocate Set
    withArrayLen (map CSChar $ Set.toList testStruct_f_set) $ \sLen set -> do
      -- Allocate Inner Struct
      fooPtr <- c_newFoo
      poke fooPtr testStruct_foo
      (#poke CTestStruct, f_bool) cStructPtr
        (CSChar $ fromIntegral $ fromEnum testStruct_f_bool)
      (#poke CTestStruct, f_byte)     cStructPtr (CSChar testStruct_f_byte)
      (#poke CTestStruct, f_i16)      cStructPtr (CShort testStruct_f_i16)
      (#poke CTestStruct, f_i32)      cStructPtr (CInt testStruct_f_i32)
      (#poke CTestStruct, f_i64)      cStructPtr (CLong testStruct_f_i64)
      (#poke CTestStruct, f_float)    cStructPtr (CFloat testStruct_f_float)
      (#poke CTestStruct, f_double)   cStructPtr (CDouble testStruct_f_double)
      (#poke CTestStruct, f_string)   cStructPtr cStr
      (#poke CTestStruct, f_list)     cStructPtr vec
      (#poke CTestStruct, f_list_len) cStructPtr (CInt $ fromIntegral vLen)
      (#poke CTestStruct, f_map_keys) cStructPtr mapKeys
      (#poke CTestStruct, f_map_vals) cStructPtr mapVals
      (#poke CTestStruct, f_map_len)  cStructPtr (CInt $ fromIntegral mapLen)
      (#poke CTestStruct, f_set)      cStructPtr set
      (#poke CTestStruct, f_set_len)  cStructPtr (CInt $ fromIntegral sLen)
      (#poke CTestStruct, o_i32) cStructPtr
        (CInt $ fromIntegral $ fromMaybe 0 testStruct_o_i32)
      (#poke CTestStruct, o_isset) cStructPtr
        (CSChar $ fromIntegral $ fromEnum $ isJust testStruct_o_i32)
      (#poke CTestStruct, foo) cStructPtr fooPtr
      c_fillStruct ptr cStructPtr

--------------------------------------------------------------------------------
#include <common/hs/hsc.h>
#include "thrift/lib/hs/tests/cpp/hs_test.h"

foreign import ccall
  #{ mangled TestStruct* getStructPtr() }
  c_newStructPtr :: IO (Ptr TestStruct)

foreign import ccall
  #{ mangled void deleteSResult(SerializedResult*) }
  c_deleteSResult :: Ptr SerializedResult -> IO ()

foreign import ccall
  #{ mangled Foo *getFooPtr() }
  c_newFoo :: IO (Ptr Foo)

foreign import ccall
  #{ mangled int getFooBar(Foo*) }
  c_getFooBar :: Ptr Foo -> IO CInt

foreign import ccall
  #{ mangled int getFooBaz(Foo*) }
  c_getFooBaz :: Ptr Foo -> IO CInt

foreign import ccall
  #{ mangled void fillFoo(Foo*, int, int) }
  c_fillFoo :: Ptr Foo -> CInt -> CInt -> IO ()

foreign import ccall
  #{ mangled void fillStruct(TestStruct*, CTestStruct*) }
    c_fillStruct :: Ptr TestStruct -> Ptr CTestStruct -> IO ()

foreign import ccall
  #{ mangled void freeBuffers(CTestStruct*) }
    c_freeBuffers :: Ptr CTestStruct -> IO ()

foreign import ccall
  #{ mangled void freeTestStruct(TestStruct*) }
    c_freeTestStruct :: Ptr TestStruct -> IO ()

foreign import ccall
  #{ mangled void readStruct(CTestStruct*, TestStruct*) }
    c_readStruct :: Ptr CTestStruct -> Ptr TestStruct -> IO ()

foreign import ccall
  #{ mangled void serializeBinary(SerializedResult*, TestStruct*) }
  c_serializeBinary :: Ptr SerializedResult -> Ptr TestStruct -> IO ()

foreign import ccall
  #{ mangled TestStruct* deserializeBinary(char*, int) }
  c_deserializeBinary :: CString -> CInt -> IO (Ptr TestStruct)

foreign import ccall
  #{ mangled void serializeCompact(SerializedResult*, TestStruct*) }
  c_serializeCompact :: Ptr SerializedResult -> Ptr TestStruct -> IO ()

foreign import ccall
  #{ mangled TestStruct* deserializeCompact(char*, int) }
  c_deserializeCompact :: CString -> CInt -> IO (Ptr TestStruct)

foreign import ccall
  #{ mangled void serializeJSON(SerializedResult*, TestStruct*) }
  c_serializeJSON :: Ptr SerializedResult -> Ptr TestStruct -> IO ()

foreign import ccall
  #{ mangled TestStruct* deserializeJSON(char*, int) }
  c_deserializeJSON :: CString -> CInt -> IO (Ptr TestStruct)
