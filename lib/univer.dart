import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveproject/univer_model.dart';
import 'package:hiveproject/view_univer.dart';
import 'package:http/http.dart' as http;

class Univer extends StatefulWidget {
  const Univer({Key? key}) : super(key: key);

  @override
  State<Univer> createState() => _UniverState();
}

class _UniverState extends State<Univer> {
  Box<UniverResponse>? box;
  UniverResponse? data;

  final name = TextEditingController();



  void _incrementCounter(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Country"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: name,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    var res = await http.get(Uri.parse(
                        "http://universities.hipolabs.com/search?country=${name.text}"));
                    UniverResponse univer =
                    data =     UniverResponse.fromJson(jsonDecode(res.body), name.text);
                    box!.put(name.text, data ?? UniverResponse(univers: [], name: name.text));
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Save"))
            ],
          );
        });
  }

  hiveInit() async {
    box = await Hive.openBox('CountUniver');
  }

  @override
  void initState() {
    hiveInit();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Country"),
      ),
      body: ListView.builder(
          itemCount: box?.values.length ?? 0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewUniversPage(data: box?.values.elementAt(index))));
              },
              child: Container(
                  padding: EdgeInsets.all(24),
                  margin: EdgeInsets.all(12),
                  color: Colors.cyanAccent,
                  child: Text(box?.values.elementAt(index).name ?? "")),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // box?.deleteFromDisk();
          _incrementCounter(context);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
