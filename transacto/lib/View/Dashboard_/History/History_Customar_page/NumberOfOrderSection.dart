// import 'package:flutter/material.dart';
// import 'package:transacto/Components/AppBar/header.dart';
// import 'package:transacto/View/Dashboard_/History/History_Customar_page/AmountReservedSection.dart';
// import 'package:transacto/View/Dashboard_/Order/Order_Customar_section/Add_Customar.dart';
//
// class NumberOfOrderSection extends StatefulWidget {
//   final String customerName;
//
//   const NumberOfOrderSection({Key? key, required this.customerName})
//       : super(key: key);
//
//   @override
//   _NumberOfOrderSectionState createState() => _NumberOfOrderSectionState();
// }
//
// class _NumberOfOrderSectionState extends State<NumberOfOrderSection> {
//   int currentPage = 1; // Start with the first page
//   final int itemsPerPage = 6; // Number of items per page
//   List<Map<String, dynamic>> customerList = [
//     {
//       'amount': '9852',
//       'order': '1234567890',
//       'date': '2024-10-01'
//     },
//     {
//       'amount': '3652',
//       'order': '0987654321',
//       'date': '2024-10-02'
//     },
//     {
//       'amount': '6325',
//       'order': '2345678901',
//       'date': '2024-10-03'
//     },
//     {
//       'amount': '9999',
//       'order': '3456789012',
//       'date': '2024-10-04'
//     },
//     {
//       'amount': '6345',
//       'order': '4567890123',
//       'date': '2024-10-05'
//     },
//     {
//       'amount': '8569',
//       'order': '5678901234',
//       'date': '2024-10-06'
//     },
//     {
//       'amount': '5635',
//       'order': '6789012345',
//       'date': '2024-10-07'
//     },
//     {
//       'amount': '8523',
//       'order': '7890123456',
//       'date': '2024-10-08'
//     },
//     // Add more customers as needed
//   ];
//
//   List<Map<String, dynamic>> filteredCustomerList = [];
//   String searchQuery = '';
//
//   @override
//   void initState() {
//     super.initState();
//     filteredCustomerList = customerList; // Initialize filtered list
//   }
//
//   void updateFilteredList() {
//     setState(() {
//       filteredCustomerList = customerList
//           .where((customer) => customer['amount']
//           .toLowerCase()
//           .contains(searchQuery.toLowerCase()))
//           .toList();
//       // Reset to first page if the current page exceeds total pages after filtering
//       int totalPages = (filteredCustomerList.length / itemsPerPage).ceil();
//       if (currentPage > totalPages) {
//         currentPage = totalPages > 0 ? totalPages : 1;
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     int totalPages = (filteredCustomerList.length / itemsPerPage).ceil(); // Calculate total pages
//
//     return Column(
//       children: [
//         SizedBox(height: 16),
//
//         // Search and Filter Row
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.filter_list, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Container(
//                   width: 200,
//                   child: TextField(
//                     onChanged: (value) {
//                       searchQuery = value;
//                       updateFilteredList(); // Update list on search
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search customer...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 16),
//                 // Decorated Dropdown for Last 7 Days and Last 30 Days
//                 Container(
//                   width: 200,
//                   padding: EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: DropdownButtonHideUnderline(
//                     child: DropdownButton<String>(
//                       value: null,
//                       hint: Text('Filter by Date'), // Placeholder text
//                       isExpanded: true, // Ensures the dropdown takes full width
//                       items: [
//                         DropdownMenuItem<String>(
//                           value: 'last7days',
//                           child: Text('Last 7 Days'),
//                         ),
//                         DropdownMenuItem<String>(
//                           value: 'last30days',
//                           child: Text('Last 30 Days'),
//                         ),
//                       ],
//                       onChanged: (value) {
//                         if (value == 'last7days') {
//                           filterByDateRange(
//                               7); // Call the filter function for the last 7 days
//                         } else if (value == 'last30days') {
//                           filterByDateRange(
//                               30); // Call the filter function for the last 30 days
//                         }
//                       },
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Icon(Icons.sort, color: Colors.grey),
//                 SizedBox(width: 8),
//                 Icon(Icons.more_vert, color: Colors.grey),
//               ],
//             ),
//           ],
//         ),
//
//         SizedBox(height: 16),
//
//         // Customer List with Headings
//         Column(
//           children: [
//             // Table headings
//             Row(
//               children: [
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text('Sr.No',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//                 VerticalDivider(color: Colors.black, thickness: 1),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text('Total Amount ',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//                 VerticalDivider(color: Colors.black, thickness: 1),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text('Order ID',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//                 VerticalDivider(color: Colors.black, thickness: 1),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text('Date',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//                 VerticalDivider(color: Colors.black, thickness: 1),
//                 Expanded(
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Text('Action',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ],
//             ),
//             Divider(thickness: 2),
//
//             // List of customers
//             ListView.builder(
//               itemCount: itemsPerPage,
//               shrinkWrap: true, // Important to use shrinkWrap
//               physics:
//               NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
//               itemBuilder: (context, index) {
//                 int startIndex = (currentPage - 1) * itemsPerPage;
//                 int customerIndex = startIndex + index;
//
//                 // Check if customerIndex is within the bounds of filteredCustomerList
//                 if (customerIndex < filteredCustomerList.length) {
//                   return _buildCustomerRow(
//                     customerIndex + 1,
//                     filteredCustomerList[customerIndex]['amount'],
//                     filteredCustomerList[customerIndex]['order'],
//                     filteredCustomerList[customerIndex]['date'], // Date column
//                   );
//                 } else {
//                   return SizedBox.expand(); // Empty space for unused rows
//                 }
//               },
//             ),
//           ],
//         ),
//
//         // Pagination Row
//         SizedBox(height: 16),
//         Visibility(
//           visible: filteredCustomerList.length > itemsPerPage,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Previous button
//               IconButton(
//                 icon: Icon(Icons.chevron_left),
//                 onPressed: currentPage > 1
//                     ? () {
//                   setState(() {
//                     currentPage--;
//                   });
//                 }
//                     : null,
//               ),
//               Row(
//                 children: [
//                   for (int i = 1; i <= totalPages; i++)
//                     _buildPageButton(i.toString(), currentPage == i),
//                 ],
//               ),
//               // Next button
//               IconButton(
//                 icon: Icon(Icons.chevron_right),
//                 onPressed: currentPage < totalPages
//                     ? () {
//                   setState(() {
//                     currentPage++;
//                   });
//                 }
//                     : null,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Customer Row Widget
//   Widget _buildCustomerRow(int index, String amount, String order, String date) {
//     return Row(
//       children: [
//         Expanded(
//           child: Align(
//             alignment: Alignment.center,
//             child: Text('$index'),
//           ),
//         ),
//         VerticalDivider(color: Colors.black, thickness: 5),
//         Expanded(
//           child: Align(
//             alignment: Alignment.center,
//             child: Text(amount),
//           ),
//         ),
//         VerticalDivider(color: Colors.black, thickness: 5),
//         Expanded(
//           child: Align(
//             alignment: Alignment.center,
//             child: Text(order),
//           ),
//         ),
//         VerticalDivider(color: Colors.black, thickness: 5),
//         Expanded(
//           child: Align(
//             alignment: Alignment.center,
//             child: Text(date),
//           ),
//         ),
//         VerticalDivider(color: Colors.black, thickness: 1),
//         Expanded(
//           child: Align(
//             alignment: Alignment.center,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.edit, color: Colors.blue),
//                   onPressed: () {
//                     // Edit customer logic
//                   },
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.delete, color: Colors.red),
//                   onPressed: () {
//                     // Confirm deletion
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return AlertDialog(
//                           title: Text('Delete Customer'),
//                           content: Text(
//                               'Are you sure you want to delete this customer?'),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop(); // Close the dialog
//                               },
//                               child: Text('Cancel'),
//                             ),
//                             ElevatedButton(
//                               onPressed: () {
//                                 setState(() {
//                                   // Find the customer by matching name, phone, and date
//                                   int actualIndex = customerList.indexWhere(
//                                           (customer) =>
//                                       customer['amount'] == amount &&
//                                           customer['order'] == order &&
//                                           customer['date'] == date);
//                                   if (actualIndex != -1) {
//                                     customerList.removeAt(actualIndex); // Remove customer from the list
//                                     updateFilteredList(); // Update filtered list after deletion
//                                   }
//                                 });
//                                 Navigator.of(context).pop(); // Close the dialog
//                               },
//                               child: Text('Delete'),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.red,
//                               ),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   // Pagination Button Widget
//   Widget _buildPageButton(String pageNumber, bool isSelected) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           currentPage = int.parse(pageNumber);
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.all(8.0),
//         margin: EdgeInsets.symmetric(horizontal: 4.0),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange : Colors.grey[300],
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Text(
//           pageNumber,
//           style: TextStyle(color: isSelected ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }
//
//   // Filter Customers by Date Range
//   void filterByDateRange(int days) {
//     setState(() {
//       DateTime now = DateTime.now();
//       DateTime pastDate = now.subtract(Duration(days: days));
//
//       filteredCustomerList = customerList.where((customer) {
//         DateTime customerDate = DateTime.parse(customer['date']);
//         return customerDate.isAfter(pastDate) && customerDate.isBefore(now);
//       }).toList();
//
//       // Reset to first page if needed
//       int totalPages = (filteredCustomerList.length / itemsPerPage).ceil();
//       if (currentPage > totalPages) {
//         currentPage = totalPages > 0 ? totalPages : 1;
//       }
//     });
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:transacto/Components/AppBar/header.dart';
// import 'package:transacto/View/Dashboard_/Order/Order_Customar_section/Add_Customar.dart';
// import '../../../../Components/AppBar/HeaderTab.dart';
//
// class NumberOfOrderSection extends StatefulWidget {
//   final String customerName;
//
//   const NumberOfOrderSection({Key? key, required this.customerName})
//       : super(key: key);
//   @override
//   _NumberOfOrderSectionState createState() => _NumberOfOrderSectionState();
// }
//
// class _NumberOfOrderSectionState extends State<NumberOfOrderSection> {
//   int currentPage = 1; // Start with the first page
//   final int itemsPerPage = 6; // Number of items per page
//   List<Map<String, dynamic>> customerList = [
//     {
//       'name': 'Vaibhav Alone',
//       'phone': '1234567890',
//       'address': 'Dhaka',
//       'date': '2024-10-01'
//     },
//     {
//       'name': 'Mohua Amin',
//       'phone': '0987654321',
//       'address': 'Chittagong',
//       'date': '2024-10-02'
//     },
//     {
//       'name': 'Estiaq Noor',
//       'phone': '2345678901',
//       'address': 'Sylhet',
//       'date': '2024-10-03'
//     },
//     {
//       'name': 'Reaz Nahid',
//       'phone': '3456789012',
//       'address': 'Rajshahi',
//       'date': '2024-10-04'
//     },
//     {
//       'name': 'Rabbi Amin',
//       'phone': '4567890123',
//       'address': 'Khulna',
//       'date': '2024-10-05'
//     },
//     {
//       'name': 'Sakib Al Baky',
//       'phone': '5678901234',
//       'address': 'Barisal',
//       'date': '2024-10-06'
//     },
//     {
//       'name': 'Maria Nur',
//       'phone': '6789012345',
//       'address': 'Rangpur',
//       'date': '2024-10-07'
//     },
//     {
//       'name': 'Ahmed Baky',
//       'phone': '7890123456',
//       'address': 'Mymensingh',
//       'date': '2024-10-08'
//     },
//     // Add more customers as needed
//   ];
//
//   List<Map<String, dynamic>> filteredCustomerList = [];
//   String searchQuery = '';
//   String? selectedFilter;
//
//   @override
//   void initState() {
//     super.initState();
//     filteredCustomerList = customerList; // Initialize filtered list
//   }
//
//   void updateFilteredList() {
//     setState(() {
//       filteredCustomerList = customerList.where((customer) {
//         final matchesSearch =
//             customer['name'].toLowerCase().contains(searchQuery.toLowerCase());
//         final matchesFilter = selectedFilter == null
//             ? true
//             : filterByDateCondition(customer['date'], selectedFilter!);
//         return matchesSearch && matchesFilter;
//       }).toList();
//
//       // Reset to first page if the current page exceeds total pages after filtering
//       int totalPages = (filteredCustomerList.length / itemsPerPage).ceil();
//       if (currentPage > totalPages) {
//         currentPage = totalPages > 0 ? totalPages : 1;
//       }
//     });
//   }
//
//   bool filterByDateCondition(String dateString, String filter) {
//     DateTime now = DateTime.now();
//     DateTime pastDate;
//     if (filter == 'last7days') {
//       pastDate = now.subtract(Duration(days: 7));
//     } else if (filter == 'last30days') {
//       pastDate = now.subtract(Duration(days: 30));
//     } else {
//       return true;
//     }
//
//     DateTime customerDate = DateTime.parse(dateString);
//     return customerDate.isAfter(pastDate) && customerDate.isBefore(now);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 600; // Mobile breakpoint
//     final isTablet = screenWidth >= 600 && screenWidth < 1024;
//     final isDesktop = screenWidth >= 1024;
//
//     int totalPages = (filteredCustomerList.length / itemsPerPage)
//         .ceil(); // Calculate total pages
//     int startIndex = (currentPage - 1) * itemsPerPage;
//     int endIndex = startIndex + itemsPerPage;
//     endIndex = endIndex > filteredCustomerList.length
//         ? filteredCustomerList.length
//         : endIndex;
//     List<Map<String, dynamic>> currentCustomers =
//         filteredCustomerList.sublist(startIndex, endIndex);
//
//     return Column(
//       children: [
//         // Title
//         // Align(
//         //   alignment: Alignment.centerLeft,
//         //   child: Center(
//         //     child: Align(
//         //         alignment: Alignment.center,
//         //         child: Text(
//         //           'Recent Order',
//         //           style: GoogleFonts.poppins(
//         //             color: Colors.black,
//         //             fontSize: isMobile ? 24 : 35,
//         //             fontWeight: FontWeight.bold,
//         //           ),
//         //         )),
//         //   ),
//         // ),
//
//         SizedBox(height: 16),
//         //
//         // // Add Customer Button
//         // Row(
//         //   mainAxisAlignment: MainAxisAlignment.end,
//         //   children: [
//         //     _buildActionButton(
//         //         Icons.add, 'Add Orders', Colors.orange, Colors.white, isMobile),
//         //   ],
//         // ),
//         //
//         SizedBox(height: 16),
//         //
//         // // Search and Filter Row
//         _buildSearchAndFilterRow(isMobile, isTablet, isDesktop),
//         //
//         SizedBox(height: 16),
//         //
//         // // Customer List with Headings or ListView
//         // _buildDesktopCustomerTable(currentCustomers),
//         // _buildMobileTabletCustomerList(currentCustomers),
//         Container(
//           child: isDesktop
//               ? _buildDesktopCustomerTable(currentCustomers)
//               : _buildMobileTabletCustomerList(currentCustomers),
//         ),
//         //
//         SizedBox(height: 16),
//         //
//         // // Pagination Row
//         _buildPaginationRow(totalPages),
//       ],
//     );
//   }
//
//   // Search and Filter Row Widget
//   Widget _buildSearchAndFilterRow(
//       bool isMobile, bool isTablet, bool isDesktop) {
//     return isDesktop
//         ? Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Search and Filter
//               Row(
//                 children: [
//                   Icon(Icons.filter_list, color: Colors.grey),
//                   SizedBox(width: 8),
//                   Container(
//                     width: 300,
//                     child: TextField(
//                       onChanged: (value) {
//                         searchQuery = value;
//                         updateFilteredList(); // Update list on search
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'Search customer...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   // Dropdown Filter
//                   Container(
//                     width: 200,
//                     padding: EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: selectedFilter,
//                         hint: Text('Filter by Date'), // Placeholder text
//                         isExpanded:
//                             true, // Ensures the dropdown takes full width
//                         items: [
//                           DropdownMenuItem<String>(
//                             value: 'last7days',
//                             child: Text('Last 7 Days'),
//                           ),
//                           DropdownMenuItem<String>(
//                             value: 'last30days',
//                             child: Text('Last 30 Days'),
//                           ),
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             selectedFilter = value;
//                             updateFilteredList();
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // Sort and More Options
//               Row(
//                 children: [
//                   Icon(Icons.sort, color: Colors.grey),
//                   SizedBox(width: 8),
//                   Icon(Icons.more_vert, color: Colors.grey),
//                 ],
//               ),
//             ],
//           )
//         : Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Search Field
//               Row(
//                 children: [
//                   Icon(Icons.search, color: Colors.grey),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: TextField(
//                       onChanged: (value) {
//                         searchQuery = value;
//                         updateFilteredList(); // Update list on search
//                       },
//                       decoration: InputDecoration(
//                         hintText: 'Search customer...',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         contentPadding: EdgeInsets.symmetric(horizontal: 12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               // Filter Dropdown
//               Row(
//                 children: [
//                   Icon(Icons.filter_list, color: Colors.grey),
//                   SizedBox(width: 8),
//                   Expanded(
//                     child: Container(
//                       padding: EdgeInsets.symmetric(horizontal: 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           value: selectedFilter,
//                           hint: Text('Filter by Date'), // Placeholder text
//                           isExpanded:
//                               true, // Ensures the dropdown takes full width
//                           items: [
//                             DropdownMenuItem<String>(
//                               value: 'last7days',
//                               child: Text('Last 7 Days'),
//                             ),
//                             DropdownMenuItem<String>(
//                               value: 'last30days',
//                               child: Text('Last 30 Days'),
//                             ),
//                           ],
//                           onChanged: (value) {
//                             setState(() {
//                               selectedFilter = value;
//                               updateFilteredList();
//                             });
//                           },
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               // Sort and More Options
//               Row(
//                 children: [
//                   Icon(Icons.sort, color: Colors.grey),
//                   SizedBox(width: 8),
//                   Icon(Icons.more_vert, color: Colors.grey),
//                 ],
//               ),
//             ],
//           );
//   }
//
//   // Desktop Customer Table
//   Widget _buildDesktopCustomerTable(List<Map<String, dynamic>> customers) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal, // Enable horizontal scrolling
//       child: DataTable(
//         headingRowHeight: 60, // Header height
//         dataRowHeight: 45, // Increased row height to allow text wrapping
//         columnSpacing: 120, // General space between columns
//         columns: [
//           DataColumn(
//             label: _buildConstrainedHeader('Sr.No', minWidth: 50, maxWidth: 60),
//           ),
//           DataColumn(
//             label: _buildConstrainedHeader('Vendor Name',
//                 minWidth: 50, maxWidth: 200),
//           ),
//           DataColumn(
//             label: _buildConstrainedHeader('Phone Number',
//                 minWidth: 50, maxWidth: 200),
//           ),
//           DataColumn(
//             label: _buildConstrainedHeader('Address',
//                 minWidth: 50, maxWidth: 200),
//           ),
//           DataColumn(
//             label: _buildConstrainedHeader('Date', minWidth: 50, maxWidth: 200),
//           ),
//           DataColumn(
//             label: _buildConstrainedHeader('Action', minWidth: 10, maxWidth: 200),
//           ),
//         ],
//         rows: List.generate(itemsPerPage, (index) {
//           if (index < customers.length) {
//             final customer = customers[index];
//             return DataRow(
//               cells: [
//                 DataCell(_buildConstrainedCell(
//                     '${(currentPage - 1) * itemsPerPage + index + 1}',
//                     minWidth: 50,
//                     maxWidth: 60)),
//                 DataCell(_buildWrappedTextCell(customer['name'], maxLines: 3)), // Wrap for long names
//                 DataCell(_buildTextCell(customer['phone'])),
//                 DataCell(_buildWrappedTextCell(customer['address'], maxLines: 3)), // Wrap for long addresses
//                 DataCell(_buildTextCell(customer['date'])),
//                 DataCell(
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.edit, color: Colors.blue),
//                         onPressed: () {
//                           // Edit customer logic
//                         },
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.delete, color: Colors.red),
//                         onPressed: () {
//                           _confirmDeletion(customer);
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             // Empty row logic
//             return DataRow(
//               cells: List.generate(6, (index) => DataCell(SizedBox.expand())),
//             );
//           }
//         }),
//       ),
//     );
//   }
//
// // Helper function to build constrained headers
//   Widget _buildConstrainedHeader(String text,
//       {double minWidth = 130, double maxWidth = 230}) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
//       child: Text(
//         text,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
//         overflow: TextOverflow.ellipsis, // Prevent overflow in headers
//       ),
//     );
//   }
//
// // Helper function to build wrapped text cells for long content
//   Widget _buildWrappedTextCell(String text, {int maxLines = 3}) {
//     return ConstrainedBox(
//       constraints:
//           BoxConstraints(minWidth: 150, maxWidth: 300), // Adjust column width
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 16),
//         overflow: TextOverflow.visible, // Ensure full content is shown
//         softWrap: true, // Enable wrapping to the next line
//         maxLines: maxLines, // Optional: Limit the number of lines
//       ),
//     );
//   }
//
// // Helper function to build general text cells
//   Widget _buildTextCell(String text) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(
//           minWidth: 130, maxWidth: 230), // General width constraints
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 16),
//         overflow: TextOverflow.ellipsis, // Prevent overflow
//         softWrap: false, // No wrapping for short content
//       ),
//     );
//   }
//
// // Helper function to build constrained cells for non-wrapped content
//   Widget _buildConstrainedCell(String text,
//       {double minWidth = 130, double maxWidth = 230}) {
//     return ConstrainedBox(
//       constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 16),
//         overflow: TextOverflow.ellipsis, // Prevent overflow
//         softWrap: false, // No wrapping
//       ),
//     );
//   }
//
//   // Mobile and Tablet Customer List
//   // Mobile and Tablet Customer List
//   Widget _buildMobileTabletCustomerList(List<Map<String, dynamic>> customers) {
//     return ListView.builder(
//       shrinkWrap: true, // Add this line
//       physics: NeverScrollableScrollPhysics(), // Add this line
//       itemCount: customers.length,
//       itemBuilder: (context, index) {
//         final customer = customers[index];
//         return Card(
//           margin: EdgeInsets.symmetric(vertical: 8),
//           elevation: 2,
//           child: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Sr.No: ${(currentPage - 1) * itemsPerPage + index + 1}',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 8),
//                 Text('Name: ${customer['name']}'),
//                 SizedBox(height: 4),
//                 Text('Phone: ${customer['phone']}'),
//                 SizedBox(height: 4),
//                 Text('Address: ${customer['address']}'),
//                 SizedBox(height: 4),
//                 Text('Date: ${customer['date']}'),
//                 SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () {
//                         // Edit customer logic
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete, color: Colors.red),
//                       onPressed: () {
//                         _confirmDeletion(customer);
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // Pagination Row Widget
//   Widget _buildPaginationRow(int totalPages) {
//     if (totalPages <= 1) return SizedBox.shrink();
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // Previous button
//         IconButton(
//           icon: Icon(Icons.chevron_left),
//           onPressed: currentPage > 1
//               ? () {
//                   setState(() {
//                     currentPage--;
//                   });
//                 }
//               : null,
//         ),
//         // Page numbers
//         Row(
//           children: [
//             for (int i = 1; i <= totalPages; i++)
//               _buildPageButton(i, currentPage == i),
//           ],
//         ),
//         // Next button
//         IconButton(
//           icon: Icon(Icons.chevron_right),
//           onPressed: currentPage < totalPages
//               ? () {
//                   setState(() {
//                     currentPage++;
//                   });
//                 }
//               : null,
//         ),
//       ],
//     );
//   }
//
//   // Page Button Widget
//   Widget _buildPageButton(int pageNumber, bool isActive) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           currentPage = pageNumber;
//         });
//       },
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         margin: EdgeInsets.symmetric(horizontal: 4.0),
//         decoration: BoxDecoration(
//           color: isActive ? Colors.orange : Colors.grey[300],
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Text(
//           '$pageNumber',
//           style: TextStyle(color: isActive ? Colors.white : Colors.black),
//         ),
//       ),
//     );
//   }
//
//   // Action Button Widget
//   Widget _buildActionButton(IconData icon, String text, Color bgColor,
//       Color textColor, bool isMobile) {
//     return ElevatedButton.icon(
//       onPressed: () {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AddOrderCustomerPage(
//               onAddCustomer: (Map<String, dynamic> customerData) {
//                 // Update the customer list with new customer data
//                 setState(() {
//                   customerList
//                       .add(customerData); // Add the new customer to the list
//                   updateFilteredList(); // Update filtered list after adding a customer
//                 });
//                 print("Customer added: $customerData");
//               },
//               existingCustomer: {},
//             );
//           },
//         );
//       },
//       icon: Icon(icon, color: textColor),
//       label: Text(text, style: TextStyle(color: textColor)),
//       style: ElevatedButton.styleFrom(
//         backgroundColor: bgColor,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         padding: isMobile
//             ? EdgeInsets.symmetric(horizontal: 12, vertical: 8)
//             : EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//     );
//   }
//
//   // Confirmation Dialog for Deletion
//   void _confirmDeletion(Map<String, dynamic> customer) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Delete Customer'),
//           content: Text('Are you sure you want to delete ${customer['name']}?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   // Find the customer by matching name, phone, and address
//                   int actualIndex = customerList.indexWhere((c) =>
//                       c['name'] == customer['name'] &&
//                       c['phone'] == customer['phone'] &&
//                       c['address'] == customer['address']);
//                   if (actualIndex != -1) {
//                     customerList
//                         .removeAt(actualIndex); // Remove customer from the list
//                     updateFilteredList(); // Update filtered list after deletion
//                   }
//                 });
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text('Delete'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transacto/Components/AppBar/header.dart';
import 'package:transacto/View/Dashboard_/Order/Order_Customar_section/Add_Customar.dart';

class NumberOfOrderSection extends StatefulWidget {
  final String customerName;

  const NumberOfOrderSection({Key? key, required this.customerName})
      : super(key: key);
  @override
  _NumberOfOrderSectionState createState() => _NumberOfOrderSectionState();
}

class _NumberOfOrderSectionState extends State<NumberOfOrderSection> {
  int currentPage = 1; // Start with the first page
  final int itemsPerPage = 6; // Number of items per page
  List<Map<String, dynamic>> customerList = [
    {
      'name': '5263',
      'phone': '1234567890',

      'date': '2024-10-01'
    },
    {
      'name': '5236',
      'phone': '0987654321',

      'date': '2024-10-02'
    },
    {
      'name': '8523',
      'phone': '2345678901',

      'date': '2024-10-03'
    },
    {
      'name': '8563',
      'phone': '3456789012',

      'date': '2024-10-04'
    },
    {
      'name': '9631',
      'phone': '4567890123',

      'date': '2024-10-05'
    },
    {
      'name': '8645',
      'phone': '5678901234',

      'date': '2024-10-06'
    },
    {
      'name': '9635',
      'phone': '6789012345',

      'date': '2024-10-07'
    },
    {
      'name': '8625',
      'phone': '7890123456',
      'date': '2024-10-08'
    },
    // Add more customers as needed
  ];

  List<Map<String, dynamic>> filteredCustomerList = [];
  String searchQuery = '';
  String? selectedFilter;

  @override
  void initState() {
    super.initState();
    filteredCustomerList = customerList; // Initialize filtered list
  }

  void updateFilteredList() {
    setState(() {
      filteredCustomerList = customerList.where((customer) {
        final matchesSearch =
        customer['name'].toLowerCase().contains(searchQuery.toLowerCase());
        final matchesFilter = selectedFilter == null
            ? true
            : filterByDateCondition(customer['date'], selectedFilter!);
        return matchesSearch && matchesFilter;
      }).toList();

      // Reset to first page if the current page exceeds total pages after filtering
      int totalPages = (filteredCustomerList.length / itemsPerPage).ceil();
      if (currentPage > totalPages) {
        currentPage = totalPages > 0 ? totalPages : 1;
      }
    });
  }

  bool filterByDateCondition(String dateString, String filter) {
    DateTime now = DateTime.now();
    DateTime pastDate;
    if (filter == 'last7days') {
      pastDate = now.subtract(Duration(days: 7));
    } else if (filter == 'last30days') {
      pastDate = now.subtract(Duration(days: 30));
    } else {
      return true;
    }

    DateTime customerDate = DateTime.parse(dateString);
    return customerDate.isAfter(pastDate) && customerDate.isBefore(now);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600; // Mobile breakpoint
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    int totalPages = (filteredCustomerList.length / itemsPerPage)
        .ceil(); // Calculate total pages
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    endIndex = endIndex > filteredCustomerList.length
        ? filteredCustomerList.length
        : endIndex;
    List<Map<String, dynamic>> currentCustomers =
    filteredCustomerList.sublist(startIndex, endIndex);

    return Column(
      children: [
        // Title
        // Align(
        //   alignment: Alignment.centerLeft,
        //   child: Center(
        //     child: Align(
        //         alignment: Alignment.center,
        //         child: Text(
        //           'Recent Order',
        //           style: GoogleFonts.poppins(
        //             color: Colors.black,
        //             fontSize: isMobile ? 24 : 35,
        //             fontWeight: FontWeight.bold,
        //           ),
        //         )),
        //   ),
        // ),

        SizedBox(height: 16),
        //
        // // Add Customer Button
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     _buildActionButton(
        //         Icons.add, 'Add Orders', Colors.orange, Colors.white, isMobile),
        //   ],
        // ),
        //
        SizedBox(height: 16),
        //
        // // Search and Filter Row
        _buildSearchAndFilterRow(isMobile, isTablet, isDesktop),
        //
        SizedBox(height: 16),
        //
        // // Customer List with Headings or ListView
        // _buildDesktopCustomerTable(currentCustomers),
        // _buildMobileTabletCustomerList(currentCustomers),
        Container(
          child: isDesktop
              ? _buildDesktopCustomerTable(currentCustomers)
              : _buildMobileTabletCustomerList(currentCustomers),
        ),
        //
        SizedBox(height: 16),
        //
        // // Pagination Row
        _buildPaginationRow(totalPages),
      ],
    );
  }

  // Search and Filter Row Widget
  Widget _buildSearchAndFilterRow(
      bool isMobile, bool isTablet, bool isDesktop) {
    return isDesktop
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Search and Filter
        Row(
          children: [
            Icon(Icons.filter_list, color: Colors.grey),
            SizedBox(width: 8),
            // Container(
            //   width: 300,
            //   child: TextField(
            //     onChanged: (value) {
            //       searchQuery = value;
            //       updateFilteredList(); // Update list on search
            //     },
            //     decoration: InputDecoration(
            //       hintText: 'Search customer...',
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       contentPadding: EdgeInsets.symmetric(horizontal: 12),
            //     ),
            //   ),
            // ),
            SizedBox(width: 16),
            // Dropdown Filter
            Container(
              width: 200,
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedFilter,
                  hint: Text('Filter by Date'), // Placeholder text
                  isExpanded:
                  true, // Ensures the dropdown takes full width
                  items: [
                    DropdownMenuItem<String>(
                      value: 'last7days',
                      child: Text('Last 7 Days'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'last30days',
                      child: Text('Last 30 Days'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedFilter = value;
                      updateFilteredList();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        // Sort and More Options
        Row(
          children: [
            Icon(Icons.sort, color: Colors.grey),
            SizedBox(width: 8),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ],
    )
        : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Field
        // Row(
        //   children: [
        //     Icon(Icons.search, color: Colors.grey),
        //     SizedBox(width: 8),
        //     Expanded(
        //       child: TextField(
        //         onChanged: (value) {
        //           searchQuery = value;
        //           updateFilteredList(); // Update list on search
        //         },
        //         decoration: InputDecoration(
        //           hintText: 'Search customer...',
        //           border: OutlineInputBorder(
        //             borderRadius: BorderRadius.circular(8),
        //           ),
        //           contentPadding: EdgeInsets.symmetric(horizontal: 12),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        SizedBox(height: 16),
        // Filter Dropdown
        Row(
          children: [
            Icon(Icons.filter_list, color: Colors.grey),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedFilter,
                    hint: Text('Filter by Date'), // Placeholder text
                    isExpanded:
                    true, // Ensures the dropdown takes full width
                    items: [
                      DropdownMenuItem<String>(
                        value: 'last7days',
                        child: Text('Last 7 Days'),
                      ),
                      DropdownMenuItem<String>(
                        value: 'last30days',
                        child: Text('Last 30 Days'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedFilter = value;
                        updateFilteredList();
                      });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        // Sort and More Options
        Row(
          children: [
            Icon(Icons.sort, color: Colors.grey),
            SizedBox(width: 8),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ],
    );
  }

  // Desktop Customer Table
  Widget _buildDesktopCustomerTable(List<Map<String, dynamic>> customers) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: DataTable(
        headingRowHeight: 60, // Header height
        dataRowHeight: 45, // Increased row height to allow text wrapping
        columnSpacing: 120, // General space between columns
        columns: [
          DataColumn(
            label: _buildConstrainedHeader('Sr.No', minWidth: 50, maxWidth: 60),
          ),
          DataColumn(
            label: _buildConstrainedHeader('Order Amount',
                minWidth: 50, maxWidth: 200),
          ),
          DataColumn(
            label: _buildConstrainedHeader('Order ID',
                minWidth: 50, maxWidth: 200),
          ),
          // DataColumn(
          //   label: _buildConstrainedHeader('Address',
          //       minWidth: 50, maxWidth: 200),
          // ),
          DataColumn(
            label: _buildConstrainedHeader('Date', minWidth: 50, maxWidth: 200),
          ),
          DataColumn(
            label: _buildConstrainedHeader('Action', minWidth: 10, maxWidth: 200),
          ),
        ],
        rows: List.generate(itemsPerPage, (index) {
          if (index < customers.length) {
            final customer = customers[index];
            return DataRow(
              cells: [
                DataCell(_buildConstrainedCell(
                    '${(currentPage - 1) * itemsPerPage + index + 1}',
                    minWidth: 50,
                    maxWidth: 60)),
                DataCell(_buildWrappedTextCell(customer['name'], maxLines: 3)), // Wrap for long names
                DataCell(_buildTextCell(customer['phone'])),
                // DataCell(_buildWrappedTextCell(customer['address'], maxLines: 3)), // Wrap for long addresses
                DataCell(_buildTextCell(customer['date'])),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Edit customer logic
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDeletion(customer);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Empty row logic
            return DataRow(
              cells: List.generate(5, (index) => DataCell(SizedBox.expand())),
            );
          }
        }),
      ),
    );
  }

// Helper function to build constrained headers
  Widget _buildConstrainedHeader(String text,
      {double minWidth = 130, double maxWidth = 230}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        overflow: TextOverflow.ellipsis, // Prevent overflow in headers
      ),
    );
  }

// Helper function to build wrapped text cells for long content
  Widget _buildWrappedTextCell(String text, {int maxLines = 3}) {
    return ConstrainedBox(
      constraints:
      BoxConstraints(minWidth: 150, maxWidth: 300), // Adjust column width
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
        overflow: TextOverflow.visible, // Ensure full content is shown
        softWrap: true, // Enable wrapping to the next line
        maxLines: maxLines, // Optional: Limit the number of lines
      ),
    );
  }

// Helper function to build general text cells
  Widget _buildTextCell(String text) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          minWidth: 130, maxWidth: 230), // General width constraints
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
        overflow: TextOverflow.ellipsis, // Prevent overflow
        softWrap: false, // No wrapping for short content
      ),
    );
  }

// Helper function to build constrained cells for non-wrapped content
  Widget _buildConstrainedCell(String text,
      {double minWidth = 130, double maxWidth = 230}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth, maxWidth: maxWidth),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
        overflow: TextOverflow.ellipsis, // Prevent overflow
        softWrap: false, // No wrapping
      ),
    );
  }

  // Mobile and Tablet Customer List
  // Mobile and Tablet Customer List
  Widget _buildMobileTabletCustomerList(List<Map<String, dynamic>> customers) {
    return ListView.builder(
      shrinkWrap: true, // Add this line
      physics: NeverScrollableScrollPhysics(), // Add this line
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sr.No: ${(currentPage - 1) * itemsPerPage + index + 1}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text('Order Amount: ${customer['name']}'),
                SizedBox(height: 4),
                Text('Order ID: ${customer['phone']}'),
                SizedBox(height: 4),
                // Text('Address: ${customer['address']}'),
                SizedBox(height: 4),
                Text('Date: ${customer['date']}'),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Edit customer logic
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _confirmDeletion(customer);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Pagination Row Widget
  Widget _buildPaginationRow(int totalPages) {
    if (totalPages <= 1) return SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous button
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: currentPage > 1
              ? () {
            setState(() {
              currentPage--;
            });
          }
              : null,
        ),
        // Page numbers
        Row(
          children: [
            for (int i = 1; i <= totalPages; i++)
              _buildPageButton(i, currentPage == i),
          ],
        ),
        // Next button
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: currentPage < totalPages
              ? () {
            setState(() {
              currentPage++;
            });
          }
              : null,
        ),
      ],
    );
  }

  // Page Button Widget
  Widget _buildPageButton(int pageNumber, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentPage = pageNumber;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.orange : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          '$pageNumber',
          style: TextStyle(color: isActive ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // Action Button Widget
  Widget _buildActionButton(IconData icon, String text, Color bgColor,
      Color textColor, bool isMobile) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AddOrderCustomerPage(
              onAddCustomer: (Map<String, dynamic> customerData) {
                // Update the customer list with new customer data
                setState(() {
                  customerList
                      .add(customerData); // Add the new customer to the list
                  updateFilteredList(); // Update filtered list after adding a customer
                });
                print("Customer added: $customerData");
              },
              existingCustomer: {},
            );
          },
        );
      },
      icon: Icon(icon, color: textColor),
      label: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: isMobile
            ? EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Confirmation Dialog for Deletion
  void _confirmDeletion(Map<String, dynamic> customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Data'),
          content: Text('Are you sure you want to delete'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Find the customer by matching name, phone, and address
                  int actualIndex = customerList.indexWhere((c) =>
                  c['name'] == customer['name'] &&
                      c['phone'] == customer['phone'] );
                      // c['address'] == customer['address']);
                  if (actualIndex != -1) {
                    customerList
                        .removeAt(actualIndex); // Remove customer from the list
                    updateFilteredList(); // Update filtered list after deletion
                  }
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child:  Text('Delete',style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }
}
