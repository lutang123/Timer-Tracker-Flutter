import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/sign_in_page.dart';
import 'package:timetracker/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/services/database.dart';

import 'bottom_navigation/home_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build');
    //change listen to false so it will not rebuild when parent changes
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
      //we can also pass an initialData, then we don't need to check if it has data or not
      stream: auth.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<User>.value(
            value: user,
            child: Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomePage(),
            ),
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
