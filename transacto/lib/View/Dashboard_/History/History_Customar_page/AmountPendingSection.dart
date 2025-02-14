

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transacto/Components/AppBar/header.dart';
import 'package:transacto/View/Dashboard_/Order/Order_Customar_section/Add_Customar.dart';

class AmountPendingSection extends StatefulWidget {
  final String customerName;

  const AmountPendingSection({Key? key, required this.customerName})
      : super(key: key);
  @override
  _AmountPendingSectionState createState() => _AmountPendingSectionState();
}

class _AmountPendingSectionState extends State<AmountPendingSection> {
  int currentPage = 1; // Start with the first page
  final int itemsPerPage = 1; // Number of items per page
  List<Map<String, dynamic>> customerList = [
    {'name': '5263', 'phone': '1780', 'pending': '522', 'date': '2024-10-01'},

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
      child: Card(
        elevation: 4, // Card shadow
        margin: const EdgeInsets.all(10.0), // Margin around the card
        child: Container(
          width: 900,
          height: 200,
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Heading Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildConstrainedHeader('Order Amount', minWidth: 50, maxWidth: 200),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildConstrainedHeader('Amount Paid', minWidth: 50, maxWidth: 200),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildConstrainedHeader('Amount Pending', minWidth: 50, maxWidth: 200),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildConstrainedHeader('Date', minWidth: 50, maxWidth: 200),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Expanded(
                      flex: 2,
                      child: _buildConstrainedHeader('Action', minWidth: 10, maxWidth: 100),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.black,), // Optional divider for separation
              SizedBox(height: 20,),

              // Data Rows
              Column(
                children: List.generate(itemsPerPage, (index) {
                  if (index < customers.length) {
                    final customer = customers[index];
                    return Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Expanded(
                            flex: 2,
                            child: _buildWrappedTextCell(customer['name'].toString(), maxLines: 3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40),
                          child: Expanded(
                            flex: 2,
                            child: _buildTextCell(customer['phone'].toString()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Expanded(
                            flex: 2,
                            child: _buildTextCell(customer['pending'].toString()),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 60),
                          child: Expanded(
                            flex: 2,
                            child: _buildTextCell(customer['date']),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
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
                        ),
                      ],
                    );
                  } else {
                    // Empty row logic
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (index) => Expanded(child: SizedBox.expand())),
                    );
                  }
                }),
              ),
            ],
          ),
        ),
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
                // Text(
                //   'Sr.No: ${(currentPage - 1) * itemsPerPage + index + 1}',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                SizedBox(height: 8),
                Text('Order Amount : ${customer['name']}'),
                SizedBox(height: 7),
                Text('Amount Paid: ${customer['phone']}'),
                SizedBox(height: 7),
                Text('Amount Pending: ${customer['pending']}'),
                SizedBox(height: 7),
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
                      c['phone'] == customer['phone']);
                  // c['address'] == customer['address']);
                  if (actualIndex != -1) {
                    customerList
                        .removeAt(actualIndex); // Remove customer from the list
                    updateFilteredList(); // Update filtered list after deletion
                  }
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete',style: TextStyle(color: Colors.white)),
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
