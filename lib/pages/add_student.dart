import 'package:academin_performance_calculator/modal/user_modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({required this.tutorEmail, Key? key}) : super(key: key);

  final String tutorEmail;

  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final TextEditingController _rollNo = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _name = TextEditingController();

  String? _rollNoError;
  String? _emailError;
  String? _nameError;

  bool isLoading = false;

  void _showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: Colors.blueAccent,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 2,
    );
  }

  storeData() {
    if (_rollNo.value.text.isNotEmpty &&
        _email.value.text.isNotEmpty &&
        _name.value.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      Student student = Student(
          rollNo: _rollNo.value.text,
          name: _name.value.text,
          email: _email.value.text);

      FirebaseFirestore.instance
          .doc('/tutor/${widget.tutorEmail}')
          .collection('/students')
          .doc(student.email)
          .set(student.toMap());

      Future.delayed(
        const Duration(seconds: 2),
      );

      _rollNo.clear();
      _email.clear();
      _showToast('Student created...');
      setState(() {
        isLoading = false;
      });
    } else {
      _showToast('All fields should have value!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.light,
        ),
      ),
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Add Students'),
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          actions: [
            IconButton(
              onPressed: () {
                storeData();
              },
              icon: const Icon(Icons.done),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 25,
                          left: 25,
                          top: 25,
                          bottom: 10,
                        ),
                        child: TextField(
                          controller: _rollNo,
                          decoration: InputDecoration(
                            hintText: 'Enter Roll No',
                            label: const Text('Roll No'),
                            errorText: _rollNoError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        child: TextField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            label: const Text('Email'),
                            errorText: _emailError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        child: TextField(
                          controller: _name,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            hintText: 'Enter Name',
                            label: const Text('Name'),
                            errorText: _nameError,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
