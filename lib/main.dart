import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:products_list/products_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Directory appDocDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocDir.path);

  await Hive.openBox('productBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ProductPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}