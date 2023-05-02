import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:road_emergency/screens/admin/add_center.dart';
import 'package:road_emergency/screens/models/center_model.dart';
import 'package:road_emergency/screens/user/user_service.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class UserCenters extends StatefulWidget {
  static const routeName = '/userCenters';
  const UserCenters({super.key});

  @override
  State<UserCenters> createState() => _UserCentersState();
}

class _UserCentersState extends State<UserCenters> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Centers> centerList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCenters();
  }

  @override
  void fetchCenters() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("centers");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Centers p = Centers.fromJson(event.snapshot.value);
      centerList.add(p);
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
            title: Text('المراكز'),
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
              itemCount: centerList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(children: [
                    Image.network('${centerList[index].imageUrl.toString()}', height:100.h),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        '${centerList[index].name.toString()}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                          'رقم السجل: ${centerList[index].recordNumber.toString()}'),
                    ),
                    SizedBox(
                      height: 9.h,
                    ),
                    FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                            'الهاتف: ${centerList[index].phoneNumber.toString()}')),
                    SizedBox(
                      height: 9.h,
                    ),
                    Container(
                        child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                                '${centerList[index].address.toString()}'))),
                    ConstrainedBox(
                      constraints:
                          BoxConstraints.tightFor(width: 90, height: 37.h),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor('#ffba26')),
                        onPressed: () async {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return UserService(
                              centerName:
                                  '${centerList[index].name.toString()}',
                            );
                          }));
                        },
                        child: Text('الخدمات'),
                      ),
                    ),
                  ]),
                );
              },
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(3, index.isEven ? 5 : 5),
              mainAxisSpacing: 10.0.h,
              crossAxisSpacing: 5.0.w,
            ),
          ),
        ),
      ),
    );
  }
}
