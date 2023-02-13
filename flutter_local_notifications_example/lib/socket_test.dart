// ignore_for_file: always_specify_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String routeName = '/socketPage';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // The list of messages to be displayed in the chat
  List<Map<String, dynamic>> messages = [];

  // The TextEditingController for the text field
  TextEditingController textController = TextEditingController();

  // The socket connection to the server
  late IO.Socket socket;

  // final Text _messages = [];

  @override
  void initState() {
    super.initState();
    // Connect to the Node.js server
    socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
      'transports': ['websocket'],
    });
    // Listen for the 'message' event from the server
    socket.on('message', (data) {
      // Decode the JSON data received from the server
      final Map<String, dynamic> message = json.decode(data);
// Add the message to the messages list
      setState(() {
        messages.add(message);
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Chat App'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  // Display each message in the messages list
                  final Map<String, dynamic> message = messages[index];
                  return ListTile(
                    title: Text(message['message']),
                  );
                },
              ),
            ),
            ListView(
                // children: [_messages],
                ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textController,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      socket
                        ..emit(
                            'send',
                            json.encode({
                              'message': textController.text,
                            }))
                        ..emit('send', textController.text);
                      setState(() {
                        // _messages.add(textController.text);
                      });
                      textController.clear();
                    }
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ],
        ),
      );
}
// ignore: slash_for_doc_comments
/**
 * 
In this code, we use the `socket_io_client` package to connect to the Node.js server and receive messages in real-time.

- In the `initState` method, we connect to the Node.js server and listen for the `message` event from the server using `socket.on`. When a message is received, we decode the JSON data, add the message to the messages list, and call `setState` to update the UI.

- In the UI, we display the messages list using a `ListView` and a `ListTile` for each message.

- In the bottom row, we have a `TextField` for the user to enter a message and a `RaisedButton` to send the message. When the button is pressed, we emit a `message` event to the server with the message as the data, and clear the text field.

 */

void main() {
  runApp(
    MessagesDisplay(
      items: List<ListItem>.generate(
        1000,
        (i) => i % 6 == 0
            ? HeadingItem('Heading $i')
            : MessageItem('Sender $i', 'Message body $i'),
      ),
    ),
  );
}

class MessagesDisplay extends StatelessWidget {
  const MessagesDisplay({super.key, required this.items});
  final List<ListItem> items;

  @override
  Widget build(BuildContext context) {
    const title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  HeadingItem(this.heading);
  final String heading;

  @override
  Widget buildTitle(BuildContext context) => Text(
        heading,
        style: Theme.of(context).textTheme.headlineSmall,
      );

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  MessageItem(this.sender, this.body);
  final String sender;
  final String body;

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
