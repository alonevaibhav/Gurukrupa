

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constants/api_con.dart';

class Vendor {
  final String id; // Changed from int to String
  final String name;
  final String phoneNumber;
  final String address;

  Vendor({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.address,
  });
}

class VendorController extends GetxController {
  var vendors = <Vendor>[].obs;
  var currentPage = 1.obs;
  var itemsPerPage = 7.obs;
  var totalPages = 1.obs;

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadVendors();
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> loadVendors() async {
    final url = Uri.parse(baseUrl + getVendorr);
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> vendorData = jsonDecode(response.body);

        vendors.value = vendorData.map((json) {
          final String backendId = json['_id']; // Use backend ID directly
          return Vendor(
            id: backendId,
            name: json['name'],
            phoneNumber: json['contact'],
            address: json['address'],
          );
        }).toList();

        calculateTotalPages();
      } else {
        Get.snackbar('Error', 'Failed to load vendors', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> postVendor() async {
    if (nameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final newVendor = {
      "name": nameController.text.trim(),
      "contact": phoneController.text.trim(),
      "address": addressController.text.trim(),
    };

    final url = Uri.parse(baseUrl + registerVendor);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newVendor),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Vendor added successfully', snackPosition: SnackPosition.BOTTOM);
        nameController.clear();
        phoneController.clear();
        addressController.clear();
        loadVendors(); // Refresh vendor list after adding
      } else {
        Get.snackbar('Error', 'Failed to add vendor: ${response.body}', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }


  Future<void> updateVendorAPI(Vendor vendor) async {
    final updatedVendor = {
      "id": vendor.id, // Directly using backend ID
      "name": nameController.text.trim(),
      "contact": phoneController.text.trim(),
      "address": addressController.text.trim(),
    };

    final url = Uri.parse(baseUrl + updateVendor);

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedVendor),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Vendor updated successfully', snackPosition: SnackPosition.BOTTOM);
        nameController.clear();
        phoneController.clear();
        addressController.clear();
        loadVendors();
      } else {
        Get.snackbar('Error', 'Failed to update vendor: ${response.body}', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteVendorAPI(Vendor vendor) async {
    final deletePayload = {"id": vendor.id}; // Directly using backend ID
    final url = Uri.parse(baseUrl + deleteVendor);

    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deletePayload),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Vendor deleted successfully', snackPosition: SnackPosition.BOTTOM);
        loadVendors();
      } else {
        Get.snackbar('Error', 'Failed to delete vendor: ${response.body}', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void calculateTotalPages() {
    totalPages.value = (vendors.length / itemsPerPage.value).ceil();
  }

  List<Vendor> get paginatedVendors {
    final startIndex = (currentPage.value - 1) * itemsPerPage.value;
    final endIndex = startIndex + itemsPerPage.value;
    if (startIndex >= vendors.length) return [];
    return vendors.sublist(startIndex, endIndex > vendors.length ? vendors.length : endIndex);
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
