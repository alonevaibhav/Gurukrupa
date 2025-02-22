// import 'package:flutter/cupertino.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../Constants/api_con.dart';
//
// class Customer {
//   final int id;
//   final String name;
//   final String phoneNumber;
//   final String address;
//
//   Customer({
//     required this.id,
//     required this.name,
//     required this.phoneNumber,
//     required this.address,
//   });
// }
//
// class CustomerController extends GetxController {
//   var customers = <Customer>[].obs;
//   var currentPage = 1.obs;
//   var itemsPerPage = 7.obs;
//   var totalPages = 1.obs;
//
//   // Mapping from our UI int id to the backend's actual String _id.
//   final Map<int, String> _backendIdMapping = {};
//
//   // Text editing controllers for customer fields.
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadCustomers(); // Load customers on init.
//   }
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     super.onClose();
//   }
//
//   // Local update of customer (if needed).
//   void updateCustomer(int id) {
//     final index = customers.indexWhere((c) => c.id == id);
//     if (index != -1) {
//       customers[index] = Customer(
//         id: id,
//         name: nameController.text.trim(),
//         phoneNumber: phoneController.text.trim(),
//         address: addressController.text.trim(),
//       );
//       customers.refresh();
//       Get.snackbar('Success', 'Customer updated successfully',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   void deleteCustomer(int id) {
//     customers.removeWhere((c) => c.id == id);
//     calculateTotalPages();
//     Get.snackbar('Deleted', 'Customer has been removed',
//         snackPosition: SnackPosition.BOTTOM);
//   }
//
//   Future<void> loadCustomers() async {
//     final url = Uri.parse(baseUrl + getCustomer);
//     try {
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final List<dynamic> customerData = jsonDecode(response.body);
//
//         // Clear the mapping on every load.
//         _backendIdMapping.clear();
//
//         customers.value = customerData.map((json) {
//           // Retrieve the backend _id as a string.
//           final String backendId = json['_id'];
//           // Generate an int ID for the UI (using hashCode).
//           final int uiId = backendId.hashCode;
//           // Save the mapping for later use (e.g., in update calls).
//           _backendIdMapping[uiId] = backendId;
//           print("Customers loaded successfully");
//           print("_backendIdMapping: $_backendIdMapping");
//
//           return Customer(
//             id: uiId,
//             name: json['name'],
//             phoneNumber: json['contact'],
//             address: json['address'],
//           );
//           print("Customers loaded successfully");
//           print("_backendIdMapping: $_backendIdMapping");
//         }).toList();
//
//         calculateTotalPages();
//       } else {
//         Get.snackbar('Error', 'Failed to load customers',
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       print("Error: $e");
//       Get.snackbar('Error', 'Something went wrong: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   Future<void> postCustomer() async {
//     if (nameController.text.trim().isEmpty ||
//         phoneController.text.trim().isEmpty ||
//         addressController.text.trim().isEmpty) {
//       Get.snackbar('Error', 'Please fill in all fields',
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     final newCustomer = {
//       "name": nameController.text.trim(),
//       "contact": phoneController.text.trim(),
//       "address": addressController.text.trim(),
//     };
//
//     final url = Uri.parse(baseUrl + registerCustomer);
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(newCustomer),
//       );
//
//       print("Response Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//
//       if (response.statusCode == 201 || response.statusCode == 200) {
//         Get.snackbar('Success', 'Customer added successfully',
//             snackPosition: SnackPosition.BOTTOM);
//         nameController.clear();
//         phoneController.clear();
//         addressController.clear();
//         loadCustomers(); // Reload customers after adding a new one.
//       } else {
//         Get.snackbar('Error', 'Failed to add customer: ${response.body}',
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       print("Error: $e");
//       Get.snackbar('Error', 'Something went wrong: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   Future<void> updateCustomerAPI(Customer customer) async {
//     // Retrieve the backend _id from the mapping using the UI id.
//     final String? backendId = _backendIdMapping[customer.id];
//     if (backendId == null) {
//       Get.snackbar('Error', 'Backend ID not found for customer',
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     final updatedCustomer = {
//       "id": backendId, // Send the valid backend id (as a string).
//       "name": nameController.text.trim(),
//       "contact": phoneController.text.trim(),
//       "address": addressController.text.trim(),
//     };
//
//     final url = Uri.parse(baseUrl + updateCustomers); // Update endpoint.
//
//     try {
//       final response = await http.put(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(updatedCustomer),
//       );
//
//       print("Response Status Code: ${response.statusCode}");
//       print("Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         Get.snackbar('Success', 'Customer updated successfully',
//             snackPosition: SnackPosition.BOTTOM);
//         nameController.clear();
//         phoneController.clear();
//         addressController.clear();
//         loadCustomers(); // Reload the customers list after updating.
//       } else {
//         Get.snackbar('Error', 'Failed to update customer: ${response.body}',
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       print("Error: $e");
//       Get.snackbar('Error', 'Something went wrong: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   Future<void> deleteCustomerAPI(Customer customer) async {
//     // Retrieve the backend _id using our mapping.
//     final String? backendId = _backendIdMapping[customer.id];
//     if (backendId == null) {
//       Get.snackbar('Error', 'Backend ID not found for customer',
//           snackPosition: SnackPosition.BOTTOM);
//       return;
//     }
//
//     // Create the payload that the backend expects.
//     final deletePayload = {
//       "id": backendId, // Send the valid backend id as a string.
//     };
//
//     // Build the delete endpoint URL.
//     final url = Uri.parse(baseUrl + deleteCustomers);
//
//     try {
//       final response = await http.delete(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(deletePayload),
//       );
//
//       print("Delete Response Status Code: ${response.statusCode}");
//       print("Delete Response Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         Get.snackbar('Success', 'Customer deleted successfully',
//             snackPosition: SnackPosition.BOTTOM);
//         loadCustomers(); // Reload the customer list after deletion.
//       } else {
//         Get.snackbar('Error', 'Failed to delete customer: ${response.body}',
//             snackPosition: SnackPosition.BOTTOM);
//       }
//     } catch (e) {
//       print("Error: $e");
//       Get.snackbar('Error', 'Something went wrong: $e',
//           snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   void calculateTotalPages() {
//     totalPages.value = (customers.length / itemsPerPage.value).ceil();
//   }
//
//   List<Customer> get paginatedCustomers {
//     final startIndex = (currentPage.value - 1) * itemsPerPage.value;
//     final endIndex = startIndex + itemsPerPage.value;
//
//     if (startIndex >= customers.length) return [];
//
//     return customers.sublist(
//       startIndex,
//       endIndex > customers.length ? customers.length : endIndex,
//     );
//   }
//
//   void nextPage() {
//     if (currentPage.value < totalPages.value) {
//       currentPage.value++;
//     }
//   }
//
//   void previousPage() {
//     if (currentPage.value > 1) {
//       currentPage.value--;
//     }
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constants/api_con.dart';

class Customer {
  final String id; // Now using the actual backend id
  final String name;
  final String phoneNumber;
  final String address;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
  });
}

