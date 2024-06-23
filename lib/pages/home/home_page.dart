import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_partner/filter_screen.dart';
import 'package:dream_partner/login_screen.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:dream_partner/userData_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../likes/likes_controller.dart';
import 'home_controller.dart';
import 'home_custom_card.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var ProfilePicture;
  var fullname;
  var usercast;
  var usercity;
  var caste;
  var city;
  var gender;
  var propertystatus;
  var familystatus;
  var agefrom;
  var ageto;
  var _ref;
  var _ref2;
  var userid;
  final  users=FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);
  final allusers=FirebaseFirestore.instance.collection('UserDetails').doc();
  final HomeController homeController = Get.put(HomeController());
  bool isfilled=false;
@override
  void initState() {
  users.get().then((value){
setState(() {
      caste=value.get('PrefCast');
      city=value.get('PrefCity');
      gender=value.get('PrefGender');
      propertystatus=value.get('PrefProperty Status');
      familystatus=value.get('PrefFamily Status');
      agefrom=value.get('PrefAgeRange From');
      ageto=value.get('PrefAgeRange To');
      userid=value.get('Uid');
});
_ref = FirebaseFirestore.instance
    .collection('UserDetails')
    .where("Family Status", isEqualTo: familystatus)
    .where("City", isEqualTo: city)
    .where("Gender", isEqualTo: gender)
    .where("Property Status", isEqualTo: propertystatus)
    .where("Age", isGreaterThanOrEqualTo: agefrom)
    .where("Age", isLessThanOrEqualTo: ageto)
    .snapshots();
_ref2=FirebaseFirestore.instance.collection('UserDetails').snapshots();
    });
    // TODO: implement initState


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: AppTheme.colors.white,
         child: city!=""?
         Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: (){
                      Get.offAll(()=>LoginPage());
                    },
                    child: Text(
                    "Discover",
                    style: GoogleFonts.breeSerif(fontSize: 27,color: AppTheme.colors.mediumPeach),
      )
                  ),
                  StreamBuilder(stream: _ref, builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.connectionState==ConnectionState.waiting)
                     {

                       return CircularProgressIndicator(color: AppTheme.colors.darkPeach,);
                     }
                    else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                      // Display centered text when no data exists
                      return Center(
                        child: Text(
                          "No Match Yet",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }

                      return
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if(snapshot.data!.docs[index]['Uid']==FirebaseAuth.instance.currentUser!.uid){
                                    Get.snackbar("It's You", 'This is your profile ');
                                  }
                                  else {
                                    Get.to(() =>
                                        UserData(
                                          Profile: snapshot.data!
                                              .docs[index]['Profile'],
                                          name: snapshot.data!
                                              .docs[index]['Full Name'],
                                          age: snapshot.data!
                                              .docs[index]['Age'],
                                          cast: snapshot.data!
                                              .docs[index]['Caste'],
                                          city: snapshot.data!
                                              .docs[index]['City'],
                                          father: snapshot.data!
                                              .docs[index]['Father Name'],
                                          m_status: snapshot.data!
                                              .docs[index]['Marriage Status'],
                                          userID: snapshot.data!
                                              .docs[index]['Uid'],


                                        ));
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: getwidth(context) * 0.1,
                                      right: getwidth(context) * 0.1),
                                  child:Container(
                                      height: getheight(context) * 0.3,
                                      width: getwidth(context) * 0.8,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            snapshot.data!.docs[index]['Profile'],
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        color: AppTheme.colors.lightPeach,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
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
                                                    child: Text(snapshot.data!
                                                        .docs[index]['Full Name']
                                                        .toString(),
                                                      style: TextStyle(color: Colors.white,
                                                          fontSize: 20,fontWeight: FontWeight.bold
                                                         ),),
                                                  ),
                                                )),
                                          ),
                                        ],
                                      ),

                                    ),
                                  ),

                              );
                              // return ListTile(
                              //   title: Text(snapshot.data!.docs[index]['Full Name'].toString()),
                              // );
                            }),
                      );




                  }),

                  // StreamBuilder(stream:streamUsers,
                  //      builder:(BuildContext context,AsyncSnapshot snapshot){
                  //     if(snapshot!.hasError){
                  //       Get.snackbar('Error', snapshot.error.toString());
                  //     }
                  //     return ListView.builder(
                  //         scrollDirection: Axis.horizontal,
                  //         itemCount: 1,
                  //
                  //         itemBuilder:(context,index){
                  //           return ListTile(
                  //              title: Text(snapshot.data['Full Name']),
                  //           );
                  //         } );
                  //
                  //      } ),
                  // StreamBuilder<QuerySnapshot>(
                  //   stream: FirebaseFirestore.instance.collection('UserDetails').snapshots(),
                  //   builder: (context,snapshot)
                  //     {
                  //       if(!snapshot.hasData){
                  //         return CircularProgressIndicator();
                  //       }
                  //       List<QueryDocumentSnapshot> users = snapshot.data!.docs;
                  //
                  //       return ListView.builder(
                  //         itemCount: users.length,
                  //         itemBuilder: (context, index) {
                  //           return Card(
                  //
                  //           );
                  //         },
                  //       );
                  //     }



                    // => Padding(
                    //   padding: const EdgeInsets.only(top: 35.0),
                    //   child: SizedBox(
                    //     height: Get.height * 0.6,
                    //     width: Get.width * 0.9,
                    //     child: Swiper(
                    //       onIndexChanged: homeController.onCardSwipe,
                    //       itemBuilder: (BuildContext context, int index) {
                    //         return HomeCustomCard(
                    //           index: index,
                    //           cardData: CardData(
                    //             backgroundImage: 'assets/images/card$index.jpg',
                    //             name: 'Name#$index',
                    //           ),
                    //         );
                    //       },
                    //       itemCount: snapshot.data,
                    //       viewportFraction: 0.8,
                    //       scale: 0.9,
                    //     ),
                    //   ),
                    // ),
                  //),

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.2,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(()=>FilterScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: AppTheme.colors.darkPeach,
                                elevation: 4.0,
                                primary: AppTheme.colors.darkPeach,
                                shape: const CircleBorder(),
                              ),
                              child: const Icon(Icons.filter_alt_rounded, size: 34),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),

                        ],
                      ),
                    ),
                  ),
                ],
              )
             :
         Column(
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             TextButton(
                 onPressed: (){
                   Get.offAll(()=>LoginPage());
                 },
                 child: Text(
                   "Discover",
                   style: GoogleFonts.breeSerif(fontSize: 27,color: AppTheme.colors.mediumPeach),
                 )
             ),
             StreamBuilder(stream: _ref2, builder: (BuildContext context, AsyncSnapshot snapshot){
               if(snapshot.connectionState==ConnectionState.waiting)
               {

                 return CircularProgressIndicator(color: AppTheme.colors.darkPeach,);
               }
               else if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                 // Display centered text when no data exists
                 return Center(
                   child: Text(
                     "No Match Yet",
                     style: TextStyle(fontSize: 18),
                   ),
                 );
               }

               return
                 Expanded(
                   child: ListView.builder(
                       shrinkWrap: true,
                       scrollDirection: Axis.horizontal,
                       itemCount: snapshot.data!.docs.length,
                       itemBuilder: (context, index) {
                         return InkWell(
                           onTap: () {
                             if(snapshot.data!.docs[index]['Uid']==FirebaseAuth.instance.currentUser!.uid){
                               Get.snackbar("It's You", 'This is your profile ');
                             }
                             else {
                               Get.to(() =>
                                   UserData(
                                     Profile: snapshot.data!
                                         .docs[index]['Profile'],
                                     name: snapshot.data!
                                         .docs[index]['Full Name'],
                                     age: snapshot.data!
                                         .docs[index]['Age'],
                                     cast: snapshot.data!
                                         .docs[index]['Caste'],
                                     city: snapshot.data!
                                         .docs[index]['City'],
                                     father: snapshot.data!
                                         .docs[index]['Father Name'],
                                     m_status: snapshot.data!
                                         .docs[index]['Marriage Status'],
                                     userID: snapshot.data!
                                         .docs[index]['Uid'],


                                   ));
                             }
                           },
                           child: Padding(
                             padding: EdgeInsets.only(
                                 left: getwidth(context) * 0.1,
                                 right: getwidth(context) * 0.1),
                             child:Container(
                               height: getheight(context) * 0.3,
                               width: getwidth(context) * 0.8,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(20),
                                 image: DecorationImage(
                                   image: NetworkImage(
                                     snapshot.data!.docs[index]['Profile'],
                                   ),
                                   fit: BoxFit.cover,
                                 ),
                                 color: AppTheme.colors.lightPeach,
                               ),
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 crossAxisAlignment: CrossAxisAlignment.end,
                                 children: [
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
                                             child: Text(snapshot.data!
                                                 .docs[index]['Full Name']
                                                 .toString(),
                                               style: TextStyle(color: Colors.white,
                                                   fontSize: 20,fontWeight: FontWeight.bold
                                               ),),
                                           ),
                                         )),
                                   ),
                                 ],
                               ),

                             ),
                           ),

                         );
                         // return ListTile(
                         //   title: Text(snapshot.data!.docs[index]['Full Name'].toString()),
                         // );
                       }),
                 );




             }),

             // StreamBuilder(stream:streamUsers,
             //      builder:(BuildContext context,AsyncSnapshot snapshot){
             //     if(snapshot!.hasError){
             //       Get.snackbar('Error', snapshot.error.toString());
             //     }
             //     return ListView.builder(
             //         scrollDirection: Axis.horizontal,
             //         itemCount: 1,
             //
             //         itemBuilder:(context,index){
             //           return ListTile(
             //              title: Text(snapshot.data['Full Name']),
             //           );
             //         } );
             //
             //      } ),
             // StreamBuilder<QuerySnapshot>(
             //   stream: FirebaseFirestore.instance.collection('UserDetails').snapshots(),
             //   builder: (context,snapshot)
             //     {
             //       if(!snapshot.hasData){
             //         return CircularProgressIndicator();
             //       }
             //       List<QueryDocumentSnapshot> users = snapshot.data!.docs;
             //
             //       return ListView.builder(
             //         itemCount: users.length,
             //         itemBuilder: (context, index) {
             //           return Card(
             //
             //           );
             //         },
             //       );
             //     }



             // => Padding(
             //   padding: const EdgeInsets.only(top: 35.0),
             //   child: SizedBox(
             //     height: Get.height * 0.6,
             //     width: Get.width * 0.9,
             //     child: Swiper(
             //       onIndexChanged: homeController.onCardSwipe,
             //       itemBuilder: (BuildContext context, int index) {
             //         return HomeCustomCard(
             //           index: index,
             //           cardData: CardData(
             //             backgroundImage: 'assets/images/card$index.jpg',
             //             name: 'Name#$index',
             //           ),
             //         );
             //       },
             //       itemCount: snapshot.data,
             //       viewportFraction: 0.8,
             //       scale: 0.9,
             //     ),
             //   ),
             // ),
             //),

             Padding(
               padding: const EdgeInsets.all(10.0),
               child: Container(
                 width: double.infinity,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [

                     const SizedBox(
                       width: 20,
                     ),
                     SizedBox(
                       height: MediaQuery.of(context).size.width * 0.2,
                       width: MediaQuery.of(context).size.width * 0.2,
                       child: ElevatedButton(
                         onPressed: () {
                           Get.to(()=>FilterScreen());
                         },
                         style: ElevatedButton.styleFrom(
                           shadowColor: AppTheme.colors.darkPeach,
                           elevation: 4.0,
                           primary: AppTheme.colors.darkPeach,
                           shape: const CircleBorder(),
                         ),
                         child: const Icon(Icons.filter_alt_rounded, size: 34),
                       ),
                     ),
                     const SizedBox(
                       width: 20,
                     ),

                   ],
                 ),
               ),
             ),
           ],
         )


        ),

    );
  }
}
