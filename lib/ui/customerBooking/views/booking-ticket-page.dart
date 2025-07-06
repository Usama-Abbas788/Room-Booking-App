import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../data/AuthRepository.dart';
import '../../../data/BookingRepository.dart';
import '../../../data/UserRepository.dart';
import '../../profile/view_models/profile_vm.dart';
import '../view_models/customerBooking_vm.dart';

class BookingTicketPage extends StatefulWidget {
  BookingTicketPage({super.key});

  @override
  State<BookingTicketPage> createState() => _BookingTicketPageState();
}

class _BookingTicketPageState extends State<BookingTicketPage> {
  final profileViewModel = Get.find<ProfileViewModel>();
  late final CustomerBookingViewModel customerBookingViewModel;

  @override
  void initState() {
    super.initState();
    customerBookingViewModel = Get.find();
    final docId = Get.arguments;
    customerBookingViewModel.getBookingById(docId);
    final userId = Get.find<AuthRepository>().getLoggedInUser()?.uid;
    if (userId != null) {
      profileViewModel.getUser(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        final user = profileViewModel.currentUser.value;
        final booking = customerBookingViewModel.selectedBooking.value;
        if (customerBookingViewModel.isSaving.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (booking == null || user == null) {
          return Center(child: Text("Loading ticket..."));
        } else {
          return Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: Column(
              children: [
                SizedBox(height: 30,),
                Container(
                  margin: EdgeInsets.only(top: 17),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: Colors.black54),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${user.firstName} ${user.lastName}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${user.email}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Phone',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${user.phoneNumber}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Check In',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${DateFormat('d MMM').format(booking.checkInDate!)}',
                                        ),
                                        Icon(Icons.calendar_month_outlined),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 12.0,
                                right: 12,
                                top: 27,
                              ),
                              child: Icon(Icons.arrow_forward_sharp, size: 19),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Check Out',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${DateFormat('d MMM').format(booking.checkOutDate!)}',
                                        ),
                                        Icon(Icons.calendar_month_outlined),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Guest',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${booking.numberOfGuests}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${booking.grandTotal}'),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Booking status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('${booking.bookingStatus}',style: TextStyle(color: booking.bookingStatus == 'Confirmed' ? Colors.green : Colors.red,fontWeight: FontWeight.bold),),
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                    ],
                  ),
                ),
                SizedBox(height: 70),
                Obx(() {
                  return customerBookingViewModel.isDownloading.value
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: () => customerBookingViewModel.downloadBookingTicketPdf(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.green,
                    ),
                    child: Text('Download ticket', style: TextStyle(color: Colors.white)),
                  );
                }),
              ],
            ),
          );
        }
      }),
    );
  }
}

class BookingTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(UserRepository());
    Get.put(BookingRepository());
    Get.put(ProfileViewModel());
    Get.put(CustomerBookingViewModel());
  }
}
