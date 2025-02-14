import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../View/Dashboard_/History/History_Customar_page/PageHistoryCustomer.dart';
import '../../View/Dashboard_/History/History_Vendor_page/PageHistoryVendor.dart';
import '../../View/Dashboard_/Order/Order_Customar_section/Customar_page.dart';
import '../../View/Dashboard_/Order/Order_Vender_section/Vendor_page.dart';
import '../../View/Dashboard_/Payments/Customer_Order/PaymentCustomerPage.dart';
import '../../View/Dashboard_/Payments/Vendor_Order/PaymentVendorPage.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(100); // AppBar height

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Mobile breakpoint
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      toolbarHeight: 100,
      title: isMobile || isTablet
          ? _buildMobileTabletHeader(context)
          : _buildDesktopHeader(context),
      // If you want to include a Drawer for mobile/tablet, uncomment below:
      // drawer: isMobile || isTablet ? _buildDrawer(context) : null
    );
  }

  Widget _buildMobileTabletHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Uncomment the following block if you want to enable the drawer
        /*
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Open the drawer from left
            },
          ),
        ),
        */
        Row(
          children: [
            Image.network(
              'https://cdn.pixabay.com/photo/2022/08/22/21/58/grocery-7404621_1280.png',
              height: 40,
              width: 40,
            ),
            const SizedBox(width: 8),
            const Text(
              "Guru",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
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
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          'https://cdn.pixabay.com/photo/2022/08/22/21/58/grocery-7404621_1280.png',
          height: 40,
          width: 40,
        ),
        const SizedBox(width: 8),
        const Text(
          "Guru",
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
        Text(
          'Krupa',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 31,
          ),
        ),
        const SizedBox(width: 100),

        // **Updated "Dashboard" as a single button without subitems**
        _buildTextButton(
          text: "Dashboard",
          onPressed: () {
            onPressed: () {
              // Your logic here, without navigation
              print("Contact button pressed.");
              // You can add any action you want here
            };
          },
        ),
        _buildTextButton(
          text: "Customer",
          onPressed: () {
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CustomerListPage()),
              );
            };
          },
        ),
        _buildTextButton(
          text: "Vendor",
          onPressed: () {
            onPressed: () {
              // Your logic here, without navigation
              print("Contact button pressed.");
              // You can add any action you want here
            };
          },
        ),
        _buildTextButton(
          text: "Product",
          onPressed: () {
            onPressed: () {
              // Your logic here, without navigation
              print("Contact button pressed.");
              // You can add any action you want here
            };
          },
        ),

        const SizedBox(width: 25),
        _buildDropdownMenu(
          mainItem: "Order",
          subItems: ["Customer", "Vendor"],
          onSubItemPressed: (subItem) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => subItem == "Customer"
                      ? CustomerListPage()
                      : OrderVenderListPage()),
            );
          },
        ),
        const SizedBox(width: 25),
        _buildDropdownMenu(
          mainItem: "History",
          subItems: ["Customer", "Vendor"],
          onSubItemPressed: (subItem) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => subItem == "Customer"
                      ? HistoryCustomarPage()
                      : PageHistoryVendor()),
            );
          },
        ),
        const SizedBox(width: 25),
        _buildDropdownMenu(
          mainItem: "Payments",
          subItems: ["Customer", "Vendor"],
          onSubItemPressed: (subItem) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => subItem == "Customer"
                      ? CustomerPaymentsPage()
                      : PaymentVendorPage()),
            );
          },
        ),
        const SizedBox(width: 25),
        _buildTextButton(
          text: "Contact",
          onPressed: () {
            // Your logic here, without navigation
            print("Contact button pressed.");
            // You can add any action you want here
          },
        ),
      ],
    );
  }

  // Uncomment and implement this method if you decide to use a Drawer for mobile/tablet
  /*
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Row(
              children: [
                Image.network(
                  'https://cdn.pixabay.com/photo/2022/08/22/21/58/grocery-7404621_1280.png',
                  height: 40,
                  width: 40,
                ),
                const SizedBox(width: 8),
                const Text(
                  "GuruKrupa",
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text("Dashboard"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainDashboardPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context,
            text: "Order",
            subItems: ["Customer", "Vendor"],
            onSubItemPressed: (subItem) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => subItem == "Customer"
                      ? CustomerListPage()
                      : OrderVenderListPage(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context,
            text: "History",
            subItems: ["Customer", "Vendor"],
            onSubItemPressed: (subItem) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => subItem == "Customer"
                      ? HistoryCustomarPage()
                      : PageHistoryVendor(),
                ),
              );
            },
          ),
          _buildDrawerItem(
            context,
            text: "Payments",
            subItems: ["Customer", "Vendor"],
            onSubItemPressed: (subItem) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => subItem == "Customer"
                      ? CustomerPaymentsPage()
                      : PaymentVendorPage(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text("Contact"),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              // Your logic here, without navigation
              print("Contact button pressed.");
            },
          ),
        ],
      ),
    );
  }
  */

  Widget _buildDrawerItem(
      BuildContext context, {
        required String text,
        required List<String> subItems,
        required Function(String) onSubItemPressed,
      }) {
    return ExpansionTile(
      title: Text(text),
      children: subItems.map((subItem) {
        return ListTile(
          title: Text(subItem),
          onTap: () {
            Navigator.pop(context); // Close the drawer before navigating
            onSubItemPressed(subItem); // Handle navigation
          },
        );
      }).toList(),
    );
  }

  Widget _buildDropdownMenu({
    required String mainItem,
    required List<String> subItems,
    required Function(String) onSubItemPressed,
  }) {
    return PopupMenuButton<String>(
      onSelected: (String selectedItem) {
        onSubItemPressed(selectedItem);
      },
      child: Text(
        mainItem,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          color: Colors.black, // Main item text color
        ),
      ),
      itemBuilder: (BuildContext context) {
        return subItems.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: MouseRegion(
              onEnter: (_) {}, // Optional hover detection for future use
              child: Text(
                choice,
                style: WidgetStateTextStyle.resolveWith(
                      (states) {
                    if (states.contains(WidgetState.hovered)) {
                      return const TextStyle(color: Colors.green); // Green on hover
                    }
                    return const TextStyle(color: Colors.black); // Default black color
                  },
                ),
              ),
            ),
          );
        }).toList();
      },
    );
  }


  TextButton _buildTextButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.hovered)) {
              return Colors.green.withOpacity(0.1); // Green hover effect
            }
            return Colors.transparent; // Default (no effect)
          },
        ),
      ),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          color: Colors.black, // Text color set to black
        ),
      ),
    );
  }

}
