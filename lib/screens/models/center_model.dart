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
    String? imageUrl,
    String? recordNumber,
  }) {
    _id = id;
    _address = address;
    _email = email;
    _name = name;
    _password = password;
    _phoneNumber = phoneNumber;
    _uid = uid;
    _imageUrl = imageUrl;
    _recordNumber = recordNumber;
  }

  Centers.fromJson(dynamic json) {
    _id = json['id'];
    _address = json['address'];
    _email = json['email'];
    _name = json['name'];
    _password = json['password'];
    _phoneNumber = json['phoneNumber'];
    _uid = json['uid'];
    _imageUrl = json['imageUrl'];
    _recordNumber = json['recordNumber'];
  }

  String? _id;
  String? _address;
  String? _email;
  String? _name;
  String? _password;
  String? _phoneNumber;
  String? _uid;
  String? _imageUrl;
  String? _recordNumber;

  String? get id => _id;
  String? get address => _address;
  String? get email => _email;
  String? get name => _name;
  String? get password => _password;
  String? get phoneNumber => _phoneNumber;
  String? get uid => _uid;
  String? get imageUrl => _imageUrl;
  String? get recordNumber => _recordNumber;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['address'] = _address;
    map['email'] = _email;
    map['name'] = _name;
    map['password'] = _password;
    map['phoneNumber'] = _phoneNumber;
    map['uid'] = _uid;
    map['imageUrl'] = _imageUrl;
    map['recordNumber'] = _recordNumber;

    return map;
  }
}
