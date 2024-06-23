import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'chatroom.dart';

void main() {
  runApp(MaterialApp(home: ChatScreen()));
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  bool isLoading = false;
  late Map<String, dynamic> userMap;
  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  late TabController _tabController;
  StreamSubscription<List<Map<String, dynamic>>>? _streamSubscription;
  bool isChatTabSelected = true;

  // Stream<List<Map<String, dynamic>>>
  //     _getContactsWithConversationsStream() async* {
  //   final currentUserUid = _auth.currentUser!.uid;
  //   Stream<QuerySnapshot> snapshotStream =
  //       _firestore.collection('users').snapshots();
  //
  //   await for (QuerySnapshot snapshot in snapshotStream) {
  //     List<Map<String, dynamic>> contacts = [];
  //     for (var doc in snapshot.docs) {
  //       final otherUserUid = doc['uid'];
  //       final conversationExists =
  //           await doesConversationExist(currentUserUid, otherUserUid);
  //       if (conversationExists) {
  //         // Fetch the latest message timestamp for this conversation
  //         final latestMessageSnapshot = await FirebaseFirestore.instance
  //             .collection('chatroom')
  //             .doc(chatRoomId(currentUserUid, otherUserUid))
  //             .collection('chats')
  //             .orderBy('time', descending: true)
  //             .limit(1)
  //             .get();
  //
  //         final latestMessageTime = latestMessageSnapshot.docs.isNotEmpty
  //             ? latestMessageSnapshot.docs[0]['time']
  //             : null;
  //
  //         // Add the contact with latest message timestamp
  //         contacts.add({
  //           ...doc.data() as Map<String, dynamic>,
  //           'latestMessageTime': latestMessageTime,
  //         });
  //       }
  //     }
  //
  //     // Sort the contacts based on latest message timestamp
  //     contacts.sort((a, b) =>
  //         (b['latestMessageTime'] ?? 0).compareTo(a['latestMessageTime'] ?? 0));
  //
  //     yield contacts;
  //   }
  // }

  // Future<bool> doesConversationExist(String user1, String user2) async {
  //   QuerySnapshot snapshot = await FirebaseFirestore.instance
  //       .collection('chatroom')
  //       .doc(chatRoomId(user1, user2))
  //       .collection('chats')
  //       .limit(1)
  //       .get();
  //
  //   return snapshot.docs.isNotEmpty;
  // }

  Future<List<Map<String, dynamic>>> getContacts() async {
    String currentUserUid = _auth.currentUser!.uid;

    QuerySnapshot snapshot = await _firestore
        .collection('chatroom')
        .where('users', arrayContains: currentUserUid)
        .get();

    List<Map<String, dynamic>> contacts = [];

    for (var doc in snapshot.docs) {
      List<dynamic> users = doc['users'];

      for (var userUid in users) {
        if (userUid != currentUserUid) {
          DocumentSnapshot userSnapshot =
              await _firestore.collection('users').doc(userUid).get();

          if (userSnapshot.exists) {
            Map<String, dynamic> userMap =
                userSnapshot.data() as Map<String, dynamic>;
            contacts.add(userMap);
          }
        }
      }
    }

    return contacts;
  }

  void onSearchh() async {
    setState(() {
      isLoading = true;
    });
    await _firestore
        .collection('users')
        .where('email', isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });
  }

  // void setStatus(String status) async {
  //   await _firestore
  //       .collection('users')
  //       .doc(_auth.currentUser?.uid)
  //       .update({'status': status});
  // }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabChange);
    WidgetsBinding.instance.addObserver(this);
    // setStatus('Online');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _handleTabChange() {
    setState(() {
      isChatTabSelected = _tabController.index == 0;
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setStatus('Online');
  //   } else if (state == AppLifecycleState.inactive ||
  //       state == AppLifecycleState.paused) {
  //     setStatus('Offline');
  //   } else {
  //     setStatus('Offline');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   flexibleSpace: Container(
      //     decoration: BoxDecoration(
      //       gradient: LinearGradient(colors: [
      //        AppTheme.colors.darkPeach,
      //         AppTheme.colors.lightPeach,
      //       ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      //     ),
      //   ),
      //   title: Center(child: Text('CHATBOX')),
      //   elevation: 0, // Remove the elevation from the AppBar
      // ),
      body: YourChatTab(),
    );
  }
}

