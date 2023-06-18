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
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class CenterTechnical extends StatefulWidget {
  String centerName;
  String serviceName;
  CenterTechnical({required this.centerName, required this.serviceName});

  @override
  State<CenterTechnical> createState() => _CenterTechnicalState();
}

class _CenterTechnicalState extends State<CenterTechnical> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Technical> technicalList = [];
  List<String> keyslist = [];

  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchTechnicals();
  }

  @override
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AddTechnical(
                                    centerName: '${widget.centerName}',
                                    serviceName: '${widget.serviceName}',
                                  );
                                }));
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
                      'الفنيين',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Container(
                child: Expanded(
                  flex: 8,
                  child: ListView.builder(
                      itemCount: technicalList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {},
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 20.w, left: 20.w),
                                  child: Container(
                                    width: double.infinity,
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Image.network(
                                            '${technicalList[index].imageUrl}',
                                            height: 100.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              '${technicalList[index].name.toString()}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              'رقم الهاتف : ${technicalList[index].phoneNumber.toString()}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              'الخبرة : ${technicalList[index].exp.toString()}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                         ConstrainedBox(
                            constraints: BoxConstraints.tightFor(
                                width: 90, height: 37.h),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromRGBO(124, 180, 226, 1),
                                padding: const EdgeInsets.all(0.0),
                                elevation: 5,
                              ),
                              onPressed: () async {
                                 Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('technicals')
                                  .child('${widget.centerName}')
                                  .child('${widget.serviceName}')
                                  .child('${technicalList[index].id}')
                                  .remove();
                              }, child: Text("حذف الفنى"),
                              
                            ),
                          ),
                                          SizedBox(height: 5.h),
                                          
                                          
                                        ],
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
