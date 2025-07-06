import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data/BookingRepository.dart';
import '../../../data/AuthRepository.dart';
import '../../../data/UserRepository.dart';
import '../../../models/items.dart';
import '../../profile/view_models/profile_vm.dart';
import '../view_models/customerBooking_vm.dart';

class BookNowPage extends StatefulWidget {
  const BookNowPage({super.key});

  @override
  State<BookNowPage> createState() => _BookNowPageState();
}

class _BookNowPageState extends State<BookNowPage> {
  late CustomerBookingViewModel bookingViewModel;
  final profileViewModel = Get.find<ProfileViewModel>();
  late final Items item;

  @override
  void initState() {
    super.initState();
    bookingViewModel = Get.find();
    item = Get.arguments as Items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Form',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Get.offNamed('/item_detail_page', arguments: item);
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 14),
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
                        child: Image.asset(item.image, fit: BoxFit.cover),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
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
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Fill additional information !',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 9.0),
                          child: Text(
                            'Check In',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => TextField(
                            readOnly: true,
                            onTap: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    bookingViewModel.checkInDate.value ??
                                    DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(DateTime.now().year + 1),
                              );
                              if (picked != null) {
                                bookingViewModel.setCheckInDate(picked);
                              }
                            },
                            controller: TextEditingController(
                              text:
                                  bookingViewModel.checkInDate.value != null
                                      ? DateFormat('MMM dd').format(
                                        bookingViewModel.checkInDate.value!,
                                      )
                                      : '',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Select date',
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 12.0, right: 12, top: 35),
                    child: Icon(Icons.arrow_forward_sharp, size: 19),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 9.0),
                          child: Text(
                            'Check Out',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 15),
                        Obx(
                          () => TextField(
                            readOnly: true,
                            onTap: () async {
                              if (bookingViewModel.checkInDate.value == null) {
                                Get.snackbar(
                                  'Error',
                                  'Please select check-in date first',
                                );
                                return;
                              }
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate:
                                    bookingViewModel.checkOutDate.value ??
                                    bookingViewModel.checkInDate.value!.add(
                                      const Duration(days: 1),
                                    ),
                                firstDate: bookingViewModel.checkInDate.value!
                                    .add(const Duration(days: 1)),
                                lastDate: DateTime(DateTime.now().year + 1),
                              );
                              if (picked != null) {
                                bookingViewModel.setCheckOutDate(picked);
                              }
                            },
                            controller: TextEditingController(
                              text:
                                  bookingViewModel.checkOutDate.value != null
                                      ? DateFormat('MMM dd').format(
                                        bookingViewModel.checkOutDate.value!,
                                      )
                                      : '',
                            ),
                            decoration: InputDecoration(
                              hintText: 'Select date',
                              suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Guest',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blueGrey),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.black87,
                                  size: 15,
                                ),
                                onPressed: bookingViewModel.decreaseGuest,
                              ),
                            ),
                            SizedBox(
                              width: 50,
                              child: TextField(
                                controller: TextEditingController(
                                  text:
                                      bookingViewModel.guestCount.value
                                          .toString(),
                                ),
                                readOnly: true,
                                decoration: const InputDecoration(
                                  hintText: '',
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                  border: InputBorder.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.black87,
                                  size: 15,
                                ),
                                onPressed: bookingViewModel.increaseGuest,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Note: This room allows up to ${item.guests} guests. Adding more will increase your total payment.',
                style: TextStyle(color: Colors.red),
              ),
              SizedBox(height: 50),
              Obx(() {
                return bookingViewModel.isSaving.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 70,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    if (bookingViewModel.checkInDate.value == null) {
                      Get.snackbar('Error', 'Please select check-in date');
                    } else if (bookingViewModel.checkOutDate.value == null) {
                      Get.snackbar('Error', 'Please select check-out date');
                    } else if (!bookingViewModel.bookingRepository.isCheckOutAfterCheckIn(
                      bookingViewModel.checkInDate.value,
                      bookingViewModel.checkOutDate.value,
                    )) {
                      Get.snackbar('Error', 'Check-out date must be after check-in date');
                    } else if (bookingViewModel.guestCount.value <= 0) {
                      Get.snackbar('Error', 'Guest count must be at least 1');
                    } else {
                      final user = profileViewModel.currentUser.value;
                      if (user == null) {
                        Get.snackbar(
                          'Incomplete Profile',
                          'Please complete your profile before booking.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      final checkIn = bookingViewModel.checkInDate.value!;
                      final checkOut = bookingViewModel.checkOutDate.value!;
                      final availabilityResult = await bookingViewModel.checkRoomAvailability(
                        item.name,
                        checkIn,
                        checkOut,
                      );
                      if (!availabilityResult['isAvailable']) {
                        final conflictingDates = availabilityResult['conflictingDates'];
                        final existingCheckIn = DateFormat('MMM dd, yyyy').format(conflictingDates['checkIn']);
                        final existingCheckOut = DateFormat('MMM dd, yyyy').format(conflictingDates['checkOut']);

                        Get.snackbar(
                          'Room Unavailable',
                          'This room is already booked from $existingCheckIn to $existingCheckOut.\nPlease choose different dates or a different room.',
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          duration: Duration(seconds: 5),
                        );
                        return;
                      }
                      final guests = bookingViewModel.guestCount.value;
                      final grandTotal = bookingViewModel.calculateTotal(item).toInt();
                      final bookingStatus = bookingViewModel.bookingStatus.value;
                      Get.offNamed('/booking_summary_page', arguments: {
                        'checkInDate': checkIn,
                        'checkOutDate': checkOut,
                        'guestCount': guests,
                        'item': item,
                        'user': user,
                        'grandTotal': grandTotal,
                        'bookingStatus':bookingStatus,
                      });
                    }
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },),
            ],
          ),
        ),
      ),
    );
  }
}

class BookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(UserRepository());
    Get.put(BookingRepository());
    Get.put(CustomerBookingViewModel());
  }
}
