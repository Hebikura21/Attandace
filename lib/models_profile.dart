class Profile {
  final String name;
  final String grade;
  final String gender;
  final String religion;
  final String nis;
  final String nisn;
  final String birthPlace;
  final String email;
  final String birthDate;
  final String address;
  String? image;

  Profile({
    required this.name,
    required this.grade,
    required this.gender,
    required this.religion,
    required this.nis,
    required this.nisn,
    required this.birthPlace,
    required this.email,
    required this.birthDate,
    required this.address,
     this.image,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      grade: json['grade'] ?? '',
      gender: json['gender'] ?? '',
      religion: json['religion'] ?? '',
      nis: json['nis'] ?? '',
      nisn: json['nisn'] ?? '',
      birthPlace: json['birth_place'] ?? '',
      email: json['email'] ?? '',
      birthDate: json['birth_date'] ?? '',
      address: json['address'] ?? '',
      image: json['image'],
    );
  }
}
