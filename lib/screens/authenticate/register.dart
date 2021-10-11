import 'package:bitetastic/services/auth.dart';
import 'package:bitetastic/shared/constants.dart';
import 'package:bitetastic/shared/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String username = "";
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.green[50],
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text('Sign up to Bitetastic'),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton.icon(
           icon: Icon(Icons.person, color: Colors.white,),
            label: Text('Sign in', style: TextStyle(color: Colors.white),),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      
      body: SingleChildScrollView(
        child: Container(
           decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/registerBg.png"
              ),
              fit: BoxFit.cover,
            )
          ),
          padding: EdgeInsets.symmetric(vertical: 140.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text("Create your account", style: 
                TextStyle(color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                ),
                ),

                Text("Get access to hundreds of recipes \n in just one app", style:
                TextStyle(color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
                SizedBox(
                  height: 20.0,
                ),
                // email field
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Username'),
                    validator: (val) =>
                        val.isEmpty ? 'Username must be filled' : null,
                    onChanged: (val) {
                      setState(() => username = val);
                    }
                ),

                SizedBox(
                  height: 20.0,
                ),
                // email field
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                    validator: (val) =>
                        val.isEmpty ? 'Email must be filled' : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    }
                ),
                
                SizedBox(height: 20.0),
                // password field
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
                    obscureText: true,
                    validator: (val) => val.length < 6
                        ? 'Password must be more than 6 characters'
                        : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                ),

                SizedBox(height: 20.0),
                ButtonTheme(
                  height: 50.0,
                  minWidth: size.width,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.green,
                    child: Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() => loading = true);
                        dynamic result = await _auth.register(email, password, username);
                        if (result == null) {
                          setState(() {
                            error = 'Please input a valid email and password';
                            loading = false;
                          });
                        } 
                      }
                    }
                  ),
                ),
                
                // error message
                SizedBox(height: 12.0),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
