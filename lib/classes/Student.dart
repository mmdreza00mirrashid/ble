class Student {
  String id;
  String name;
  DateTime? birthDate;
  String? surname;
  String educationalStage;
  String major;
  String gender;
  String? password;

  Student({
    required this.id,
    required this.name,
    this.birthDate,
    this.surname,
    required this.educationalStage,
    required this.major,
    required this.gender,
    this.password,
  });

  // Factory constructor to parse JSON into a Student object
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'].toString(),
      name: json['name'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      surname: json['surname'],
      educationalStage: json['educational_stage'],
      major: json['major'],
      gender: json['gender'],
    );
  }

  // Convert the Student object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birth_date': birthDate?.toIso8601String(),
      'surname': surname,
      'educational_stage': educationalStage,
      'major': major,
      'gender': gender,
    };
  }

  // Factory constructor to create a Student object from a Map
  factory Student.fromRow(Map<String, dynamic> map) {
    return Student(
      id: map['id'],
      name: map['name'],
      birthDate: map['birth_date'] != null
          ? DateTime.parse(map['birth_date'])
          : null,
      surname: map['surname'],
      educationalStage: map['educational_stage'],
      major: map['major'],
      gender: map['gender'],
    );
  }
}
