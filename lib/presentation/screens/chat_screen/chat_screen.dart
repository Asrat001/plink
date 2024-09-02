import 'package:flutter/material.dart';
import '../../../data/services/websocket_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final WebSocketService _webSocketService =
      WebSocketService('ws://209.38.25.10:8000/ws');
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  int _userCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _webSocketService.messages.listen((message) {
      setState(() {
        _messages.add(message);
      });
    });
    _fetchUserCount();
    _timer = Timer.periodic(Duration(minutes: 1), (timer) => _fetchUserCount());
  }

  Future<void> _fetchUserCount() async {
    try {
      final response =
          await http.get(Uri.parse('http://209.38.25.10:8000/user-count'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _userCount = data['user_count'];
        });
      } else {
        print('Failed to load user count');
      }
    } catch (e) {
      print('Error fetching user count: $e');
    }
  }

  @override
  void dispose() {
    _webSocketService.close();
    _timer?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _webSocketService.sendMessage(_controller.text);
      _messages.add(_controller.text);
      _controller.clear();

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 59, 53, 59),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Chat',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.left,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$_userCount',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 229, 229),
                        fontSize: 21,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      ' Online',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[_messages.length - index - 1],
                        style: TextStyle(color: Colors.white)),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff403a3f)
                                  .withOpacity(1), // Example shadow color
                              spreadRadius: 1,
                              blurRadius: 10,
                              blurStyle: BlurStyle.inner,
                              offset:
                                  Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.white.withOpacity(0.5)),
                            hintText: 'Enter your message',
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 4,
                        child: Container(
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                              right: Radius.circular(20),
                            ),
                            color: Colors.white
                                .withOpacity(0.25), // Example background color
                          ),
                          child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _sendMessage,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
