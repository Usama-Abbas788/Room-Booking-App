import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/BookingRepository.dart';
import '../../../models/booking.dart';
import '../../../models/items.dart';
import '../../profile/view_models/profile_vm.dart';

class CustomerBookingViewModel extends GetxController {
  BookingRepository bookingRepository = Get.find();
  var isSaving = false.obs;
  var isDeleting = false.obs;
  var bookings = <Booking>[].obs;
  var isDownloading = false.obs;
  int get bookingCount => bookings.length;
  Rx<DateTime?> checkInDate = Rx<DateTime?>(null);
  Rx<DateTime?> checkOutDate = Rx<DateTime?>(null);
  RxInt guestCount = 1.obs;
  Rx<Booking?> selectedBooking = Rx<Booking?>(null);
  Rx<String> bookingStatus = 'Pending'.obs;
  StreamSubscription<List<Booking>>? _bookingStreamSubscription;
  StreamSubscription<Booking?>? _singleBookingSubscription;



  Future<void> saveBooking(
    Items item,
    DateTime checkInDate,
    DateTime checkOutDate,
    int numberOfGuests,
    int grandTotal,
    String bookingStatus,
  ) async {
    try {
      isSaving.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not logged in');
        isSaving.value = false;
        return;
      }
      final booking = Booking(
        "",
        user.uid,
        item.name,
        item.location,
        item.price.toDouble(),
        item.image,
        checkInDate,
        checkOutDate,
        guestCount.value,
        grandTotal.toInt(),
        bookingStatus,
      );
      final availabilityResult = await bookingRepository.checkRoomAvailability(
        roomName: item.name,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
      );

      if (!availabilityResult['isAvailable']) {
        Get.snackbar('Room Unavailable', 'Selected dates already booked.');
        return;
      }
      final docId = await bookingRepository.saveBooking(booking);
      getBookingsByUserId(user.uid);
      Get.snackbar(
        'Booking Registered',
        'Your room has been registered. Please confirm your payment to approve the customerBooking.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      resetForm();
      Get.offAndToNamed('/booking_ticket_page', arguments: docId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save Booking: $e');
      print(e);
    } finally {
      isSaving.value = false;
    }
  }
  Future<void> getBookingById(String docId) async {
    _singleBookingSubscription?.cancel(); // cancel previous if any
    _singleBookingSubscription = bookingRepository.getBookingById(docId).listen((booking) {
      if (booking != null) {
        selectedBooking.value = booking;
      } else {
        Get.snackbar('Not Found', 'Booking not found');
      }
    }, onError: (e) {
      Get.snackbar('Error', 'Failed to fetch booking: $e');
    });
  }

  Future<void> getBookingsByUserId(String userId) async {
    _bookingStreamSubscription?.cancel(); // Avoid duplicate listeners
    _bookingStreamSubscription = bookingRepository
        .getBookingsByUserId(userId)
        .listen((bookingList) {
      bookings.value = bookingList;
    }, onError: (error) {
      Get.snackbar('Error', 'Failed to listen to bookings: $error');
    });
  }



  Future<void> deleteBooking(Booking booking) async {
    try {
      isDeleting.value = true;
      Get.back();
      await bookingRepository.deleteBooking(booking);
      bookings.removeWhere((b) => b.docId == booking.docId);
      Get.snackbar('Success', 'Booking removed successfully');
    } catch (e) {
      Get.back(); // Close any open dialogs first
      Get.snackbar('Error', 'Failed to remove Booking: $e');
      throw e; // Re-throw to handle in the UI
    } finally {
      isDeleting.value = false;
    }
  }

  Future<Map<String, dynamic>> checkRoomAvailability(
      String roomName,
      DateTime checkIn,
      DateTime checkOut,
      ) async {
    return await bookingRepository.checkRoomAvailability(
      roomName: roomName,
      checkInDate: checkIn,
      checkOutDate: checkOut,
    );
  }

  void setCheckInDate(DateTime date) {
    checkInDate.value = date;

    if (checkOutDate.value != null &&
        !bookingRepository.isCheckOutAfterCheckIn(
          checkInDate.value,
          checkOutDate.value,
        )) {
      checkOutDate.value = null;
    }
  }

  void setCheckOutDate(DateTime date) {
    if (bookingRepository.isCheckOutAfterCheckIn(checkInDate.value, date)) {
      checkOutDate.value = date;
    }
  }

  void increaseGuest() {
    guestCount++;
  }

  void decreaseGuest() {
    if (guestCount > 1) {
      guestCount--;
    }
  }

  bool isFormValid() {
    return checkInDate.value != null &&
        checkOutDate.value != null &&
        bookingRepository.isCheckOutAfterCheckIn(
          checkInDate.value,
          checkOutDate.value,
        ) &&
        guestCount.value > 0;
  }

  double calculateTotal(Items item) {
    if (checkInDate.value == null || checkOutDate.value == null) {
      return 0.0;
    }
    final nights = checkOutDate.value!.difference(checkInDate.value!).inDays;
    if (nights <= 0) return 0.0;

    final basePricePerNight = item.price.toDouble();
    final extraGuests = guestCount.value - item.guests;

    double nightlyRate = basePricePerNight;

    if (extraGuests > 0) {
      final extraChargePerNight = basePricePerNight * 0.25 * extraGuests;
      nightlyRate += extraChargePerNight;
    }

    return nightlyRate * nights;
  }

  void resetForm() {
    checkInDate.value = null;
    checkOutDate.value = null;
    guestCount.value = 1;
  }
  @override
  void onClose() {
    _bookingStreamSubscription?.cancel();
    _singleBookingSubscription?.cancel();
    super.onClose();
  }

  Future<void> downloadBookingTicketPdf() async {
    final booking = selectedBooking.value;
    final user = Get.find<ProfileViewModel>().currentUser.value;

    if (booking == null || user == null) {
      Get.snackbar("Error", "Missing booking or user data.");
      return;
    }
    isDownloading.value = true;
    try {
      if (await Permission.storage.request().isDenied) {
        Get.snackbar("Permission Denied", "Storage permission is required.");
        return;
      }

      final pdf = pw.Document();
      final themeColor = PdfColors.deepOrange;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Padding(
              padding: pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header
                  pw.Container(
                    width: double.infinity,
                    padding: pw.EdgeInsets.symmetric(vertical: 16),
                    color: themeColor,
                    child: pw.Center(
                      child: pw.Text(
                        "Hostel Room Booking Ticket",
                        style: pw.TextStyle(
                          fontSize: 22,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),

                  // Guest Details
                  pw.Text("Guest Details", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: themeColor)),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    padding: pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey600),
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Name: ${user.firstName} ${user.lastName}"),
                        pw.Text("Email: ${user.email}"),
                        pw.Text("Phone: ${user.phoneNumber}"),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20),

                  // Booking Info
                  pw.Text("Booking Details", style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: themeColor)),
                  pw.SizedBox(height: 10),
                  pw.Container(
                    padding: pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey600),
                      borderRadius: pw.BorderRadius.circular(6),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Room: ${booking.roomName}"),
                        pw.Text("Location: ${booking.roomLocation}"),
                        pw.Text("Price per Night: Rs. ${booking.roomPrice.toInt()}"),
                        pw.Text("Check-in: ${DateFormat('d MMM yyyy').format(booking.checkInDate!)}"),
                        pw.Text("Check-out: ${DateFormat('d MMM yyyy').format(booking.checkOutDate!)}"),
                        pw.Text("Guests: ${booking.numberOfGuests}"),
                        pw.Text("Grand Total: Rs. ${booking.grandTotal}"),
                        pw.Row(
                          children: [
                            pw.Text("Status: "),
                            pw.Text(
                              "${booking.bookingStatus}",
                              style: pw.TextStyle(
                                color: booking.bookingStatus.toLowerCase() == 'confirmed'
                                    ? PdfColors.green
                                    : PdfColors.red,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 30),
                  pw.Divider(color: PdfColors.grey),
                  pw.Center(
                    child: pw.Text(
                      "Thank you for booking with us!",
                      style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      final dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final file = File('${dir.path}/BookingTicket-${DateTime.now().millisecondsSinceEpoch}.pdf');
      await file.writeAsBytes(await pdf.save());


      await OpenFile.open(file.path);
      Get.snackbar("Success", "Ticket downloaded.");
    } catch (e) {
      Get.snackbar("Error", "Failed to generate PDF: $e");
    } finally {
      isDownloading.value = false;
    }
  }
}
