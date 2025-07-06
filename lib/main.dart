import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/ui/adminBooking/views/admin-booking-list-page.dart';
import 'package:my_app/ui/adminBooking/views/admin-booking-ticket-page.dart';
import 'package:my_app/ui/adminHome/views/admin-home-page.dart';
import 'package:my_app/ui/auth/views/forgot_password-page.dart';
import 'package:my_app/ui/auth/views/login_page.dart';
import 'package:my_app/ui/customerBooking/views/book-now-page.dart';
import 'package:my_app/ui/customerBooking/views/booking-list-page.dart';
import 'package:my_app/ui/customerBooking/views/booking-summary-page.dart';
import 'package:my_app/ui/customerBooking/views/booking-ticket-page.dart';
import 'package:my_app/ui/customerHome/views/customer-home-page.dart';
import 'package:my_app/ui/items/views/item-detail-page.dart';
import 'package:my_app/ui/items/views/see-all-items-page.dart';
import 'package:my_app/ui/profile/views/save_profile_page.dart';
import 'package:my_app/ui/auth/views/sign_up-page.dart';
import 'package:my_app/ui/profile/views/show_profile_page.dart';
import 'package:my_app/ui/welcome/views/welcome-page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white, // AppBar color using WhatsApp green
        ),
      ),
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: "/welcome", page: () => WelcomePage(),),
        GetPage(name: "/login", page: () => LoginPage(),binding: LoginBinding()),
        GetPage(name: "/signup", page: () => SignUpPage(),binding: SignUpBinding()),
        GetPage(name: "/forget_password", page: () => ForgetPasswordPage(),binding: ResetPasswordBinding()),
        GetPage(name: "/save_profile", page: () => SaveProfilePage(),binding: SaveProfileBinding()),
        GetPage(name: "/show_profile", page: () => ShowProfilePage(),binding: ShowProfileBinding()),
        GetPage(name: "/item_detail_page", page: () => ItemDetailPage(),binding: ItemDetailPageBinding()),
        GetPage(name: "/see_all_items_page", page: () => SeeAll()),
        GetPage(name: "/customer_home_page", page: () => CustomerHomePage(),binding: CustomerHomeBinding(),),
        GetPage(name: "/admin_home_page", page: () => AdminHomePage(),binding: AdminHomeBinding()),
        GetPage(name: "/book_now_page", page: () => BookNowPage(),binding: BookingBinding(),),
        GetPage(name: "/booking_summary_page", page: () => BookingSummaryPage(),binding: BookingSummaryBinding()),
        GetPage(name: "/booking_list_page", page: () => BookingListPage(),binding: BookingListBinding()),
        GetPage(name: "/admin_booking_list_page", page: () => AdminBookingListPage(),binding: BookingListBinding()),
        GetPage(name: "/admin_booking_ticket_page", page: () => AdminBookingTicketPage(),binding: AdminBookingTicketBinding()),
        GetPage(name: "/booking_ticket_page", page: () => BookingTicketPage(),binding: BookingTicketBinding()),
      ],
      initialRoute: "/welcome",
    );
  }
}


