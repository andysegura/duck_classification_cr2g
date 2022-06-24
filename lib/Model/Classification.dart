class Classification {
  late int id;
  late String picture_name;
  late int picture_classification;
  Classification(this.id, this.picture_name, this.picture_classification);
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'picture_name': picture_name,
      'picture_class': picture_classification
    };
    return map;
  }
  Classification.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    picture_name = map['picture_name'];
    picture_classification = int.parse(map['picture_class']);
  }
}

