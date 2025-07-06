import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/data/BookingRepository.dart';
import 'package:my_app/data/FavoritesRepository.dart';
import 'package:my_app/providers/dummy-item-provider.dart';
import 'package:my_app/ui/auth/view_models/login_vm.dart';
import 'package:my_app/ui/items/view-models/item_vm.dart';
import 'package:my_app/ui/items/views/favorite-items-page.dart';
import 'package:my_app/ui/profile/views/show_profile_page.dart';
import 'package:my_app/widgets/card-widget.dart';
import 'package:my_app/widgets/item-widget.dart';
import '../../../data/AuthRepository.dart';
import '../../../data/MediaRepository.dart';
import '../../../data/UserRepository.dart';
import '../../customerBooking/view_models/customerBooking_vm.dart';
import '../../customerBooking/views/booking-list-page.dart';
import '../../profile/view_models/profile_vm.dart';

class CustomerHomePage extends StatefulWidget {
  CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  final RxInt currentPage = 0.obs;
  final list = DummyItemProvider.getDummyItem();
  final profileViewModel = Get.find<ProfileViewModel>();
  late CustomerBookingViewModel bookingViewModel;
  late ItemViewModel itemViewModel;
  late LoginViewModel loginViewModel;

  @override
  void initState() {
    super.initState();
    bookingViewModel = Get.find();
    itemViewModel = Get.find();
    loginViewModel = Get.find();

    // Schedule the initialization after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Get.find<AuthRepository>().getLoggedInUser()?.uid;
      if (userId != null) {
        Get.find<ProfileViewModel>().getUser(userId, showNotFoundMessage: true);
        bookingViewModel.getBookingsByUserId(userId);
        itemViewModel.getFavoritesByUserId(userId);
      }
    });
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
                  label: Text('${itemViewModel.favoritesCount}'),
                  child: Icon(Icons.favorite_outline),
                ),
              ),
              activeIcon: Obx(
                () => Badge(
                  label: Text('${itemViewModel.favoritesCount}'),
                  child: Icon(Icons.favorite),
                ),
              ),
              label: "Favorites",
            ),
            BottomNavigationBarItem(
              icon: Obx(
                () => Badge(
                  label: Text('${bookingViewModel.bookingCount}'),
                  child: Icon(Icons.article_outlined),
                ),
              ),
              activeIcon: Obx(
                () => Badge(
                  label: Text('${bookingViewModel.bookingCount}'),
                  child: Icon(Icons.article),
                ),
              ),
              label: "Bookings",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(() {
        // Show loading indicator while user data is being fetched
        if (profileViewModel.isAdding.value &&
            profileViewModel.currentUser.value == null) {
          return Center(child: CircularProgressIndicator());
        }
        return getPage(currentPage.value);
      }),
    );
  }

  Widget getPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return buildCustomerHomePage();
      case 1:
        FavoriteItemsBinding().dependencies();
        return FavoriteItemsPage();
      case 2:
        BookingListBinding().dependencies();
        return BookingListPage();
      case 3:
        ShowProfileBinding().dependencies();
        return ShowProfilePage();
      default:
        return buildCustomerHomePage(); // fallback if unexpected index
    }
  }

  Widget buildCustomerHomePage() {
    return Scaffold(
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Obx(() {
                final user = profileViewModel.currentUser.value;
                return UserAccountsDrawerHeader(
                  accountName: Text(user?.firstName ?? 'Guest'),
                  accountEmail: Text(user?.email ?? 'guest@example.com'),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage:
                        user?.image != null ? NetworkImage(user!.image!) : null,
                    child:
                        user?.image == null
                            ? Icon(Icons.person, size: 40, color: Colors.grey)
                            : null,
                  ),
                  decoration: BoxDecoration(color: Colors.green),
                );
              }),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  currentPage.value = 0;
                  Get.back(); // close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text('Favorites'),
                onTap: () {
                  currentPage.value = 1;
                  Get.back(); // close the drawer
                },
              ),
              ListTile(
                leading: Icon(Icons.article),
                title: Text('Bookings'),
                onTap: () {
                  currentPage.value = 2;
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  currentPage.value = 3;
                  Get.back();
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text('Create profile'),
                onTap: () {
                  Get.offAndToNamed('/save_profile');
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                onTap: () {
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
                          child: Text(
                            'Yes',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
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
              Obx(() {
                final user = profileViewModel.currentUser.value;
                return Container(
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
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/show_profile');
                          },
                          child: Row(
                            children: [
                              if (user != null)
                                user.image == null
                                    ? CircleAvatar(
                                      radius: 23,
                                      child: Icon(Icons.image),
                                    )
                                    : CircleAvatar(
                                      radius: 23,
                                      backgroundImage: NetworkImage(
                                        user.image!,
                                      ),
                                    ),
                              if (user == null)
                                CircleAvatar(
                                  radius: 23,
                                  child: Icon(Icons.image),
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
                                  '"${user?.firstName ?? ''}"',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                );
              }),
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return ItemWidget(item: list[index]);
                  },
                  itemCount: list.length > 5 ? 5 : list.length,
                ),
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
                              'first Booking',
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

class CustomerHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MediaRepository());
    Get.put(BookingRepository());
    Get.put(AuthRepository());
    Get.put(FavoritesRepository());
    Get.put(UserRepository());
    Get.put(ProfileViewModel());
    Get.put(ItemViewModel());
    Get.put(LoginViewModel());
    Get.put(CustomerBookingViewModel());
  }
}
