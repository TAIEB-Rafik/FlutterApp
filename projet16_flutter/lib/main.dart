import 'package:flutter/material.dart';
import 'package:projet16_flutter/UI/login.dart';
import 'package:projet16_flutter/UI/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login':(context) => const LoginUi(),
        'sign_up':(context) => const SignUpUi()
      }
        ,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

    );
  }
}



