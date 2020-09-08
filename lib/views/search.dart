import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/conversation_screen.dart';
import 'package:chatapp/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethod _databaseMethod = new DatabaseMethod();

  TextEditingController searchTextController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    _databaseMethod.getUserByUsername(searchTextController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndConversation(String userName) {
    String chatRoomId = getChatRoomId(userName, Constants.myName);

    List<String> users = [userName, Constants.myName];
    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };
    _databaseMethod.createChatRoom(chatRoomId, chatRoom);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ConversationScreen(chatRoomId: chatRoomId,)));
  }

  Widget searchTile({String username,String email}){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                username,
                style: mediumTextStyle(),
              ),
              Text(
                email,
                style: mediumTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndConversation(username);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              child: Text(
                'Message',
                style: mediumTextStyle(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot.docs.length,
            itemBuilder: (context, index) {
              return searchTile(
                username: searchSnapshot.docs[index].data()["name"],
                email: searchSnapshot.docs[index].data()["email"],
              );
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarMain(context, 'Search'),
      body: Container(
          child: Column(
        children: <Widget>[
          Container(
            color: Color(0x54FFFFFF),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: searchTextController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'Search name...',
                      hintStyle: TextStyle(color: Colors.white60),
                      border: InputBorder.none),
                )),
                GestureDetector(
                  onTap: () {
                    initiateSearch();
                  },
                  child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      child: Image.asset(
                        "assets/images/search icon.png",
                        height: 20,
                        width: 20,
                      )),
                ),
              ],
            ),
          ),
          searchList()
        ],
      )),
    );
  }
}


getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
