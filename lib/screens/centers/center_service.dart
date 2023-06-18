import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:road_emergency/screens/centers/add_service.dart';
import 'package:road_emergency/screens/centers/center_technicals.dart';
import 'package:road_emergency/screens/models/service_model.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/user_model.dart';

class CenterService extends StatefulWidget {
  String centerName;
  static const routeName = '/centerService';
  CenterService({required this.centerName});

  @override
  State<CenterService> createState() => _CenterServiceState();
}

class _CenterServiceState extends State<CenterService> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Service> serviceList = [];
  List<String> keyslist = [];

  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCenters();
  }

  @override
  void fetchCenters() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("services").child('${widget.centerName}');
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Service p = Service.fromJson(event.snapshot.value);
      serviceList.add(p);
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
                                  return AddService(
                                    centerName: '${widget.centerName}',
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
                      'الخدمات',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  width: double.infinity,
                  child: StaggeredGridView.countBuilder(
                    padding: EdgeInsets.only(
                      top: 20.h,
                      left: 15.w,
                      right: 15.w,
                      bottom: 15.h,
                    ),
                    crossAxisCount: 6,
                    itemCount: serviceList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: HexColor('#eaf1f7'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(children: [
                          Image.network(
                            '${serviceList[index].serviceImage.toString()}',
                            height: 165.h,
                            width: 100.w,
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              '${serviceList[index].serviceName.toString()}',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 3, 57, 101),
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis,
                                  fontFamily: 'ElMessiri',
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(height: 20.h,),
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
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CenterTechnical(
                                    centerName: widget.centerName,
                                    serviceName:
                                        '${serviceList[index].serviceName.toString()}',
                                  );
                                }));
                              }, child: Text('أضافة فنى'),
                              
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
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
                                  .child('services')
                                  .child('${widget.centerName}')
                                  .child('${serviceList[index].id}')
                                  .remove();
                              }, child: Text("حذف الخدمة"),
                              
                            ),
                          ),
                          
                        ]),
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(3, index.isEven ? 5 : 5),
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 5.0,
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
