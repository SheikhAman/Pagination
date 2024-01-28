

import 'dart:io';

import 'package:api_paginate_example/getx_pagination/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaginateController extends GetxController{

  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  RxList items = [].obs;

  final scrollController = ScrollController();
  int limit = 25;
  int page = 1;

  void getOrderList() async {
 //   bool isOnline = await InternetChecker.hasInternet();
  //  if (isOnline) {
      try {
        isLoading.value = true;
        await RemoteServices().getOrderListData(limit: limit,page: page).then((response) async {
       //   orderData.clear();
       //   orderData.value = response;
       final List newItems = response;
          page++;

          if (newItems.length < limit) {
            hasMore.value = false;
          }
          items.addAll(newItems.map<String>((item) {
            final number = item['id'];
            return 'Item $number';
          }).toList());
        }
        ).catchError((error) {
          debugPrint('getOrderList catchError: $error');
        });
      } on HttpException catch (error) {
        debugPrint('getOrderList HttpException: $error');
      } finally {
        isLoading.value = false;

      }
  //  }
  }


  Future refresh() async {

      isLoading.value = false;
      hasMore.value = true;
      page = 1;
      items.clear();

      getOrderList();
  }

  @override
  void onInit() {
    getOrderList();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        getOrderList();
      }
    });

    // TODO: implement onInit
    super.onInit();
  }


}