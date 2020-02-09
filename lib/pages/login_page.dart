import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  String _email, _password;
  bool _isSubmitting, _obscure = true;

  Widget _showTitle() {
    return Text('Login', style: Theme.of(context).textTheme.headline);
  }

  Widget _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
      ),
      child: TextFormField(
        //TODO: Remember
        onSaved: (val) => _email = val,
        validator: (val) =>
            !val.contains('@') ? 'Invalid Email' : null,
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
        validator: (val) => val.length < 6 ? 'Enter Valid Password' : null,
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
          hintText: 'Enter password, min length 6',
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
                  color: Colors.blueGrey,
                  onPressed: _submit,
                  splashColor: Colors.grey[400],
                ),
          FlatButton(
              child: Text('New User? Register'),
              onPressed: () =>
                  Navigator.of(context).pushReplacementNamed('/Register'))
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
    http.Response response = await http.post('http://10.0.2.2:1337/auth/local',
        body: {"identifier": _email, "password": _password});
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
        'User successfully Logged In!',
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
    throw Exception('Error logging in: $msg');
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
          'Login',
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
