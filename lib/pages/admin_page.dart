import 'package:flutter/material.dart';

import '../modal/user_modal.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({required this.user,Key? key}) : super(key: key);

  final BasicUser user;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
