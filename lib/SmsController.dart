import 'package:another_telephony/telephony.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class Smscontroller extends GetxController {
  var allMessages = <SmsMessage>[].obs;


  
void requestPermissions() async {
    var status = await Permission.sms.request();
    if (status.isGranted) {
      fetchInboxMessages();
    } else {
      print("Ogolaanshiyaha lama oggolaan!");
    }
  }


  fetchInboxMessages() async {
    final Telephony telephony = Telephony.instance;
    List<SmsMessage> messages = await telephony.getInboxSms();
    allMessages.value = messages;

  }
}
