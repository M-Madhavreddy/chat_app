import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitForm, this.isLoading);

  final bool isLoading;

  final void Function(
      String email, String password, String userName, bool isLogin) submitForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  @override
  final _formkey = GlobalKey<FormState>();
  var _islogin = true;
  var _passwordVisible;
  String _userEmail = '';
  String _password = '';
  String _userName = '';

  void initState() {
    _passwordVisible = false;
  }

  void _trySubmit() {
    final _isvalid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_isvalid) {
      _formkey.currentState!.save();

      widget.submitForm(
          _userEmail.trim(), _password.trim(), _userName.trim(), _islogin);
    }
  }

  Widget build(BuildContext context) {
    // bool loadingStatus = widget.isLoading;
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Column(
              // cloumn within single child scroll view can take as much as space required leading to infinity height
              //size helps in just taking as min space req
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'please enter a valid E-mail';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'E-Mail ID'),
                  onSaved: (value) {
                    _userEmail = value!;
                  },
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || value!.length < 7) {
                      return 'please enter a valid password with atleast 7 characters';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                if (!_islogin)
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value!.length < 5) {
                        return 'please enter a valid userName with atleast 5 characters';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(labelText: 'User_Name'),
                    onSaved: (value) {
                      _userName = value!;
                    },
                  ),
                const SizedBox(
                  height: 12,
                ),
                if (widget.isLoading)
                  CircularProgressIndicator()
                else
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _trySubmit,
                      child: Text(_islogin ? 'Login' : 'SignUp'),
                    ),
                  ),
                  TextButton(
                  onPressed: () {
                    setState(() {
                      _islogin = !_islogin;
                    });
                  },
                  child: Text(
                      _islogin ? 'Create New Account' : 'Already Registered?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
