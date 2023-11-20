import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:langchain_summary_chatbot/chat_page.dart';
import 'package:langchain_summary_chatbot/common/button.dart';
import 'package:langchain_summary_chatbot/summary_page.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

var uuid = const Uuid();

class Home extends StatefulWidget {
  final String title;

  const Home({super.key, required this.title});

  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> {
  bool isLoading = false;
  String? id;

  void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    var docId = uuid.v1();
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        isLoading = true;
        id = docId.toString();
      });

      final request = http.MultipartRequest(
          "POST", Uri.parse('http://127.0.0.1:8111/upload/${id}'));
      request.files.add(http.MultipartFile.fromBytes(
          'file', await file.readAsBytes(),
          filename: 'file'));
      request.send().then((response) {
        setState(() {
          isLoading = false;
        });
        if (response.statusCode == 200) {
          print('File uploaded successfully');
        } else {
          print('Error occurred due to ');
        }
      });
    } else {
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CButton(
                onPress: uploadFile,
                text: 'Upload file',
                disable: isLoading,
              ),
              CButton(
                onPress: () => {
                  if (id == null)
                    {
                      showCupertinoDialog(
                        context: context,
                        builder: (ctx) => CupertinoAlertDialog(
                          title: const Text('Error'),
                          actions: [
                            CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Ok")),
                          ],
                          content: const Text(
                              'You need to have uploaded a document you want to summarise'),
                        ),
                      ),
                    }
                  else
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SummaryPage(id: id!),
                        ),
                      ),
                    }
                },
                text: 'Summarise uploaded document',
                disable: true,
              ),
              CButton(
                onPress: () => {
                  if (id == null)
                    {
                      showCupertinoDialog(
                        context: context,
                        builder: (ctx) => CupertinoAlertDialog(
                          title: const Text('Error'),
                          actions: [
                            CupertinoDialogAction(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Ok")),
                          ],
                          content: const Text(
                              'You need to have uploaded a document you want to summarise'),
                        ),
                      ),
                    }
                  else
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(id: id!),
                        ),
                      ),
                    }
                },
                text: 'Chat',
                disable: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
