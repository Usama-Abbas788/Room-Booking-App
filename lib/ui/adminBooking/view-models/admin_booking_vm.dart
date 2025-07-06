import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/UserRepository.dart';
import 'package:my_app/models/user.dart';

import '../../../data/BookingRepository.dart';
import '../../../models/booking.dart';


class AdminBookingViewModel extends GetxController {
  final BookingRepository bookingRepository = BookingRepository();
  final UserRepository userRepository=UserRepository();
  var allBookings = <Booking>[].obs;
  var isLoading = false.obs;
  var selectedBooking = Rxn<Booking>();
  var selectedUser = Rxn<NewUser>();
  int get bookingCount => allBookings.length;
  StreamSubscription<List<Booking>>? _bookingSubscription;
  StreamSubscription<Booking?>? _selectedBookingSubscription;


  // Add this function to get all bookings
  Future<void> getAllBookings() async {
    _bookingSubscription = bookingRepository.getAllBookings().listen((bookings) {
      allBookings.value = bookings;
    }, onError: (error) {
      print('Error listening to bookings stream: $error');
    });
  }


  Future<void> loadBookingAndUser(String bookingId) async {
    _selectedBookingSubscription?.cancel(); // Cancel previous subscription if any

    _selectedBookingSubscription = bookingRepository.getBookingById(bookingId).listen((booking) async {
      selectedBooking.value = booking;
      if (booking != null) {
        final user = await userRepository.getUser(booking.userId);
        selectedUser.value = user;
      }
    }, onError: (error) {
      Get.snackbar('Error', 'Failed to load ticket: $error');
    });
  }


  Future<void> markBookingAsConfirmed(String bookingId) async {
    try {
      await bookingRepository.updateBookingStatus(bookingId, 'Confirmed');
      // Optionally reload bookings after update
      await getAllBookings();
      await loadBookingAndUser(bookingId);
      Get.snackbar('Success', 'Booking marked as Completed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking status: $e');
    }
  }

  Future<void> markBookingAsCancelled(String bookingId) async {
    try {
      await bookingRepository.updateBookingStatus(bookingId, 'Cancelled');
      // Optionally reload bookings after update
      await getAllBookings();
      await loadBookingAndUser(bookingId);
      Get.snackbar('Success', 'Booking marked as Cancelled');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update booking status: $e');
    }
  }
  @override
  void onClose() {
    _bookingSubscription?.cancel();
    _selectedBookingSubscription?.cancel();
    super.onClose();
  }


}
