// import 'package:flutter/material.dart';
// import 'package:transacto/Components/AppBar/header.dart';
// import 'package:transacto/View/Dashboard_/History/History_Customar_page/AmountPendingSection.dart';
// import 'package:transacto/View/Dashboard_/History/History_Customar_page/AmountReservedSection.dart';
// import 'package:transacto/View/Dashboard_/History/History_Customar_page/NumberOfOrderSection.dart';
//
// // Import the custom widget sections
//
// class HistoryCustomarPage extends StatefulWidget {
//   const HistoryCustomarPage({super.key});
//
//   @override
//   State<HistoryCustomarPage> createState() => _HistoryCustomarPageState();
// }
//
// class _HistoryCustomarPageState extends State<HistoryCustomarPage> {
//   // List of customer names
//   final List<String> customerNames = [
//     'John Doe',
//     'Jane Smith',
//     'Alice Johnson',
//     'Bob Brown',
//   ];
//
//   // Variable to store the selected customer name
//   String? selectedCustomer;
//
//   // Track which section to show
//   String selectedSection = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Header(),
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             Center(
//               child: Text(
//                 'History Of the Customer',
//                 style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
//               ),
//             ),
//             const SizedBox(height: 30),
//             // DropdownButton Container
//             Padding(
//               padding: const EdgeInsets.only(left: 500,right: 500),
//               child: Container(
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.black),
//                 ),
//                 child: DropdownButton<String>(
//                   value: selectedCustomer,
//                   hint: const Padding(
//                     padding: EdgeInsets.only(left: 8.0),
//                     child: Text('Select Customer'),
//                   ),
//                   icon: const Padding(
//                     padding: EdgeInsets.only(right: 8.0),
//                     child: Icon(Icons.arrow_downward),
//                   ),
//                   elevation: 16,
//                   isExpanded: true,
//                   style: const TextStyle(color: Colors.black),
//                   underline: SizedBox.shrink(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       selectedCustomer = newValue;
//                       // Reset section when new customer is selected
//                       selectedSection = '';
//                     });
//                   },
//                   items:
//                       customerNames.map<DropdownMenuItem<String>>((String value) {
//                     return DropdownMenuItem<String>(
//                       value: value,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                         child: Text(value),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Row with three buttons
//             Padding(
//               padding: const EdgeInsets.only(left: 500,right: 500),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   // Button for "No of Order"
//                   ElevatedButton(
//                     onPressed: () {
//                       if (selectedCustomer != null) {
//                         setState(() {
//                           selectedSection = 'No of Order';
//                         });
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 12.0),
//                       backgroundColor: Colors.orangeAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('No of Order'),
//                   ),
//                   // Button for "Amount Reserved"
//                   ElevatedButton(
//                     onPressed: () {
//                       if (selectedCustomer != null) {
//                         setState(() {
//                           selectedSection = 'Amount Reserved';
//                         });
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 12.0),
//                       backgroundColor: Colors.orangeAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Amount Reserved'),
//                   ),
//                   // Button for "Amount Pending"
//                   ElevatedButton(
//                     onPressed: () {
//                       if (selectedCustomer != null) {
//                         setState(() {
//                           selectedSection = 'Amount Pending';
//                         });
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16.0, vertical: 12.0),
//                       backgroundColor: Colors.orangeAccent,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Amount Pending'),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Conditional rendering of selected section
//             if (selectedCustomer != null)
//               if (selectedSection == 'No of Order')
//                 NumberOfOrderSection(customerName: selectedCustomer!)
//               else if (selectedSection == 'Amount Reserved')
//                 AmountReservedSection(customerName: selectedCustomer!)
//               else if (selectedSection == 'Amount Pending')
//                 AmountPendingSection(customerName: selectedCustomer!),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transacto/Components/AppBar/header.dart';
import 'package:transacto/View/Dashboard_/History/History_Customar_page/AmountPendingSection.dart';
import 'package:transacto/View/Dashboard_/History/History_Customar_page/AmountReservedSection.dart';
import 'package:transacto/View/Dashboard_/History/History_Customar_page/NumberOfOrderSection.dart';

import '../../../Mobile_AppBar/AppBar.dart';

class HistoryCustomarPage extends StatefulWidget {
  const HistoryCustomarPage({super.key});

  @override
  State<HistoryCustomarPage> createState() => _HistoryCustomarPageState();
}

class _HistoryCustomarPageState extends State<HistoryCustomarPage> {
  final List<String> customerNames = [
    'John Doe',
    'Jane Smith',
    'Alice Johnson',
    'Bob Brown',
  ];

  String? selectedCustomer;
  String selectedSection = ''; // Track which section is selected

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      // appBar: Header(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = MediaQuery.of(context).size.width;

          // Adjust padding for different screen sizes
          double horizontalPadding = screenWidth < 600
              ? 10 // Mobile devices
              : screenWidth < 1000
              ? 20 // Tablets
              : 50; // Desktops

          // final screenWidth = MediaQuery.of(context).size.width;
          final isMobile = screenWidth < 600; // Mobile breakpoint
          final isTablet = screenWidth >= 600 && screenWidth < 1024;
          final isDesktop = screenWidth >= 1024;


          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'History Of Customer',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: isMobile ? 24 : 35,
                        fontWeight: FontWeight.bold,
                      ),
                    )

                ),
                const SizedBox(height: 30),
                // DropdownButton Container
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Center(
                    child: Container(
                      height: 50,
                      width: 600,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black),
                      ),
                      child: DropdownButton<String>(
                        value: selectedCustomer,
                        hint: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Text('Select Customer'),
                        ),
                        icon: const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.arrow_downward),
                        ),
                        elevation: 16,
                        isExpanded: true,
                        style: const TextStyle(color: Colors.black),
                        underline: SizedBox.shrink(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCustomer = newValue;
                            selectedSection = ''; // Reset section on new customer selection
                          });
                        },
                        items: customerNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(value),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Display buttons in a Row for all screen sizes
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Adjust button size for web view
                      buildButton('No of Order', context, screenWidth),
                      SizedBox(width: 10,),
                      buildButton('Amount Received', context, screenWidth),
                      SizedBox(width: 10,),
                      buildButton('Outstanding Amount', context, screenWidth),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Conditional rendering of selected section
                if (selectedCustomer != null)
                  if (selectedSection == 'No of Order')
                    NumberOfOrderSection(customerName: selectedCustomer!)
                  else if (selectedSection == 'Amount Received')
                    AmountReservedSection(customerName: selectedCustomer!)
                  else if (selectedSection == 'Outstanding Amount')
                      AmountPendingSection(customerName: selectedCustomer!),
              ],
            ),
          );
        },
      ),
    );
  }

  // Reusable method to build a button and handle section changes
  Widget buildButton(String buttonText, BuildContext context, double screenWidth) {
    return SizedBox(
      width: screenWidth < 600 ? 100 : 150, // Set width based on screen size
      child: ElevatedButton(
        onPressed: selectedCustomer != null
            ? () {
          setState(() {
            selectedSection = buttonText;
          });
        }
            : null, // Disable button if no customer is selected
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0), // Reduce vertical padding
          backgroundColor:
          selectedCustomer != null ? Colors.orangeAccent : Colors.grey, // Grey if disabled
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(buttonText, textAlign: TextAlign.center), // Center the text
      ),
    );
  }
}

