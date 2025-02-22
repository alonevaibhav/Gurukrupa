//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../Controller/customer_controller.dart';
// import '../../../../Controller/order_customer_controller.dart';
// import '../../../../Controller/product_controller.dart';
//
// // Dialog for adding a new customer order item
// class AddCustomerOrderDialog extends StatelessWidget {
//   final CustomerOrderController orderController = Get.find<CustomerOrderController>();
//   final CustomerController customerController = Get.find<CustomerController>();
//   final ProductController productController = Get.find<ProductController>();
//
//   // Observables for dropdown selections
//   final Rx<Customer?> selectedCustomer = Rx<Customer?>(null);
//   final Rx<Product?> selectedProduct = Rx<Product?>(null);
//
//   // Controllers for quantity and amount fields
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//
//   AddCustomerOrderDialog({Key? key}) : super(key: key) {
//     // Initialize defaults if lists are not empty
//     if (customerController.customers.isNotEmpty) {
//       selectedCustomer.value = customerController.customers.first;
//     }
//     if (productController.products.isNotEmpty) {
//       selectedProduct.value = productController.products.first;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 400,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFEF3E2),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Add Order Item",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               // Customer Dropdown
//               Obx(() => DropdownButton<Customer>(
//                 isExpanded: true,
//                 value: selectedCustomer.value,
//                 onChanged: (Customer? newValue) {
//                   selectedCustomer.value = newValue;
//                 },
//                 items: customerController.customers.map((customer) {
//                   return DropdownMenuItem<Customer>(
//                     value: customer,
//                     child: Text(customer.name),
//                   );
//                 }).toList(),
//               )),
//               const SizedBox(height: 16),
//               // Product Dropdown
//               Obx(() => DropdownButton<Product>(
//                 isExpanded: true,
//                 value: selectedProduct.value,
//                 onChanged: (Product? newValue) {
//                   selectedProduct.value = newValue;
//                 },
//                 items: productController.products.map((product) {
//                   return DropdownMenuItem<Product>(
//                     value: product,
//                     child: Text(product.name),
//                   );
//                 }).toList(),
//               )),
//               const SizedBox(height: 16),
//               // Quantity Field
//               TextField(
//                 controller: quantityController,
//                 decoration: const InputDecoration(
//                   labelText: "Quantity",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),
//               // Amount Field
//               TextField(
//                 controller: amountController,
//                 decoration: const InputDecoration(
//                   labelText: "Amount",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               ),
//               const SizedBox(height: 24),
//               // Add button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (selectedCustomer.value == null ||
//                         selectedProduct.value == null ||
//                         quantityController.text.trim().isEmpty ||
//                         amountController.text.trim().isEmpty) {
//                       Get.snackbar("Error", "Please fill all fields properly",
//                           snackPosition: SnackPosition.BOTTOM);
//                       return;
//                     }
//                     final int? quantity = int.tryParse(quantityController.text.trim());
//                     final double? amount = double.tryParse(amountController.text.trim());
//                     if (quantity == null || amount == null) {
//                       Get.snackbar("Error", "Invalid number format",
//                           snackPosition: SnackPosition.BOTTOM);
//                       return;
//                     }
//                     final newOrder = CustomerOrderItem(
//                       id: orderController.orderItems.length + 1,
//                       customerId: selectedCustomer.value!.id,
//                       customerName: selectedCustomer.value!.name,
//                       productName: selectedProduct.value!.name,
//                       quantity: quantity,
//                       amount: amount,
//                     );
//                     orderController.orderItems.add(newOrder);
//                     Get.snackbar("Success", "Order item added successfully",
//                         snackPosition: SnackPosition.BOTTOM);
//                     Get.back();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: const Text("Add Order Item"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // Dialog for editing an existing customer order item
// class EditCustomerOrderDialog extends StatelessWidget {
//   final CustomerOrderItem order;
//   final CustomerOrderController orderController = Get.find<CustomerOrderController>();
//   final CustomerController customerController = Get.find<CustomerController>();
//   final ProductController productController = Get.find<ProductController>();
//
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//
//   final Rx<Customer?> selectedCustomer = Rx<Customer?>(null);
//   final Rx<Product?> selectedProduct = Rx<Product?>(null);
//
//   EditCustomerOrderDialog({required this.order, Key? key}) : super(key: key) {
//     quantityController.text = order.quantity.toString();
//     amountController.text = order.amount.toString();
//     selectedCustomer.value = customerController.customers.firstWhere(
//           (c) => c.id == order.customerId,
//       orElse: () => customerController.customers.first,
//     );
//     selectedProduct.value = productController.products.firstWhere(
//           (p) => p.name == order.productName,
//       orElse: () => productController.products.first,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Container(
//         width: 400,
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFEF3E2),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Edit Order Item",
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               // Customer Dropdown
//               Obx(() => DropdownButton<Customer>(
//                 isExpanded: true,
//                 value: selectedCustomer.value,
//                 onChanged: (Customer? newValue) {
//                   selectedCustomer.value = newValue;
//                 },
//                 items: customerController.customers.map((customer) {
//                   return DropdownMenuItem<Customer>(
//                     value: customer,
//                     child: Text(customer.name),
//                   );
//                 }).toList(),
//               )),
//               const SizedBox(height: 16),
//               // Product Dropdown
//               Obx(() => DropdownButton<Product>(
//                 isExpanded: true,
//                 value: selectedProduct.value,
//                 onChanged: (Product? newValue) {
//                   selectedProduct.value = newValue;
//                 },
//                 items: productController.products.map((product) {
//                   return DropdownMenuItem<Product>(
//                     value: product,
//                     child: Text(product.name),
//                   );
//                 }).toList(),
//               )),
//               const SizedBox(height: 16),
//               // Quantity Field
//               TextField(
//                 controller: quantityController,
//                 decoration: const InputDecoration(
//                   labelText: "Quantity",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),
//               // Amount Field
//               TextField(
//                 controller: amountController,
//                 decoration: const InputDecoration(
//                   labelText: "Amount",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: const TextInputType.numberWithOptions(decimal: true),
//               ),
//               const SizedBox(height: 24),
//               // Update button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final int? quantity = int.tryParse(quantityController.text.trim());
//                     final double? amount = double.tryParse(amountController.text.trim());
//                     if (selectedCustomer.value == null ||
//                         selectedProduct.value == null ||
//                         quantity == null ||
//                         amount == null) {
//                       Get.snackbar("Error", "Please fill all fields properly",
//                           snackPosition: SnackPosition.BOTTOM);
//                       return;
//                     }
//                     final index = orderController.orderItems.indexWhere((item) => item.id == order.id);
//                     if (index != -1) {
//                       orderController.orderItems[index] = CustomerOrderItem(
//                         id: order.id,
//                         customerId: selectedCustomer.value!.id,
//                         customerName: selectedCustomer.value!.name,
//                         productName: selectedProduct.value!.name,
//                         quantity: quantity,
//                         amount: amount,
//                       );
//                       orderController.orderItems.refresh();
//                       Get.snackbar("Success", "Order item updated successfully",
//                           snackPosition: SnackPosition.BOTTOM);
//                     }
//                     Get.back();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: const Text("Update Order Item"),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // A generic delete confirmation dialog (can be reused)
// class DeleteDialog extends StatelessWidget {
//   final String itemName;
//   final VoidCallback onConfirm;
//
//   const DeleteDialog({
//     Key? key,
//     required this.itemName,
//     required this.onConfirm,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text("Delete $itemName?"),
//       content: const Text("Are you sure you want to delete this item? This action cannot be undone."),
//       actions: [
//         TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
//         ElevatedButton(
//           onPressed: () {
//             onConfirm();
//             Get.back();
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           child: const Text("Delete"),
//         ),
//       ],
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/customer_controller.dart';
import '../../../../Controller/order_customer_controller.dart';
import '../../../../Controller/product_controller.dart';

