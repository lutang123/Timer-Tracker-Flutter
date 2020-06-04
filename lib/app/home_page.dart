import 'package:flutter/material.dart';
import 'package:timetracker/services/auth.dart';

class HomePage extends StatelessWidget {
  HomePage({@required this.auth});
//  final VoidCallback onSignOut;
  final Auth auth;

//  Future<void> _signOut() async {
//    try {
//      await FirebaseAuth.instance.signOut();
//      onSignOut();
//    } catch (e) {
//      print(e.toString());
//    }
//  }

  Future<void> _signOut() async {
    try {
      await auth.signOut();
//      onSignOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: _signOut,
          )
        ],
      ),
    );
  }
}
