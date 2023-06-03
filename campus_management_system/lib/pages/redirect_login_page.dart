import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RedirectLoginPage extends StatefulWidget {
  @override
  _RedirectLoginPageState createState() => _RedirectLoginPageState();
}

class _RedirectLoginPageState extends State<RedirectLoginPage> {
  @override
  void initState() {
    super.initState();
    // Programmatically navigate to the second page after 2 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/student_main');
    });
  }

  @override
  Widget build(BuildContext context) {
    String role = 'db get';
    return Scaffold(
      body: Center(
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.yellow,
                borderRadius: BorderRadius.all(Radius.circular(25))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    textAlign: TextAlign.center,
                    'You are login as a ' +
                        role +
                        ' \nRedirecting to the Login Page...',
                    style: TextStyle(fontSize: 30)),
                SizedBox(
                  height: 25,
                ),
                Text(
                  'You should be redirected automatically in 3 second if not please press Login Button',
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/student_main', (route) => false);
                    },
                    child: Text('Main page'))
              ],
            )),
      ),
    );
  }
}
