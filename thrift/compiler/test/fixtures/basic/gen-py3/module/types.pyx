#
# Autogenerated by Thrift
#
# DO NOT EDIT UNLESS YOU ARE SURE THAT YOU KNOW WHAT YOU ARE DOING
#  @generated
#

from libcpp.memory cimport shared_ptr, make_shared, unique_ptr, make_unique
from libcpp.string cimport string
from libcpp cimport bool as cbool
from libcpp.iterator cimport inserter as cinserter
from cpython cimport bool as pbool
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint32_t
from cython.operator cimport dereference as deref, preincrement as inc, address as ptr_address
import thrift.py3.types
cimport thrift.py3.types
cimport thrift.py3.exceptions
from thrift.py3.types import NOTSET as __NOTSET
from thrift.py3.types cimport translate_cpp_enum_to_python
cimport thrift.py3.std_libcpp as std_libcpp
from thrift.py3.serializer import Protocol
cimport thrift.py3.serializer as serializer
from thrift.py3.serializer import deserialize, serialize
import folly.iobuf as __iobuf
from folly.optional cimport cOptional

import sys
import itertools
from collections import Sequence, Set, Mapping, Iterable
import enum as __enum
import warnings
import builtins as _builtins


class MyEnum(__enum.Enum):
    MyValue1 = 0
    MyValue2 = 1

    __hash__ = __enum.Enum.__hash__

    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            warnings.warn(f"comparison not supported between instances of {type(self)} and {type(other)}", RuntimeWarning, stacklevel=2)
            return False
        return self.value == other.value

    def __int__(self):
        return self.value

cdef inline cMyEnum MyEnum_to_cpp(value):
    cdef int cvalue = value.value
    if cvalue == 0:
        return MyEnum__MyValue1
    elif cvalue == 1:
        return MyEnum__MyValue2


cdef cMyStruct _MyStruct_defaults = cMyStruct()

