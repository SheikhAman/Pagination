import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RemoteServices {

  static var client = http.Client();

  static String baseUrl = 'https://jsonplaceholder.typicode.com/';

  Map<String,String> headers = {'Content-Type': 'application/json; charset=UTF-8',
   // 'Authorization': 'Bearer ${localPreferences.token.val}'
  };


  Future<List> getOrderListData({required int limit,required int page}) async {

    final url = '${baseUrl}posts?_limit=$limit&_page=$page';
    debugPrint("body-> ${jsonEncode(url)}");

    var response = await client.get(
      Uri.parse(url),
      headers: headers,
    );

    debugPrint("item response ${response.statusCode} returning =>${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else if (response.statusCode == 400) {
      debugPrint("getOrderListData Error");
    //  negativeSnackbar(Icons.warning_outlined, "warning!".tr, "something_wrong".tr);
      throw const HttpException('getOrderListData Error');
    }
    else if (response.statusCode == 502 || response.statusCode == 500) {
      debugPrint("getOrderListData Error");
    //  negativeSnackbar(Icons.warning_outlined, "warning!".tr, "server_problem".tr);
      throw const HttpException('getTodayOrderListData Error');
    }
    else {
      debugPrint("getOrderListData Error");
      // negativeSnackbar(Icons.warning_outlined, "warning!".tr, "something_wrong".tr);
      throw const HttpException('getOrderListData Error');
    }
  }

}