import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../modal/user_modal.dart';
import '../utils/signinprovider.dart';
import 'add_tutor.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({required this.user, Key? key}) : super(key: key);

  final BasicUser user;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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

  showAlertDelete(var tutor, var context) {
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
                child: Text("Delete?"),
              ),
            ],
          ),
          actionsPadding: const EdgeInsets.all(5),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          content: Text(
            "Are sure you want to delete the teacher with email $tutor ?",
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
                        .collection('/user')
                        .doc(tutor.toString())
                        .delete();
                    FirebaseFirestore.instance
                        .collection('/admin')
                        .doc(widget.user.email)
                        .update({
                      'tutors': FieldValue.arrayRemove([tutor.toString()]),
                    });
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
        .collection('/admin')
        .doc('/${widget.user.email}')
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
        title: const Text('Teacher List'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: StreamBuilder(
        stream: studentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            List<String> students = [];
            final list = snapshot.data!.data()!['tutors'];
            for (var ele in list) {
              students.add(ele.toString());
            }
            return students.isNotEmpty
                ? Scrollbar(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListView.builder(
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            child: Card(
                              elevation: 2,
                              shadowColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2),
                              color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                              child: ListTile(
                                title:
                                    Text(students.elementAt(index).toString()),
                                trailing: IconButton(
                                  onPressed: () {
                                    showAlertDelete(
                                        students.elementAt(index).toString(),
                                        context);
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                : const Center(
                    child: Text('Click The \'+\' icon to add Tutors'),
                  );
          }

          return const Center(
            child: Text('Something Went Wrong!!'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTutor(email: widget.user.email)));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
