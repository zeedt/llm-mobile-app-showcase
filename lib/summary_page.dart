import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SummaryPage extends StatefulWidget {
  final String id;
  const SummaryPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _SummaryPageState();
  }
}

class _SummaryPageState extends State<SummaryPage> {
  bool isLoading = true;
  String summary = '';

  void loadData(String id) {
    try {
      final uri = Uri.parse('http://127.0.0.1:8111/v2/summarize/$id');
      http.get(uri).then(
            (value) => setState(() {
              isLoading = false;
              if (value.statusCode == 200) {
                summary = value.body;
              } else {
                summary = 'Unable to load data';
              }
            }),
          );
      return;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData(widget.id);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: isLoading
              ? const Text('Loading summary for uploaded document...')
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(summary),
                  ),
                ),
        ),
      ),
    );
  }
}
