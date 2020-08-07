#!/usr/bin/env python
# Lennart Schoettker, Erkan-Can Saripekmez
# Python v3.8
# 
import queue
from typing import List

class Graph_II:
    def __init__(self, n: int):
        pass
    def setEdge(self, source: int, destin: int) -> bool:
        pass
    def getEdges(self) -> List[List[int]]:
        pass
    def hasWay(self, source: int, destin: int) -> bool:
        pass
    def isConnected(self) -> bool:
        pass
    def isConnected_biased(self, nodes : List[int]) -> bool:
        pass
    def getBridges(self) -> List[List[int]]:
        pass
    def getArticulations(self) -> List[int]:
        pass
    

class PVL8_Group9(Graph_II):
    def __init__(self, n: int):
        self.vertices = n
        self.graph = [[] for _ in range(n)]

        
    def _validateVertices(self, v1: int, v2: int) -> bool:
        if v1 not in range(0, self.vertices):
            return False
        if v2 not in range(0, self.vertices):
            return False
        if v1 == v2:
            return False
        return True

    def _getNeighbours(self, v: int):
        return self.graph[v]

    def _bfs(self, start, end=None):
        q = queue.Queue()
        q.put(start)

        visited = [False] * self.vertices
        visited[start] = True

        while not q.empty():
            v = q.get()
            if type(end) is int:
                if v == end:
                    return True
            neighbours = self._getNeighbours(v)

            for neighbour in neighbours:
                if not visited[neighbour]:
                    q.put(neighbour)
                    visited[neighbour] = True
        if type(end) is int:
            return False
        return visited
        

    def setEdge(self, source: int, destin: int) -> bool:
        if not self._validateVertices(source, destin):
            return False
        if (destin in self.graph[source]):
            return False
        if (source in self.graph[destin]):
            return False
        self.graph[source].append(destin)
        self.graph[destin].append(source)
        return True

    def getEdges(self) -> List[List[int]]:
        return self.graph
        
    def hasWay(self, source: int, destin: int) -> bool:
        if not self._validateVertices(source, destin):
            return False
        result = self._bfs(source, destin)
        return result

        
    def isConnected(self) -> bool:
        visited = self._bfs(0)
        return False in visited
    
    def isConnected_biased(self, nodes : List[int]) -> bool:
        start = nodes[0]
        q = queue.Queue()
        q.put(start)

        visited = [False] * self.vertices
        visited[start] = True

        while not q.empty():
            v = q.get()
            allNeighbours = self._getNeighbours(v)
            validNeighbours = [n for n in allNeighbours if n in nodes]

            for neighbour in validNeighbours:
                if not visited[neighbour]:
                    q.put(neighbour)
                    visited[neighbour] = True

        for i, v in enumerate(visited):
            if (not v) and i in nodes:
                return False
        return True
