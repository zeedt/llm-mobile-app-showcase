import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:langchain_summary_chatbot/common/message.dart';

class ChatPage extends StatefulWidget {
  final String id;
  const ChatPage({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPage> {
  bool isLoading = true;
  List<Message> messages = [];
  String message = '';

  final messageText = TextEditingController();

  void clearText() {
    messageText.clear();
  }

  void sendMessageViaAPI(String description) {
    try {
      final uri = Uri.parse('http://127.0.0.1:8111/v2/chatbot');
      http
          .post(
            uri,
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode(
              {'uuid': widget.id, 'message': description},
            ),
          )
          .then(
            (value) => setState(() {
              isLoading = false;
              if (value.statusCode == 200) {
                messages.add(Message(isBot: true, content: value.body));
              } else {
                print('Code is ${value.statusCode}');
                print('Error occurred fetching');
              }
            }),
          );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e.toString());
    }
  }

  void sendMessage(String message) {
    clearText();
    sendMessageViaAPI(message);
    setState(() {
      messages.add(Message(isBot: false, content: message));
      message = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // loadData(widget.id);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Stack(children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextButton.icon(
                  onPressed: () => {Navigator.pop(context)},
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color.fromARGB(255, 54, 5, 5),
                  ),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: Color.fromARGB(255, 54, 5, 5)),
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 70, top: 20),
              child: ListView.builder(
                itemCount: messages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: messages[index].isBot
                          ? const Color.fromRGBO(179, 190, 191, 1)
                          : const Color.fromRGBO(139, 201, 207, 1),
                    ),
                    margin: messages[index].isBot
                        ? const EdgeInsets.only(right: 50, top: 10)
                        : const EdgeInsets.only(left: 50, top: 10),
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    child: Text(messages[index].content),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                height: 80,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                        onChanged: (value) {
                          setState(() {
                            message = value;
                          });
                        },
                        controller: messageText,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (message.length >= 5) {
                          sendMessage(message);
                        }
                      },
                      backgroundColor: Colors.blue,
                      elevation: 0,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
