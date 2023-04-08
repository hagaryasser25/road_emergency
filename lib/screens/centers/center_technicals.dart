import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Align(
                alignment: Alignment.topRight,
                child: TextButton.icon(
                  // Your icon here
                  label: Text(
                    'أضافة فنى',
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
                      return AddTechnical(
                        centerName: '${widget.centerName}',
                        serviceName: '${widget.serviceName}',
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
              itemCount: technicalList.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 10.h,
                      ),
                      child: CircleAvatar(
                        radius: 37,
                        backgroundImage: NetworkImage(
                            '${technicalList[index].imageUrl.toString()}'),
                      ),
                    ),
                    Text(
                      '${technicalList[index].name.toString()}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Text('${technicalList[index].phoneNumber.toString()}'),
                    SizedBox(
                      height: 5.h,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(
                        right: 10.w,
                        left: 10.w
                      ),
                      child: Text('${technicalList[index].exp.toString()}'),
                    ),
                    SizedBox(
                      height: 5.h,
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
                            .child('craftsMen')
                            .child('${widget.centerName}').
                            child('${widget.serviceName}')
                            .child('${technicalList[index].id}')
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
              mainAxisSpacing: 40.0,
              crossAxisSpacing: 5.0,
            ),
          ),
        ),
      ),
    );
  }
}