class YourChatTab extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxList<Map<String, dynamic>> contacts = <Map<String, dynamic>>[].obs;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colors.white,
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getContactsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.colors.darkPeach,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Update the RxList with the latest data
          contacts.assignAll(snapshot.data ?? []);

          if (contacts.isEmpty) {
            return Center(child: Text('No conversations yet.'));
          }

          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (BuildContext context, int index) {
              final chattedContacts = contacts[index];
              return contact(
                chattedContacts['Profile'],
                chattedContacts['Full Name'],
                '',
                '',
               '',
                context,
              );
            },
          );
        },
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> getContactsStream() async* {
    final currentUserUid = _auth.currentUser!.uid;
    Stream<QuerySnapshot> snapshotStream =
        _firestore.collection('UserDetails').snapshots();

    await for (QuerySnapshot snapshot in snapshotStream) {
      List<Map<String, dynamic>> updatedContacts = [];
      for (var doc in snapshot.docs) {
        final otherUserUid = doc['Uid'];
        final conversationExists =
            await doesConversationExist(currentUserUid, otherUserUid);
        if (conversationExists) {
          // Fetch the latest message timestamp for this conversation
          final latestMessageSnapshot = await _firestore
              .collection('chatroom')
              .doc(chatRoomId(currentUserUid, otherUserUid))
              .collection('chats')
              .orderBy('time', descending: true)
              .limit(1)
              .get();

          final latestMessageTime = latestMessageSnapshot.docs.isNotEmpty
              ? latestMessageSnapshot.docs[0]['time']
              : null;

          // Add the contact with the latest message timestamp
          updatedContacts.add({
            ...doc.data() as Map<String, dynamic>,
            'latestMessageTime': latestMessageTime,
          });
        }
      }

      // Sort the contacts based on the latest message timestamp
      updatedContacts.sort((a, b) =>
          (b['latestMessageTime'] ?? 0).compareTo(a['latestMessageTime'] ?? 0));

      yield updatedContacts;
    }
  }

  Future<bool> doesConversationExist(String user1, String user2) async {
    QuerySnapshot snapshot = await _firestore
        .collection('chatroom')
        .doc(chatRoomId(user1, user2))
        .collection('chats')
        .limit(1)
        .get();

    return snapshot.docs.isNotEmpty;
  }
}

class ContactsManager {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Map<String, dynamic>> contacts = [];

  Stream<List<Map<String, dynamic>>> getContactsStream(
      String currentUserUid) async* {
    // Fetch contacts and yield the initial list
    await fetchContacts(currentUserUid);
    yield contacts.toList();
    // Listen for real-time updates and yield them
    await for (var _ in _firestore.collection('users').snapshots()) {
      await fetchContacts(currentUserUid);
      yield contacts.toList();
    }
  }

  Future<void> fetchContacts(String currentUserUid) async {
    contacts.clear();
    QuerySnapshot snapshot = await _firestore
        .collection('chatroom')
        .where('users', arrayContains: currentUserUid)
        .get();

    for (var doc in snapshot.docs) {
      List<dynamic> users = doc['users'];
      for (var userUid in users) {
        if (userUid != currentUserUid) {
          DocumentSnapshot userSnapshot =
              await _firestore.collection('UserDetails').doc(userUid).get();

          if (userSnapshot.exists) {
            Map<String, dynamic> userMap =
                userSnapshot.data() as Map<String, dynamic>;
            // You can add a conversationExists check here and update the 'conversations' field of userMap
            contacts.add(userMap);
          }
        }
      }
    }
  }
}
String chatRoomId(String user1, String user2) {
  if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
    return "$user1$user2";
  } else {
    return "$user2$user1";
  }
}

