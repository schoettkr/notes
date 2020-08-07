#!/usr/bin/env python
# Lennart Schoettker, Erkan-Can Saripekmez
# Python v3.8
# 
from typing import List

class Set:
    def __init__(self, element: int):
        pass
    def union(self, toInsert):
        pass
    def cut(self, toCutWith):
        pass
    def isSubsetOf(self, sampleSet):
        pass
    def relativeComplementWith(self, sampleSet):
        pass
    def equals(self, sampleSet):
        pass
    def __iter__(self):
        pass
    def __next__(self):
        pass
    def asIntList(self) -> List[int]:
        pass
    

class PVL5_Group9(Set):
    def __init__(self, element: int):
        self._set = {}
        self.add(element)

    def add(self, element):
        self._set[element] = element

    def union(self, toInsert: Set) -> Set:
        if not toInsert:
            return None
        for val in toInsert._set:
            self.add(val)
        return self

    def cut(self, toCutWith: Set) -> Set:
        if not toCutWith:
            return None
        cut = {}
        for val in toCutWith._set:
            if val in self._set:
                cut[val] = val
        self._set = cut
        return self

    def isSubsetOf(self, sampleSet: Set) -> bool:
        if not sampleSet:
            return None
        for val in self._set:
            if not val in sampleSet._set:
                return False
        return True

    def relativeComplementWith(self, sampleSet: Set) -> Set:
        if not sampleSet:
            return None
        # self._set minus sampleSet._set
        for val in sampleSet._set:
            if val in self._set:
                self._set.pop(val)
        return val

    def equals(self, sampleSet: Set) -> bool:
        if not sampleSet:
            return None
        for val in self._set:
            if not val in sampleSet._set:
                return False
        for val in sampleSet._set:
            if not val in self._set:
                return False
        return True

    def __iter__(self) -> Set:
        self.pos = 0
        return self

    def __next__(self) -> Set:
        valList = list(self._set.values())
        valLen = len(valList)
        if self.pos >= valLen:
            raise StopIteration
        val = valList[self.pos]
        self.pos += 1
        return PVL5_Group9(val)

    def asIntList(self) -> List[int]:
        return list(self._set.values())
