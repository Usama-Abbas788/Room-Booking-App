import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/MediaRepository.dart';
import '../../../data/BookingRepository.dart';
import '../../customerBooking/view_models/customerBooking_vm.dart';
import '../view-models/admin_booking_vm.dart';
class AdminBookingListPage extends StatefulWidget {

  @override
  State<AdminBookingListPage> createState() => _AdminBookingListPageState();
}

class _AdminBookingListPageState extends State<AdminBookingListPage> {
  final AdminBookingViewModel adminBookingViewModel = Get.find<AdminBookingViewModel>();
  final CustomerBookingViewModel customerBookingViewModel = Get.find<CustomerBookingViewModel>();
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      adminBookingViewModel.getAllBookings();
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
        if (adminBookingViewModel.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (adminBookingViewModel.allBookings.isEmpty) {
          return Center(child: Text("No bookings found."));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 10,
          ),
          child: ListView.builder(
            itemCount: adminBookingViewModel.allBookings.length,
            itemBuilder: (context, index) {
              final booking = adminBookingViewModel.allBookings[index];
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
                                    SizedBox(height: 5),
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
                                    title: Text('Confirm Delete!'),
                                    content: Text('Are you sure you want to delete this booking?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: Text('No'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // Show loading indicator
                                          try {
                                            await customerBookingViewModel.deleteBooking(booking);
                                            await adminBookingViewModel.getAllBookings();
                                          } catch (e) {
                                            // Error handling is done in the view model
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
                                'Delete',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                Get.toNamed('/admin_booking_ticket_page', arguments: booking.docId);
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
class AdminBookingListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BookingRepository());
    Get.put(MediaRepository());
    Get.put(AdminBookingViewModel());
    Get.put(CustomerBookingViewModel());
  }
}

