
import 'package:flutter/material.dart';
import 'package:transacto/Components/AppBar/header.dart';

class AddOrderCustomerPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onAddCustomer;
  final Map<String, String> existingCustomer;

  AddOrderCustomerPage({
    required this.onAddCustomer,
    required this.existingCustomer,
  });

  @override
  _AddOrderCustomerPageState createState() => _AddOrderCustomerPageState();
}

class _AddOrderCustomerPageState extends State<AddOrderCustomerPage> {
  List<Map<String, TextEditingController>> productList = [];
  double _calculatedTotalAmount = 0.0;
  List<String> customerNames = [];
  List<String> productNames = [];
  String? selectedCustomer;
  List<String?> selectedProducts = [];

  // Controllers for phone number and address
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addProductRow();
    fetchCustomers();
    fetchProducts();
    selectedCustomer = widget.existingCustomer['name'];
    phoneController.text = widget.existingCustomer['phone'] ?? '';
    addressController.text = widget.existingCustomer['address'] ?? '';
  }

  void fetchCustomers() {
    customerNames = ['Customer 1', 'Customer 2', 'Customer 3'];
  }

  void fetchProducts() {
    productNames = ['Product A', 'Product B', 'Product C'];
  }

  void addProductRow() {
    setState(() {
      productList.add({
        'product': TextEditingController(),
        'quantity': TextEditingController(),
        'amount': TextEditingController(),
      });
      selectedProducts.add(null);
    });
  }

  void removeProductRow(int index) {
    setState(() {
      productList.removeAt(index);
      selectedProducts.removeAt(index);
    });
    calculateTotalAmount(); // Recalculate after removal
  }

  void calculateTotalAmount() {
    double totalAmount = 0.0;

    for (var controllers in productList) {
      int quantity = int.tryParse(controllers['quantity']!.text) ?? 0;
      double amount = double.tryParse(controllers['amount']!.text) ?? 0.0;
      totalAmount += quantity * amount;
    }

    setState(() {
      _calculatedTotalAmount = totalAmount;
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
      return {
        'product': selectedProducts[productList.indexOf(controllers)] ??
            'Unknown Product',
        'quantity': int.tryParse(controllers['quantity']!.text) ?? 0,
        'amount': double.tryParse(controllers['amount']!.text) ?? 0.0,
      };
    }).toList();

    Map<String, dynamic> customerData = {
      'name': selectedCustomer ?? 'Unknown Customer',
      'phone': phoneController.text,
      'address': addressController.text,
      'products': products,
      'totalAmount': _calculatedTotalAmount,
      'date': DateTime.now().toString().split(' ')[0],
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Preview Customer Data',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content:SizedBox(
          width: double.maxFinite, // Responsive width
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Information
                _buildSectionTitle('Customer Details'),
                SizedBox(height: 10),
                _buildInfoRow('Name:', customerData['name']),
                SizedBox(height: 5),
                _buildInfoRow('Phone:', customerData['phone']),
                SizedBox(height: 5),
                _buildInfoRow('Address:', customerData['address']),
                SizedBox(height: 20),

                // Products Information
                _buildSectionTitle('Products'),
                Divider(),
                ...products.map<Widget>((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(product['product'],
                              style: TextStyle(fontSize: 16)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text('Qty: ${product['quantity']}',
                              style: TextStyle(fontSize: 16)),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                              'Amount: \$${product['amount'].toStringAsFixed(2)}',
                              style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                SizedBox(height: 20),

                // Total Amount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align to the right
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 600 ? 13 : 20, // Adjust font size for mobile
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(width: 8), // Space between label and amount
                    Text(
                      'Rs ${customerData['totalAmount'].toStringAsFixed(2)}', // Use Rs instead of $
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 600 ? 13 : 20, // Adjust font size for mobile
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // Date
                _buildInfoRow('Date:', customerData['date']),
              ],
            ),
          ),
        ),


        actions: [
          ElevatedButton(
            onPressed: () {
              widget.onAddCustomer(customerData);
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

  void updateCustomerDetails(String? customerName) {
    if (customerName == 'Customer 1') {
      phoneController.text = '123-456-7890'; // Example phone number
      addressController.text = '123 Main St, City, Country'; // Example address
    } else if (customerName == 'Customer 2') {
      phoneController.text = '987-654-3210'; // Example phone number
      addressController.text = '456 Elm St, City, Country'; // Example address
    } else if (customerName == 'Customer 3') {
      phoneController.text = '555-555-5555'; // Example phone number
      addressController.text = '789 Maple St, City, Country'; // Example address
    } else {
      phoneController.clear();
      addressController.clear();
    }
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
                'Place Order',
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
                                          updateCustomerDetails(newValue);
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
                                    'Phone Number',
                                    TextField(
                                      controller: phoneController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter phone number',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 15.0),
                                      ),
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),

                                // Address
                                Expanded(
                                  flex: 1,
                                  child: buildContainer(
                                    'Address',
                                    TextField(
                                      controller: addressController,
                                      decoration: InputDecoration(
                                        hintText: 'Enter address',
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
                                        updateCustomerDetails(newValue);
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
                                  'Phone Number',
                                  TextField(
                                    controller: phoneController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter phone number',
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
                                  'Address',
                                  TextField(
                                    controller: addressController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter address',
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
                        'Products',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent),
                      ),
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
                                          'Select Product',
                                          DropdownButton<String>(
                                            value: selectedProducts[index],
                                            hint: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text('Select Product'),
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
                                          'Quantity',
                                          TextField(
                                            controller: controllers['quantity'],
                                            decoration: InputDecoration(
                                              hintText: 'Enter quantity',
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 15.0),
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              calculateTotalAmount();
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20),

                                      // Amount
                                      Expanded(
                                        flex: 1,
                                        child: buildContainer(
                                          'Amount',
                                          TextField(
                                            controller: controllers['amount'],
                                            decoration: InputDecoration(
                                              hintText: 'Enter amount',
                                              border: InputBorder.none,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 15.0),
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              calculateTotalAmount();
                                            },
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 20),

                                      // Remove Button
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.remove_circle),
                                            onPressed: () {
                                              removeProductRow(index);
                                            },
                                            color: Colors.red,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                : Column(
                                    // Mobile view
                                    children: [
                                      // Select Product
                                      buildContainer(
                                        'Select Product',
                                        DropdownButton<String>(
                                          value: selectedProducts[index],
                                          hint: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text('Select Product'),
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
                                        'Quantity',
                                        TextField(
                                          controller: controllers['quantity'],
                                          decoration: InputDecoration(
                                            hintText: 'Enter quantity',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 15.0),
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            calculateTotalAmount();
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),

                                      // Amount
                                      buildContainer(
                                        'Amount mobile',
                                        TextField(
                                          controller: controllers['amount'],
                                          decoration: InputDecoration(
                                            hintText: 'Enter amount',
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 15.0),
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            calculateTotalAmount();
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 10),

                                      // Remove Button
                                      IconButton(
                                        icon: Icon(Icons.remove_circle),
                                        onPressed: () {
                                          removeProductRow(index);
                                        },
                                        color: Colors.red,
                                      ),
                                    ],
                                  ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),

                      // Add Product Button
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Row for Total Amount aligned to the right
                          Padding(
                            padding: EdgeInsets.only(right: MediaQuery.of(context).size.width >= 600 ? 60 : 10), // Apply padding only for larger screens
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Amount: Rs ${_calculatedTotalAmount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width < 600 ? 13 : 20, // Adjust font size for mobile
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10), // Space between the rows
                          // Centered Add Product Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                onPressed: addProductRow,
                                icon: Icon(Icons.add),
                                label: Text('Add Product'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),


                    ],
                  ),
                ),
              ),

              // SizedBox(height: 30),
              //
              // // Total Amount
              // Align(
              //   alignment: Alignment.centerRight,
              //   child: Text(
              //     'Total Amount web: \$${_calculatedTotalAmount.toStringAsFixed(2)}',
              //     style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.green),
              //   ),
              // ),
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
