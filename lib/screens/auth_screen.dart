import 'package:chatty/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext context,
  ) async {
    try {
      UserCredential authResult;
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        setState(() {
          isLoading = false;
        });
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
        setState(() {
          isLoading = false;
        });
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      var msg = 'Please check your credentials.';
      if (error.message != null) msg = error.message!;
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      var msg = 'Something went wrong! Try again';
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, isLoading),
    );
  }
}
