import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dream_partner/pages/dashboard/dashboard.dart';
import 'package:dream_partner/responsiveness.dart';
import 'package:dream_partner/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  File? image;
  var imgurl;
  bool loading = false;
  bool getloading=false;
  final users=FirebaseFirestore.instance.collection('UserDetails').doc(FirebaseAuth.instance.currentUser!.uid);
  Future pickImage() async {

    try {

      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) {
       return;
      }
       setState(() {
         Get.snackbar('Please Wait', 'your picture is uploading ....');
       });
      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
      String uniqueFilename=DateTime.now().millisecond.toString();
      Reference store=FirebaseStorage.instance.ref().child('Images').child(uniqueFilename);
      await store.putFile(File(image.path));
      imgurl=await store.getDownloadURL();
    } on PlatformException catch(e) {
      print('Failed to pick image: $e');
    }
  }
  UpdateProfilePicture() async{
    return users.update({
      'Profile': imgurl.toString(),
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users.get().then((value){

    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 70,
        backgroundColor: AppTheme.colors.darkPeach,
        title: Text('Profile Picture',style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        height: getheight(context),
        width: getwidth(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getheight(context)*0.05,),
            Padding(
              padding: EdgeInsets.only(top: getheight(context) * 0.02),
              child: Stack(
                children: [
                  Container(
                    height: getwidth(context) * 0.3,
                    width: getwidth(context) * 0.3,
                    decoration: BoxDecoration(
                      color: AppTheme.colors.lightPeach,
                      borderRadius: BorderRadius.circular(getwidth(context) * 0.3),
                    ),
                    child: ClipOval(
                        child:
                        image!=null? Container(
                          child: Image.file(
                            image!,
                            fit: BoxFit.cover,
                          ),
                        ):Image(image: AssetImage('assets/images/default_image.png'),fit: BoxFit.cover,)
                    ),
                  ),
                   Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: AppTheme.colors.zeroPeach,
                                      ),
                                      onPressed: ()async {
                                        setState(() {
                                          getloading=true;
                                        });
                                        pickImage().then((value){
                                          setState(() {
                                            getloading=false;

                                          });
                                        }).onError((error, stackTrace){
                                          setState(() {
                                            getloading=false;
                                          });
                                        });


                  }
                                    ),
                                  ),
                ],
              ),
            ),
            SizedBox(height: getheight(context)*0.05,),
            InkWell(
              onTap: ()async{
                setState(() {
                  loading=true;
                });
                UpdateProfilePicture().then((value){
                  setState(() {
                    loading=false;
                  });
                  Get.snackbar('Updated', 'Your Profile is updated');
                  Get.offAll(()=>MyDashBoard());
                }).onError((error, stackTrace) {
                  setState(() {
                    loading=false;
                  });
                  Get.snackbar('Error', error.toString());
                });
              },
              child: getloading?CircularProgressIndicator(color: AppTheme.colors.darkPeach,):Container(
                height: getheight(context)*0.05,
                width: getwidth(context)*0.35,
                decoration: BoxDecoration(
                  color: AppTheme.colors.darkPeach,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: loading?CircularProgressIndicator(color: Colors.white,):Text('Save Changes',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

