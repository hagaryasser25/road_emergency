import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:road_emergency/screens/user/add_opinion.dart';

import '../models/opinions_model.dart';

class UserOpinions extends StatefulWidget {
  static const routeName = '/userOpinions';

  const UserOpinions({super.key});

  @override
  State<UserOpinions> createState() => _UserOpinionsState();
}

class _UserOpinionsState extends State<UserOpinions> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Exp> expList = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchExp();
  }

  void fetchExp() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("userOpinion");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Exp p = Exp.fromJson(event.snapshot.value);
      expList.add(p);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) => Scaffold(
          body: Column(
            children: [
              Container(
                height: 150.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [.01, .25],
                    colors: [
                      Colors.blue,
                      Color.fromRGBO(124, 180, 226, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue, //<-- SEE HERE
                            child: IconButton(
                              icon: Center(
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(
                                    context, AddOpinion.routeName);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 250.w,
                          ),
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.blue, //<-- SEE HERE
                            child: IconButton(
                              icon: Center(
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Text(
                      'الأراء',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                    left: 10,
                  ),
                  child: ListView.builder(
                    itemCount: expList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: HexColor('#eaf1f7'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 15, left: 15, bottom: 10),
                            child: Column(children: [
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'الاسم: ${expList[index].name.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'الراى: ${expList[index].opinion.toString()}',
                                    style: TextStyle(fontSize: 17),
                                  )),
                            ]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
