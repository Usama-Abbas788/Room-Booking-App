class NewUser {
  String docId;
  String userId;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String? image;

  NewUser(
    this.docId,
    this.userId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
  );

  Map<String, dynamic> toMap() {
    return {
      "docId":docId,
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phoneNumber": phoneNumber,
      "image": image,
    };
  }

  static NewUser fromMap(Map<String, dynamic> map) {
    NewUser u = NewUser(
      map['docId'],
      map['userId'],
      map['firstName'] ?? '',
      map['lastName'] ?? '',
      map['email'] ?? '',
      map['phoneNumber'] ?? '',
    );
    u.image=map['image'];
    return u;
  }
}
