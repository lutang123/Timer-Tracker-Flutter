import 'package:flutter/material.dart';
import 'package:timetracker/app/sign_in/sign_in_button.dart';
import 'package:timetracker/app/sign_in/social_sign_in_button.dart';
import 'package:timetracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  SignInPage({@required this.auth});
//  final Function(User) onSignIn;
  final AuthBase auth;

//  Future<void> _signInAnonymously() async {
//    try {
//      final authResult = await FirebaseAuth.instance.signInAnonymously();
//      onSignIn(authResult.user);
//    } catch (e) {
//      print(e.toString());
//    }
//  }

  Future<void> _signInAnonymously() async {
    try {
      await auth.signInAnonymously();
//      onSignIn(user);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInAnonymously();
//      onSignIn(user);
    } catch (e) {
      print(e.toString());
    }
  }

  final bool isLoading = false;

//  const SignInPage({Key key, this.isLoading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
//    isLoading = false;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 48.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle,
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
//              onPressed: isLoading ? null : () => _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
//              key: emailPasswordKey,
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
//              onPressed: isLoading ? null : () => _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
