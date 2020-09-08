import 'package:chatapp/helper/authenticate.dart';
import 'package:chatapp/helper/constants.dart';
import 'package:chatapp/helper/helperfunctions.dart';
import 'package:chatapp/services/auth.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/views/search.dart';
import 'package:chatapp/widgets/widget.dart';

import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethod _authMethod = new AuthMethod();
  DatabaseMethod _databaseMethod = new DatabaseMethod();
  Stream chatRoomStream;

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return ChatRoomTile(
                    userName: snapshot.data.docs[index].data()["chatRoomId"],
                  );
                })
            : Container();
      },
    );
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPref();

    _databaseMethod.getChatRooms(Constants.myName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              "assets/images/logo.png",
              width: 50,
              height: 60,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Welcome ${Constants.myName}',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )
          ],
        ),
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        actions: <Widget>[
          GestureDetector(
              onTap: () {
                _authMethod.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Authenticate()));
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(Icons.exit_to_app))),
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.search),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (builder) => SearchScreen()));
          }),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;

  const ChatRoomTile({Key key, this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: <Widget>[
        Container(
          alignment: Alignment.center,
          height: 40,
          width: 40,
          decoration: BoxDecoration(        
              color: Colors.blue, borderRadius: BorderRadius.circular(40)),
          child: Text("${userName.substring(0, 1).toUpperCase()}"),
        ),
        SizedBox(width: 5),
        Text(userName,style: mediumTextStyle(),)
      ]),
    );
  }
}
