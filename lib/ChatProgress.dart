import 'package:flutter/material.dart';
class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service Progress'),
      ),
      body: ChatBody(),
    );
  }
}

class ChatBody extends StatefulWidget {
  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _textController = TextEditingController();
  List<String> _messages = []; // List to hold chat messages

  void _handleSubmitted(String text) {
    if (text.isNotEmpty) {
      setState(() {
        _messages.add(text); // Add the message to the list
      });
      _textController.clear(); // Clear the text field
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: _messages.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildMessage(_messages[index], index.isEven);
            },
          ),
        ),
        Divider(height: 1.0),
        _buildTextComposer(),
      ],
    );
  }

  Widget _buildMessage(String text, bool isMe) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 16.0, color: isMe ? Colors.white : Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              onChanged: (String text) {
                // You can implement additional logic on text change if needed
              },
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: Colors.blueAccent),
            onPressed: () {
              _handleSubmitted(_textController.text);
            },
          ),
        ],
      ),
    );
  }
}

