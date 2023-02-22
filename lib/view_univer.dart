import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hiveproject/univer_model.dart';


class ViewUniversPage extends StatefulWidget {
  final UniverResponse? data;

  const ViewUniversPage({Key? key, required this.data}) : super(key: key);

  @override
  State<ViewUniversPage> createState() => _ViewUniversPageState();
}

class _ViewUniversPageState extends State<ViewUniversPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data?.name ?? ""),
      ),
      body: ListView.builder(
          itemCount: widget.data?.univers.length ?? 0,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.pinkAccent.withOpacity(0.3),
              padding: EdgeInsets.all(24),
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(widget.data?.univers[index].name ?? ""),
                  Text(widget.data?.univers[index].webPages?.first ?? ""),
                ],
              ),
            );
          }),
    );
  }
}
