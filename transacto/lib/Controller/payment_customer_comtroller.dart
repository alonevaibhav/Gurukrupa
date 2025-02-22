// import 'package:get/get.dart';
//
//
// // payment_model.dart
// class PaymentItem {
//   final String id;
//   final String customerId;
//   final String customerName;
//   final String accountName;
//   final String gstNo;
//   final double amount;
//   final String paymentType;
//
//   PaymentItem({
//     required this.id,
//     required this.customerId,
//     required this.customerName,
//     required this.accountName,
//     required this.gstNo,
//     required this.amount,
//     required this.paymentType,
//   });
// }
//
//
// class PaymentController extends GetxController {
//   var paymentItems = <PaymentItem>[].obs;
//
//   // Predefined account names
//   final List<String> accountNames = [
//     'BIO',
//     'ICICI',
//     'BOM',
//     'Indus Bank',
//     'HDFC',
//     'BOI'
//   ];
//
//   // Predefined payment types
//   final List<String> paymentTypes = [
//     'Cash',
//     'Credit Card',
//     'Debit Card',
//     'Net Banking',
//     'UPI',
//     'Cheque'
//   ];
//
//   void deletePaymentItem(int id) {
//     paymentItems.removeWhere((item) => item.id == id);
//     Get.snackbar('Deleted', 'Payment item deleted',
//         snackPosition: SnackPosition.BOTTOM);
//   }
// }


import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constants/api_con.dart';

class PaymentItem {
  final String id;
  final String customerId;
  final String customerName;
  final String accountName;
  final String gstNo;
  final double amount;
  final String paymentType;

  PaymentItem({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.accountName,
    required this.gstNo,
    required this.amount,
    required this.paymentType,
  });
}

class PaymentController extends GetxController {
  var paymentItems = <PaymentItem>[].obs;

  // Predefined account names
  final List<String> accountNames = [
    'BIO',
    'ICICI',
    'BOM',
    'Indus Bank',
    'HDFC',
    'BOI'
  ];

  // Predefined payment types
  final List<String> paymentTypes = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Net Banking',
    'UPI',
    'Cheque'
  ];

  @override
  void onInit() {
    super.onInit();
    loadPayments();
  }

  Future<void> loadPayments() async {
    final url = Uri.parse(baseUrl + getPaymentCustomer);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> paymentData = jsonDecode(response.body);

        paymentItems.value = paymentData.map((json) {
          final String id = (json['_id'] ?? '').toString();

          final dynamic customerData = json['customer'];
          String customerId;
          String customerName;
          if (customerData is Map<String, dynamic>) {
            customerId = (customerData['_id'] ?? '').toString();
            customerName = (customerData['name'] ?? 'Unknown').toString();
          } else {
            customerId = customerData?.toString() ?? '';
            customerName = 'Unknown';
          }

          String accountName = json['bank']?.toString() ?? '';
          String gstNo = json['gstno']?.toString() ?? '';
          double amount = (json['amount'] is num)
              ? (json['amount'] as num).toDouble()
              : 0.0;
          String paymentType = json['paymentType']?.toString().trim() ?? '';

          return PaymentItem(
            id: id,
            customerId: customerId,
            customerName: customerName,
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

  Future<void> postPayment(String customerId, String gstNo, double amount,
      String paymentType, String bank) async {
    final newPayment = {
      "customer": customerId,
      "gstno": gstNo,
      "amount": amount,
      "paymentType": paymentType,
      "bank": bank,
    };

    final url = Uri.parse(baseUrl + registerPaymentCustomer);
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

  Future<void> updatePayment(PaymentItem payment, {
    String? newCustomerId,
    String? newGSTNo,
    double? newAmount,
    String? newPaymentType,
    String? newBank,
  }) async {
    final updatedPayment = {
      "id": payment.id,
      "customer": newCustomerId ?? payment.customerId,
      "gstno": newGSTNo ?? payment.gstNo,
      "amount": newAmount ?? payment.amount,
      "paymentType": newPaymentType ?? payment.paymentType,
      "bank": newBank ?? payment.accountName,
    };

    final url = Uri.parse(baseUrl + updatePaymentCustomer);
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

  Future<void> deletePayment(PaymentItem payment) async {
    final deletePayload = {"id": payment.id};

    final url = Uri.parse(baseUrl + deletePaymentCustomer);
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
