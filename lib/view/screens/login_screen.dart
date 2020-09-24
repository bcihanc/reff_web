import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:reff_web/core/providers/busy_state_notifier.dart';

class LoginScreen extends HookWidget {
  final _emailState = useState("");
  final _passwordState = useState("");

  Future<void> _hangleLogin(BuildContext context) async {
    context.read(BusyState.provider).busy();
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailState.value, password: _passwordState.value);
    } on Exception catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      context.read(BusyState.provider).notBusy();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = useProvider(BusyState.provider.state);

    final style = TextStyle(fontWeight: FontWeight.bold);
    final perfectWidth = MediaQuery.of(context).size.width;

    final isDarkMode =
        (MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      body: Container(
        width: perfectWidth,
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Image.network(
                  "images/logo.png",
                  color: isDarkMode ? Colors.grey : Colors.white,
                  width: 300,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("", style: style),
              ),
              Card(
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Icon(Icons.alternate_email),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => _emailState.value = value,
                    onSubmitted: (value) => _hangleLogin(context)),
              ),
              Divider(color: Colors.transparent),
              Card(
                child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: InputBorder.none,
                    ),
                    onChanged: (value) => _passwordState.value = value,
                    onSubmitted: (value) => _hangleLogin(context)),
              ),
              Divider(color: Colors.transparent),
              isBusy
                  ? SpinKitWave(color: Colors.grey)
                  : RaisedButton.icon(
                      color: Colors.grey,
                      icon: Icon(MdiIcons.login,
                          color: isDarkMode ? Colors.black : Colors.white),
                      label: Text(
                        "Sign In",
                        style: TextStyle(
                            color: isDarkMode ? Colors.black : Colors.white),
                      ),
                      onPressed: () => _hangleLogin(context),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
