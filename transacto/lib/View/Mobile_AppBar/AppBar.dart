import 'package:flutter/material.dart';

import '../../Components/AppBar/Header.dart';
import '../../Constants/constant_color.dart';
import '../Dashboard_/History/History_Customar_page/PageHistoryCustomer.dart';
import '../Dashboard_/History/History_Vendor_page/PageHistoryVendor.dart';
import '../Dashboard_/Order/Order_Customar_section/Customar_page.dart';
import '../Dashboard_/Order/Order_Vender_section/Vendor_page.dart';
import '../Dashboard_/Payments/Customer_Order/PaymentCustomerPage.dart';
import '../Dashboard_/Payments/Vendor_Order/PaymentVendorPage.dart';

class BaseScaffold extends StatelessWidget {
  final Widget body;

  const BaseScaffold({Key? key, required this.body}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Define mobile breakpoint

    return Scaffold(
      appBar: Header(), // Use your custom Header widget
      drawer: isMobile
          ? Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFF3D48A)),
              child: Center(
                child: Row(
                  children: [
                    Image.network(
                      'https://cdn.pixabay.com/photo/2022/08/22/21/58/grocery-7404621_1280.png',
                      height: 40,
                      width: 40,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "Guru",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(width: 10), // Add space between the texts
                    Text(
                      'Krupa',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ListTile(
              title: const Text("Dashboard",style: TextStyle(color:Colors.blue ),),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              title: const Text("Customer"),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              title: const Text("Vendor"),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            ListTile(
              title: const Text("Product"),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
            ),
            _buildExpandableMenu(
              context,
              title: 'Order',
              subItems: ['Customer', 'Vendor'],
              orderPage: true,
            ),
            _buildExpandableMenu(
              context,
              title: 'History',
              subItems: ['Customer', 'Vendor'],
              historyPage: true,
            ),
            _buildExpandableMenu(
              context,
              title: 'Payments',
              subItems: ['Customer', 'Vendor'],
              paymentPage: true,
            ),
            ListTile(
              title: const Text("Contact"),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                // Add navigation logic for Contact page
              },
            ),
          ],
        ),
      )
          : null, // No drawer for tablet/desktop views
      body: body, // Display the content passed to this widget
    );
  }

  Widget _buildExpandableMenu(
      BuildContext context, {
        required String title,
        required List<String> subItems,
        bool orderPage = false,
        bool historyPage = false,
        bool paymentPage = false,
      }) {
    return ExpansionTile(
      title: Text(title),
      children: subItems.map((subItem) {
        return ListTile(
          title: Text(subItem),
          onTap: () {
            Navigator.pop(context); // Close the drawer

            // Handle navigation logic for sub-items
            if (orderPage) {
              if (subItem == 'Customer') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerListPage()), // Navigate to Monucumer
                );
              }  else if (subItem == 'Vendor') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrderVenderListPage()), // Navigate to VendorPage
                );
              }
            } else if (historyPage) {
              if (subItem == 'Customer') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryCustomarPage()), // Navigate to Monucumer
                );
              }  else if (subItem == 'Vendor') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PageHistoryVendor()), // Navigate to VendorPage
                );
              }
            } else if (paymentPage) {
              if (subItem == 'Customer') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CustomerPaymentsPage()), // Navigate to Monucumer
                );
              }  else if (subItem == 'Vendor') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentVendorPage()), // Navigate to VendorPage
                );
              }
            }
          },
        );
      }).toList(),
    );
  }
}
