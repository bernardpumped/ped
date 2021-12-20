/*
 *     Copyright (c) 2021.
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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pumped_end_device/user-interface/tabs/about/screen/datasource/remote/get_backend_metadata.dart';
import 'package:pumped_end_device/user-interface/tabs/about/screen/datasource/remote/model/response/get_backend_metadata_response.dart';
import 'package:pumped_end_device/user-interface/tabs/about/screen/datasource/remote/response-parser/get_backend_metadata_response_parser.dart';
import 'package:pumped_end_device/user-interface/fonts_and_colors.dart';
import 'package:pumped_end_device/util/log_util.dart';

class ServerVersionWidget extends StatefulWidget {
  ServerVersionWidget({Key key}) : super(key: key);

  @override
  _ServerVersionWidgetState createState() => _ServerVersionWidgetState();
}

class _ServerVersionWidgetState extends State<ServerVersionWidget> {
  static const _TAG = 'ServerVersionWidget';
  Future<GetBackendMetadataResponse> _backendMetadataResponseFuture;

  @override
  void initState() {
    super.initState();
    _backendMetadataResponseFuture = _getBackendMetadata();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _backendMetadataResponseFuture,
        builder: (context, snapshot) {
          String displayText;
          if (snapshot.hasData) {
            GetBackendMetadataResponse response = snapshot.data;
            if (response.responseCode == 'SUCCESS') {
              displayText = 'Server Version ${response.versionId}';
            } else {
              displayText = response.responseDetails;
            }
          } else if (snapshot.hasError) {
            displayText = 'Error loading ${snapshot.error}';
          } else {
            displayText = 'Loading...';
          }
          return ListTile(
              title: Text(displayText,
                  style: TextStyle(fontSize: FontsAndColors.largeFontSize, color: FontsAndColors.blackTextColor),
                  textAlign: TextAlign.center));
        });
  }

  Future<GetBackendMetadataResponse> _getBackendMetadata() async {
    GetBackendMetadataResponse response;
    try {
      response = await new GetBackendMetadata(new GetBackendMetadataResponseParser()).execute(null);
    } on Exception catch (e, s) {
      LogUtil.debug(_TAG, 'Exception happened while making call GetBackendMetadata $s');
      response = GetBackendMetadataResponse("CALL-EXCEPTION", s.toString(), {}, DateTime.now().millisecondsSinceEpoch);
    }
    return response;
  }
}
