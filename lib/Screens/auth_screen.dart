import 'package:chat_app/Screens/chat_screen.dart';
import 'package:chat_app/Widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  late UserCredential authResult;
  bool isLoading = false;

  @override
  void _submitForm(
      String Email, String Password, String UserName, bool isLogin) async {
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: Email, password: Password);
        print('login Successful');
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: Email, password: Password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'userName': UserName, 'email': Email});
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
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('2$error'),
        backgroundColor: Colors.redAccent,
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshots) {
            if (userSnapshots.hasData) {
              return ChatScreen();
            }
            return AuthForm(_submitForm, isLoading);
          },
        ));
  }
}
