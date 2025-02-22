import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transacto/Constants/constant_color.dart';
import 'Controller/customer_controller.dart';
import 'Controller/product_controller.dart';
import 'Controller/vendor_controller.dart';
import 'View/Dashboard_/Payments/Vendor_Order/PaymentVendorPage.dart';
import 'helper/size_config.dart';
import 'package:get/get.dart';
import 'package:transacto/Utils/get_di.dart' as di;

void main() async {
  Get.put(VendorController());
  Get.put(ProductController());
  Get.put(CustomerController());
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return OrientationBuilder(
        builder: (BuildContext context2, Orientation orientation) {
          SizeConfig.init(constraints, orientation);
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Transacto",
            theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: kcPrimary),
                primaryColor: Color(0xFFF3D48A),
                textTheme: GoogleFonts.poppinsTextTheme()),
            home: VendorPaymentPage(),
          );
        },
      );
    });
  }
}
