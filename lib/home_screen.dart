import 'package:another_telephony/telephony.dart';
import 'package:flutter/material.dart';
import 'package:reading_messege_app/details_Screen.dart';

class SmsListener extends StatefulWidget {
  @override
  _SmsListenerState createState() => _SmsListenerState();
}

class _SmsListenerState extends State<SmsListener>
    with SingleTickerProviderStateMixin {
  final Telephony telephony = Telephony.instance;
  String _newMessage = '';
  Map<String, List<SmsMessage>> _groupedMessages = {};
  List<SmsMessage> _newMessages = [];
  late TabController _tabController;
  List<SmsMessage> _readMessages = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        setState(() {
          _newMessage = message.body ?? 'Fariin aan jirin';
          _groupMessages(message);
          _newMessages.add(message);
        });
        print('Fariin cusub oo SMS ah: ${message.body}');
      },
      onBackgroundMessage: backgroundMessageHandler,
    );

    loadInboxMessages();
  }

  void loadInboxMessages() async {
    List<SmsMessage> messages = await telephony.getInboxSms();
    setState(() {
      _groupedMessages.clear();
      for (var message in messages) {
        _groupMessages(message);
      }
    });
  }

  void _groupMessages(SmsMessage message) {
    if (message.address == '192') {
      _groupedMessages['192_${message.date}'] = [message];
    } else if (_groupedMessages.containsKey(message.address)) {
      _groupedMessages[message.address]?.add(message);
    } else {
      _groupedMessages[message.address.toString()] = [message];
    }
  }

  /// Extracts sender's phone number from the message body if it's from 192
  String _extractSenderNumber(String? body) {
    if (body == null || !body.contains(':')) return 'Unknown';
    return body.split(':')[0].trim(); // Extract sender's number before ":"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Inbox'),
            Tab(
              text: _newMessages.isNotEmpty
                  ? 'New Message (${_newMessages.length})'
                  : 'New Message',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _groupedMessages.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _groupedMessages.length,
                          itemBuilder: (context, index) {
                            final sender =
                                _groupedMessages.keys.elementAt(index);
                            final messages = _groupedMessages[sender]!;

                            // If message is from 192, display sender's number from body
                            String displaySender =
                                messages.first.address == '192'
                                    ? _extractSenderNumber(messages.first.body)
                                    : messages.first.address ?? 'Unknown';

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageDetailPage(
                                      sender: sender,
                                      messages: messages,
                                    ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Card(
                                  color: Colors.white,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(12),
                                    title: Text(
                                      'SMS from: $displaySender',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${messages.first.body}',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    trailing: Icon(
                                      Icons.message,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        'Inbox waa madhan!',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _newMessages.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: _newMessages.length,
                          itemBuilder: (context, index) {
                            final message = _newMessages[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MessageDetailPage(
                                      sender: message.address ?? 'Unknown',
                                      messages: [message],
                                    ),
                                  ),
                                );
                                setState(() {
                                  _readMessages.add(message);
                                  _newMessages.removeAt(index);
                                });
                              },
                              child: Card(
                                elevation: 5,
                                margin: EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(12),
                                  title: Text(
                                    'New SMS: ${message.address}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    message.body ?? 'Unknown',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Icon(
                                    Icons.message,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Text(
                        'Fariin cusub ma jiraan!',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> backgroundMessageHandler(SmsMessage message) async {
  print('Received background message: ${message.body}');
}
