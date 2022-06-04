import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading, {Key? key}) : super(key: key);
  var isLoading = false;
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
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

  _trySubmit() {
    FocusScope.of(context).unfocus();
    setState(() {
      widget.isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _username.trim(),
        _isLogin,
        context,
      );
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
              TextFormField(
                key: Key('email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  }
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
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return null;
                    }
                  }),
                  onSaved: (value) {
                    _username = value!;
                  },
                  decoration: InputDecoration(labelText: 'Username'),
                ),
              TextFormField(
                key: Key('password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return null;
                  }
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
