class PageRouterName {
  final String name;
  final String path;
  const PageRouterName({required this.name, required this.path});
}

class Routes {
  static const PageRouterName splashScreen = PageRouterName(
    name: "splash_screen",
    path: "/splash_screen",
  );
  static const PageRouterName loginScreen = PageRouterName(
    name: "login_screen",
    path: "/login_screen",
  );
  static const PageRouterName homeScreen = PageRouterName(
    name: "home_screen",
    path: "/home_screen",
  );
  static const PageRouterName languageScreen = PageRouterName(
    name: "language_screen",
    path: "/language_screen",
  );
  static const PageRouterName employeeListScreen = PageRouterName(
    name: "employee_list_screen",
    path: "/employee_list_screen",
  );
  static const PageRouterName employeeAddScreen = PageRouterName(
    name: "employee_add_screen",
    path: "/employee_add_screen",
  );
  static const PageRouterName anganwadiListScreen = PageRouterName(
    name: "anganwadi_list_screen",
    path: "/anganwadi_list_screen",
  );
  static const PageRouterName anganwadiAddScreen = PageRouterName(
    name: "anganwadi_add_screen",
    path: "/anganwadi_add_screen",
  );
  static const PageRouterName bookings = PageRouterName(
    name: "bookings",
    path: "/bookings",
  );
  static const PageRouterName hotels = PageRouterName(
    name: "hotels",
    path: "/hotels",
  );
  static const PageRouterName bookingCheckInScreen = PageRouterName(
    name: "booking_checkin_screen",
    path: "/booking_checkin_screen",
  );
  static const PageRouterName bookingCheckOutScreen = PageRouterName(
    name: "booking_checkout_screen",
    path: "/booking_checkout_screen",
  );
  static const PageRouterName coustomerScreen = PageRouterName(
    name: "coustomer_screen",
    path: "/coustomer_screen",
  );
  static const PageRouterName faceRegistrScreen = PageRouterName(
    name: "face_registration_screen",
    path: "/face_registration_screen",
  );

  static const PageRouterName faceVerifyScreen = PageRouterName(
    name: "face_verify_screen",
    path: "/face_verify_screen",
  );
}
