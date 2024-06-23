import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_partner/pages/messages/chatroom.dart';
import 'package:dream_partner/pages/messages/messages_page.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class UserData extends StatefulWidget {
  final Profile;
  final name;
  final age;
  final cast;
  final city;
  final father;
  final m_status;
  final userID;
  const UserData({super.key, required this.Profile,required this.name, required this.age, required this.cast,required this.city,
    required this.father, required this.m_status,required this.userID,});


  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  late bool isfill;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isfill=false;
    });

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.colors.mediumPeach,
        body: Container(
          height: getheight(context),
          width: getwidth(context),
          child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: getwidth(context)*0.05,right: getwidth(context)*0.05),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Container(
                      height: getheight(context)*0.55,
                      width: getwidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(widget.Profile),
                          fit: BoxFit.cover,
                        )
                      ),



                       ),
                    SizedBox(height: getheight(context)*0.02,),
                    Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Name: ' + widget.name,style: TextStyle(color: Colors.white,fontSize: 16,),),
                          // Text('Father Name: ' + widget.father,style: TextStyle(color: Colors.white,fontSize: 16,),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10,right: 10,top: getheight(context)*0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Text('Name: ' + widget.name,style: TextStyle(color: Colors.white,fontSize: 16,),),
                           Text('Father Name: ' + widget.father,style: TextStyle(color: Colors.white,fontSize: 16,),),
                        ],
                      ),
                    ),
                    SizedBox(height: getheight(context)*0.02,),
                    Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Age: ' + widget.age,style: TextStyle(color: Colors.white,fontSize: 16,),),
                          Text('Cast: ' + widget.cast,style: TextStyle(color: Colors.white,fontSize: 16,),),
                        ],
                      ),
                    ),
                    SizedBox(height: getheight(context)*0.02,),
                    Padding(
                      padding: EdgeInsets.only(left: 10,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('City: ' + widget.city,style: TextStyle(color: Colors.white,fontSize: 16,),),
                          Text('Marriage Status: ' + widget.m_status,style: TextStyle(color: Colors.white,fontSize: 16,),),
                        ],
                      ),
                    ),
                    SizedBox(height: getheight(context)*0.03,),
                    InkWell(
                      onTap: (){

                        //Chat Button Functionality Here................



                      },
                      child: Container(
                        height: getheight(context)*0.07,
                        width: getwidth(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppTheme.colors.darkPeach,
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: getwidth(context)*0.05),
                          child: InkWell(
                            onTap: () async {
                              FirebaseFirestore _firestore = FirebaseFirestore.instance;

                              // Fetch user data for the tapped contact
                              QuerySnapshot querySnapshot = await _firestore
                                  .collection('UserDetails')
                                  .where('Full Name',
                                  isEqualTo: widget.name) // Use the appropriate field for name
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.message,color: Colors.white),
                                SizedBox(width: getwidth(context)*0.05,),
                                Text('Chat with '+ widget.name,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontSize: 16
                                ),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: getheight(context)*0.01,),
                    Container(
                      height: getheight(context)*0.07,
                      width: getwidth(context),
                      decoration: BoxDecoration(
                        color: AppTheme.colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(onPressed: (){

                          setState(() {
                            if(isfill==false){
                              setState(() {
                                isfill=true;
                              });

                              Get.snackbar('Liked','Like Given to '+widget.name);
                              final _ref=FirebaseFirestore.instance.collection('UserDetails').doc(widget.userID)
                              .update({
                                'Liked Users': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
                              });
                            }
                          });



                      }, icon: isfill? Icon(Icons.favorite,color: Colors.red,size: 40,):Icon(
                        Icons.favorite,color: Colors.red,size: 40,
                      )),
                    )
                  ],
                ),
              ),
          ),
        ),
      ),
    );
  }
}
