import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data/BookingRepository.dart';
import 'package:my_app/models/user.dart';
import '../../../data/AuthRepository.dart';
import '../../../data/UserRepository.dart';
import '../../../models/items.dart';
import '../../profile/view_models/profile_vm.dart';
import '../view_models/customerBooking_vm.dart';

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({super.key});

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  final profileViewModel = Get.find<ProfileViewModel>();
  late final CustomerBookingViewModel bookingViewModel;
  late DateTime checkInDate;
  late DateTime checkOutDate;
  late int guestCount;
  late Items item; // Replace with your Item model
  late NewUser user; // Replace with your User model
  late int grandTotal;
  late String bookingStatus;

  @override
  void initState() {
    super.initState();
    bookingViewModel = Get.find<CustomerBookingViewModel>();
    final arguments = Get.arguments as Map<String, dynamic>;

    checkInDate = arguments['checkInDate'];
    checkOutDate = arguments['checkOutDate'];
    guestCount = arguments['guestCount'];
    item = arguments['item'];
    user = arguments['user'];
    grandTotal = arguments['grandTotal'];
    bookingStatus = arguments['bookingStatus'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Booking Summary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18),
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.black54),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 17,
                  bottom: 17,
                  right: 27,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${user.firstName} ${user.lastName}'),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${user.email}'),
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Phone',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('${user.phoneNumber}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 17),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: Colors.black54),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 6.0,
                      right: 6,
                      top: 16,
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 30),
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(17),
                            color: Colors.grey.withOpacity(.2),
                          ),
                          child: Row(
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
                                  item.image,
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
                                        item.name,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        item.location,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        'Rs. ${(item.price.toString())}/Night',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Positioned(
                        //   top: 7,
                        //   right: 10,
                        //   child: GestureDetector(
                        //     onTap: () => _toggleFavorite(context, product),
                        //     child: Icon(
                        //       isInFavoriteProducts
                        //           ? Icons.favorite
                        //           : Icons.favorite_border,
                        //       color: Colors.green,
                        //       size: 30,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                      '${DateFormat('d MMM').format(checkInDate!)}',
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
                                style: TextStyle(fontWeight: FontWeight.bold),
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
                                      '${DateFormat('d MMM').format(checkOutDate!)}',
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
                        Text('${guestCount}'),
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
                        Text('Rs. ${grandTotal}'),
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
                        Text('${bookingStatus}',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  SizedBox(height: 13),
                ],
              ),
            ),
            SizedBox(height: 35),
            Obx(() {
              return bookingViewModel.isSaving.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.green,
                    ),
                    onPressed: () {
                      bookingViewModel.saveBooking(
                        item,
                        checkInDate,
                        checkOutDate,
                        guestCount,
                        grandTotal,
                        bookingStatus,
                      );
                    },
                    child: Text(
                      'Confirm payment',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
            }),
          ],
        ),
      ),
    );
  }
}

class BookingSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(UserRepository());
    Get.put(BookingRepository());
    Get.put(ProfileViewModel());
    Get.put(CustomerBookingViewModel());
  }
}
