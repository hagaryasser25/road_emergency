import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/complains_model.dart';

class AdminComplain extends StatefulWidget {
  String centerName;
  static const routeName = '/adminComplain';
   AdminComplain({
    required this.centerName
  });

  @override
  State<AdminComplain> createState() => _AdminComplainState();
}

class _AdminComplainState extends State<AdminComplain> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Complains> complainsList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchComplains();
  }

  @override
  void fetchComplains() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("userComplains");
    base
        .orderByChild("centerName")
        .equalTo("${widget.centerName}")
        .onChildAdded
        .listen((event) {
      print(event.snapshot.value);
      Complains p = Complains.fromJson(event.snapshot.value);
      complainsList.add(p);
      keyslist.add(event.snapshot.key.toString());
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
            appBar: AppBar(backgroundColor: Colors.red, title: Text('الشكاوى')),
            body: Column(children: [
              SizedBox(height: 1.h,),
              Expanded(
                flex: 8,
                child: ListView.builder(
                  itemCount: complainsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
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
                                Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'الشكوى : ${complainsList[index].description.toString()}',
                                      style: TextStyle(fontSize: 17),
                                    )),
                                
                                    Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'رقم الهاتف: ${complainsList[index].userPhone.toString()}',
                                      style: TextStyle(fontSize: 17),
                                    )),
                                    Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      'اسم المشتكى: ${complainsList[index].userName.toString()}',
                                      style: TextStyle(fontSize: 17),
                                    )),
                                SizedBox(
                                  height: 10.h,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints.tightFor(
                                      width: 120.w, height: 35.h),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary:
                                          Colors.red,
                                    ),
                                    child: Text('مسح الشكوى'),
                                    onPressed: () async {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  super.widget));
                                      base
                                          .child(complainsList[index]
                                              .id
                                              .toString())
                                          .remove();
                                    },
                                  ),
                                )
                              ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        )
                      ],
                    );
                  },
                ),
              ),
            ]),
          ),
        ));
  }
}
