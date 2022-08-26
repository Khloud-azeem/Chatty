import 'dart:io';

import 'package:chatty/widgets/auth/profile_photo.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);
  var isLoading = false;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
    String path,
    BuildContext context,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = '';
  String _userPassword = '';
  String _username = '';
  String _photoPath = '';

  void pickImage(String path) {
    _photoPath = path;
  }

  _trySubmit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState!.validate();
    if (!_isLogin && _photoPath.isEmpty) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("No photo selected.")));
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _username.trim(),
        _isLogin,
        _photoPath,
        context,
      );
      setState(() {
        widget.isLoading = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(13),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Form(
            key: _formKey,
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              if (!_isLogin) ProfilePhoto(pickImage),
              TextFormField(
                key: Key('email'),
                validator: (value) {
                  if (!EmailValidator.validate(value as String)) {
                    return "This email isn't valid.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _userEmail = value!;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email address'),
              ),
              if (!_isLogin)
                TextFormField(
                  key: Key('username'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 3) {
                      return "This username isn't valid.";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _username = value!;
                  },
                  decoration: InputDecoration(labelText: 'Username'),
                ),
              TextFormField(
                key: Key('password'),
                validator: (value) {
                  if (value!.isEmpty || value.length < 7) {
                    return "This password isn't valid.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _userPassword = value!;
                },
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              SizedBox(
                height: 13,
              ),
              if (widget.isLoading) CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                  onPressed: _trySubmit,
                  child: Text(_isLogin ? 'Login' : 'Create account'),
                ),
              if (!widget.isLoading)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? 'Create an account'
                      : 'Have an account? Login instead'),
                ),
            ]),
          ),
        )),
      ),
    );
  }
}
