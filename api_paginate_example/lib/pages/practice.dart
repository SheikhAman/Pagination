import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  List items = [];
  int limit = 25;
  int page = 1;
  bool hasMore = true;
  bool isLoading = false;

  final controller = ScrollController();

  @override
  void initState() {
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
    super.initState();
  }

  Future fetch() async {
    if (isLoading) return;
    isLoading = true;
    print('called fetch');

    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page'));
    if (response.statusCode == 200) {
      page++;
      final List newList = jsonDecode(response.body);
      items.addAll(newList.map((item) {
        return 'Index ${item['id']}';
      }));

      if (newList.length < limit) {
        print('fdfdfdf' + newList.length.toString());
        hasMore = false;
      }
    }
    isLoading = false;
    setState(() {});
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      page = 1;
      limit = 25;
      items.clear();
    });
    fetch();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build called');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: controller,
          padding: const EdgeInsets.all(8),
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            if (index < items.length) {
              var item = items[index];
              return ListTile(
                title: Text(item),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: hasMore
                        ? CircularProgressIndicator()
                        : Text('No More Data To Load')),
              );
            }
          },
        ),
      ),
    );
  }
}
