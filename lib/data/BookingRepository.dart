import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/booking.dart';

class BookingRepository {
  late CollectionReference bookingsCollection;

  BookingRepository() {
    bookingsCollection = FirebaseFirestore.instance.collection('bookings');
  }

  Future<String> saveBooking(Booking booking) async {
    var doc = bookingsCollection.doc();
    booking.docId = doc.id;
    await doc.set(booking.toMap());
    return doc.id;
  }

  Stream<List<Booking>> getBookingsByUserId(String userId) {
    return bookingsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final bookingData = doc.data() as Map<String, dynamic>;
        bookingData['docId'] = doc.id;
        return Booking.fromMap(bookingData);
      }).toList();
    });
  }


  Stream<Booking?> getBookingById(String docId) {
    return bookingsCollection.doc(docId).snapshots().map((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        data['docId'] = docSnapshot.id;
        return Booking.fromMap(data);
      }
      return null;
    });
  }


  Stream<List<Booking>> getAllBookings() {
    return bookingsCollection.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        final bookingData = doc.data() as Map<String, dynamic>;
        bookingData['docId'] = doc.id;
        return Booking.fromMap(bookingData);
      }).toList();
    });
  }


  Future<void> updateBookingStatus(String docId, String newStatus) async {
    try {
      await bookingsCollection.doc(docId).update({'bookingStatus': newStatus});
    } catch (e) {
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  Future<void> deleteBooking(Booking booking) async {
    await bookingsCollection.doc(booking.docId).delete();
  }

  Future<Map<String, dynamic>> checkRoomAvailability({
    required String roomName,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    try {
      final normalizedCheckIn = DateTime(checkInDate.year, checkInDate.month, checkInDate.day);
      final normalizedCheckOut = DateTime(checkOutDate.year, checkOutDate.month, checkOutDate.day);

      final snapshot = await bookingsCollection
          .where('roomName', isEqualTo: roomName)
          .where('bookingStatus', whereIn: ['Pending', 'Confirmed'])
          .get();

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        DateTime existingCheckIn;
        DateTime existingCheckOut;

        if (data['checkInDate'] is Timestamp) {
          existingCheckIn = (data['checkInDate'] as Timestamp).toDate();
        } else {
          existingCheckIn = DateTime.parse(data['checkInDate'] as String);
        }

        if (data['checkOutDate'] is Timestamp) {
          existingCheckOut = (data['checkOutDate'] as Timestamp).toDate();
        } else {
          existingCheckOut = DateTime.parse(data['checkOutDate'] as String);
        }

        final normalizedExistingCheckIn = DateTime(
            existingCheckIn.year, existingCheckIn.month, existingCheckIn.day);
        final normalizedExistingCheckOut = DateTime(
            existingCheckOut.year, existingCheckOut.month, existingCheckOut.day);

        if (normalizedCheckIn.isBefore(normalizedExistingCheckOut) &&
            normalizedCheckOut.isAfter(normalizedExistingCheckIn)) {
          return {
            'isAvailable': false,
            'conflictingDates': {
              'checkIn': existingCheckIn,
              'checkOut': existingCheckOut,
            }
          };
        }
      }
      return {'isAvailable': true};
    } catch (e) {
      print('Error checking availability: $e');
      return {'isAvailable': false};
    }
  }

  bool isCheckOutAfterCheckIn(DateTime? checkIn, DateTime? checkOut) {
    if (checkIn == null || checkOut == null) return false;
    return checkOut.isAfter(checkIn);
  }

  bool isDateValid(DateTime? date) {
    return date != null &&
        date.isAfter(DateTime.now().subtract(Duration(days: 1)));
  }
}
