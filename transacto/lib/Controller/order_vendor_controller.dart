//
// import 'package:get/get.dart';
//
// /// Model for an Order Item
// class OrderItem {
//   final int id;
//   final int vendorId;
//   final String vendorName;
//   final String productName;
//   final int quantity;
//   final double amount;
//
//   OrderItem({
//     required this.id,
//     required this.vendorId,
//     required this.vendorName,
//     required this.productName,
//     required this.quantity,
//     required this.amount,
//   });
// }
//
// /// Controller to manage order items and related form state
// class OrderController extends GetxController {
//   // List of order items
//   var orderItems = <OrderItem>[].obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//   }
//
//   /// Delete an order item by id
//   void deleteOrderItem(int id) {
//     orderItems.removeWhere((item) => item.id == id);
//     Get.snackbar('Deleted', 'Order item deleted',
//         snackPosition: SnackPosition.BOTTOM);
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Constants/api_con.dart';

class VendorOrderItem {
  final String id; // Backend order ID
  final String vendorId; // Actual backend vendor ID
  final String vendorName;
  final String productId; // Actual backend product ID
  final String productName;
  final int quantity;
  final double amount;

  VendorOrderItem({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.amount,
  });
}

class VendorOrderController extends GetxController {
  var orderItems = <VendorOrderItem>[].obs;

  Future<void> loadOrders() async {
    final url = Uri.parse(baseUrl + getOrderVendor);
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> orderData = jsonDecode(response.body);

        orderItems.value = orderData.map((json) {
          // The order's own _id
          final String orderId = (json['_id'] ?? '').toString();

          // vendor might be an object { "_id": "...", "name": "..." }
          // or just a string "67b474ac53fd7c3c10664af2"
          final dynamic vendorData = json['vendor'];
          String vendorId;
          String vendorName;

          if (vendorData is Map<String, dynamic>) {
            vendorId = (vendorData['_id'] ?? '').toString();
            vendorName = (vendorData['name'] ?? 'Unknown').toString();
          } else {
            // If it's just a string or null
            vendorId = vendorData?.toString() ?? '';
            vendorName = 'Unknown';
          }

          // product might be an object { "_id": "...", "name": "..." }
          // or just a string "67b6fb9cfa72f087b979987b"
          final dynamic productData = json['product'];
          String productId;
          String productName;

          if (productData is Map<String, dynamic>) {
            productId = (productData['_id'] ?? '').toString();
            productName = (productData['name'] ?? 'Unknown').toString();
          } else {
            // If it's just a string or null
            productId = productData?.toString() ?? '';
            productName = 'Unknown';
          }

          // Safely parse quantity and amount
          final int quantity = (json['quantity'] ?? 0) as int;
          final double amount =
          (json['amount'] is num) ? (json['amount'] as num).toDouble() : 0.0;

          return VendorOrderItem(
            id: orderId,
            vendorId: vendorId,
            vendorName: vendorName,
            productId: productId,
            productName: productName,
            quantity: quantity,
            amount: amount,
          );
        }).toList();

      } else {
        Get.snackbar('Error', 'Failed to load orders');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Create a new order using actual backend IDs for vendor and product.
  Future<void> postOrder(String vendorId, String productId, int quantity, double amount) async {
    print("Inside postOrder method");

    // Prepare the payload directly using the actual backend IDs
    final newOrder = {
      "vendor": vendorId,
      "product": productId,
      "quantity": quantity,
      "amount": amount,
    };

    print("Request Payload: $newOrder");

    final url = Uri.parse(baseUrl + registerOrderVendor);
    print("API URL: $url");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(newOrder),
      );

      print("API Response Status Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Order added successfully');
        loadOrders(); // Refresh the list
      } else {
        Get.snackbar('Error', 'Failed to add order: ${response.body}');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Update an existing order
  Future<void> updateOrder(VendorOrderItem order, {
    String? newVendorId,
    String? newProductId,
    int? newQuantity,
    double? newAmount
  }) async {
    // Prepare the payload using new values if provided; otherwise, use current order values.
    final updatedOrder = {
      "id": order.id,
      "vendor": newVendorId ?? order.vendorId,
      "product": newProductId ?? order.productId,
      "quantity": newQuantity ?? order.quantity,
      "amount": newAmount ?? order.amount,
    };

    final url = Uri.parse(baseUrl + updateOrderVendor);
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedOrder),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Order updated successfully');
        loadOrders(); // Refresh the list
      } else {
        Get.snackbar('Error', 'Failed to update order: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }

  // Delete an order
  Future<void> deleteOrder(VendorOrderItem order) async {
    // Prepare the payload using the backend order ID directly.
    final deletePayload = {"id": order.id};

    final url = Uri.parse(baseUrl + deleteOrderVendor);
    try {
      final response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deletePayload),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Order deleted successfully');
        loadOrders(); // Refresh the list
      } else {
        Get.snackbar('Error', 'Failed to delete order: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    }
  }
}