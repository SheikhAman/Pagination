import 'dart:io';
import 'package:api_paginate_example/getx_pagination/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PaginateController extends GetxController{

  RxBool isLoading = false.obs;
  bool isFirstCall = true;
  RxBool hasMore = true.obs; // From start we hope it is max than 25 so that we will load all data in the start.
  RxList items = [].obs;

  final scrollController = ScrollController();
  int limit = 25;
  int page = 1;

  // I want isLoading will only be true when it gets called first time after that it will always be false when it gets called how can i do it.

  void getOrderList() async {
 //   bool isOnline = await InternetChecker.hasInternet();
  //  if (isOnline) {
      try {
        // isLoading.value = true;
        isLoading.value = isFirstCall;
        await RemoteServices().getOrderListData(limit: limit, page: page)
            .then((response) async {
       //   orderData.clear();
       //   orderData.value = response;
       final List newItems = response;
          page++;
          // length starts from 1.
          // (newItems.length < limit) than 25 then hasMore value will be false.
          if (newItems.length < limit) {
            hasMore.value = false;
          }
          // Map function will return iterable and we will convert it to List using toList fun.
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
        isFirstCall = false; // set isFirstCall to false after the first call
      }

  //  }

  }


  Future refresh() async {
    // all values are reInitialize & Api fun gets called.
      isLoading.value = false;
      bool isFirstCall = true;
      hasMore.value = true;
      page = 1;
      items.clear();
      getOrderList();
  }

  @override
  void onInit() {

    // getOrderList();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        getOrderList();
      }
    });

    // TODO: implement onInit
    super.onInit();
  }

  buildMethod(){
    getOrderList();
    // scrollController.addListener(() {
    //   if (scrollController.position.maxScrollExtent == scrollController.offset) {
    //     getOrderList();
    //   }
    // });
  }



}