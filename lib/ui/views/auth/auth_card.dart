import 'package:ethio_shoppers/core/models/http_exception.dart';
import 'package:ethio_shoppers/core/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthCard extends StatefulWidget {

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  AnimationController _controller;
  Animation<Size> _heightAnimation;

  @override
  void initState() {

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    final _curve = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _heightAnimation = Tween<Size>(begin: Size(double.infinity, 260), end: Size(double.infinity, 320)).animate(_curve);

    _heightAnimation.addListener(() => setState(() {}));
    super.initState();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    setState(() => _isLoading = true);

    try {
      if (_authMode == AuthMode.Login)
        await Provider.of<Auth>(context, listen: false).login(_authData["email"], _authData["password"]);
      else
        await Provider.of<Auth>(context, listen: false).signUp(_authData["email"], _authData["password"]);
    }
    on HttpException catch(err) {
      String errMessage;
      if( err.toString().contains("EMAIL_EXISTS"))
        errMessage = "Account already exists with this email";
      else if( err.toString().contains("WEAK_PASSWORD"))
        errMessage = "This password is too short";
      else if( err.toString().contains("EMAIL_NOT_FOUND"))
        errMessage = "Email not found";
      else if( err.toString().contains("INVALID_PASSWORD"))
        errMessage = "invalid password";
      else errMessage = "try later";

      _showErrorDialog(errMessage);
    }
    catch(err) {
      _showErrorDialog("Please try again"); // may be network ...
    }

    setState(() => _isLoading = false);
  }
  void _showErrorDialog(String message) {
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text("Authentication Error!"),
      content: Text(message),
      actions: [
        TextButton(
            onPressed: ()=>Navigator.of(ctx).pop(),
            child: Text("Okay"))
      ],
    ));
  }
  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() => _authMode = AuthMode.Signup);
      _controller.forward();
    }
    else {
      setState(() => _authMode = AuthMode.Login);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        // height: _authMode == AuthMode.Signup ? 320 : 260,
        height: _heightAnimation.value.height,
        constraints:
        BoxConstraints(minHeight: _heightAnimation.value.height),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                    } : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                    Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                    EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
