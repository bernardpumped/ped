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

import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:pumped_end_device/data/remote/model/pumped_http_exception.dart';
import 'package:pumped_end_device/data/remote/model/request/request.dart';
import 'package:pumped_end_device/data/remote/model/response/response.dart';
import 'package:pumped_end_device/data/remote/pumped_end_point.dart';
import 'package:pumped_end_device/data/remote/response-parser/response_parser.dart';
import 'package:pumped_end_device/util/log_util.dart';

abstract class HttpPostExecutor<I extends Request, O extends Response> {
  static const Map<String, String> headers = {
    "Content-Encoding": "utf-8",
    "Content-Type": "application/json; charset=UTF-8",
  };

  static const defaultTimeOut = 10000;

  final ResponseParser<O> responseParser;
  final String tag;
  final int timeOutInMills;
  Function onTimeOutFunction;

  HttpPostExecutor(this.tag, this.responseParser, {this.timeOutInMills: defaultTimeOut, this.onTimeOutFunction}) {
    if (onTimeOutFunction == null) {
      onTimeOutFunction = () {
        LogUtil.debug(tag, 'Timeout happened');
      };
    }
  }

  Future<O> execute(final I request) async {
    final String url = PumpedEndPoint.pumperBaseUrl + getUrl();
    LogUtil.debug(tag, 'execute::url is $url');
    var response;
    int startTimeMills;
    try {
      startTimeMills = DateTime.now().millisecondsSinceEpoch;
      var requestBody = convert.jsonEncode(request.toJson());
      LogUtil.debug(tag, 'Request - $requestBody');
      response = await http
          .post(Uri.parse(url), body: requestBody, headers: headers)
          .timeout(Duration(milliseconds: timeOutInMills), onTimeout: onTimeOutFunction);
    } catch (e, s) {
      LogUtil.debug(tag, 'execute::Exception happened while making call to server $s ${e.toString()}');
      return getDefaultResponse(
          'CALL-FAILED', 'Exception when making call', DateTime.now().millisecondsSinceEpoch, request);
    } finally {
      LogUtil.debug(tag, 'execute::Time taken ${DateTime.now().millisecondsSinceEpoch - startTimeMills}');
    }
    LogUtil.debug(tag, 'execute::response.statusCode : ${response.statusCode}');
    if (response != null) {
      if (response.statusCode == 200) {
        LogUtil.debug(tag, 'execute::response : ${response.body}');
        return responseParser.parseResponse(response.body);
      } else {
        throw pumpedHttpException(response.httpStatusCode, response.reasonPhrase, url);
      }
    } else {
      throw pumpedHttpException(408, 'Timed out', url);
    }
  }

  PumpedHttpException pumpedHttpException(final int httpStatusCode, final String reasonPhrase, String url) {
    return PumpedHttpException(
        httpStatusCode: httpStatusCode,
        httpStatusDescription: reasonPhrase,
        url: url,
        message: 'Exception occurred while $tag execute');
  }

  String getUrl();
  O getDefaultResponse(String responseCode, String responseDetails, int responseEpoch, I request);
}
