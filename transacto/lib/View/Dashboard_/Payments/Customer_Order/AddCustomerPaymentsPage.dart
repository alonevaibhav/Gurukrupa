import 'package:flutter/material.dart';
import 'package:transacto/Components/AppBar/header.dart';

class AddCustomerPaymentsPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddPayment;
  final Map<String, String> existingPayment;

  AddCustomerPaymentsPage(
      {required this.onAddPayment, required this.existingPayment});

  @override
  _AddCustomerPaymentsPageState createState() =>
      _AddCustomerPaymentsPageState();
}

//web view
class _AddCustomerPaymentsPageState extends State<AddCustomerPaymentsPage> {
  List<Map<String, TextEditingController>> productList = [];
  double _calculatedTotalAmount = 0.0;
  List<String> customerNames = [];
  List<String> productNames = [];
  List<String> transactionIds = [];
  String? selectedCustomer;
  List<String?> selectedProducts = [];
  List<String?> selectedPaymentTypes = [];

  // Controllers for phone number and address
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addProductRow();
    fetchCustomers();
    fetchProducts();
    fetchTransactionIds(); // Add this line
    selectedCustomer = widget.existingPayment['name'];
    phoneController.text = widget.existingPayment['phone'] ?? '';
    addressController.text = widget.existingPayment['address'] ?? '';
  }

  void fetchCustomers() {
    customerNames = ['vaibhav 1', 'Customer 2', 'Customer 3', 'Customer 4', 'Customer 5'];
  }

  void fetchProducts() {
    productNames = ['Account A', 'Account B', 'Account C'];
  }

  void fetchTransactionIds() {
    transactionIds = ['Cash', 'UPI', 'Black', 'Hawala', 'Dark Web'];
  }

  void addProductRow() {
    setState(() {
      productList.add({
        'product': TextEditingController(),
        'paymentType': TextEditingController(),
        'amount': TextEditingController(),
      });
      selectedProducts.add(null);
      selectedPaymentTypes.add(null); // Add this line
    });
  }

  void showPreview(BuildContext context) {
    if (selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a customer.'),
      ));
      return;
    }

    List<Map<String, dynamic>> products = productList.map((controllers) {
      int index = productList
          .indexOf(controllers); // Find the index of the current product
      String paymentType = selectedPaymentTypes[index] ??
          'Unknown Payment Type'; // Get the payment type using the index

      return {
        'product': selectedProducts[productList.indexOf(controllers)] ??
            'Unknown Account',
        'paymentType': selectedPaymentTypes[productList.indexOf(controllers)] ??
            'Unknown Payment Type',
        // 'paymentType': double.tryParse(controllers['Paymenttype']!.text) ?? 0,
        'amount': double.tryParse(controllers['amount']!.text) ?? 0.0,
        // 'paymentType': paymentType, // Add paymentType to the product data
      };
    }).toList();

    Map<String, dynamic> PaymentCustomerData = {
      'name': selectedCustomer ?? 'Unknown Customer',
      'phone': phoneController.text,
      'address': addressController.text,
      'account': selectedProducts ?? 'Unknown Customer',
      'paymentType': selectedPaymentTypes ?? 'Unknown Payment',
      'products': products,
      'totalAmount': _calculatedTotalAmount,
      'date': DateTime.now().toString().split(' ')[0],
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(
          child: Text(
            'Preview Order Data Of Customer',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite, // Responsive width
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Information
                _buildSectionTitle('Payment Details'),
                SizedBox(height: 10),
                _buildInfoRow('Customer Name:', PaymentCustomerData['name']),
                SizedBox(height: 5),
                _buildInfoRow('Transaction ID:', PaymentCustomerData['phone']),
                SizedBox(height: 5),
                _buildInfoRow('Amount:', PaymentCustomerData['address']),
                // SizedBox(height: 20),

                // Products Information
                // _buildSectionTitle('Products'),
                // Divider(),
                ...products.map<Widget>((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text('Account : ${product['product']}',
                              style: TextStyle(fontSize: 16)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Payment : ${product['paymentType']}',
                              style: TextStyle(fontSize: 16)),
                        ),
                        // Expanded(
                        //   flex: 2,
                        //   child: Text(
                        //       'Amount: \$${product['amount'].toStringAsFixed(2)}',
                        //       style: TextStyle(fontSize: 16)),
                        // ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),

                // Total Amount
                // _buildInfoRow('Total Amount:',
                //     '\$${PaymentCustomerData['totalAmount'].toStringAsFixed(2)}',
                //     isTotal: true),
                SizedBox(height: 10),

                // Date
                _buildInfoRow('Date:', PaymentCustomerData['date']),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              widget.onAddPayment(PaymentCustomerData);
              Navigator.of(context).pop(); // Close the preview dialog
              Navigator.of(context).pop(); // Close the main page
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange, // Set background color to orange
              foregroundColor: Colors.white, // Set text color to white
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Confirm and Add Order',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the preview dialog
            },
            child: Text(
              'Close Preview',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width >
        600; // Adjust width threshold as needed

    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Title
              Text(
                'Add Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Customer Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      Text(
                        'Customer Information',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
                      SizedBox(height: 20),

                      // Use Column for mobile view and Row for wide screens
                      isWideScreen
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Select Customer
                                Expanded(
                                  flex: 1,
                                  child: buildContainer(
                                    'Select Customer',
                                    DropdownButton<String>(
                                      value: selectedCustomer,
                                      hint: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text('Select Customer'),
                                      ),
                                      isExpanded: true,
                                      underline: SizedBox.shrink(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedCustomer = newValue;
                                          // updateCustomerDetails(newValue);
                                        });
                                      },
                                      items: customerNames
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(value),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),

                                // Phone Number
                                Expanded(
                                  flex: 1,
                                  child: buildContainer(
                                    'Transaction ID',
                                    TextField(
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Transaction ID',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 15.0),
                                      ),
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ),
                                // Transaction ID

                                SizedBox(width: 20),

                                // Address
                                Expanded(
                                  flex: 1,
                                  child: buildContainer(
                                    'Amount',
                                    TextField(
                                      controller: addressController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter Amount',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                // Select Customer
                                buildContainer(
                                  'Select Customer',
                                  DropdownButton<String>(
                                    value: selectedCustomer,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text('Select Customer'),
                                    ),
                                    isExpanded: true,
                                    underline: SizedBox.shrink(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedCustomer = newValue;
                                        // updateCustomerDetails(newValue);
                                      });
                                    },
                                    items: customerNames
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Text(value),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Phone Number
                                buildContainer(
                                  'Transaction ID',
                                  TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Transaction ID',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 15.0),
                                    ),
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                                SizedBox(height: 20),

                                // Address
                                buildContainer(
                                  'Amount',
                                  TextField(
                                    controller: addressController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter Amount',
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 15.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Products Details Card
              // Products Details Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title
                      // Text(
                      //   'Products',
                      //   style: TextStyle(
                      //       fontSize: 20,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.blueAccent),
                      // ),
                      SizedBox(height: 20),

                      // Product Rows
                      Column(
                        children: productList.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, TextEditingController> controllers =
                              entry.value;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: MediaQuery.of(context).size.width >
                                    600 // Wide screen
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Select Product
                                      Expanded(
                                        flex: 1,
                                        child: buildContainer(
                                          'Select Account',
                                          DropdownButton<String>(
                                            value: selectedProducts[index],
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text('Select Account'),
                                            ),
                                            isExpanded: true,
                                            underline: SizedBox.shrink(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedProducts[index] =
                                                    newValue;
                                              });
                                            },
                                            items: productNames
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(value),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),

                                      // Quantity
                                      Expanded(
                                        flex: 1,
                                        child: buildContainer(
                                          'Payment Type',
                                          DropdownButton<String>(
                                            value: selectedPaymentTypes[index],
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child:
                                                  Text('Select Payment Type'),
                                            ),
                                            isExpanded: true,
                                            underline: SizedBox.shrink(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                selectedPaymentTypes[index] =
                                                    newValue;
                                              });
                                            },
                                            items: transactionIds
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(value),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 20),

                                      // Amount
                                      // Expanded(
                                      //   flex: 1,
                                      //   child: buildContainer(
                                      //     'Amount Web',
                                      //     TextField(
                                      //       controller: controllers['amount'],
                                      //       decoration: InputDecoration(
                                      //         hintText: 'Enter amount',
                                      //         border: InputBorder.none,
                                      //         contentPadding:
                                      //             EdgeInsets.symmetric(
                                      //                 horizontal: 8.0,
                                      //                 vertical: 15.0),
                                      //       ),
                                      //       keyboardType: TextInputType.number,
                                      //       onChanged: (value) {
                                      //         // calculateTotalAmount();
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                      SizedBox(width: 20),
                                    ],
                                  )
                                : Column(
                                    // Mobile view
                                    children: [
                                      // Select Product
                                      buildContainer(
                                        'Select Account',
                                        DropdownButton<String>(
                                          value: selectedProducts[index],
                                          hint: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text('Select Account'),
                                          ),
                                          isExpanded: true,
                                          underline: SizedBox.shrink(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedProducts[index] =
                                                  newValue;
                                            });
                                          },
                                          items: productNames
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(value),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(height: 10),

                                      // Quantity
                                      buildContainer(
                                        'Payment Type',
                                        DropdownButton<String>(
                                          value: selectedPaymentTypes[index],
                                          hint: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text('Select Account'),
                                          ),
                                          isExpanded: true,
                                          underline: SizedBox.shrink(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedPaymentTypes[index] =
                                                  newValue;
                                            });
                                          },
                                          items: transactionIds
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(value),
                                                  ),
                                                );
                                              }).toList(),
                                        ),
                                      ),
                                      SizedBox(height: 10),

                                      // Amount
                                      // buildContainer(
                                      //   'Amount',
                                      //   TextField(
                                      //     controller: controllers['amount'],
                                      //     decoration: InputDecoration(
                                      //       hintText: 'Enter amount',
                                      //       border: InputBorder.none,
                                      //       contentPadding:
                                      //           EdgeInsets.symmetric(
                                      //               horizontal: 8.0,
                                      //               vertical: 15.0),
                                      //     ),
                                      //     keyboardType: TextInputType.number,
                                      //     onChanged: (value) {
                                      //       // calculateTotalAmount();
                                      //     },
                                      //   ),
                                      // ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 30),

              SizedBox(height: 30),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    showPreview(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Preview Order',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContainer(String heading, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Label
        Text(
          heading,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),

        // Input Container
        Container(
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black),
          ),
          child: child,
        ),
      ],
    );
  }
}
