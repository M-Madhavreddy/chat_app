import 'package:chat_app/Widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>{
  final _auth = FirebaseAuth.instance;
  late UserCredential authResult;

  @override
  void _submitForm(
      String Email, String Password, String UserName, bool isLogin) async {
    try {
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: Email, password: Password);
        print('login Successful');
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: Email, password: Password);
        print('sign up successful');
      }
    } on PlatformException catch (error) {
      String? msg = 'Invalid Credentials';

      if (error != null) {
        msg = error.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('1.$msg'),
        backgroundColor: Colors.redAccent,
      ));
    }
    catch (error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('2$error'),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm),
    );
  }
}
