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
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class AdminCenters extends StatefulWidget {
  static const routeName = '/adminCenters';
  const AdminCenters({super.key});

  @override
  State<AdminCenters> createState() => _AdminCentersState();
}

class _AdminCentersState extends State<AdminCenters> {
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
                                    context, AddCenters.routeName);
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
                      'المراكز',
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
                      itemCount: centerList.length,
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
                                      color: HexColor('#eaf1f7'),
                                      child: Column(
                                        children: [
                                          Image.network(
                                            '${centerList[index].imageUrl}',
                                            height: 100.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              '${centerList[index].name.toString()}',
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
                                                  '${centerList[index].email.toString()}')),
                                          SizedBox(
                                            height: 9.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                                'كلمة المرور: ${centerList[index].password.toString()}'),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                                'رقم السجل: ${centerList[index].recordNumber.toString()}'),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          FittedBox(
                                              fit: BoxFit.fitWidth,
                                              child: Text(
                                                  'الهاتف: ${centerList[index].phoneNumber.toString()}')),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                          Container(
                                              child: Text(
                                                  '${centerList[index].address.toString()}')),
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
                                                  .child('centers')
                                                  .child(
                                                      '${centerList[index].id}')
                                                  .remove();
                                            },
                                            child: Icon(Icons.delete,
                                                color: Color.fromARGB(
                                                    255, 122, 122, 122)),
                                          )
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
              /*
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
                    itemCount: centerList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Column(children: [
                          CircleAvatar(
                            radius: 37,
                            backgroundImage: NetworkImage(
                                '${centerList[index].imageUrl.toString()}'),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              '${centerList[index].name.toString()}',
                              style:
                                  TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text('${centerList[index].email.toString()}')),
                          SizedBox(
                            height: 9.h,
                          ),
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                                'كلمة المرور: ${centerList[index].password.toString()}'),
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
                              child: Text('${centerList[index].address.toString()}')),
                          InkWell(
                            onTap: () async {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          super.widget));
                              FirebaseDatabase.instance
                                  .reference()
                                  .child('centers')
                                  .child('${centerList[index].id}')
                                  .remove();
                            },
                            child: Icon(Icons.delete,
                                color: Color.fromARGB(255, 122, 122, 122)),
                          )
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
              */
            ],
          ),
        ),
      ),
    );
  }
}
