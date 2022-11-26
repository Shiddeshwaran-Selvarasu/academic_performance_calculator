class Student {
  final String rollNo;
  final String name;
  final String email;
  final int CGPA;
  final List<Semester> semester = [];

  Student({
    required this.rollNo,
    required this.name,
    required this.email,
    required this.CGPA,
  });

  void addSem(Semester s){
    semester.add(s);
    double tCGPA = 0.0;
    for(Semester ss in semester){

    }
  }
}

class Semester {
  final int number;
  final int gpa;
  final List<Subject> sub = [];

  Semester({
    required this.number,
    required this.gpa,
  });
}

class Subject {
  final String code;
  final String name;
  final int internalMark;
  final int semesterMark;
  final String grade;

  Subject({
    required this.code,
    required this.name,
    required this.internalMark,
    required this.semesterMark,
    required this.grade,
  });
}

class BasicUser {
  final String name;
  final String email;
  final String role;

  BasicUser({
    required this.name,
    required this.email,
    required this.role,
  });
}

class Admin {
  final String name;
  final String email;
  final List<String> teachers;

  Admin({
    required this.name,
    required this.email,
    required this.teachers,
  });
}

class Tutor {
  final String staffNo;
  final String name;
  final String email;
  final String degree;
  final String dept;
  final String mobile;
  final List<String> students;

  Tutor({
    required this.staffNo,
    required this.name,
    required this.email,
    required this.degree,
    required this.dept,
    required this.mobile,
    required this.students,
  });
}
