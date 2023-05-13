import 'package:flutter/cupertino.dart';

class Complains {
  Complains({
    String? id,
    String? userUid,
    String? description,
    String? centerName,
    String? userName,
    String? userPhone,
    int? date,
  }) {
    _id = id;
    _userUid = userUid;
    _description = description;
    _centerName = centerName;
    _userName = userName;
    _userPhone = userPhone;
    _date = date;
  }

  Complains.fromJson(dynamic json) {
    _id = json['id'];
    _userUid = json['userUid'];
    _description = json['description'];
    _centerName = json['centerName'];
    _userName = json['userName'];
    _userPhone = json['userPhone'];
    _date = json['date'];
  }

  String? _id;
  String? _userUid;
  String? _description;
  String? _centerName;
  String? _userName;
  String? _userPhone;
  int? _date;

  String? get id => _id;
  String? get userUid => _userUid;
  String? get description => _description;
  String? get centerName => _centerName;
  String? get userName => _userName;
  String? get userPhone => _userPhone;
  int? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userUid'] = _userUid;
    map['description'] = _description;
    map['date'] = _date;

    return map;
  }
}