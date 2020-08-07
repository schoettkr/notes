#!/usr/bin/env python
def findFirstDuplicate(arr):
    visited = {}
    for num in arr:
        if num in visited:
            return num
        else:
            visited[num] = True
    return -1

arr = [1,2,3,4,5,6,7,7,8,9,10,11,12,12,13,14]
dup = findFirstDuplicate(arr)
print(dup)
