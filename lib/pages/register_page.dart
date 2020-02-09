import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _username, _email, _password;
  bool _obscure = true;
  bool _isSubmitting;

  Widget _showTitle() {
    return Text('Register', style: Theme.of(context).textTheme.headline);
  }

  Widget _showUsernameInput() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: TextFormField(
        onSaved: (val) => _username = val,
        validator: (val) => val.length < 6 ? 'Username too short' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
          hintText: 'Enter username, min length 6',
          icon: Icon(
            Icons.face,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: TextFormField(
        //TODO: Remember
        onSaved: (val) => _email = val,
        validator: (val) => !val.contains(RegExp(
                r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$'))
            ? 'Invalid Email'
            : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
          hintText: 'Enter a valid email',
          icon: Icon(
            Icons.mail,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: TextFormField(
        onSaved: (val) => _password = val,
        validator: (val) =>
            (!val.contains(RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$')))
                ? 'Eight characters [A-Z] and [0-9]'
                : null,
        obscureText: _obscure,
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscure = !_obscure;
              });
            },
            child: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
          ),
          border: OutlineInputBorder(),
          labelText: 'Password',
          hintText: 'Enter password atleast one number',
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(
        top: 45,
      ),
      child: Column(
        children: <Widget>[
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                )
              : RaisedButton(
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.body1.copyWith(
                        color: Colors.grey[900], fontWeight: FontWeight.bold),
                  ),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  color: Theme.of(context).primaryColor,
                  onPressed: _submit,
                  splashColor: Colors.grey[400],
                ),
          FlatButton(
            child: Text('Existing User? Login'),
            onPressed: () =>
                Navigator.of(context).pushReplacementNamed('/login'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    //iterate through all the validator functions and see if they are true and return true
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() => _isSubmitting = true);
    http.Response response = await http.post(
        'http://10.0.2.2:1337/auth/local/register',
        body: {"username": _username, "email": _email, "password": _password});
    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();
      print(responseData);
    } else {
      setState(() => _isSubmitting = false);

      final String errorMsg = responseData['message'];
      _showErrorSnack(errorMsg);
    }
  }

  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences
        .getInstance(); //to get access and store userdata and store as key,value pair
    //taking jwt and user and combining them to one single entry
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    String stringUser = json.encode(user);
    print(stringUser);
    prefs.setString('user', stringUser);
  }

  _showSuccessSnack() {
    final snackbar = SnackBar(
      content: Text(
        'User $_username successfully created!',
        style: TextStyle(color: Colors.green),
      ),
      backgroundColor: Colors.grey[850],
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  _showErrorSnack(String msg) {
    final snackbar = SnackBar(
      content: Text(
        msg,
        style: TextStyle(color: Colors.red),
      ),
      backgroundColor: Colors.grey[850],
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    throw Exception('Error registering: $msg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/product');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _showTitle(),
                  _showUsernameInput(),
                  _showEmailInput(),
                  _showPasswordInput(),
                  _showFormActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
