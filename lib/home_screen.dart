import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reading_messege_app/SmsController.dart';
import 'package:reading_messege_app/details_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var smscotroller = Get.put(Smscontroller());
  Set<String> readMessages = {}; 

  @override
  void initState() {
    super.initState();
    smscotroller.requestPermissions();
  }

 
  Map<String, List<dynamic>> getUniqueMessages() {
    Map<String, List<dynamic>> messageMap = {};

    for (var message in smscotroller.allMessages) {
      if (message.address != null) {
        if (!messageMap.containsKey(message.address)) {
          messageMap[message.address!] = [];
        }
        messageMap[message.address!]!.add(message);
      }
    }
    return messageMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe3f9ff),
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(systemNavigationBarColor: Color(0xffe3f9ff)),
        backgroundColor: Color(0xffe3f9ff),
        title: Text(
          "Messages",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        foregroundColor: Color(0xff4A3F69),
      ),
      body: Obx(
        () {
          var uniqueMessages = getUniqueMessages();
          return uniqueMessages.isEmpty
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: uniqueMessages.length,
                  itemBuilder: (context, index) {
                    String sender = uniqueMessages.keys.elementAt(index);
                    List<dynamic> senderMessages = uniqueMessages[sender]!;

                    int unreadCount = readMessages.contains(sender)
                        ? 0
                        : senderMessages
                            .length; 

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          readMessages.add(
                              sender);
                        });
                        Get.to(() => DetailsScreen(sender: sender));
                      },
                      child: Card(
                        color: Color(0xffe3f9ff),
                        elevation: 10,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue,
                          ),
                          title: Text(sender),
                          subtitle: Text(
                            senderMessages.last.body ?? "",
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: unreadCount > 0
                              ? CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 12,
                                  child: Text(
                                    unreadCount.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : null, 
                        ),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
