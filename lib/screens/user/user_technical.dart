import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:road_emergency/screens/centers/add_technical.dart';
import 'package:road_emergency/screens/models/technical_model.dart';
import 'package:road_emergency/screens/user/send_complain.dart';
import 'package:road_emergency/screens/user/send_request.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/user_model.dart';

class UserTechnical extends StatefulWidget {
  String centerName;
  String serviceName;
  UserTechnical({required this.centerName, required this.serviceName});

  @override
  State<UserTechnical> createState() => _UserTechnicalState();
}

class _UserTechnicalState extends State<UserTechnical> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Technical> technicalList = [];
  List<String> keyslist = [];
  late Users currentUser;

  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTechnicals();
  }


  void fetchTechnicals() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database
        .reference()
        .child("technicals")
        .child('${widget.centerName}')
        .child('${widget.serviceName}');
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Technical p = Technical.fromJson(event.snapshot.value);
      technicalList.add(p);
      keyslist.add(event.snapshot.key.toString());
      print(keyslist);
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
          appBar: AppBar(backgroundColor: Colors.red, title: Text('الفنيين')),
          body: Container(
            width: double.infinity,
            child: StaggeredGridView.countBuilder(
              padding: EdgeInsets.only(
                top: 20.h,
                left: 15.w,
                right: 15.w,
                bottom: 15.h,
              ),
              crossAxisCount: 6,
              itemCount: technicalList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 1.h,
                      ),
                      child: CircleAvatar(
                        radius: 37,
                        backgroundImage: NetworkImage(
                            '${technicalList[index].imageUrl.toString()}'),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${technicalList[index].name.toString()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text('${technicalList[index].phoneNumber.toString()}'),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 10.w, left: 10.w),
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child:
                              Text('${technicalList[index].exp.toString()}')),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 100, height: 37.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor('#ffba26')),
                        onPressed: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SendRequest(
                              centerName: widget.centerName,
                              serviceName: widget.serviceName,
                              technicalName:
                                  '${technicalList[index].name.toString()}',
                              technicalPhone:
                                  '${technicalList[index].phoneNumber.toString()}',
                            );
                          }));
                        },
                        child: Text('ارسال طلب'),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 100, height: 37.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor('#ffba26')),
                        onPressed: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SendComplain(
                              centerName: widget.centerName,
                            );
                          }));
                        },
                        child: Text('ارسال شكوى'),
                      ),
                    ),
                  ]),
                );
              },
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(3, index.isEven ? 4 : 4),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 5.0,
            ),
          ),
        ),
      ),
    );
  }
}
