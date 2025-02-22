
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constants/api_con.dart';

class VendorPaymentItem {
  final String id; // Backend payment ID
  final String vendorId; // Actual backend vendor/vendor ID
  final String vendorName; // Vendor name, if provided
  final String accountName; // Bank/account name
  final String gstNo;
  final double amount;
  final String paymentType;

  VendorPaymentItem({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.accountName,
    required this.gstNo,
    required this.amount,
    required this.paymentType,
  });
}

class PaymentVendorController extends GetxController {
  // Observable list of payment items.
  var paymentItems = <VendorPaymentItem>[].obs;

  // Predefined account names for vendor payments.
  final List<String> accountNames = [
    'BIO',
    'ICICI',
    'BOM',
    'Indus Bank',
    'HDFC',
    'BOI'
  ];

  // Predefined payment types.
  final List<String> paymentTypes = [
    'Cash',
    'Bank Transfer',
    'Cheque',
    'Net Banking',
    'UPI',
    'Credit'
  ];

  /// Load (GET) payments from the backend.
  /// The API response is expected to contain payment details,
  /// where the "vendor" field might be an object or just a string.
  Future<void> loadPayments() async {
    final url = Uri.parse(baseUrl + getPaymentVendor);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> paymentData = jsonDecode(response.body);

        paymentItems.value = paymentData.map((json) {
          final String id = (json['_id'] ?? '').toString();

          // Handle the vendor field which might be an object or string.
          final dynamic vendorData = json['vendor'];
          String vendorId;
          String vendorName;
          if (vendorData is Map<String, dynamic>) {
            vendorId = (vendorData['_id'] ?? '').toString();
            vendorName = (vendorData['name'] ?? 'Unknown').toString();
          } else {
            vendorId = vendorData?.toString() ?? '';
            vendorName = 'Unknown';
          }

          // "bank" from backend maps to accountName.
          String accountName = json['bank']?.toString() ?? '';
          String gstNo = json['gstno']?.toString() ?? '';
          double amount = (json['amount'] is num)
              ? (json['amount'] as num).toDouble()
              : 0.0;
          String paymentType = json['paymentType']?.toString().trim() ?? '';

          return VendorPaymentItem(
            id: id,
            vendorId: vendorId,
            vendorName: vendorName,
            accountName: accountName,
            gstNo: gstNo,
            amount: amount,
            paymentType: paymentType,
          );
        }).toList();
      } else {
        Get.snackbar('Error', 'Failed to load payments');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  /// Create (POST) a new payment.
  ///
  /// Expected JSON payload:
  /// {
  ///   "vendor": "67b6fb7ffa72f087b9799872",
  ///   "gstno": "GSTIN1234567",
  ///   "amount": 111111.75,
  ///   "paymentType": "Debit",
  ///   "bank": "HDFC Bank"
  /// }
  ///
  /// Use the provided [accountNames] and [paymentTypes] lists in your form inputs.
  Future<void> postPayment(String vendorId, String gstNo, double amount,
      String paymentType, String bank) async {
    final newPayment = {
      "vendor": vendorId,
      "gstno": gstNo,
      "amount": amount,
      "paymentType": paymentType,
      "bank": bank,
    };

    final url = Uri.parse(baseUrl + registerPaymentVendor );
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newPayment),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Payment added successfully',
            snackPosition: SnackPosition.BOTTOM);
        loadPayments(); // Refresh the list after creation.
      } else {
        Get.snackbar('Error', 'Failed to add payment: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Update (PUT) an existing payment.
  ///
  /// Expected JSON payload:
  /// {
  ///    "id": "67b837b9f4118648a83638fa",
  ///    "vendor": "67b78c037689d520c2627814",
  ///    "gstno": "GSTIN1234567",
  ///    "amount": 111111.75,
  ///    "paymentType": "Cash",
  ///    "bank": "Canara Bank"
  /// }
  ///
  /// Use the [accountNames] and [paymentTypes] lists for dropdown options in your update form.
  Future<void> updatePayment(VendorPaymentItem payment, {
    String? newVendorId,
    String? newGSTNo,
    double? newAmount,
    String? newPaymentType,
    String? newBank,
  }) async {
    final updatedPayment = {
      "id": payment.id,
      "vendor": newVendorId ?? payment.vendorId,
      "gstno": newGSTNo ?? payment.gstNo,
      "amount": newAmount ?? payment.amount,
      "paymentType": newPaymentType ?? payment.paymentType,
      "bank": newBank ?? payment.accountName,
    };

    final url = Uri.parse(baseUrl + updatePaymentVendor);
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedPayment),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Payment updated successfully',
            snackPosition: SnackPosition.BOTTOM);
        loadPayments(); // Refresh the list after update.
      } else {
        Get.snackbar('Error', 'Failed to update payment: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Delete (DELETE) a payment.
  ///
  /// For deletion, only the payment id is required.
  Future<void> deletePayment(VendorPaymentItem payment) async {
    final deletePayload = {"id": payment.id};

    final url = Uri.parse(baseUrl + deletePaymentVendor);
    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deletePayload),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Payment deleted successfully',
            snackPosition: SnackPosition.BOTTOM);
        loadPayments(); // Refresh the list after deletion.
      } else {
        Get.snackbar('Error', 'Failed to delete payment: ${response.body}',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