Widget contact(
    String urlImage, String title, var time, onOff, String msgs, context) {
  FirebaseAuth _auth = FirebaseAuth.instance;
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
    child: ListTile(
      onTap: () async {
        FirebaseFirestore _firestore = FirebaseFirestore.instance;

        // Fetch user data for the tapped contact
        QuerySnapshot querySnapshot = await _firestore
            .collection('UserDetails')
            .where('Full Name',
            isEqualTo: title) // Use the appropriate field for name
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          Map<String, dynamic> userMap =
          querySnapshot.docs[0].data() as Map<String, dynamic>;

          String roomId = chatRoomId(
            _auth.currentUser!.uid.toString(),
            userMap['Uid'].toString(),
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  chatroom(chatRoomID: roomId, userMap: userMap),
            ),
          );
        }
      },
      leading: Container(
        height: 50,
        width: 50,
        child: ClipOval(
          child: Image.network(
            urlImage,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(title),
      subtitle: Row(
        children: [
          // const Icon(
          //   Icons.done_all,
          //   size: 20,
          //   color: Colors.blueAccent,
          // ),
          // const SizedBox(
          //   width: 4.0,
          // ),
          Text(
            msgs,style: TextStyle(fontSize: 12),
          ),
        ],
      ),
      trailing: Text(time),
    ),
  );
}
// Widget message(String urlImage, String title, String onOff, context) {
//   return Scaffold(
//     extendBodyBehindAppBar: true,
//     appBar: AppBar(
//       backgroundColor: Colors.transparent,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [
//             Color.fromRGBO(120, 149, 203, 1),
//             Color.fromRGBO(74, 85, 162, 1),
//           ], begin: Alignment.topLeft, end: Alignment.bottomRight),
//         ),
//       ),
//       titleSpacing: 0.0,
//       leading: IconButton(
//         onPressed: () {
//           Navigator.pop(context);
//         },
//         icon: const Icon(Icons.arrow_back_rounded),
//       ),
//       title: Row(
//         children: [
//           Container(
//             height: 40,
//             width: 40,
//             child: ClipOval(
//               child: Image.asset(
//                 urlImage,
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//           const SizedBox(
//             width: 10,
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title),
//               const SizedBox(
//                 height: 2,
//               ),
//               Text(
//                 onOff,
//                 style: const TextStyle(fontSize: 12),
//               ),
//             ],
//           ),
//         ],
//       ),
//       actions: const [
//         Icon(Icons.videocam),
//         Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16),
//           child: Icon(Icons.call),
//         ),
//         Icon(Icons.more_vert),
//       ],
//     ),
//     body: const ChatScr(),
//   );
// }
//
// class ChatMess extends StatelessWidget {
//   final String text;
//   final AnimationController animationController;
//
//   const ChatMess(
//       {Key? key, required this.text, required this.animationController})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizeTransition(
//       sizeFactor:
//           CurvedAnimation(parent: animationController, curve: Curves.easeOut),
//       axisAlignment: 0.0,
//       child: Container(
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//             color: const Color.fromRGBO(197, 223, 248, 0.8),
//             borderRadius: BorderRadius.circular(5.0)),
//         margin: const EdgeInsets.symmetric(vertical: 2.0),
//         child: Text(text),
//       ),
//     );
//   }
// }
//
// class ChatScr extends StatefulWidget {
//   const ChatScr({Key? key}) : super(key: key);
//
//   @override
//   State<ChatScr> createState() => _ChatScrState();
// }
//
// class _ChatScrState extends State<ChatScr> with TickerProviderStateMixin {
//   final _textController = TextEditingController();
//   final List<ChatMess> _messages = [];
//   final FocusNode _focusNode = FocusNode();
//
//   @override
//   void dispose() {
//     for (var message in _messages) {
//       message.animationController.dispose();
//     }
//     super.dispose();
//   }
//
//   void _handleSubmitted(String text) {
//     _textController.clear();
//
//     var message = ChatMess(
//       text: text,
//       animationController: AnimationController(
//         duration: const Duration(milliseconds: 700),
//         vsync: this,
//       ),
//     );
//     setState(() {
//       _messages.insert(0, message);
//     });
//     _focusNode.requestFocus();
//     message.animationController.forward();
//   }
//
//   Widget _buildTextComposer() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Row(
//         children: [
//           Flexible(
//             child: Container(
//               height: 50,
//               child: TextField(
//                 controller: _textController,
//                 onChanged: (text) {
//                   setState(() {});
//                 },
//                 onSubmitted: _handleSubmitted,
//                 decoration: InputDecoration(
//                   contentPadding: EdgeInsets.zero,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(25.7),
//                     borderSide: const BorderSide(
//                       width: 0,
//                       style: BorderStyle.none,
//                     ),
//                   ),
//                   filled: true,
//                   fillColor: Colors.white,
//                   prefixIcon: const Icon(
//                     Icons.emoji_emotions_outlined,
//                     color: Colors.grey,
//                   ),
//                   hintText: 'Message',
//                   hintStyle: const TextStyle(fontSize: 20, color: Colors.grey),
//                   suffixIconConstraints:
//                       const BoxConstraints(minWidth: 80, maxWidth: 100),
//                   suffixIcon: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Icon(
//                         Icons.attach_file_outlined,
//                         color: Colors.grey,
//                       ),
//                       SizedBox(
//                         width: 16,
//                       ),
//                       Icon(
//                         Icons.camera_alt,
//                         color: Colors.grey,
//                       ),
//                     ],
//                   ),
//                 ),
//                 focusNode: _focusNode,
//               ),
//             ),
//           ),
//           Container(
//             height: 65,
//             width: 65,
//             child: IconButton(
//               icon: _textController.text == ''
//                   ? const CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Color.fromRGBO(120, 149, 203, 0.95),
//                       child: Icon(
//                         Icons.mic,
//                         color: Colors.white,
//                       ))
//                   : const CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Color.fromRGBO(120, 149, 203, 0.95),
//                       child: Icon(
//                         Icons.send,
//                         color: Colors.white,
//                       ),
//                     ),
//               onPressed: () => _handleSubmitted(_textController.text),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       constraints: const BoxConstraints.expand(),
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               opacity: 0.1,
//               scale: 0.5,
//               image: AssetImage("assets/images/logo.png"),
//               fit: BoxFit.contain)),
//       child: Column(
//         children: [
//           Flexible(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(8.0),
//               reverse: true,
//               itemBuilder: (_, index) => _messages[index],
//               itemCount: _messages.length,
//             ),
//           ),
//           Container(
//             child: _buildTextComposer(),
//           ),
//         ],
//       ),
//     );
//   }
// }
