class Favorites{
  String docId;
  String userId;
  String roomName;
  String roomLocation;
  double roomPrice;
  String roomImage;

  Favorites(this.docId, this.userId, this.roomName, this.roomLocation,
      this.roomPrice, this.roomImage,);

  Map<String, dynamic> toMap() {
    return {
      "docId":docId,
      "userId": userId,
      "roomName": roomName,
      "roomLocation": roomLocation,
      "roomPrice": roomPrice,
      "roomImage": roomImage,
    };
  }
  static Favorites fromMap(Map<String, dynamic> map) {
    return Favorites(
      map['docId'],
      map['userId'],
      map['roomName'] ?? '',
      map['roomLocation'] ?? '',
      double.tryParse(map['roomPrice']?.toString() ?? '0') ?? 0.0,
      map['roomImage'] ?? '',
    );
  }
}