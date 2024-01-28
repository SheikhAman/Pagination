import 'package:api_paginate_example/getx_pagination/paginate_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GetXPaginateView extends StatelessWidget {
  const GetXPaginateView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaginateController());
      return Scaffold(
      appBar: AppBar(
        title: const Text('GetX Paginate with API'),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: Obx(
        () =>  ListView.builder(
            controller: controller.scrollController,
            padding: const EdgeInsets.all(8),
            itemCount: controller.items.length + 1,
            itemBuilder: (context, index) {
              if (index < controller.items.length) {
                var item = controller.items[index];
                return ListTile(
                  title: Text(item),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: controller.hasMore.value
                        ? const CircularProgressIndicator()
                        : const Text('No more data to load'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}



