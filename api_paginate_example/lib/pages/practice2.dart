import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Practice2 extends StatefulWidget {
  const Practice2({super.key});

  @override
  State<Practice2> createState() => _Practice2State();
}

class _Practice2State extends State<Practice2> {
  List items = [];
  List apiList = [];
  final controller = ScrollController();
  int page = 1;
  bool hasMore = true;

  @override
  void initState() {
    fetch();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  Future fetch() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));
    if (response.statusCode == 200) {
      page++;
      Map datas = jsonDecode(response.body);
      apiList = datas['data'];
    }

    print(apiList);
    items.addAll(apiList);
    if (apiList.isEmpty) {
      hasMore = false;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice 2'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length + 1,
        controller: controller,
        itemBuilder: (context, index) {
          if (index < items.length) {
            var item = items[index];
            return Stack(
              children: [
                Container(
                  height: size.height * 0.4,
                  width: double.infinity,
                  child: Card(
                    elevation: 5,
                    child: Image.network(
                      item['avatar'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 20,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              item['first_name'],
                              style: TextStyle(
                                fontSize: 20,
                                backgroundColor: Colors.grey,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              item['last_name'],
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                backgroundColor: Colors.grey,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item['email'],
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            backgroundColor: Colors.grey,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: hasMore
                  ? CircularProgressIndicator(
                      color: Colors.red,
                    )
                  : Text('No more data to load'),
            );
          }
        },
      ),
    );
  }
}
