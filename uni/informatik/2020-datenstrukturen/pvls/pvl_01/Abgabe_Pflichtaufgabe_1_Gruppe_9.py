#!/usr/bin/env python
# Lennart Schoettker, Erkan-Can Saripekmez
# Python v3.8
# 
class State:
    def __init__(self, name, transitions):
        self.name = name
        self.transitions  = {transitionName: targetState for (transitionName, targetState) in pairwise(transitions)}

    def performTransition(self, transitionName):
        if transitionName not in self.transitions:
            print("Cannot perform transition %s because it has not been defined" % transitionName)
            return -1
        return self.transitions[transitionName]

    def addTransition(self, transitionName, targetState):
        self.transitions[transitionName] = targetState

    def deleteTransition(self, transitionName):
        if transitionName not in self.transitions:
            print("Cannot delete transition %s because it has not been defined" % transitionName)
            return -1
        del self.transitions[transitionName]

        
class PVL1_Group9: # class Automat:
    def __init__(self, data):
        self.stateCount = data[0][0]
        self.maxTransitionsPerState = data[1][0]
        self.validTransitions = data[2]
        self.states = {state: State(state, transitions) for (state, transitions) in enumerate(data[3:])}
        self.currentState = None
        
    def setTransition(self, state, transition, to):
        if transition not in self.validTransitions:
            print("Transition #%s is not valid." % transition)
            return
        if state not in self.states:
            print("State #%s not found." % state)
            return
        self.states[state].addTransition(transition, to)

    def deleteTransition(self, state, transition):
        if transition not in self.validTransitions:
            print("Transition #%s cannot be deleted because it wasn't valid in the first place." % transition)
            return
        res = self.states[state].deleteTransition(transition)
        if res == -1:
            print("Cannot delete transition %s because it has not been defined for state #%s" % transitionName, state)

    def traverse_input(self, startState, transitions):
        if startState not in self.states:
            print("#%s is not defined and cannot be used as start state" % startState)
            return -1
        self.currentState = self.states[startState]
        for transition in transitions:
            nextState = self.currentState.performTransition(transition)
            if nextState == -1:
                print("Transition %s is not valid for state #%s" % (transition, self.currentState.name))
                return -1
            self.currentState = self.states[nextState]
        print("Traversal ended in state #%s"% self.currentState.name)
        return self.currentState.name

def pairwise(it):
    it = iter(it)
    while True:
        try:
            yield next(it), next(it)
        except StopIteration:
            return

        
data = [
    [4], # Anzahl der Zustaende (n)
    [2], # maximale Anzahl von Zustandsuebergangen pro Zustand (k)
    [1,2], # zulaessige/moegliche Eingaben fuer Zustandsuebergange, alles andere Fehler (-1)
    # ab [3 bis n+2]: gerades i = Eingabe, ungerades i = valider Zustand in den uebergegangen wird
    [1,0, 2,1], # Zustand 0 fuehrt bei Eingabe 1 zu Zustand 0 und bei Eingabe 2 zu Zustand 1
    [1,2, 2,3], # Zustand 1 fuehrt bei Eingabe 1 zu Zustand 2 und bei Eingabe 2 zu Zustand 3
    [1,0],      # Zustand 2 fuehrt bei Eingabe 1 zu Zustand 0
    []          # Zustand 3 fuehrt bei jeder Eingabe zu Fehler (-1)
]


transitions = [1,2,1,1,2,2,2]

automat = PVL1_Group9(data)
automat.setTransition(3, 2, 1)
automat.traverse_input(0, transitions)
