/*
 *     Copyright (c) 2022.
 *     This file is part of Pumped End Device.
 *
 *     Pumped End Device is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     Pumped End Device is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with Pumped End Device.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pumped_end_device/util/log_util.dart';
import 'package:twitter_login/twitter_login.dart';

class SignedInUser {
  bool isMockUser = false;
  User? user;

  SignedInUser(this.isMockUser, {this.user});

  Future<String?> getToken() async {
    if (!isMockUser && user != null) {
      return await user!.getIdToken();
    }
    return 'regression-token';
  }

  String getUserId() {
    if (!isMockUser && user != null) {
      return user!.uid;
    }
    return 'regression-user-id';
  }

  String? getUserDisplayName() {
    if (isMockUser) {
      return 'Regression User';
    }
    return user?.displayName;
  }

  String? getEmail() {
    if (isMockUser) {
      return 'regression@email.com';
    }
    List<UserInfo>? providerData = user?.providerData;
    if (providerData != null && providerData.isNotEmpty) {
      return providerData[0].email;
    }
    return user?.email;
  }

  String? getPhotoUrl() {
    List<UserInfo>? providerData = user?.providerData;
    if (providerData != null && providerData.isNotEmpty) {
      return providerData[0].photoURL;
    }
    return user?.photoURL;
  }

  bool isSignedIn() {
    return user != null;
  }

}

class FirebaseService {
  static const _tag = 'FirebaseService';
  static const googleIdProvider = 'google-signin';
  static const facebookIdProvider = 'facebook-signin';
  static const twitterIdProvider = 'twitter-signin';
  static const _idProviders = [googleIdProvider, facebookIdProvider, twitterIdProvider];

  static final Map<String, List<String>> _osSupport = {
    'android': [googleIdProvider, facebookIdProvider, twitterIdProvider],
    'ios': [googleIdProvider, facebookIdProvider, twitterIdProvider]
  };

  late FirebaseAuth _auth;
  late GoogleSignIn _googleSignIn;
  late FacebookAuth _facebookAuth;
  late TwitterLogin _twitterLogin;

  FirebaseService() {
    List<String>? platformSupport = _osSupport[Platform.operatingSystem];
    LogUtil.debug(_tag, 'platformSupport is $platformSupport');
    if (platformSupport != null && platformSupport.isNotEmpty) {
      _auth = FirebaseAuth.instance;
      if (platformSupport.contains(googleIdProvider)) {
        _googleSignIn = GoogleSignIn();
      }
      if (platformSupport.contains(facebookIdProvider)) {
        _facebookAuth = FacebookAuth.instance;
      }
      if (platformSupport.contains(twitterIdProvider)) {
        _twitterLogin = TwitterLogin(
            apiKey: "YOUR_Twitter_apiKey", apiSecretKey: "YOUR_Twitter_apiSecretKey", redirectURI: "twittersdk://");
      }
    } else {
      LogUtil.debug(_tag, 'Platform does not yet support firebase');
    }
  }

  String? idProviderUsed;

  SignedInUser? getSignedInUser() {
    if (idProviderUsed == null) {
      return null;
    }
    final List<String>? platformSupport = _osSupport[Platform.operatingSystem];
    if (platformSupport != null && platformSupport.contains(idProviderUsed)) {
      return SignedInUser(false, user: FirebaseAuth.instance.currentUser);
    }
    return SignedInUser(true);
  }

  Future<bool> signIn(final String idProviderType) async {
    if (!_idProviders.contains(idProviderType)) {
      throw FirebaseAuthException(message: 'Unknown idProviderType $idProviderType', code: 'unknown-idProvider');
    }
    idProviderUsed = idProviderType;
    final List<String>? platformSupport = _osSupport[Platform.operatingSystem];
    if (platformSupport != null) {
      if (platformSupport.contains(idProviderType)) {
        switch (idProviderType) {
          case googleIdProvider:
            return (await _signInWithGoogleInternal()).status == Status.success;
          case facebookIdProvider:
            return (await _signInWithFacebookInternal()).status == Status.success;
          case twitterIdProvider:
            return (await _signInWithTwitterInternal()).status == Status.success;
          default:
            throw UnimplementedError('$idProviderType mechanism not implemented yet');
        }
      }
    } else {}
    return true;
  }

  Future<Resource> _signInWithGoogleInternal() async {
    try {
      LogUtil.debug(_tag, 'statement-1');
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      LogUtil.debug(_tag, 'statement-2');
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      LogUtil.debug(_tag, 'statement-3');
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      LogUtil.debug(_tag, 'statement-4');
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      LogUtil.debug(_tag, 'statement-5');
      if (userCredential.user != null) {
        LogUtil.debug(_tag, '_signInWithGoogleInternal::signin successful');
        return Resource(status: Status.success);
      } else {
        LogUtil.debug(_tag, '_signInWithGoogleInternal::signin failed :: user null');
        return Resource(status: Status.error);
      }
    } on FirebaseAuthException catch (e) {
      LogUtil.debug(_tag, '_signInWithGoogleInternal::Error happened : ${e.message}');
      return Resource(status: Status.error);
    }
  }

  Future<Resource> _signInWithFacebookInternal() async {
    try {
      LogUtil.debug(_tag, '_signInWithFacebookInternal::attempting');
      final LoginResult result = await _facebookAuth.login();
      LogUtil.debug(_tag, '_signInWithFacebookInternal::LoginResult received $result');
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential = FacebookAuthProvider.credential(result.accessToken!.token);
          UserCredential userCredential = await _auth.signInWithCredential(facebookCredential);
          if (userCredential.user != null) {
            LogUtil.debug(_tag, '_signInWithFacebookInternal::signin successful');
            return Resource(status: Status.success);
          } else {
            LogUtil.debug(_tag, '_signInWithFacebookInternal::signin failed :: user null');
            return Resource(status: Status.error);
          }
        case LoginStatus.cancelled:
          LogUtil.debug(_tag, '_signInWithFacebookInternal::signin cancelled');
          return Resource(status: Status.cancelled);
        case LoginStatus.failed:
        default:
          LogUtil.debug(_tag, '_signInWithFacebookInternal::signin failed');
          return Resource(status: Status.error);
      }
    } on FirebaseAuthException catch (e) {
      LogUtil.debug(_tag, '_signInWithFacebookInternal::Error happened : ${e.message}');
      return Resource(status: Status.error);
    }
  }
//https://stackoverflow.com/questions/70937933/how-to-set-up-firebase-authentication-with-twitter-login-4-0-1-and-f
  Future<Resource> _signInWithTwitterInternal() async {
    try {
      LogUtil.debug(_tag, '_signInWithTwitterInternal::attempting');
      final result = await _twitterLogin.loginV2();
      LogUtil.debug(_tag, '_signInWithTwitterInternal::LoginResult received ${result.authToken} ${result.errorMessage}');
      switch (result.status) {
        case TwitterLoginStatus.loggedIn:
          final AuthCredential twitterAuthCredential =
              TwitterAuthProvider.credential(accessToken: result.authToken!, secret: result.authTokenSecret!);
          final userCredential = await _auth.signInWithCredential(twitterAuthCredential);
          if (userCredential.user != null) {
            LogUtil.debug(_tag, '_signInWithTwitterInternal::signin successful');
            return Resource(status: Status.success);
          } else {
            LogUtil.debug(_tag, '_signInWithTwitterInternal::signin failed :: user null');
            return Resource(status: Status.error);
          }
        case TwitterLoginStatus.cancelledByUser:
          LogUtil.debug(_tag, '_signInWithTwitterInternal::signin cancelled');
          return Resource(status: Status.cancelled);
        case TwitterLoginStatus.error:
        default:
          LogUtil.debug(_tag, '_signInWithTwitterInternal::signin failed');
          return Resource(status: Status.error);
      }
    } on FirebaseAuthException catch (e) {
      LogUtil.debug(_tag, '_signInWithTwitterInternal::Error happened : ${e.message}');
      return Resource(status: Status.error);
    }
  }

  Future<void> signOut(final SignedInUser? signedInUser) async {
    if (signedInUser != null && !signedInUser.isMockUser && signedInUser.user != null) {
      final User userDetails = signedInUser.user!;
      final String? providerId = userDetails.providerData.isNotEmpty ? userDetails.providerData[0].providerId : null;
      if (providerId != null) {
        if (providerId.contains('google')) {
          bool isGoogleSignedIn = await _googleSignIn.isSignedIn();
          if (isGoogleSignedIn) {
            await _googleSignIn.signOut();
          }
        }
        if (providerId.contains('facebook')) {
          await _facebookAuth.logOut();
        }
        if (providerId.contains('twitter')) {
          // Twitter login does not expose any API for logout.
        }
      }
      await _auth.signOut();
    }
    idProviderUsed = null;
  }
}

class Resource {
  final Status status;
  Resource({required this.status});
}

enum Status { success, error, cancelled }
