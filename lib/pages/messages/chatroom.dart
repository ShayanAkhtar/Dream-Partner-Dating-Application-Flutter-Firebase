import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../responsiveness.dart';
import '../../theme/app_theme.dart';

class chatroom extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomID;

  chatroom({required this.chatRoomID, required this.userMap});

  @override
  _chatroomstate createState() => _chatroomstate();
}

class _chatroomstate extends State<chatroom> {
  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final users = FirebaseFirestore.instance
      .collection('UserDetails')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isSendIconVisible = false;
  final FocusNode _focusnode = FocusNode();
  File? imageFile;
  String? displayName;

  final ScrollController _scrollController = ScrollController();

  Future getImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path as String);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    if (imageFile != null) {
      String fileName = Uuid().v1();
      int status = 1;
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomID)
          .collection('chats')
          .doc(fileName)
          .set({
        "sendby": displayName,
        'message': _message.text,
        'type': 'img',
        "time": FieldValue.serverTimestamp()
      });
      var ref =
          FirebaseStorage.instance.ref().child('images').child('$fileName.jpg');
      var uploadTask = ref.putFile(imageFile!).catchError((error) async {
        await _firestore
            .collection('chatroom')
            .doc(widget.chatRoomID)
            .collection('chats')
            .doc(fileName)
            .delete();
        status = 0;
      });
      await uploadTask.whenComplete(() => null);
      if (status == 1) {
        String imageUrl = await ref.getDownloadURL();
        await _firestore
            .collection('chatroom')
            .doc(widget.chatRoomID)
            .collection('chats')
            .doc(fileName)
            .update({"message": imageUrl});
        print(imageUrl);
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  void initState() {
    super.initState();
    users.get().then((value) {
      setState(() {
        displayName = value['Full Name'];
      });
    });
    _message.addListener(() {
      setState(() {
        isSendIconVisible = _message.text.trim().isNotEmpty;
      });
    });
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": displayName,
        'message': _message.text,
        'type': 'text',
        "time": FieldValue.serverTimestamp()
      };
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomID)
          .collection("chats")
          .add(messages);
      _message.clear();
    } else {
      print('Enter Text');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppTheme.colors.darkPeach,
              AppTheme.colors.lightPeach,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection('UserDetails')
              .doc(widget.userMap['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.userMap['Full Name']),
                    // Text(
                    //   snapshot.data?['status'],
                    //   style: TextStyle(fontSize: 12),
                    // ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.center,
                            image: AssetImage('assets/images/logo.png'),
                            opacity: 0.3,
                            scale: 0.1)),
                    height: constraints.maxHeight * 0.88,
                    width: constraints.maxWidth,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('chatroom')
                          .doc(widget.chatRoomID)
                          .collection('chats')
                          .orderBy('time', descending: false)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          WidgetsBinding.instance!.addPostFrameCallback((_) {
                            _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                            );
                          });

                          return ListView.builder(
                            controller: _scrollController,
                            itemCount: snapshot.data!.docs.length,
                            // Show latest messages at the bottom
                            itemBuilder: (context, index) {
                              Map<String, dynamic>? map =
                                  snapshot.data?.docs[index].data()
                                      as Map<String, dynamic>?;
                              return messages(context, map!);
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    )),
                Container(
                  height: constraints.maxHeight * 0.1,
                  width: constraints.maxWidth,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: TextField(
                                maxLines: null,
                                minLines: 1,
                                keyboardType: TextInputType.multiline,
                                controller: _message,
                                focusNode: _focusnode,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.7),
                                    borderSide: const BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,

                                  hintText: 'Message',
                                  hintStyle: const TextStyle(
                                      fontSize: 20, color: Colors.grey),
                                  suffixIconConstraints: const BoxConstraints(
                                      minWidth: 80, maxWidth: 100),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                      ),
                                      IconButton(
                                        onPressed: () => getImage(),
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 50,
                            child: GestureDetector(
                              onTap: isSendIconVisible ? onSendMessage : null,
                              onLongPress: () {
                                // Handle microphone action here
                              },
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: AppTheme.colors.darkPeach,
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget messages(BuildContext context, Map<String, dynamic> map) {
    return map['type'] == 'text'
        ? Container(
            width: getwidth(context),
            alignment: map['sendby'] == displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: map['sendby'] == displayName
                  ? BoxDecoration(
                      color: AppTheme.colors.mediumPeach,
                      borderRadius: BorderRadius.circular(15),
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppTheme.colors.darkPeach,
                    ),
              child: Text(
                map['message'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          )
        : Container(
            margin: EdgeInsets.all(5),
            height: getheight(context) / 2.5,
            width: getwidth(context),
            alignment: map['sendby'] == displayName
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => ShowImage(imageurl: map['message']))),
              child: Container(
                alignment: Alignment.center,
                height: getheight(context) / 2.5,
                width: getwidth(context) / 2,
                child: FutureBuilder(
                  future: loadImage(map['message']),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    // if (snapshot.connectionState == ConnectionState.waiting) {
                    //   return CircularProgressIndicator();}
                    if (snapshot.hasError) {
                      return Text('Error loading image');
                    } else if (snapshot.hasData) {
                      return Image.network(snapshot.data!);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          );
  }

  Future<String> loadImage(String imageUrl) async {
    try {
      await precacheImage(NetworkImage(imageUrl), context);
      return imageUrl;
    } catch (e) {
      print('Error preloading image: $e');
      return '';
    }
  }
}

class ShowImage extends StatelessWidget {
  const ShowImage({super.key, required this.imageurl});

  final String imageurl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: getheight(context),
        width: getwidth(context),
        color: Colors.black,
        child: Image.network(imageurl),
      ),
    );
  }
}
