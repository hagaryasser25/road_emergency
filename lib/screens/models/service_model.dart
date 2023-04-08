import 'package:flutter/cupertino.dart';

class Service {
  Service({
    String? id,
    String? serviceName,
    String? serviceImage,
    String? centerName,
  }) {
    _id = id;
    _serviceName = serviceName;
    _serviceImage = serviceImage;
    _centerName = centerName;
  }

  Service.fromJson(dynamic json) {
    _id = json['id'];
    _serviceName = json['serviceName'];
    _serviceImage = json['serviceImage'];
    _centerName = json['centerName'];
  }

  String? _id;
  String? _serviceName;
  String? _serviceImage;
  String? _centerName;

  String? get id => _id;
  String? get serviceName => _serviceName;
  String? get serviceImage => _serviceImage;
  String? get centerName => _centerName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['serviceName'] = _serviceName;
    map['serviceImage'] = _serviceImage;
    map['centerName'] = _centerName;


    return map;
  }
}