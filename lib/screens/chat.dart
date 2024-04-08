import 'package:chat_app/widgets/chat_messages.dart';
import 'package:chat_app/widgets/new_messages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  void setupPushNotifications()async{
    final fcm= FirebaseMessaging.instance;
    await fcm.requestPermission();
    final token= await fcm.getToken();
    //you can send this to backend via HTTP or send to firebase for notification
    print(token);

    //for sending msg as a way if singl person send msg then it give notification to each group member
    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupPushNotifications();
  }
//SET UP PUSH NOTIFICATION
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
          }, icon: Icon(Icons.exit_to_app,color: Theme.of(context).colorScheme.primary,))
        ],
      ),
      body: Column(
        children: const[
          Expanded(child: ChatMessages()),
          NewMessage()
        ],
      )
    )
    ;
  }
}
///-------------CODE FOR SENDING NOTIFIATION TO ALL IN ONE GO USING FIREBASE FUNCTIONS METHOD AND NODE JS AS A BACKEND-------------//
/*
const functions= require("firebase-functions");
const admin= require("firebase-admin");

admin.initializeApp();

exports.myFunction= functions.firestore.document("chat/{messageId}")
.onCreate((snapshot,context)=>{
return admin.messaging().sendToTopic("chat",{
notification{
title: snapshot.data()["username"],
body:snapshot.data()["text"],
clickAction: "FLUTTER_NOTIFICATION_CLICK",
},
});
});
 */