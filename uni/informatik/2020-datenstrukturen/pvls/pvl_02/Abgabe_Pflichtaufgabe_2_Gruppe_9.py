#!/usr/bin/env python
# Lennart Schoettker, Erkan-Can Saripekmez
# Python v3.8
#
class Student:
    def __init__(self, firstName, lastName, matrNr):
        self.firstName = firstName
        self.lastName = lastName
        self.matrNr = matrNr
        self.courses = {}

    def takeExam(self, courseId, passed):
        course = self.courses.get(courseId, {'tries': 0, 'passed': False})
        if course['passed']:
            return True
        course['tries'] += 1
        course['passed'] = passed
        if (course['tries'] == 3 and not passed):
            return False
        self.courses[courseId] = course
        return True

    def formatAllCourses(self):
        res = ""
        for (courseId) in self.courses:
            res += self.formatCourse(courseId) + "\n"
        return res
        
    def formatCourse(self, courseId):
        course = self.courses[courseId]
        return "%s\t%s\t%s" % (courseId, course['tries'], course['passed'])
        

class PVL2_studentAdministration_Group9:
    def __init__(self):
        self.availableMatrNums = list(range(999,0, -1))
        self.students = {}

    def matriculate(self, firstName: str, lastName: str) -> int:
        if  not len(self.availableMatrNums) or not firstName or not lastName:
                return -1
            
        matrNr = self.availableMatrNums.pop()
        student = Student(firstName, lastName, matrNr)
        self.students[matrNr] = student
        return matrNr

    def deregister(self, matriculationNumber: int) -> bool:
        if not self.__exists(matriculationNumber):
            return False
        self.students.pop(matriculationNumber)
        self.availableMatrNums.append(matriculationNumber)
        self.availableMatrNums.sort(reverse = True)
        return True

    def __exists(self, matriculationNumber: int) -> bool:
        if (not matriculationNumber):
            return None
        return self.students.get(matriculationNumber, False)

    def find(self, matriculationNumber: int) -> str:
        student = self.__exists(matriculationNumber)
        if not student:
            return None
        res = "%s\n%s\n%s\n" % (student.firstName, student.lastName, student.matrNr)
        res += student.formatAllCourses()
        return res

    def takeExam(self,matriculationNumber: int, courseID : str, passed : bool) -> str:
        student = self.__exists(matriculationNumber)
        if not student:
            return ""
        res = student.takeExam(courseID, passed)
        if not res:
            self.deregister(matriculationNumber)
        return student.formatCourse(courseID)

    def dataBase(self)-> str:
        str = ""
        for (matrNum) in sorted(list(self.students.keys())):
            student = self.students[matrNum]
            res = "%s\n%s\n%s\n" % (student.firstName, student.lastName, student.matrNr)
            res += student.formatAllCourses()
            str += res
            str += '\n'
        return str