cdef class MyStruct(thrift.py3.types.Struct):

    def __init__(
        MyStruct self, *,
        MyIntField=None,
        str MyStringField=None,
        MyDataItem MyDataField=None,
        major=None,
        myEnum=None
    ):
        if MyIntField is not None:
            if not isinstance(MyIntField, int):
                raise TypeError(f'MyIntField is not a { int !r}.')
            MyIntField = <int64_t> MyIntField

        if major is not None:
            if not isinstance(major, int):
                raise TypeError(f'major is not a { int !r}.')
            major = <int64_t> major

        if myEnum is not None:
            if not isinstance(myEnum, MyEnum):
                raise TypeError(f'field myEnum value: { myEnum !r} is not of the enum type { MyEnum }.')

        self._cpp_obj = move(MyStruct._make_instance(
          NULL,
          MyIntField,
          MyStringField,
          MyDataField,
          major,
          myEnum,
        ))

    def __call__(
        MyStruct self,
        MyIntField=__NOTSET,
        MyStringField=__NOTSET,
        MyDataField=__NOTSET,
        major=__NOTSET,
        myEnum=__NOTSET
    ):
        changes = any((
            MyIntField is not __NOTSET,

            MyStringField is not __NOTSET,

            MyDataField is not __NOTSET,

            major is not __NOTSET,

            myEnum is not __NOTSET,
        ))

        if not changes:
            return self

        if None is not MyIntField is not __NOTSET:
            if not isinstance(MyIntField, int):
                raise TypeError(f'MyIntField is not a { int !r}.')
            MyIntField = <int64_t> MyIntField

        if None is not MyStringField is not __NOTSET:
            if not isinstance(MyStringField, str):
                raise TypeError(f'MyStringField is not a { str !r}.')

        if None is not MyDataField is not __NOTSET:
            if not isinstance(MyDataField, MyDataItem):
                raise TypeError(f'MyDataField is not a { MyDataItem !r}.')

        if None is not major is not __NOTSET:
            if not isinstance(major, int):
                raise TypeError(f'major is not a { int !r}.')
            major = <int64_t> major

        if None is not myEnum is not __NOTSET:
            if not isinstance(myEnum, MyEnum):
                raise TypeError(f'field myEnum value: { myEnum !r} is not of the enum type { MyEnum }.')

        inst = <MyStruct>MyStruct.__new__(MyStruct)
        inst._cpp_obj = move(MyStruct._make_instance(
          self._cpp_obj.get(),
          MyIntField,
          MyStringField,
          MyDataField,
          major,
          myEnum,
        ))
        return inst

    @staticmethod
    cdef unique_ptr[cMyStruct] _make_instance(
        cMyStruct* base_instance,
        object MyIntField,
        object MyStringField,
        object MyDataField,
        object major,
        object myEnum
    ) except *:
        cdef unique_ptr[cMyStruct] c_inst
        if base_instance:
            c_inst = make_unique[cMyStruct](deref(base_instance))
        else:
            c_inst = make_unique[cMyStruct]()

        if base_instance:
            # Convert None's to default value. (or unset)
            if MyIntField is None:
                deref(c_inst).MyIntField = _MyStruct_defaults.MyIntField
                deref(c_inst).__isset.MyIntField = False
                pass
            elif MyIntField is __NOTSET:
                MyIntField = None

            if MyStringField is None:
                deref(c_inst).MyStringField = _MyStruct_defaults.MyStringField
                deref(c_inst).__isset.MyStringField = False
                pass
            elif MyStringField is __NOTSET:
                MyStringField = None

            if MyDataField is None:
                deref(c_inst).MyDataField = _MyStruct_defaults.MyDataField
                deref(c_inst).__isset.MyDataField = False
                pass
            elif MyDataField is __NOTSET:
                MyDataField = None

            if major is None:
                deref(c_inst).major = _MyStruct_defaults.major
                deref(c_inst).__isset.major = False
                pass
            elif major is __NOTSET:
                major = None

            if myEnum is None:
                deref(c_inst).myEnum = _MyStruct_defaults.myEnum
                deref(c_inst).__isset.myEnum = False
                pass
            elif myEnum is __NOTSET:
                myEnum = None

        if MyIntField is not None:
            deref(c_inst).MyIntField = MyIntField
            deref(c_inst).__isset.MyIntField = True
        if MyStringField is not None:
            deref(c_inst).MyStringField = MyStringField.encode('UTF-8')
            deref(c_inst).__isset.MyStringField = True
        if MyDataField is not None:
            deref(c_inst).MyDataField = deref((<MyDataItem?> MyDataField)._cpp_obj)
            deref(c_inst).__isset.MyDataField = True
        if major is not None:
            deref(c_inst).major = major
            deref(c_inst).__isset.major = True
        if myEnum is not None:
            deref(c_inst).myEnum = MyEnum_to_cpp(myEnum)
            deref(c_inst).__isset.myEnum = True
        # in C++ you don't have to call move(), but this doesn't translate
        # into a C++ return statement, so you do here
        return move_unique(c_inst)

    def __iter__(self):
        yield 'MyIntField', self.MyIntField
        yield 'MyStringField', self.MyStringField
        yield 'MyDataField', self.MyDataField
        yield 'major', self.major
        yield 'myEnum', self.myEnum

    def __bool__(self):
        return True or True or True or True or True

    @staticmethod
    cdef create(shared_ptr[cMyStruct] cpp_obj):
        inst = <MyStruct>MyStruct.__new__(MyStruct)
        inst._cpp_obj = cpp_obj
        return inst

    @property
    def MyIntField(self):

        return self._cpp_obj.get().MyIntField

    @property
    def MyStringField(self):

        return (<bytes>self._cpp_obj.get().MyStringField).decode('UTF-8')

    @property
    def MyDataField(self):

        if self.__MyDataField is None:
            self.__MyDataField = MyDataItem.create(make_shared[cMyDataItem](deref(self._cpp_obj).MyDataField))
        return self.__MyDataField

    @property
    def major(self):

        return self._cpp_obj.get().major

    @property
    def myEnum(self):

        return translate_cpp_enum_to_python(MyEnum, <int>(deref(self._cpp_obj).myEnum))


    def __hash__(MyStruct self):
        if not self.__hash:
            self.__hash = hash((
            self.MyIntField,
            self.MyStringField,
            self.MyDataField,
            self.major,
            self.myEnum,
            ))
        return self.__hash

    def __repr__(MyStruct self):
        return f'MyStruct(MyIntField={repr(self.MyIntField)}, MyStringField={repr(self.MyStringField)}, MyDataField={repr(self.MyDataField)}, major={repr(self.major)}, myEnum={repr(self.myEnum)})'
    def __richcmp__(self, other, op):
        cdef int cop = op
        if cop not in (2, 3):
            raise TypeError("unorderable types: {}, {}".format(self, other))
        if not (
                isinstance(self, MyStruct) and
                isinstance(other, MyStruct)):
            if cop == 2:  # different types are never equal
                return False
            else:         # different types are always notequal
                return True

        cdef cMyStruct cself = deref((<MyStruct>self)._cpp_obj)
        cdef cMyStruct cother = deref((<MyStruct>other)._cpp_obj)
        cdef cbool cmp = cself == cother
        if cop == 2:
            return cmp
        return not cmp

    cdef __iobuf.IOBuf _serialize(MyStruct self, proto):
        cdef __iobuf.cIOBufQueue queue = __iobuf.cIOBufQueue(__iobuf.cacheChainLength())
        cdef cMyStruct* cpp_obj = self._cpp_obj.get()
        if proto is Protocol.COMPACT:
            with nogil:
                serializer.CompactSerialize[cMyStruct](deref(cpp_obj), &queue, serializer.SHARE_EXTERNAL_BUFFER)
        elif proto is Protocol.BINARY:
            with nogil:
                serializer.BinarySerialize[cMyStruct](deref(cpp_obj), &queue, serializer.SHARE_EXTERNAL_BUFFER)
        elif proto is Protocol.JSON:
            with nogil:
                serializer.JSONSerialize[cMyStruct](deref(cpp_obj), &queue, serializer.SHARE_EXTERNAL_BUFFER)
        return __iobuf.from_unique_ptr(queue.move())

    cdef uint32_t _deserialize(MyStruct self, const __iobuf.cIOBuf* buf, proto) except? 0:
        cdef uint32_t needed
        self._cpp_obj = make_shared[cMyStruct]()
        cdef cMyStruct* cpp_obj = self._cpp_obj.get()
        if proto is Protocol.COMPACT:
            with nogil:
                needed = serializer.CompactDeserialize[cMyStruct](buf, deref(cpp_obj), serializer.SHARE_EXTERNAL_BUFFER)
        elif proto is Protocol.BINARY:
            with nogil:
                needed = serializer.BinaryDeserialize[cMyStruct](buf, deref(cpp_obj), serializer.SHARE_EXTERNAL_BUFFER)
        elif proto is Protocol.JSON:
            with nogil:
                needed = serializer.JSONDeserialize[cMyStruct](buf, deref(cpp_obj), serializer.SHARE_EXTERNAL_BUFFER)
        return needed

    def __reduce__(self):
        return (deserialize, (MyStruct, serialize(self)))


