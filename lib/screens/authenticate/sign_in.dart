import 'package:bitetastic/services/auth.dart';
import 'package:bitetastic/shared/constants.dart';
import 'package:bitetastic/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.green[900],
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        elevation: 0.0,
        title: Text('Sign in to Bitetastic'),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton.icon(
            icon: Icon(Icons.person, color: Colors.white,),
            label: Text('Sign up', style: TextStyle(color: Colors.white),),
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
                "assets/loginBg.png"
              ),
              fit: BoxFit.cover,
            )
          ),
          padding: EdgeInsets.symmetric(vertical: 150.0, horizontal: 40.0),
          child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text("Welcome Back!", style:
                TextStyle(color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                ),
              ),

              Text("Login to your Bitetastic account", style:
                TextStyle(color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
                ),
              ),

              SizedBox(
                height: 100.0,
              ),

              // email field
              Container(
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) =>
                      val.isEmpty ? 'Email must be filled' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                    }
                  ),

                  decoration: BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: -4,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.0),
              // password field

              Container(
                child: TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Password'),
                  obscureText: true,
                  validator: (val) => val.length < 6
                      ? 'Password must be more than 6 characters'
                      : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  }
              ),

              decoration: BoxDecoration(
                    boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 15,
                      spreadRadius: -4,
                      offset: const Offset(2, 0),
                    ),
                  ],
                ),
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
                  color: Colors.green[900],
                  child: Text(
                    'Sign in',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() => loading = true);
                      dynamic result = await _auth.signIn(email, password);
                      if (result.runtimeType == String) {
                        setState(() {
                          error = result;
                          loading = false; 
                        });
                      }
                    }
                  },
                ),
              ),
            
              // error message
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            
            ],
            
          ),
        ),
       
        ),
      ),

    );
  }
}