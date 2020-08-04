import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reff_web/view/screens/questions_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email;
  String _password;

  String _result;

  bool _isBusy = false;

  Future<void> _hangleLogin() async {
    setState(() => _isBusy = true);
    try {
      final result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);

      if (result.user != null) {
        Navigator.pushReplacementNamed(context, QuestionsScreen.route);
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(fontWeight: FontWeight.bold);
    final perfectWidth = MediaQuery.of(context).size.width;
    return Container(
      width: perfectWidth,
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Card(
          color: Colors.grey.shade700,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("", style: style),
              ),
              Card(
                margin: const EdgeInsets.all(8),
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "email",
                      prefixIcon: Icon(Icons.alternate_email),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => setState(() => _email = value)),
              ),
              Card(
                margin: const EdgeInsets.all(8),
                child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "password",
                      prefixIcon: Icon(Icons.lock),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => setState(() => _password = value),
                    onSubmitted: (value) => setState(() => _password = value)),
              ),
              _isBusy
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text("sign in"),
                      onPressed: _hangleLogin,
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_result ?? ""),
              )
            ],
          ),
        ),
      ),
    );
  }
}
