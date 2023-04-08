import 'package:flutter/cupertino.dart';

class Technical {
  Technical({
    String? id,
    String? name,
    String? phoneNumber,
    String? imageUrl,
    String? exp,
  }) {
    _id = id;
    _name = name;
    _phoneNumber = phoneNumber;
    _imageUrl = imageUrl;
    _exp = exp;
  }

  Technical.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _phoneNumber = json['phoneNumber'];
    _imageUrl = json['imageUrl'];
    _exp = json['exp'];
  }

  String? _id;
  String? _name;
  String? _phoneNumber;
  String? _imageUrl;
  String? _exp;

  String? get id => _id;
  String? get name => _name;
  String? get phoneNumber => _phoneNumber;
  String? get imageUrl => _imageUrl;
  String? get exp => _exp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['phoneNumber'] = _phoneNumber;
    map['imageUrl'] = _imageUrl;
    map['exp'] = _exp;


    return map;
  }
}