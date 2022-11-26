import 'package:flutter/material.dart';

import '../modal/user_modal.dart';

class TutorPage extends StatefulWidget {
  const TutorPage({Key? key,required this.user}) : super(key: key);

  final BasicUser user;

  @override
  State<TutorPage> createState() => _TutorPageState();
}

class _TutorPageState extends State<TutorPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
