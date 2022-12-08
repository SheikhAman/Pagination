import 'package:flutter/material.dart';

class PaginateExample1 extends StatefulWidget {
  const PaginateExample1({super.key});

  @override
  State<PaginateExample1> createState() => _PaginateExample1State();
}

class _PaginateExample1State extends State<PaginateExample1> {
  final controller = ScrollController();

  List<String> items = List.generate(15, (index) => 'Item ${index + 1}');

  @override
  void initState() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        fetch();
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future fetch() async {
    setState(() {
      items.addAll(['Item A', 'Item B', 'Item C', 'Item D']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Infinite Scroll ListView"),
      ),
      body: ListView.builder(
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
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
