import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../modal/user_modal.dart';
import '../utils/signinprovider.dart';
import 'add_student.dart';

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key, required this.user}) : super(key: key);

  final BasicUser user;

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  void _showToast(String text, bool isError) {
    String color = isError ? "#ff3333" : "#4caf50";
    Fluttertoast.showToast(
      msg: text,
      backgroundColor: isError ? Colors.red : Colors.green,
      webBgColor: color,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_LONG,
      timeInSecForIosWeb: 2,
    );
  }

  showAlert(var provider, var context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 25,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text("Log Out?"),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.all(5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          content: const Text(
            "Are sure you want to log out?",
            style: TextStyle(fontSize: 17),
          ),
          actionsAlignment: MainAxisAlignment.end,
          elevation: 5,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    provider.logout();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  showAlertDelete(var student, var context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.red,
                size: 25,
              ),
              Padding(
                padding: EdgeInsets.all(5),
                child: Text(" Delete?"),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.all(5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          content: Text(
            "Are sure you want to delete the student with email $student ?",
            style: const TextStyle(fontSize: 17),
          ),
          actionsAlignment: MainAxisAlignment.end,
          elevation: 5,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('/tutor')
                        .doc(widget.user.email)
                        .collection('/students')
                        .doc(student)
                        .delete();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EmailSignIn>(context, listen: false);
    final studentList = FirebaseFirestore.instance
        .collection('/tutor')
        .doc('/${widget.user.email}')
        .collection('/students')
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            showAlert(provider, context);
          },
          icon: const Icon(Icons.logout),
        ),
        title: const Text('Student List'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: StreamBuilder(
          stream: studentList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              List<Student> students = snapshot.data!.docs
                  .map((e) => Student.fromJson(e.data()))
                  .toList();
              return students.isNotEmpty
                  ? Scrollbar(
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 5,
                            ),
                            child: Card(
                              elevation: 2.5,
                              shadowColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                              child: ListTile(
                                title: Text(students[index].name),
                                subtitle: Text(students[index].email),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showAlertDelete(
                                          students[index].email,
                                          context,
                                        );
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                    IconButton(
                                      onPressed: () {

                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text('Click The \'+\' icon to add Students'),
                    );
            }

            return const Center(
              child: Text('Something Went Wrong!!'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudent(tutorEmail: widget.user.email),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
