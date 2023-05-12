import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui' as ui;

import 'package:road_emergency/screens/models/request_model.dart';

class CenterRequests extends StatefulWidget {
  String centerName;
  static const routeName = '/centerRequests';
  CenterRequests({required this.centerName});

  @override
  State<CenterRequests> createState() => _CenterRequestsState();
}

class _CenterRequestsState extends State<CenterRequests> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Requests> requestsList = [];
  List<String> keyslist = [];
  String request = 'false';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchRequests();
  }

  @override
  void fetchRequests() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("requests").child("${widget.centerName}");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Requests p = Requests.fromJson(event.snapshot.value);
      requestsList.add(p);
      keyslist.add(event.snapshot.key.toString());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          appBar: AppBar(backgroundColor: Colors.red, title: Text('الطلبات')),
          body: Padding(
            padding: EdgeInsets.only(
              top: 15.h,
              right: 10.w,
              left: 10.w,
            ),
            child: ListView.builder(
              itemCount: requestsList.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 15, left: 15, bottom: 10),
                            child: Column(children: [
                              Image.network(
                                  '${requestsList[index].imageUrl.toString()}',
                                  height: 150.h),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'اسم المستخدم: ${requestsList[index].userName.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'رقم الهاتف : ${requestsList[index].userPhone.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'العنوان الحالى : ${requestsList[index].address.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'اسم الخدمة : ${requestsList[index].serviceName.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'اسم الفنى : ${requestsList[index].technicalName.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'تاريخ الطلب : ${requestsList[index].date.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'وصف الطلب : ${requestsList[index].description.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                              SizedBox(
                                height: 10.h,
                              ),
                              requestsList[index].request == 'false'
                                  ? Row(
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints.tightFor(
                                              width: 120.w, height: 35.h),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.red,
                                            ),
                                            child: Text('تأكيد الطلب'),
                                            onPressed: () async {
                                              User? user = FirebaseAuth
                                                  .instance.currentUser;

                                              if (user != null) {
                                                String uid = user.uid;
                                                int date = DateTime.now()
                                                    .millisecondsSinceEpoch;

                                                DatabaseReference companyRef =
                                                    FirebaseDatabase.instance
                                                        .reference()
                                                        .child('requests')
                                                        .child(
                                                            '${widget.centerName}')
                                                        .child(
                                                            '${requestsList[index].id.toString()}');

                                                await companyRef.update({
                                                  'request': 'true',
                                                });
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        
                                                        content: Text(
                                                            'تم تأكيد الطلب'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(context);
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  super
                                                                      .widget));
                                                            },
                                                            child: Text("حسنا"),
                                                          ),
                                                          
                                                        ],
                                                      );
                                                    });
                                               
                                                
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100.w,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        super.widget));
                                            FirebaseDatabase.instance
                                                .reference()
                                                .child('requests')
                                                .child('${widget.centerName}')
                                                .child(
                                                    '${requestsList[index].id.toString()}')
                                                .remove();
                                          },
                                          child: Icon(Icons.delete,
                                              color: Color.fromARGB(
                                                  255, 122, 122, 122)),
                                        )
                                      ],
                                    )
                                  : InkWell(
                                      onTap: () async {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        super.widget));
                                        FirebaseDatabase.instance
                                            .reference()
                                            .child('requests')
                                            .child('${widget.centerName}')
                                            .child(
                                                '${requestsList[index].id.toString()}')
                                            .remove();
                                      },
                                      child: Icon(Icons.delete,
                                          color: Color.fromARGB(
                                              255, 122, 122, 122)),
                                    )
                            ]),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String getDate(int date) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(date);

    return DateFormat('MMM dd yyyy').format(dateTime);
  }
}
