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
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  // Your icon here
                  label: Text(
                    'أضافة خدمة',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  icon: Align(
                      child: Icon(
                    Icons.add,
                    color: Colors.white,
                  )), // Your text here
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddService(
                        centerName: '${widget.centerName}',
                      );
                    }));
                  },
                )),
          ),
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
              itemCount: serviceList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(children: [
                    Image.network(
                      '${serviceList[index].serviceImage.toString()}',
                      height: 170.h,
                      width: 100.w,
                    ),
                    Text(
                      '${serviceList[index].serviceName.toString()}',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'ElMessiri',
                          fontWeight: FontWeight.w600),
                    ),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 90, height: 37.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor('#ffba26')),
                        onPressed: () async {
                          
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return CenterTechnical(
                              centerName: widget.centerName,
                              serviceName: '${serviceList[index].serviceName.toString()}',
                            );
                          }));
                          
                        },
                        child: Text('اضافة فنى'),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: () async {
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
                      },
                      child: Icon(Icons.delete,
                          color: Color.fromARGB(255, 122, 122, 122)),
                    )
                  ]),
                );
              },
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(3, index.isEven ? 3 : 3),
              mainAxisSpacing: 55.0,
              crossAxisSpacing: 5.0,
            ),
          ),
        ),
      ),
    );
  }
}