class CustomerController extends GetxController {
  var customers = <Customer>[].obs;
  var currentPage = 1.obs;
  var itemsPerPage = 7.obs;
  var totalPages = 1.obs;

  // Text editing controllers for customer fields.
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCustomers(); // Load customers on init.
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // Local update of customer (if needed).
  void updateCustomer(String id) {
    final index = customers.indexWhere((c) => c.id == id);
    if (index != -1) {
      customers[index] = Customer(
        id: id,
        name: nameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        address: addressController.text.trim(),
      );
      customers.refresh();
      Get.snackbar('Success', 'Customer updated successfully',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void deleteCustomer(String id) {
    customers.removeWhere((c) => c.id == id);
    calculateTotalPages();
    Get.snackbar('Deleted', 'Customer has been removed',
        snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> loadCustomers() async {
    final url = Uri.parse(baseUrl + getCustomer);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {

        final List<dynamic> customerData = jsonDecode(response.body);

        customers.value = customerData.map((json) {
          final String backendId = json['_id']; // Use the actual backend id
          print("Customers loaded successfully with id: $backendId");

          return Customer(
            id: backendId,
            name: json['name'],
            phoneNumber: json['contact'],
            address: json['address'],
          );
        }).toList();

        calculateTotalPages();
      } else {
        Get.snackbar('Error', 'Failed to load customers',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> postCustomer() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final newCustomer = {
      "name": nameController.text.trim(),
      "contact": phoneController.text.trim(),
      "address": addressController.text.trim(),
    };

    final url = Uri.parse(baseUrl + registerCustomer);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newCustomer),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Customer added successfully',
            snackPosition: SnackPosition.BOTTOM);
        nameController.clear();
        phoneController.clear();
        addressController.clear();
        loadCustomers(); // Reload customers after adding a new one.
      } else {
        Get.snackbar('Error', 'Failed to add customer: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> updateCustomerAPI(Customer customer) async {
    final updatedCustomer = {
      "id": customer.id, // Directly using the actual backend id
      "name": nameController.text.trim(),
      "contact": phoneController.text.trim(),
      "address": addressController.text.trim(),
    };

    final url = Uri.parse(baseUrl + updateCustomers); // Update endpoint

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedCustomer),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Customer updated successfully',
            snackPosition: SnackPosition.BOTTOM);
        nameController.clear();
        phoneController.clear();
        addressController.clear();
        loadCustomers(); // Reload the customers list after updating.
      } else {
        Get.snackbar('Error', 'Failed to update customer: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteCustomerAPI(Customer customer) async {
    final deletePayload = {
      "id": customer.id, // Directly using the actual backend id
    };

    final url = Uri.parse(baseUrl + deleteCustomers);

    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deletePayload),
      );

      print("Delete Response Status Code: ${response.statusCode}");
      print("Delete Response Body: ${response.body}");

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Customer deleted successfully',
            snackPosition: SnackPosition.BOTTOM);
        loadCustomers(); // Reload the customer list after deletion.
      } else {
        Get.snackbar('Error', 'Failed to delete customer: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      print("Error: $e");
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void calculateTotalPages() {
    totalPages.value = (customers.length / itemsPerPage.value).ceil();
  }

  List<Customer> get paginatedCustomers {
    final startIndex = (currentPage.value - 1) * itemsPerPage.value;
    final endIndex = startIndex + itemsPerPage.value;

    if (startIndex >= customers.length) return [];

    return customers.sublist(
      startIndex,
      endIndex > customers.length ? customers.length : endIndex,
    );
  }

  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}
