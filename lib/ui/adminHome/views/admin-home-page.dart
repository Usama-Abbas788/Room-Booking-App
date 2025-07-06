import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/AuthRepository.dart';
import 'package:my_app/data/BookingRepository.dart';
import 'package:my_app/data/UserRepository.dart';
import 'package:my_app/ui/auth/view_models/login_vm.dart';
import '../../../widgets/card-widget.dart';
import '../../adminBooking/view-models/admin_booking_vm.dart';
import '../../adminBooking/views/admin-booking-list-page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late AdminBookingViewModel adminBookingViewModel;
  late LoginViewModel loginViewModel;
  final RxInt currentPage = 0.obs;

  @override
  void initState() {
    super.initState();
    adminBookingViewModel = Get.find();
    loginViewModel=Get.find();
    adminBookingViewModel.getAllBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          currentIndex: currentPage.value,
          onTap: (index) {
            currentPage.value = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Obx(
                () => Badge(
                  label: Text('${adminBookingViewModel.bookingCount}'),
                  child: Icon(Icons.article_outlined),
                ),
              ),
              activeIcon: Obx(
                () => Badge(
                  label: Text('${adminBookingViewModel.bookingCount}'),
                  child: Icon(Icons.article),
                ),
              ),
              label: "Bookings",
            ),
          ],
        ),
      ),
      body: Obx(() {
        return getPage(currentPage.value);
      }),
    );
  }

  Widget getPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return buildAdminHomePage();
      case 1:
        AdminBookingListBinding().dependencies();
        return AdminBookingListPage();
      default:
        return buildAdminHomePage(); // fallback if unexpected index
    }
  }

  Widget buildAdminHomePage() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: Text('Confirm logout!'),
                content: Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await loginViewModel.confirmLogout();
                    },
                    child: Text('Yes', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          icon: Icon(Icons.logout, color: Colors.black87),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 17.0),
            child: Column(
              children: [
                Text(
                  'Current Location',
                  style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Icon(
                        Icons.location_on_outlined,
                        size: 19,
                        color: Colors.green,
                      ),
                    ),
                    Text('Lahore, Pakistan', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            child: Icon(Icons.person, color: Colors.green),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0),
                            child: Icon(
                              Icons.waving_hand,
                              color: Colors.orange,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text('Hello'),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              '"Admin"',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: SearchBar(
                          leading: Icon(Icons.search, color: Colors.white),
                          hintText: 'Search for hotels',
                          hintStyle: WidgetStatePropertyAll(
                            TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          elevation: WidgetStatePropertyAll(4),
                          backgroundColor: WidgetStatePropertyAll(
                            Colors.black.withOpacity(0.85),
                          ),
                          shadowColor: WidgetStatePropertyAll(Colors.green),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStatePropertyAll(Colors.black87),
                    ),
                    onPressed: null,
                    child: Text('Hot Deals'),
                  ),
                  TextButton(onPressed: null, child: Text('Recommended')),
                  TextButton(onPressed: null, child: Text('Popular')),
                ],
              ),
              Container(
                height: 136,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Text('hello'),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 6, bottom: 2),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed("/see_all_items_page");
                    },
                    child: Text(
                      'See all',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 11.0, bottom: 3),
                  child: Text(
                    'Coming Soon',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    CardItem(
                      image: 'assets/images/hotel2.jpg',
                      name: 'Sierra Crest',
                      cityName: 'Islamabad',
                    ),
                    CardItem(
                      image: 'assets/images/hotel3.jpg',
                      name: 'Alpine Vista',
                      cityName: 'Karachi',
                    ),
                    CardItem(
                      image: 'assets/images/hotel4.jpg',
                      name: 'Summit Grace',
                      cityName: 'Multan',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 0),
                child: Container(
                  height: 115,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/picture1.webp',
                        fit: BoxFit.cover,
                      ),
                      Container(
                        color: Colors.black.withOpacity(
                          0.25,
                        ), // Optional dark overlay
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Get',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              '10% OFF on your',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 23,
                              ),
                            ),
                            Text(
                              'first customerBooking',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
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
    );
  }
}

class AdminHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BookingRepository());
    Get.put(UserRepository());
    Get.put(AuthRepository());
    Get.put(AdminBookingViewModel());
    Get.put(LoginViewModel());
  }
}
