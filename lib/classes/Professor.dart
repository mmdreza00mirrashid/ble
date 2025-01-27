class Professor {
  String id;
  String surname;
  String name;
  String profId;
  String faculty;
  String? roomNumber;
  String phoneNum;
  String? password;

  Professor({
    required this.id,
    required this.surname,
    required this.name,
    required this.profId,
    required this.faculty,
    this.roomNumber,
    required this.phoneNum,
     this.password,
  });

  // Factory constructor to parse JSON into a Professor object
  factory Professor.fromJson(Map<String, dynamic> json) {
    return Professor(
      id: json['id'].toString(),
      surname: json['surname'],
      name: json['name'],
      profId: json['prof_id'],
      faculty: json['faculty'],
      roomNumber: json['room_number'],
      phoneNum: json['phone_num'],
    );
  }

  // Convert the Professor object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'surname': surname,
      'name': name,
      'prof_id': profId,
      'faculty': faculty,
      'room_number': roomNumber,
      'phone_num': phoneNum,
    };
  }

  // Factory constructor to create a Professor object from a Map
  factory Professor.fromRow(Map<String, dynamic> map) {
    return Professor(
      id: map['id'],
      surname: map['surname'],
      name: map['name'],
      profId: map['prof_id'],
      faculty: map['faculty'],
      roomNumber: map['room_number'],
      phoneNum: map['phone_num'],
    );
  }
}
