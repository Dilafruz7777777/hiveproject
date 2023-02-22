import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hiveproject/person_model.dart';
import 'package:hiveproject/univer.dart' as u;
import 'package:hiveproject/univer_model.dart' as m;
import 'package:http/http.dart' as http;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  Hive.registerAdapter(m.UniverAdapter());
  Hive.registerAdapter(m.UniverResponseAdapter());


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
      home: u.Univer(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box<Person>? box;
  final name = TextEditingController();
  final age = TextEditingController();

  void _incrementCounter(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Name"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: name,
                ),

                // TextFormField(
                //   controller: age,
                // ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () async {
                    var res = await http.get(
                      Uri.parse("https://api.genderize.io/?name=${name.text}"),
                    );
                    Person newPerson = Person.fromJson(jsonDecode(res.body));
                    box!.put(name.text, newPerson);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: Text("Save"))
            ],
          );
        });
  }

  hiveInit() async {
    box = await Hive.openBox('newPerson');
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
        title: Text(widget.title),
      ),
      body: ListView.builder(
          itemCount: box?.values.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.pinkAccent.withOpacity(0.3),
              margin: EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(24),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(box?.values.elementAt(index).name ?? ""),
                      Text(box?.values.elementAt(index).count.toString() ?? ""),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      box!.deleteAt(index);
                      setState(() {});
                    },
                    icon: Icon(Icons.delete),
                  )
                ],
              ),
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
