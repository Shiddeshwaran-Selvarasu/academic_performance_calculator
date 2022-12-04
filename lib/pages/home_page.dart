import 'package:academin_performance_calculator/pages/admin_page.dart';
import 'package:academin_performance_calculator/pages/tutor_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../modal/user_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final userStream = FirebaseFirestore.instance.collection('/user').doc(user!.email).snapshots();
    return StreamBuilder(
      stream: userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          String role = snapshot.data?.data()!['role'];
          BasicUser user = BasicUser(
              name: snapshot.data?.data()!['name'],
              email: snapshot.data?.data()!['email'],
              role: role);
          if (role == 'admin') {
            return AdminPage(user: user);
          } else {
            return TutorPage(user: user);
          }
        }

        return const Center(
          child: Text('Something Went Wrong!'),
        );
      },
    );
  }
}
