//
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:transacto/View/Mobile_AppBar/AppBar.dart';
// import '../../../../Controller/order_vendor_controller.dart';
// import '../../../../Controller/product_controller.dart';
// import '../../../../Controller/vendor_controller.dart';
// import 'Add_vendors.dart';
//
//
// /// Main page displaying the order table and a button to add a new order item
// class OrderPage extends StatelessWidget {
//   final OrderController controller = Get.put(OrderController());
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseScaffold(
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: () {
//               Get.dialog(AddOrderDialog());
//             },
//             child: const Text("Add Order"),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search customers...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Obx(
//                   () => SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   columns: const [
//                     DataColumn(label: Text('Sr.No.')),
//                     DataColumn(label: Text('Vendor')),
//                     DataColumn(label: Text('Product')),
//                     DataColumn(label: Text('Quantity')),
//                     DataColumn(label: Text('Amount')),
//                     DataColumn(label: Text('Actions')),
//                   ],
//                   rows: controller.orderItems.map((order) {
//                     return DataRow(cells: [
//                       DataCell(Text(order.id.toString())),
//                       DataCell(Text(order.vendorName)),
//                       DataCell(Text(order.productName)),
//                       DataCell(Text(order.quantity.toString())),
//                       DataCell(Text(order.amount.toStringAsFixed(2))),
//                       DataCell(
//                         PopupMenuButton(
//                           itemBuilder: (context) => [
//                             PopupMenuItem(
//                               value: 'edit',
//                               child: const Text('Edit'),
//                               onTap: () {
//                                 // Delay to allow popup to close before opening dialog
//                                 Future.delayed(Duration.zero, () {
//                                   Get.dialog(EditOrderDialog(order: order));
//                                 });
//                               },
//                             ),
//                             PopupMenuItem(
//                               value: 'delete',
//                               child: const Text('Delete'),
//                               onTap: () {
//                                 Future.delayed(Duration.zero, () {
//                                   Get.dialog(DeleteDialog(
//                                     itemName: 'Order Item ${order.id}',
//                                     onConfirm: () {
//                                       controller.deleteOrderItem(order.id);
//                                       Get.back();
//                                     },
//                                   ));
//                                 });
//                               },
//                             ),
//                           ],
//                         ),
//                       ),
//                     ]);
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
// /// Dialog for editing an existing order item
// class EditOrderDialog extends StatelessWidget {
//   final OrderItem order;
//   final OrderController controller = Get.find<OrderController>();
//   final VendorController vendorController = Get.find<VendorController>();
//   final ProductController productController = Get.find<ProductController>();
//
//   final TextEditingController quantityController = TextEditingController();
//   final TextEditingController amountController = TextEditingController();
//
//   final Rx<Vendor?> selectedVendor = Rx<Vendor?>(null);
//   final Rx<Product?> selectedProduct = Rx<Product?>(null);
//
//   EditOrderDialog({required this.order, Key? key}) : super(key: key) {
//     // Pre-fill with current data
//     quantityController.text = order.quantity.toString();
//     amountController.text = order.amount.toString();
//     selectedVendor.value = vendorController.vendors.firstWhere(
//           (v) => v.id == order.vendorId,
//       orElse: () => vendorController.vendors.first,
//     );
//     // Find a product from the product list that matches the order's product name
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
//                 'Edit Order Item',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               // Vendor Dropdown
//               Obx(
//                     () => DropdownButton<Vendor>(
//                   isExpanded: true,
//                   value: selectedVendor.value,
//                   onChanged: (Vendor? newValue) {
//                     selectedVendor.value = newValue;
//                   },
//                   items: vendorController.vendors.map((vendor) {
//                     return DropdownMenuItem<Vendor>(
//                       value: vendor,
//                       child: Text(vendor.name),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Product Dropdown (using ProductController)
//               Obx(
//                     () => DropdownButton<Product>(
//                   isExpanded: true,
//                   value: selectedProduct.value,
//                   onChanged: (Product? newValue) {
//                     selectedProduct.value = newValue;
//                   },
//                   items: productController.products.map((product) {
//                     return DropdownMenuItem<Product>(
//                       value: product,
//                       child: Text(product.name),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               // Quantity Field
//               TextField(
//                 controller: quantityController,
//                 decoration: const InputDecoration(
//                   labelText: 'Quantity',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 16),
//               // Amount Field
//               TextField(
//                 controller: amountController,
//                 decoration: const InputDecoration(
//                   labelText: 'Amount',
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType:
//                 const TextInputType.numberWithOptions(decimal: true),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     final int? quantity =
//                     int.tryParse(quantityController.text.trim());
//                     final double? amount =
//                     double.tryParse(amountController.text.trim());
//                     if (selectedVendor.value == null ||
//                         selectedProduct.value == null ||
//                         quantity == null ||
//                         amount == null) {
//                       Get.snackbar('Error', 'Please fill all fields properly',
//                           snackPosition: SnackPosition.BOTTOM);
//                       return;
//                     }
//                     // Update the order item in the list
//                     final index = controller.orderItems
//                         .indexWhere((item) => item.id == order.id);
//                     if (index != -1) {
//                       controller.orderItems[index] = OrderItem(
//                         id: order.id,
//                         vendorId: selectedVendor.value!.id,
//                         vendorName: selectedVendor.value!.name,
//                         productName: selectedProduct.value!.name,
//                         quantity: quantity,
//                         amount: amount,
//                       );
//                       controller.orderItems.refresh();
//                       Get.snackbar('Success', 'Order item updated successfully',
//                           snackPosition: SnackPosition.BOTTOM);
//                     }
//                     Get.back();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8)),
//                   ),
//                   child: const Text('Update Order Item'),
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
//
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
//       title: Text('Delete $itemName?'),
//       content: const Text(
//           'Are you sure you want to delete this item? This action cannot be undone.'),
//       actions: [
//         TextButton(
//           onPressed: () => Get.back(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             onConfirm();
//             Get.back();
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           child: const Text('Delete'),
//         ),
//       ],
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transacto/View/Mobile_AppBar/AppBar.dart';
import '../../../../Controller/order_vendor_controller.dart';
import '../../../../Controller/product_controller.dart';
import '../../../../Controller/vendor_controller.dart';
import 'Add_vendors.dart';

/// Main page displaying the order table and a button to add a new order item
class OrderPage extends StatefulWidget {
  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final VendorOrderController controller = Get.put(VendorOrderController());

  @override
  void initState() {
    super.initState();

    controller.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.dialog(AddOrderDialog());
            },
            child: const Text("Add Order"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Sr.No.')),
                    DataColumn(label: Text('Vendor')),
                    DataColumn(label: Text('Product')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Amount')),
                    DataColumn(label: Text('Actions')),
                  ],


                  rows: controller.orderItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final order = entry.value;
                    return DataRow(cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(order.vendorName)),
                      DataCell(Text(order.productName)),
                      DataCell(Text(order.quantity.toString())),
                      DataCell(Text(order.amount.toStringAsFixed(2))),
                      DataCell(
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: const Text('Edit'),
                              onTap: () {
                                // Delay to allow popup to close before opening dialog
                                Future.delayed(Duration.zero, () {
                                  Get.dialog(EditOrderDialog(order: order));
                                });
                              },
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: const Text('Delete'),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Get.dialog(DeleteDialog(
                                    itemName: 'Order Item ${order.id}',
                                    onConfirm: () {
                                      controller.deleteOrder(order);
                                      Get.back();
                                    },
                                  ));
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog for editing an existing order item
class EditOrderDialog extends StatelessWidget {
  final VendorOrderItem order;
  final VendorOrderController controller = Get.find<VendorOrderController>();
  final VendorController vendorController = Get.find<VendorController>();
  final ProductController productController = Get.find<ProductController>();

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final Rx<Vendor?> selectedVendor = Rx<Vendor?>(null);
  final Rx<Product?> selectedProduct = Rx<Product?>(null);

  EditOrderDialog({required this.order, Key? key}) : super(key: key) {
    // Pre-fill with current data
    quantityController.text = order.quantity.toString();
    amountController.text = order.amount.toString();

    selectedVendor.value = vendorController.vendors.firstWhere(
      (v) => v.id == order.vendorId,
      orElse: () => vendorController.vendors.first,
    );

    // Fix: Match product by product id instead of product name
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
              const Text(
                'Edit Order Item',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Vendor Dropdown
              Obx(
                () => DropdownButton<Vendor>(
                  isExpanded: true,
                  value: selectedVendor.value,
                  onChanged: (Vendor? newValue) {
                    selectedVendor.value = newValue;
                  },
                  items: vendorController.vendors.map((vendor) {
                    return DropdownMenuItem<Vendor>(
                      value: vendor,
                      child: Text(vendor.name),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Product Dropdown (using ProductController)
              Obx(
                () => DropdownButton<Product>(
                  isExpanded: true,
                  value: selectedProduct.value,
                  onChanged: (Product? newValue) {
                    selectedProduct.value = newValue;
                  },
                  items: productController.products.map((product) {
                    return DropdownMenuItem<Product>(
                      value: product,
                      child: Text(product.name),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Quantity Field
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              // Amount Field
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final int? quantity =
                        int.tryParse(quantityController.text.trim());
                    final double? amount =
                        double.tryParse(amountController.text.trim());

                    if (selectedVendor.value == null ||
                        selectedProduct.value == null ||
                        quantity == null ||
                        amount == null) {
                      Get.snackbar('Error', 'Please fill all fields properly',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }

                    final updatedOrder = VendorOrderItem(
                      id: order.id,
                      vendorId: selectedVendor.value!.id as String,
                      vendorName: selectedVendor.value!.name,
                      productId: selectedProduct.value!.id as String,
                      productName: selectedProduct.value!.name,
                      quantity: quantity,
                      amount: amount,
                    );

                    await controller.updateOrder(updatedOrder);
                    Get.back();

                    // // Update the order item in the list
                    // final index = controller.orderItems.indexWhere((item) => item.id == order.id);
                    // if (index != -1) {
                    //   controller.orderItems[index] = VendorOrderItem(
                    //     id: order.id,
                    //     vendorId: selectedVendor.value!.id as String,
                    //     vendorName: selectedVendor.value!.name,
                    //     productName: selectedProduct.value!.name,
                    //     productId: selectedProduct.value!.id as String,
                    //     quantity: quantity,
                    //     amount: amount,
                    //   );
                    //   controller.orderItems.refresh();
                    //   Get.snackbar('Success', 'Order item updated successfully',
                    //       snackPosition: SnackPosition.BOTTOM);
                    // }
                    // Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Update Order Item'),
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
      title: Text('Delete $itemName?'),
      content: const Text(
          'Are you sure you want to delete this item? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
            Get.back();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
