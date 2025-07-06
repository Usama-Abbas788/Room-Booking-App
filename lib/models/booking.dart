class Booking{
  String docId;
  String userId;
  String roomName;
  String roomLocation;
  double roomPrice;
  String roomImage;
  DateTime checkInDate;
  DateTime checkOutDate;
  int numberOfGuests;
  int grandTotal;
  String bookingStatus='Pending';

  Booking(this.docId, this.userId, this.roomName, this.roomLocation,
      this.roomPrice, this.roomImage, this.checkInDate, this.checkOutDate,
      this.numberOfGuests, this.grandTotal,this.bookingStatus);

  Map<String, dynamic> toMap() {
    return {
      "docId":docId,
      "userId": userId,
      "roomName": roomName,
      "roomLocation": roomLocation,
      "roomPrice": roomPrice,
      "roomImage": roomImage,
      "checkInDate": checkInDate.toIso8601String(),
      "checkOutDate": checkOutDate.toIso8601String(),
      "numberOfGuests": numberOfGuests,
      "grandTotal": grandTotal,
      "bookingStatus": bookingStatus
    };
  }
  static Booking fromMap(Map<String, dynamic> map) {
    return Booking(
      map['docId'],
      map['userId'],
      map['roomName'] ?? '',
      map['roomLocation'] ?? '',
      double.tryParse(map['roomPrice']?.toString() ?? '0') ?? 0.0,
      map['roomImage'] ?? '',
      DateTime.parse(map['checkInDate']),
      DateTime.parse(map['checkOutDate']),
      (map['numberOfGuests'] as num?)?.toInt() ?? 1,
      (map['grandTotal'] as num?)?.toInt() ?? 0,
      map['bookingStatus'] ?? '',
    );
  }
}