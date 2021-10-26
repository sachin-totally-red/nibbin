// Determine if Apple SignIn is available
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:nibbin_app/common/shared_preference.dart';
import 'package:nibbin_app/resource/login_repository.dart';

/// Sign in with Apple
Future appleSignIn(
    {BuildContext context, GlobalKey<ScaffoldState> scaffoldKey}) async {
  try {
    final _firebaseAuth = auth.FirebaseAuth.instance;
    bool isAvailable = await AppleSignIn.isAvailable();

    if (!isAvailable) return null;
    final AuthorizationResult appleResult = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    if (appleResult.error != null) {
      // handle errors from Apple here
      return false;
    }

    print(appleResult);
    final auth.AuthCredential credential =
        auth.OAuthProvider('apple.com').credential(
      accessToken:
          String.fromCharCodes(appleResult.credential.authorizationCode),
      idToken: String.fromCharCodes(appleResult.credential.identityToken),
    );

    auth.UserCredential firebaseResult =
        await _firebaseAuth.signInWithCredential(credential);
    auth.User user = firebaseResult.user;

    //Make API call here to save data on our backend
    String _fullName = (appleResult.credential.fullName.givenName ?? "") +
        " " +
        (appleResult.credential.fullName.familyName ?? "");
    String _email = (appleResult.credential.email);

    var response = await LoginRepository.saveDataForAppleSignIn(
      email: _email,
      fullName: _fullName,
      scaffoldKey: scaffoldKey,
    );
    if (response) await addStringToSF("UserIDFirebaseAppleIdLogin", user.uid);

    print(user);
    return response;
  } catch (error) {
    print(error);
    return false;
  }
}
