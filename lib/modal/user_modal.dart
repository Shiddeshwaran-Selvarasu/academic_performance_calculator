class Student {
  final String rollNo;
  final String name;
  final String email;
  double CGPA;
  final List<Semester> semester = [];

  Student({
    required this.rollNo,
    required this.name,
    required this.email,
    this.CGPA = 0.0,
  });

  factory Student.fromJson(Map<String, dynamic> data) {
    var student = Student(
        rollNo: data['rollNo'],
        name: data['name'],
        email: data['email'],
        CGPA: data['CGPA']);
    List<dynamic> semList = data['semester'];
    for (var sem in semList) {
      student.addSem(Semester.fromJson(sem));
    }
    return student;
  }

  void addSem(Semester s) {
    semester.add(s);
    double tCGPA = 0.0;
    for (Semester ss in semester) {
      tCGPA += ss.gpa;
    }
    CGPA = tCGPA / semester.length;
  }

  Map<String, dynamic> toMap() {
    return {
      'rollNo': rollNo,
      'email': email,
      'name': name,
      'CGPA': CGPA,
      'semester': semester.map((e) => e.toMap()).toList(),
    };
  }
}

class Semester {
  final int number;
  double gpa = 0.0;
  final List<Subject> subject = [];

  Semester({
    required this.number,
    required this.gpa,
  });

  void addSubject(Subject s){
    subject.add(s);
    gpa += s.gradePoints;
    gpa /= subject.length;
  }

  factory Semester.fromJson(Map<String, dynamic> data) {
    var sem = Semester(number: data['number'], gpa: data['gpa']);
    List<Map<String, dynamic>> sublist = data['subject'];
    for(var subject in sublist){
      sem.addSubject(Subject.fromJson(subject));
    }
    return sem;
  }

  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'gpa': gpa,
      'subject': subject.map((e) => e.toMap()).toList(),
    };
  }
}

class Subject {
  final String code;
  final String name;
  final int internalMark;
  final int semesterMark;
  final int credits;
  double gradePoints;

  Subject({
    required this.code,
    required this.name,
    required this.credits,
    this.internalMark = 0,
    this.semesterMark = 0,
    this.gradePoints = 0.0,
  });

  factory Subject.fromJson(Map<String, dynamic> data) {
    return Subject(
      code: data['code'],
      name: data['name'],
      credits: data['credits'],
      gradePoints: data['gradePoints'],
      internalMark: data['internalMark'],
      semesterMark: data['semesterMark'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'name': name,
      'internalMark': internalMark,
      'semesterMark': semesterMark,
      'gradePoints': gradePoints,
      'credits': credits,
    };
  }
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
    };
  }
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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'tutors': teachers.toList(),
    };
  }
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

  Map<String, dynamic> toMap() {
    return {
      'staffNo': staffNo,
      'name': name,
      'email': email,
      'degree': degree,
      'dept': dept,
      'mobile': mobile,
      'students': students,
    };
  }
}
