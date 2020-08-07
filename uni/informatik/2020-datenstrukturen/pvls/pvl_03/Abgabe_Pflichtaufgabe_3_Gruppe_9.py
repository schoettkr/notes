#!/usr/bin/env python
# Lennart Schoettker, Erkan-Can Saripekmez
# Python v3.8
#
VALID_OPERATORS = {
    '*': 2,
    '+': 1
}
    
def precedence(operator):
    return VALID_OPERATORS[operator]

def isInteger(token):
    token = stringToInt(token)
    return (isinstance(token, int))

def stringToInt(s):
    try:
        return int(s)
    except:
        return None

def isOperator(token):
    return token in VALID_OPERATORS

def isParen(token):
    parens = ('(', ')')
    return token in parens

def isLeftParen(token):
    return token == '('

def isRightParen(token):
    return token == ')'
            

class Calculator_Group9:
    def __init__(self):
        self.outputQueue = []
        self.operatorStack = []

    def validate(self, expression):
        tokens = expression.split()
        count = len(tokens)
        if count == 1:
            if not isInteger(tokens[0]):
                return False
            else:
                return True
        if count == 0:
            return False

        balanced = self.checkParens(tokens)
        if not balanced:
            return False

        for (index, token) in enumerate(tokens):
            if index == 0:
                if isOperator(token):
                    return False
                if isInteger(token):
                    next = tokens[index+1]
                    if not (isParen(next) or isOperator(next)):
                        return False
                continue

            if index == count - 1:
                if isOperator(token):
                    return False

                if isInteger(token):
                  prev = tokens[index-1]
                  if not (isParen(prev) or isOperator(prev)):
                      return False
                continue
                    
            prev, next = tokens[index-1], tokens[index+1]
            if isOperator(token):
                if not (isParen(prev) or isInteger(prev)):
                    return False
                elif not (isParen(next) or isInteger(next)):
                    return False
            elif isInteger(token):
                if not (isParen(prev) or isOperator(prev)):
                    return False
                elif not (isParen(next) or isOperator(next)):
                    return False
        return True

    def checkParens(self, tokens):
        parensStack = []
        for token in tokens:
            if isLeftParen(token):
                parensStack.append(token)
            if isRightParen(token):
                try:
                    match = parensStack.pop()
                    if not isLeftParen(match):
                        return False
                except:
                    return False
        return not len(parensStack)
        
    def toPostfix(self, expression):
        valid = self.validate(expression)
        if not valid:
            return False
        self.outputQueue = []
        self.operatorStack = []

        tokens = expression.split()
        for token in tokens:
            if isInteger(token):
                self.outputQueue.append(token)
            elif isOperator(token):
                while isOperator(self.__peekStack()) and precedence(self.__peekStack()) > precedence(token):
                    self.outputQueue.append(self.operatorStack.pop())
                self.operatorStack.append(token)
            elif isLeftParen(token):
                self.operatorStack.append(token)
            elif isRightParen(token):
                while not isLeftParen(self.__peekStack()):
                    if not self.__peekStack():
                        raise Exception('Invalid input')
                    self.outputQueue.append(self.operatorStack.pop())
                if isLeftParen(self.__peekStack()):
                    self.operatorStack.pop()
                else:
                    raise Exception('Invalid input')
            else:
                raise Exception('Invalid input')

        while len(self.operatorStack):
            top = self.operatorStack.pop()
            if (isRightParen(top) or isLeftParen(top)):
                    raise Exception('Invalid input')
            else:
                self.outputQueue.append(top)

        return self.outputQueue

    def evalPostfix(self, postfixTokens):
        tempStack = []
        for token in postfixTokens:
            if isInteger(token):
                tempStack.append(token)
            if isOperator(token):
                right, left = tempStack.pop(), tempStack.pop()
                expression = str(left) + str(token) + str(right)
                res = eval(expression)
                tempStack.append(res)

        return tempStack[-1]

    def calculate(self, expression : str) -> int:
        postfixTokens = self.toPostfix(expression)
        result = self.evalPostfix(postfixTokens)
        return result
                

    def __peekStack(self):
        return self.operatorStack[-1] if len(self.operatorStack) else None
