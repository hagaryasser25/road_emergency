import 'dart:io';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:road_emergency/screens/user/user_home.dart';

import '../models/user_model.dart';

class SendRequest extends StatefulWidget {
  String centerName;
  String serviceName;
  String technicalName;
  String technicalPhone;
  static const routeName = '/sendRequest';
  SendRequest(
      {required this.centerName,
      required this.serviceName,
      required this.technicalName,
      required this.technicalPhone});

  @override
  State<SendRequest> createState() => _SendRequestState();
}

class _SendRequestState extends State<SendRequest> {
  var dateController = TextEditingController();
  var addressController = TextEditingController();
  var descriptionController = TextEditingController();
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  late Users currentUser;

  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserData();
  }

  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    final snapshot = await base.get();
    setState(() {
      currentUser = Users.fromSnapshot(snapshot);
    });
  }

  String imageUrl = '';
  File? image;

  Future pickImageFromDevice() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    final tempImage = File(xFile.path);
    setState(() {
      image = tempImage;
      print(image!.path);
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference refrenceImageToUpload = referenceDirImages.child(uniqueFileName);
    try {
      await refrenceImageToUpload.putFile(File(xFile.path));

      imageUrl = await refrenceImageToUpload.getDownloadURL();
    } catch (error) {}
    print(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              top: 40.h,
            ),
            child: Padding(
              padding: EdgeInsets.only(right: 10.w, left: 10.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 1.h,
                    ),
                    Text('صورة البطاقة'),
                    Align(
                      alignment: Alignment.center,
                      child: Stack(
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 30, horizontal: 30),
                              child: CircleAvatar(
                                radius: 65,
                                backgroundColor:
                                    Color.fromARGB(255, 235, 234, 234),
                                backgroundImage:
                                    image == null ? null : FileImage(image!),
                              )),
                          Positioned(
                              top: 120,
                              left: 120,
                              child: SizedBox(
                                width: 50,
                                child: RawMaterialButton(
                                    // constraints: BoxConstraints.tight(const Size(45, 45)),
                                    elevation: 10,
                                    fillColor: Colors.red,
                                    child: const Align(
                                        // ignore: unnecessary_const
                                        child: Icon(Icons.add_a_photo,
                                            color: Colors.white, size: 22)),
                                    padding: const EdgeInsets.all(15),
                                    shape: const CircleBorder(),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Choose option',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.red)),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          pickImageFromDevice();
                                                        },
                                                        splashColor:
                                                            HexColor('#FA8072'),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                  Icons.image,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            Text('Gallery',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ))
                                                          ],
                                                        )),
                                                    InkWell(
                                                        onTap: () {
                                                          // pickImageFromCamera();
                                                        },
                                                        splashColor:
                                                            HexColor('#FA8072'),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                  Icons.camera,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            Text('Camera',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ))
                                                          ],
                                                        )),
                                                    InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                        },
                                                        splashColor:
                                                            HexColor('#FA8072'),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                  Icons
                                                                      .remove_circle,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                            Text('Remove',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ))
                                                          ],
                                                        ))
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    }),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: dateController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'التاريخ',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 65.h,
                      child: TextField(
                        controller: addressController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'العنوان الحالى',
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: 150.h,
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: 10,
                        controller: descriptionController,
                        decoration: InputDecoration(
                          fillColor: HexColor('#155564'),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                          border: OutlineInputBorder(),
                          hintText: 'الوصف',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.tightFor(
                          width: double.infinity, height: 65.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () async {
                          String date = dateController.text.trim();
                          String description =
                              descriptionController.text.trim();
                          String address = addressController.text.trim();

                          if (date.isEmpty ||
                              description.isEmpty ||
                              address.isEmpty ||
                              imageUrl.isEmpty) {
                            CherryToast.info(
                              title: Text('ادخل جميع الحقول'),
                              actionHandler: () {},
                            ).show(context);
                            return;
                          }

                          User? user = FirebaseAuth.instance.currentUser;

                          if (user != null) {
                            String uid = user.uid;

                            DatabaseReference companyRef = FirebaseDatabase
                                .instance
                                .reference()
                                .child('requests')
                                .child('${widget.centerName}');

                            String? id = companyRef.push().key;

                            await companyRef.child(id!).set({
                              'id': id,
                              'date': date,
                              'description': description,
                              'address': address,
                              'serviceName': widget.serviceName,
                              'technicalName': widget.technicalName,
                              'userName': currentUser.fullName,
                              'userPhone': currentUser.phoneNumber,
                              'imageUrl': imageUrl,
                              'request': 'false',
                            });
                          }
                          Widget remindButton = TextButton(
                            style: TextButton.styleFrom(
                              primary: HexColor('#6bbcba'),
                            ),
                            child: Text("Ok"),
                            onPressed: () {
                              Navigator.pushNamed(context, UserHome.routeName);
                            },
                          );

                          // set up the AlertDialog
                          AlertDialog alert = AlertDialog(
                            title: Text("Notice"),
                            content: Container(
                              height: 100.h,
                              child: Column(
                                children: [
                                  Text("تم ارسال الطلب"),
                                  Text("رقم هاتف الفنى: ${widget.technicalPhone}")
                                ],
                              ),
                            ),
                            actions: [
                              remindButton,
                            ],
                          );

                          // show the dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        },
                        child: Text('حفظ'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

