import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;

  const ConversationScreen({Key key, this.chatRoomId}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethod _databaseMethod = new DatabaseMethod();
  TextEditingController chatTextController = new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessagesList() {
    return StreamBuilder(
        stream: chatMessageStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    return MessageBubble(
                        message: snapshot.data.documents[index].data["message"],
                        isSentbyMe:
                            snapshot.data.documents[index].data["sentBy"] ==
                                Constants.myName);
                  })
              : Container();
        });
  }

  sendMessage() {
    if (chatTextController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": chatTextController.text,
        "sentBy": Constants.myName,
        "time": DateTime.now().microsecondsSinceEpoch
      };
      _databaseMethod.addConversation(widget.chatRoomId, messageMap);
      chatTextController.text = "";
    }
  }

  @override
  void initState() {
    _databaseMethod.getConversation(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain(context, "Conversation"),
      body: Container(
        child: Stack(children: <Widget>[
          chatMessagesList(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: chatTextController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.white60),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0xFFFFFFFF),
                              const Color(0xEFFFFFFF)
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        child: Image.asset(
                          "assets/images/send.png",
                          height: 20,
                          width: 20,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSentbyMe;
  const MessageBubble({Key key, this.message, this.isSentbyMe})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: isSentbyMe? 80:0, right: isSentbyMe?0: 80),
      width: MediaQuery.of(context).size.width,
      alignment: isSentbyMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal:10,vertical: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 16),
        decoration: BoxDecoration( 
          gradient: LinearGradient(
            colors: isSentbyMe ?
            [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ]
            :
            [
              const Color(0x1aFFFFFF),
              const Color(0x1aFFFFFF)
            ]
          ),
          borderRadius: isSentbyMe ?
              BorderRadius.only(
                topLeft: Radius.circular(23),
                bottomLeft: Radius.circular(23),
                topRight: Radius.circular(30)
              ):
                BorderRadius.only(
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23),
                topLeft: Radius.circular(30)
              )
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
