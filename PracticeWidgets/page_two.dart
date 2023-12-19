import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PracticeScreen extends StatefulWidget {
  const PracticeScreen({super.key});

  @override
  State<PracticeScreen> createState() => _PracticeScreen();
}

class _PracticeScreen extends State<PracticeScreen> {
  List Items = [];
  int page = 1;
  int pageSize = 10;
  bool isLoadingMore = false;
  final scrollContoller = ScrollController();

  Future<void> fetchData() async {
    String apiURL = "https://jsonplaceholder.typicode.com/comments";

    final response = await http.get(Uri.parse(apiURL));

    if (response.statusCode == 200) {
      final dataList = jsonDecode(response.body) as List;
      setState(() {
        Items.addAll(dataList.sublist(
            (page - 1) * pageSize,
            (page * pageSize) < dataList.length
                ? (page * pageSize)
                : dataList.length));
        page++;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    scrollContoller.addListener(_scrollListener);
    fetchData();
  }

  void _scrollListener() {
    if (isLoadingMore) return;
    if (scrollContoller.position.pixels ==
        scrollContoller.position.maxScrollExtent) {
      setState(() {
        isLoadingMore = true;
        page++;
      });
      fetchData();
      setState(() {
        isLoadingMore = false;
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PageController")),
      body: ListView.builder(
        controller: scrollContoller,
        itemCount: isLoadingMore ? Items.length + 1 : Items.length,
        itemBuilder: (context, index) {
          final title = Items[index]['name'];
          final ids = Items[index]['id'];
          if (index < Items.length) {
            return Container(
                margin: const EdgeInsets.all(10),
                height: 60,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255)),
                child: Row(
                  children: [
                    Text(ids.toString()),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(child: Text(title)),
                  ],
                ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