cdef cMyDataItem _MyDataItem_defaults = cMyDataItem()

cdef class MyDataItem(thrift.py3.types.Struct):

    def __init__(
        MyDataItem self, *
    ):
        self._cpp_obj = move(MyDataItem._make_instance(
          NULL,
        ))

    def __call__(
        MyDataItem self
    ):
        changes = any((        ))

        if not changes:
            return self
        inst = <MyDataItem>MyDataItem.__new__(MyDataItem)
        inst._cpp_obj = move(MyDataItem._make_instance(
          self._cpp_obj.get(),
        ))
        return inst

    @staticmethod
    cdef unique_ptr[cMyDataItem] _make_instance(
        cMyDataItem* base_instance
    ) except *:
        cdef unique_ptr[cMyDataItem] c_inst
        if base_instance:
            c_inst = make_unique[cMyDataItem](deref(base_instance))
        else:
            c_inst = make_unique[cMyDataItem]()

        if base_instance:
            # Convert None's to default value. (or unset)
            pass
        # in C++ you don't have to call move(), but this doesn't translate
        # into a C++ return statement, so you do here
        return move_unique(c_inst)

    def __iter__(self):
        return iter(())

    def __bool__(self):
        return True

    @staticmethod
    cdef create(shared_ptr[cMyDataItem] cpp_obj):
        inst = <MyDataItem>MyDataItem.__new__(MyDataItem)
        inst._cpp_obj = cpp_obj
        return inst


    def __hash__(MyDataItem self):
        if not self.__hash:
            self.__hash = hash((
            type(self)   # Hash the class there are no fields
            ))
        return self.__hash

    def __repr__(MyDataItem self):
        return f'MyDataItem()'
    def __richcmp__(self, other, op):
        cdef int cop = op
        if cop not in (2, 3):
            raise TypeError("unorderable types: {}, {}".format(self, other))
        if not (
                isinstance(self, MyDataItem) and
                isinstance(other, MyDataItem)):
            if cop == 2:  # different types are never equal
                return False
            else:         # different types are always notequal
                return True

        cdef cMyDataItem cself = deref((<MyDataItem>self)._cpp_obj)
        cdef cMyDataItem cother = deref((<MyDataItem>other)._cpp_obj)
        cdef cbool cmp = cself == cother
        if cop == 2:
            return cmp
        return not cmp

    cdef __iobuf.IOBuf _serialize(MyDataItem self, proto):
        cdef __iobuf.cIOBufQueue queue = __iobuf.cIOBufQueue(__iobuf.cacheChainLength())
        cdef cMyDataItem* cpp_obj = self._cpp_obj.get()
        if proto is Protocol.COMPACT:
            with nogil:
                serializer.CompactSerialize[cMyDataItem](deref(cpp_obj), &queue, serializer.SHARE_EXTERNAL_BUFFER)
        elif proto is Protocol.BINARY:
            with nogil:
                serializer.BinarySerialize[cMyDataItem](deref(cpp_obj), &queue, serializer.SHARE_EXTERNAL_BUFFER)
        elif proto is Protocol.JSON:
            with nogil:
                serializer.JSONSerialize[cMyDataItem](deref(cpp_obj), &queue, serializer.SHARE_EXTERNAL_BUFFER)
        return __iobuf.from_unique_ptr(queue.move())

    cdef uint32_t _deserialize(MyDataItem self, const __iobuf.cIOBuf* buf, proto) except? 0:
        cdef uint32_t needed
        self._cpp_obj = make_shared[cMyDataItem]()
        cdef cMyDataItem* cpp_obj = self._cpp_obj.get()
        if proto is Protocol.COMPACT:
            with nogil:
                needed = serializer.CompactDeserialize[cMyDataItem](buf, deref(cpp_obj), serializer.SHARE_EXTERNAL_BUFFER)
        elif proto is Protocol.BINARY:
            with nogil:
                needed = serializer.BinaryDeserialize[cMyDataItem](buf, deref(cpp_obj), serializer.SHARE_EXTERNAL_BUFFER)
        elif proto is Protocol.JSON:
            with nogil:
                needed = serializer.JSONDeserialize[cMyDataItem](buf, deref(cpp_obj), serializer.SHARE_EXTERNAL_BUFFER)
        return needed

    def __reduce__(self):
        return (deserialize, (MyDataItem, serialize(self)))


