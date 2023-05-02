class Exp {
  Exp({
      String? opinion, 
      String? name,
      String? id,
      

  }){
    _opinion = opinion;
    _name = name;
    _id = id;
   

  }

  Exp.fromJson(dynamic json) {
    _opinion = json['opinion'];
    _name = json['name'];
    _id = json['id'];

  }
  String? _opinion;
  String? _name;
  String? _id;



  String? get opinion => _opinion;
  String? get name => _name;
  String? get id => _id;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['opinion'] = _opinion;
    map['name'] = _name;
    map['id'] = _id;
   
    return map;
  }

}