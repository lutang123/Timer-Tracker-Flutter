import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timetracker/services/auth.dart';

///changed from SignInBloc to this.
class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);

//  Future<User> signInWithFacebook() async => await _signIn(auth.signInWithFacebook);
}

// /// later changed all these with value notifier
// class SignInBloc {
//   SignInBloc({@required this.auth});
//   final AuthBase auth;
//
//   final StreamController<bool> _isLoadingController = StreamController<bool>();
//   Stream<bool> get isLoadingStream => _isLoadingController.stream;
//
//   void dispose() {
//     _isLoadingController.close();
//   }
//
//   void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
//
//   Future<User> _signIn(Future<User> Function() signInMethod) async {
//     try {
//       _setIsLoading(true);
//       return await signInMethod();
//     } catch (e) {
//       _setIsLoading(false);
//       rethrow;
//     }
//   }
//
//   Future<User> signInAnonymously() async =>
//       await _signIn(auth.signInAnonymously);
//
//   Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
//
// // Future<User> signInWithFacebook() async => await _signIn(auth.signInWithFacebook);
// }
