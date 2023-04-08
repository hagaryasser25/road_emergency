import 'package:flutter/cupertino.dart';

class Centers {
  Centers({
    String? id,
    String? address,
    String? email,
    String? name,
    String? password,
    String? phoneNumber,
    String? uid,
  }) {
    _id = id;
    _address = address;
    _email = email;
    _name = name;
    _password = password;
    _phoneNumber = phoneNumber;
    _uid = uid;
  }

  Centers.fromJson(dynamic json) {
    _id = json['id'];
    _address = json['address'];
    _email = json['email'];
    _name = json['name'];
    _password = json['password'];
    _phoneNumber = json['phoneNumber'];
    _uid = json['uid'];
  }

  String? _id;
  String? _address;
  String? _email;
  String? _name;
  String? _password;
  String? _phoneNumber;
  String? _uid;

  String? get id => _id;
  String? get address => _address;
  String? get email => _email;
  String? get name => _name;
  String? get password => _password;
  String? get phoneNumber => _phoneNumber;
  String? get uid => _uid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['address'] = _address;
    map['email'] = _email;
    map['name'] = _name;
    map['password'] = _password;
    map['phoneNumber'] = _phoneNumber;
    map['uid'] = _uid;

    return map;
  }
}