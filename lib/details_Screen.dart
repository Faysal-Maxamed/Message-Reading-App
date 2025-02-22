import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reading_messege_app/SmsController.dart';

class DetailsScreen extends StatelessWidget {
  final String sender;
  final smscotroller = Get.find<Smscontroller>();

  DetailsScreen({super.key, required this.sender});

  @override
  Widget build(BuildContext context) {
    var senderMessages =
        smscotroller.allMessages.where((msg) => msg.address == sender).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          sender,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Color(
          0xff4A3F69,
        ),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xfff5f5f5),
      body: senderMessages.isEmpty
          ? Center(child: Text("No messages from $sender"))
          : ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: senderMessages.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    leading: Icon(Icons.message, color: Colors.blue),
                    title: Text(
                      senderMessages[index].body ?? "No content",
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Text(
                      senderMessages[index].dateSent.toString(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
