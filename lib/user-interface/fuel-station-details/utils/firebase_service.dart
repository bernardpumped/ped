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
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pumped_end_device/util/log_util.dart';

class SignedInUser {
  static const _tag = 'SignedInUser';
  bool isMockUser = false;
  User? user;

  SignedInUser(this.isMockUser, {this.user});

  Future<String> getToken() async {
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
}

class FirebaseService {
  static const _tag = 'FirebaseService';
  static const googleIdProvider = 'google-signin';
  static const facebookIdProvider = 'facebook-signin';
  static const twitterIdProvider = 'twitter-signin';
  static const _idProviders = [googleIdProvider, facebookIdProvider, twitterIdProvider];

  static final Map<String, List<String>> _osSupport = {
    'android': [googleIdProvider],
    'ios': [],
    'fuchsia': [],
    'linux': [],
    'macos': [],
    'windows': []
  };

  static final List<String> _webSupport = [googleIdProvider];

  late FirebaseAuth _auth;
  late GoogleSignIn _googleSignIn;

  FirebaseService() {
    List<String>? platformSupport = _getPlatformSupport();
    LogUtil.debug(_tag, 'platformSupport is $platformSupport');
    if (platformSupport != null && platformSupport.isNotEmpty) {
      _auth = FirebaseAuth.instance;
      if (platformSupport.contains(googleIdProvider)) {
        _googleSignIn = GoogleSignIn();
      }
    } else {
      LogUtil.debug(_tag, 'Platform does not support firebase');
    }
  }

  List<String>? _getPlatformSupport() {
    List<String>? platformSupport;
    if (kIsWeb) {
      platformSupport = _webSupport;
    } else {
      platformSupport = _osSupport[Platform.operatingSystem];
    }
    return platformSupport;
  }

  String? idProviderUsed;

  SignedInUser? getSignedInUser() {
    if (idProviderUsed == null) {
      return null;
    }
    final List<String>? platformSupport =_getPlatformSupport();
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
    final List<String>? platformSupport = _getPlatformSupport();
    if (platformSupport != null) {
      if (platformSupport.contains(idProviderType)) {
        switch (idProviderType) {
          case googleIdProvider:
            return _signInWithGoogle();
          case facebookIdProvider:
            throw UnimplementedError('$idProviderType mechanism not implemented yet');
          case twitterIdProvider:
            throw UnimplementedError('$idProviderType mechanism not implemented yet');
          default:
            throw UnimplementedError('$idProviderType mechanism not implemented yet');
        }
      }
    } else {}
    return true;
  }

  Future<bool> _signInWithGoogle() async {
    final UserCredential userCred = await _signInWithGoogleInternal();
    if (userCred.user != null) {
      LogUtil.debug(_tag, 'userCred.user.displayName = ${userCred.user?.displayName}');
      return true;
    } else {
      LogUtil.debug(_tag, 'userCred.user is null');
      return false;
    }
  }

  Future<UserCredential> _signInWithGoogleInternal() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      LogUtil.error(_tag, 'Error happened : ${e.message}');
      rethrow;
    }
  }

  Future<void> signOut(final SignedInUser? signedInUser) async {
    if (signedInUser != null && !signedInUser.isMockUser && signedInUser.user != null) {
      final User userDetails = signedInUser.user!;
      final String? providerId = userDetails.providerData.isNotEmpty ? userDetails.providerData[0].providerId : null;
      if (providerId != null) {
        if (providerId.contains('google')) {
          await _googleSignIn.signOut();
        }
        // TODO extend this logic for twitter and facebook
      }
      bool isGoogleSignedIn = await _googleSignIn.isSignedIn();
      if (isGoogleSignedIn) {
        await _googleSignIn.signOut();
      }
      // TODO extend this logic for twitter and facebook
      await _auth.signOut();
    }
    idProviderUsed = null;
  }
}
