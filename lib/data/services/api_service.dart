import 'dart:convert';
import 'dart:io';

import 'package:realise/core/utils/local_strings.dart';
import 'package:realise/data/model/global/response_model/response_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:realise/core/helper/shared_preference_helper.dart';
import 'package:realise/core/route/route.dart';
import 'package:realise/core/utils/method.dart';
import 'package:realise/data/model/authorization/authorization_response_model.dart';

class ApiClient extends GetxService {
  SharedPreferences sharedPreferences;
  ApiClient({required this.sharedPreferences});

  Future<ResponseModel> request(
    String uri,
    String method,
    Map<String, dynamic>? params, {
    bool passHeader = false,
    bool isOnlyAcceptType = false,
  }) async {
    Uri url = Uri.parse(uri);
    http.Response response;

    try {
      if (method == Method.postMethod) {
        if (passHeader) {
          initToken();
          if (isOnlyAcceptType) {
            response = await http.post(url, body: params, headers: {
              "Accept": "application/json",
            });
          } else {
            response = await http.post(url, body: params, headers: {
              "Accept": "application/json",
              "Authorization": token
            });
          }
        } else {
          response = await http.post(url, body: params);
        }
      } else if (method == Method.postMethod) {
        if (passHeader) {
          initToken();
          response = await http.post(url,
              body: params,
              headers: {"Accept": "application/json", "Authorization": token});
        } else {
          response = await http.post(url, body: params);
        }
      } else if (method == Method.putMethod) {
        if (passHeader) {
          initToken();
          response = await http.put(url,
              body: params,
              headers: {"Accept": "application/json", "Authorization": token});
        } else {
          response = await http.post(url, body: params);
        }
      } else if (method == Method.deleteMethod) {
        response = await http.delete(url);
      } else if (method == Method.updateMethod) {
        response = await http.patch(url);
      } else {
        if (passHeader) {
          initToken();
          response = await http.get(url,
              headers: {"Accept": "application/json", "Authorization": token});
        } else {
          response = await http.get(
            url,
          );
        }
      }

      if (kDebugMode) {
        print('url--------------${uri.toString()}');
        print('params-----------${params.toString()}');
        print('status-----------${response.statusCode}');
        print('body-------------${response.body.toString()}');
        print('token------------$token');
      }

      if (response.statusCode == 200) {
        try {
          AuthorizationResponseModel model =
              AuthorizationResponseModel.fromJson(jsonDecode(response.body));
          if (!model.success!) {
            sharedPreferences.setBool(
                SharedPreferenceHelper.rememberMeKey, false);
            sharedPreferences.remove(SharedPreferenceHelper.token);
            Get.offAllNamed(RouteHelper.loginScreen);
            return ResponseModel(false, model.message!, 401, response.body);
          }
        } catch (e) {
          e.toString();
        }

        return ResponseModel(true, 'Success', 200, response.body);
      } else if (response.statusCode == 401) {
        AuthorizationResponseModel model =
            AuthorizationResponseModel.fromJson(jsonDecode(response.body));
        sharedPreferences.setBool(SharedPreferenceHelper.rememberMeKey, false);
        Get.offAllNamed(RouteHelper.loginScreen);
        return ResponseModel(false, model.message!, 401, response.body);
      } else if (response.statusCode == 500) {
        return ResponseModel(
            false, LocalStrings.serverError.tr, 500, response.body);
      } else {
        return ResponseModel(
            false, LocalStrings.somethingWentWrong.tr, 499, response.body);
      }
    } on SocketException {
      return ResponseModel(false, LocalStrings.noInternet.tr, 503, '');
    } on FormatException {
      return ResponseModel(false, LocalStrings.badResponseMsg.tr, 400, '');
    } catch (e) {
      return ResponseModel(false, LocalStrings.somethingWentWrong.tr, 499, '');
    }
  }

  String token = '';
  String tokenType = '';

  initToken() {
    if (sharedPreferences.containsKey(SharedPreferenceHelper.accessTokenKey)) {
      String? t =
          sharedPreferences.getString(SharedPreferenceHelper.accessTokenKey);
      String? tType =
          sharedPreferences.getString(SharedPreferenceHelper.accessTokenType);
      token = t ?? '';
      tokenType = tType ?? 'Bearer';
    } else {
      token = '';
      tokenType = 'Bearer';
    }
  }
}
