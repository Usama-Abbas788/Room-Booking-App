import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/BookingRepository.dart';
import '../../../models/booking.dart';
import '../view_models/customerBooking_vm.dart';
class BookingListPage extends StatefulWidget {
  BookingListPage();

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  final CustomerBookingViewModel bookingViewModel = Get.find<CustomerBookingViewModel>();
  final Set<String> _shownSnackbars = {};
  @override
  void initState() {
    super.initState();

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      bookingViewModel.getBookingsByUserId(userId);
      ever(bookingViewModel.bookings, (List<Booking> newBookings) {
        for (var booking in newBookings) {
          if (_shownSnackbars.contains(booking.docId)) continue;

          final status = booking.bookingStatus.toLowerCase();
          if (status == 'confirmed') {
            _shownSnackbars.add(booking.docId);
            Get.snackbar(
              'Booking Approved',
              'Your booking for ${booking.roomName} has been confirmed!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.shade100,
              colorText: Colors.black,
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(10),
            );
          } else if (status == 'cancelled') {
            _shownSnackbars.add(booking.docId);
            Get.snackbar(
              'Booking Cancelled',
              'Your booking for ${booking.roomName} has been cancelled by the admin. You can remove it from list.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade100,
              colorText: Colors.black,
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(10),
            );
          }
        }
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Bookings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        if (bookingViewModel.isSaving.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (bookingViewModel.bookings.isEmpty) {
          return Center(child: Text("No bookings found."));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          child: ListView.builder(
            itemCount: bookingViewModel.bookings.length,
            itemBuilder: (context, index) {
              final booking = bookingViewModel.bookings[index];
              return Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 23),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: Colors.black54),
                      color: booking.bookingStatus.toLowerCase() == 'confirmed'
                          ? Colors.green.withOpacity(.3)
                          : Colors.red.withOpacity(.3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              height: 100,
                              width: 150,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(17),
                                color: Colors.blue,
                              ),
                              child: Image.asset(
                                booking.roomImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      booking.roomName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      booking.roomLocation,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Rs. ${(booking.roomPrice.toString())}/Night',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      'Status: ${booking.bookingStatus}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8,),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              onPressed: () {
                                Get.dialog(
                                  AlertDialog(
                                    title: Text('Confirm Remove!'),
                                    content: Text('Are you sure you want to remove this booking?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          try {
                                            await bookingViewModel.deleteBooking(booking);
                                          } catch (e) {
                                            //
                                          }
                                        },
                                        child: Text(
                                          'Yes',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                  barrierDismissible: false,
                                );
                              },
                              child: Text(
                                'Remove',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Get.toNamed('/booking_ticket_page', arguments: booking.docId);
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Colors.black87,
                              ),
                              child: Text(
                                'View Booking',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },),
    );
  }
}
class BookingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BookingRepository());
    Get.lazyPut(() => CustomerBookingViewModel());
  }
}

