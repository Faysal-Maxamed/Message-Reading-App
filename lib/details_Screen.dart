import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';

class MessageDetailPage extends StatelessWidget {
  final String sender;
  final List<SmsMessage> messages;

  MessageDetailPage({required this.sender, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Messages from $sender')),
      body: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: ListTile(
                title: Text(message.body ?? 'No message content'),
                subtitle: Text('Received: ${message.dateSent}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
