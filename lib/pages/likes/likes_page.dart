import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_partner/pages/dashboard/dashboard.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  State<LikesPage> createState() => _LikesPageState();
}

  // List<dynamic> array=[];
  // List<String> name=[];
  // List<String> profilepic=[];
  // final _refer=FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   _refer.get().then((value){
  //     array=value.get('Liked Users');
  //   });
  // }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //    backgroundColor: AppTheme.colors.white,
  //     body:ListView.builder(
  //                     scrollDirection: Axis.vertical,
  //                   itemCount: array.length,
  //                     itemBuilder:(context, index) {
  //                       print(array[index]);
  //                         final _ref = FirebaseFirestore.instance.collection(
  //                             'UserDetails').doc(array[index])
  //                             .get().then((value){
  //        var f_name=value.get('Full Name');
  //        var p=value.get('Profile');
  //        name.add(f_name.toString());
  //        profilepic[index]=p;
  //
  //   }).onError((error, stackTrace) {
  //     print('Error fetching data : $error');
  //                         });
  //                           return Container(
  //                             height: getheight(context) * 0.5,
  //                             decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(20),
  //                               image: DecorationImage(
  //                                 image: NetworkImage(
  //                                   profilepic[index],
  //                                 ),
  //                                 fit: BoxFit.cover,
  //                               ),
  //                               color: AppTheme.colors.lightPeach,
  //                             ),
  //                             child: Column(
  //                               mainAxisAlignment: MainAxisAlignment
  //                                   .spaceBetween,
  //                               crossAxisAlignment: CrossAxisAlignment.end,
  //                               children: [
  //                                 Row(
  //                                   children: [
  //                                     IconButton(onPressed: () {
  //                                       _refer.update({
  //                                         'Liked Users': FieldValue.arrayRemove(
  //                                             [
  //                                               FirebaseAuth.instance
  //                                                   .currentUser!.uid
  //                                             ]),
  //                                       });
  //                                     }, icon: Icon(
  //                                       Icons.cancel_rounded,
  //                                       color: Colors.white,
  //                                       size: 30,
  //                                     )),
  //                                     // IconButton(onPressed: (){
  //                                     //   setState(() {
  //                                     //     if(isfilled==false){
  //                                     //       isfilled=true;
  //                                     //       Get.snackbar('Liked User','Like Given to '+snapshot.data!
  //                                     //           .docs[index]['Full Name']
  //                                     //           .toString(),);
  //                                     //     }
  //                                     //     else{
  //                                     //       isfilled=false;
  //                                     //     }
  //                                     //   });
  //                                     // }, icon: isfilled? Icon(
  //                                     //   Icons.favorite,color: AppTheme.colors.darkPeach,
  //                                     // ):Icon(
  //                                     //   Icons.favorite_border,color: Colors.white,
  //                                     // )),
  //                                   ],
  //                                   mainAxisAlignment: MainAxisAlignment.end,
  //                                 ),
  //
  //
  //                                 Padding(
  //                                   padding: const EdgeInsets.all(0),
  //                                   child: Container(
  //
  //                                       alignment: Alignment.bottomCenter,
  //                                       child: Container(
  //                                         decoration: BoxDecoration(
  //                                             color: AppTheme.colors.lightPeach,
  //                                             borderRadius: BorderRadius.only(
  //                                               bottomLeft: Radius.circular(20),
  //                                               bottomRight: Radius.circular(
  //                                                   20),
  //                                             )
  //                                         ),
  //                                         height: 50,
  //                                         child: Center(
  //                                           child: Text(
  //                                         name[index],
  //                                             style: TextStyle(
  //                                                 color: Colors.white,
  //                                                 fontSize: 20,
  //                                                 fontWeight: FontWeight.bold
  //                                             ),),
  //                                         ),
  //                                       )),
  //                                 ),
  //                               ],
  //                             ),
  //
  //
  //                         );
  //                       }),
  //
  //
  //
  //   );
  // }
  class _LikesPageState extends State<LikesPage> {
  List<dynamic> array = [];
  List<String> name = [];
  List<String> profilepic = [];
  final _refer = FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  void initState() {
  super.initState();
  _refer.get().then((value) {
  setState(() {
  array = value.get('Liked Users');
  });
  });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  backgroundColor: AppTheme.colors.white,
  body: array.isEmpty
      ? Center(
    child: Text(
      "No likes Yet",
      style: TextStyle(fontSize: 18),
    ),
  )
      : ListView.builder(
    physics: BouncingScrollPhysics(),
    padding: EdgeInsets.only(top: getheight(context)*0.02,bottom: getheight(context)*0.02),
  scrollDirection: Axis.vertical,
  itemCount: array.length,

  itemBuilder: (context, index) {
  return FutureBuilder<DocumentSnapshot>(
  future: FirebaseFirestore.instance.collection('UserDetails').doc(array[index]).get(),
  builder: (context, snapshot) {
  if (snapshot.connectionState == ConnectionState.done) {
  if (snapshot.hasData) {
  var f_name = snapshot.data!.get('Full Name');
  var p = snapshot.data!.get('Profile');
  name.add(f_name.toString());
  profilepic.add(p.toString());

  return Padding(
    padding: EdgeInsets.only(left: getwidth(context)*0.05,right: getwidth(context)*0.05,bottom: getwidth(context)*0.05),
    child: Container(
    height: getheight(context)*0.5,
      width: getwidth(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
            profilepic[index].toString(),
          ),
          fit: BoxFit.cover,
        )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              IconButton(onPressed: (){
                final _ref=FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser
                !.uid)
                    .update({

                  'Liked Users': FieldValue.arrayRemove([snapshot.data!.get('Uid').toString()]),
                }).then((value) {
                  setState(() {
                    name.removeAt(index);
                    profilepic.removeAt(index);
                  });
                  Get.offAll(()=>MyDashBoard());
                });
                int userIndex = name.indexOf(name[index]);
    if (userIndex != -1) {
      // Remove the user's data from the local lists
      setState(() {
        name.removeAt(userIndex);
        profilepic.removeAt(userIndex);
      });
      Get.snackbar('Removed', name[index] + ' is removed from the list');
    } else {
    Get.snackbar('error', 'User not found');
    }


              }, icon: Icon(
                Icons.cancel_rounded,color: AppTheme.colors.darkPeach,
                size: 30,
              )),
              // IconButton(onPressed: (){
              //   setState(() {
              //     if(isfilled==false){
              //       isfilled=true;
              //       Get.snackbar('Liked User','Like Given to '+snapshot.data!
              //           .docs[index]['Full Name']
              //           .toString(),);
              //     }
              //     else{
              //       isfilled=false;
              //     }
              //   });
              // }, icon: isfilled? Icon(
              //   Icons.favorite,color: AppTheme.colors.darkPeach,
              // ):Icon(
              //   Icons.favorite_border,color: Colors.white,
              // )),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),


          Padding(
            padding: const EdgeInsets.all(0),
            child: Container(

                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.colors.mediumPeach,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )
                  ),
                  height: 50,

                  child: Center(
                    child: Text(
                                name[index].toString(),
                      style: TextStyle(color: Colors.white,
                          fontSize: 20,fontWeight: FontWeight.bold
                      ),),
                  ),
                )),
          ),
        ],
      ),
    ),
  );
  } else if (snapshot.hasError) {
  return Text('Error fetching data: ${snapshot.error}');
  }
  }

  // You can return a loading indicator or an empty container while waiting for data.
  return Center(child: CircularProgressIndicator(color: AppTheme.colors.darkPeach,)); // Replace with your preferred loading indicator.
  },
  );
  },
  ),
  );
  }
  }

