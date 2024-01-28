import 'package:api_paginate_example/getx_pagination/getx_pagenate_view.dart';
import 'package:api_paginate_example/pages/paginate_example2.dart';
import 'package:api_paginate_example/pages/practice.dart';
import 'package:flutter/material.dart';

import 'pages/paginate_example1.dart';
import 'pages/practice2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GetXPaginateView(),
    );
  }
}
