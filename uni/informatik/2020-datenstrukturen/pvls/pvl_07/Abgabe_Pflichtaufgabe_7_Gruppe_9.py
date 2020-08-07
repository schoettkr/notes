#!/usr/bin/env python
# Lennart Schoettker, Erkan-Can Saripekmez
# Python v3.8
# 
from typing import List

class Graph_I:
    def __init__(self, n: int):
        pass
    def setEdge(self, fromVertex: int, toVertex: int) -> bool: # 'from' is reserved keyword
        pass
    def getEdges(self) -> List[List[int]]:
        pass
    def getNGons (self, n: int) -> List[List[int]]:
        pass
    def hasFullCircle(self) -> bool:
        pass
    def getLongestPath(self, fromVertex: int, toVertex: int) -> List[int]:
        pass
    

class PVL7_Group9(Graph_I):
    def __init__(self, n: int):
        self.vertices = n
        self.edges = []
    def setEdge(self, fromVertex: int, toVertex: int) -> bool: # 'from' is reserved keyword
        if fromVertex not in range(0, self.vertices):
            return False
        if toVertex not in range(0, self.vertices):
            return False
        if fromVertex == toVertex:
            return False
        edgeSet = {fromVertex, toVertex}
        if edgeSet in self.edges:
            return False
        self.edges.append(edgeSet)
        return True

    def getEdges(self) -> List[List[int]]:
        graphEdges = []
        for v in range(0, self.vertices):
            vEdges = []
            for edge in self.edges:
                if v in edge:
                    vEdges.append(edge.difference({v}).pop())
            graphEdges.append(vEdges)
        return graphEdges
            
    def getNGons (self, n: int) -> List[List[int]]:
        pass
    def hasFullCircle(self) -> bool:
        pass
    def getLongestPath(self, fromVertex: int, toVertex: int) -> List[int]:
        pass
