import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class PaginateExample2 extends StatefulWidget {
  const PaginateExample2({super.key});

  @override
  State<PaginateExample2> createState() => _PaginateExample2State();
}

class _PaginateExample2State extends State<PaginateExample2> {
  List items = [];
  int page = 1;
  bool hasMore = true;
  bool isLoading = false;

  final _controller = ScrollController();

  @override
  void initState() {
    fetch();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        fetch();
      }
    });
    // TODO: implement initState
  }

  Future fetch() async {
    print('fetch');
    if (isLoading) return;
    isLoading = true;
    const limit = 25;
    final response = await http.get(Uri.parse(
        'https://jsonplaceholder.typicode.com/posts?_limit=$limit&_page=$page'));

    if (response.statusCode == 200) {
      final List newItems = json.decode(response.body);
      setState(() {
        page++;
        isLoading = false;

        if (newItems.length < limit) {
          hasMore = false;
        }

        items.addAll(newItems.map<String>((item) {
          final number = item['id'];
          return 'Item $number';
        }).toList());
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      page = 1;
      items.clear();
    });
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paginate with API'),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          controller: _controller,
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
                      : Text('No more data to load'),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
