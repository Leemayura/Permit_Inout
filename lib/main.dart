import 'package:flutter/material.dart';
import 'package:permit_inout/login.dart';
import 'package:permit_inout/permit_form.dart';
import 'package:permit_inout/register.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_super_parameters
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PERMIT IN-OUT',
      home: const Login(),
      routes: {
        'register': (context) => Register(),
        'permit_form':(context) => PermitForm(),
        'login':(context) => Login()
      },
    );
  }
}
