import 'package:flutter/cupertino.dart';

class Requests {
  Requests({
    String? id,
    String? date,
    String? description,
    String? serviceName,
    String? technicalName,
    String? userName,
    String? userPhone,
    String? address,
  }) {
    _id = id;
    _date = date;
    _description = description;
    _serviceName = serviceName;
    _technicalName = technicalName;
    _userName = userName;
    _userPhone = userPhone;
    _address = address;
  }

  Requests.fromJson(dynamic json) {
    _id = json['id'];
    _date = json['date'];
    _serviceName = json['serviceName'];
    _description = json['description'];
    _technicalName = json['technicalName'];
    _userName = json['userName'];
    _userPhone = json['userPhone'];
    _address = json['address'];
  }

  String? _id;
  String? _date;
  String? _serviceName;
  String? _description;
  String? _technicalName;
  String? _userName;
  String? _userPhone;
  String? _address;

  String? get id => _id;
  String? get date => _date;
  String? get serviceName => _serviceName;
  String? get description => _description;
  String? get technicalName => _technicalName;
  String? get userName => _userName;
  String? get userPhone => _userPhone;
  String? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['date'] = _date;
    map['serviceName'] = _serviceName;
    map['description'] = _description;
    map['technicalName'] = _technicalName;
    map['userName'] = _userName;
    map['userPhone'] = _userPhone;
    map['address'] = _address;

    return map;
  }
}