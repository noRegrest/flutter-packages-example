// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late IO.Socket socket;
  String _message = "";

  @override
  void initState() {
    super.initState();
    // socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{
    //   'transports': ['websocket', 'polling']
    // });
    socket =
        IO.io('https://bantinsang-socket-dev.metatech.xyz/', <String, dynamic>{
      'transports': ['websocket', 'polling']
    });
    socket.connect();
    socket.onConnect((_) {
      print('connect');
    });
    socket.on('time', (data) => setState(() => _message = data));
    socket.onDisconnect((_) => print('disconnect'));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Emit a string'),
                onPressed: () {
                  socket.emit('send', 'Hello from Flutter');
                },
              ),
              Text(_message)
            ],
          ),
        ),
      ),
    );
  }
}