// Dialog for adding a new customer order item

class AddCustomerOrderDialog extends StatelessWidget {
  final CustomerOrderController orderController = Get.find();
  final CustomerController customerController = Get.find();
  final ProductController productController = Get.find();

  final Rx<Customer?> selectedCustomer = Rx<Customer?>(null);
  final Rx<Product?> selectedProduct = Rx<Product?>(null);
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  AddCustomerOrderDialog({Key? key}) : super(key: key) {
    if (customerController.customers.isNotEmpty) {
      selectedCustomer.value = customerController.customers.first;
    }
    if (productController.products.isNotEmpty) {
      selectedProduct.value = productController.products.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3E2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add Order Item",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Customer Dropdown
              Obx(() => DropdownButton<Customer>(
                isExpanded: true,
                value: selectedCustomer.value,
                onChanged: (Customer? newValue) => selectedCustomer.value = newValue,
                items: customerController.customers.map((customer) => DropdownMenuItem(
                  value: customer,
                  child: Text(customer.name),
                )).toList(),
              )),
              const SizedBox(height: 16),

              // Product Dropdown
              Obx(() => DropdownButton<Product>(
                isExpanded: true,
                value: selectedProduct.value,
                onChanged: (Product? newValue) => selectedProduct.value = newValue,
                items: productController.products.map((product) => DropdownMenuItem(
                  value: product,
                  child: Text(product.name),
                )).toList(),
              )),
              const SizedBox(height: 16),

              // Quantity Field
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),

              // Add Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    print("Add Order Button Pressed");

                    if (selectedCustomer.value == null ||
                        selectedProduct.value == null ||
                        quantityController.text.isEmpty ||
                        amountController.text.isEmpty) {
                      print("Validation failed: Please fill all fields");
                      Get.snackbar("Error", "Please fill all fields");
                      return;
                    }

                    final quantity = int.tryParse(quantityController.text);
                    final amount = double.tryParse(amountController.text);

                    if (quantity == null || amount == null) {
                      print("Validation failed: Invalid number format");
                      Get.snackbar("Error", "Invalid number format");
                      return;
                    }

                    print("Calling postOrder...");
                    print("Customer ID: ${selectedCustomer.value!.id}");
                    print("Product ID: ${selectedProduct.value!.id}");
                    print("Quantity: $quantity");
                    print("Amount: $amount");

                    await orderController.postOrder(
                      selectedCustomer.value!.id as String,
                      selectedProduct.value!.id as String,
                      quantity,
                      amount,
                    );

                    print("Order creation process completed");
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text("Add Order Item"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditCustomerOrderDialog extends StatelessWidget {
  final CustomerOrderItem order;
  final CustomerOrderController orderController = Get.find();
  final CustomerController customerController = Get.find();
  final ProductController productController = Get.find();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final Rx<Customer?> selectedCustomer = Rx<Customer?>(null);
  final Rx<Product?> selectedProduct = Rx<Product?>(null);

  EditCustomerOrderDialog({required this.order, Key? key}) : super(key: key) {
    quantityController.text = order.quantity.toString();
    amountController.text = order.amount.toString();

    selectedCustomer.value = customerController.customers.firstWhere(
          (c) => c.id == order.customerId,
      orElse: () => customerController.customers.first,
    );

    selectedProduct.value = productController.products.firstWhere(
          (p) => p.id == order.productId,
      orElse: () => productController.products.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3E2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Edit Order Item",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Customer Dropdown
              Obx(() => DropdownButton<Customer>(
                isExpanded: true,
                value: selectedCustomer.value,
                onChanged: (Customer? newValue) => selectedCustomer.value = newValue,
                items: customerController.customers.map((customer) => DropdownMenuItem(
                  value: customer,
                  child: Text(customer.name),
                )).toList(),
              )),
              const SizedBox(height: 16),

              // Product Dropdown
              Obx(() => DropdownButton<Product>(
                isExpanded: true,
                value: selectedProduct.value,
                onChanged: (Product? newValue) => selectedProduct.value = newValue,
                items: productController.products.map((product) => DropdownMenuItem(
                  value: product,
                  child: Text(product.name),
                )).toList(),
              )),
              const SizedBox(height: 16),

              // Quantity Field
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                    labelText: "Quantity",
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Amount Field
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final quantity = int.tryParse(quantityController.text);
                    final amount = double.tryParse(amountController.text);

                    if (selectedCustomer.value == null ||
                        selectedProduct.value == null ||
                        quantity == null ||
                        amount == null) {
                      Get.snackbar("Error", "Invalid input values");
                      return;
                    }

                    final updatedOrder = CustomerOrderItem(
                      id: order.id,
                      customerId: selectedCustomer.value!.id as String,
                      customerName: selectedCustomer.value!.name ,
                      productId: selectedProduct.value!.id as String,
                      productName: selectedProduct.value!.name,
                      quantity: quantity,
                      amount: amount,
                    );

                    await orderController.updateOrder(updatedOrder);Get.back();

                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text("Update Order Item"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;

  const DeleteDialog({
    Key? key,
    required this.itemName,
    required this.onConfirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Delete $itemName?"),
      content: const Text("This action cannot be undone."),
      actions: [
        TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel")
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Get.back();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text("Delete"),
        ),
      ],
    );
  }
}