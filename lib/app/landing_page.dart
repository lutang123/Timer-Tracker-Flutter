import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/sign_in_page.dart';
import 'package:timetracker/services/auth.dart';

import 'home_page.dart';

class LandingPage extends StatelessWidget {
  LandingPage({@required this.auth});
  final AuthBase auth;
//
//  @override
//  _LandingPageState createState() => _LandingPageState();
//}
//
//class _LandingPageState extends State<LandingPage> {
////  FirebaseUser _user;
//  User _user;

  //_LandingPageState.initState() returned a Future
  //State.initState() must be a void method without an 'async' keyword.
  //rather than awaiting on asynchronous work directly inside of initState,
  // call a separate method to do this without awaiting it.
//  void initState() async {
//    // TODO: implement initState
//    super.initState();
//    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    _updateUser(user);
//  }
//  @override
//  void initState() {
//    // TODO: implement initState
//    super.initState();
//    //note this method is called without awaiting.
//    // await suspends the execution of the code, calling await is optional.
////    _checkCurrentUser();
//    //we listen to the change on the stream, and be notified everytime the user is updated.
//    widget.auth.onAuthStateChanged.listen((event) {
//      //?. means is event is null, print as null, otherwise print uid
//      print('user: ${event?.uid}');
//    });
//  }

//  Future<void> _checkCurrentUser() async {
//    //this instance is a singleton patter
//    User user = await widget.auth.currentUser();
////    _updateUser(user);
//  }

//  void _updateUser(FirebaseUser user) {
//    setState(() {
//      _user = user;
//    });
//    print('User id: ${user.uid}');
//  }

//  //with StreamBuilder, we no longer need this
//  void _updateUser(User user) {
//    setState(() {
//      _user = user;
//    });
//    print('User id: ${user.uid}');
//  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      //we can also pass an initialData, then we don't need to check if it has data or not
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage(
              auth: auth,
//              onSignIn: _updateUser,
              // same as: onSignIn: (user) => _updateUser(user),
            );
          }
          return HomePage(
            auth: auth,
            //onSignOut takes a VoidCallback, which means no parameters
//            onSignOut: () => _updateUser(null),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
