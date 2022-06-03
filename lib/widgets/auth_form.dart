import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, {Key? key}) : super(key: key);

  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
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
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(_userEmail, _userPassword, _username, _isLogin);
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
              ElevatedButton(
                onPressed: () {},
                child: Text('Login'),
              ),
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
