import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/order_customer_controller.dart';
import '../../../Mobile_AppBar/AppBar.dart';
import 'add_customer.dart';

class CustomerOrderPage extends StatefulWidget {
  @override
  State<CustomerOrderPage> createState() => _CustomerOrderPageState();
}

class _CustomerOrderPageState extends State<CustomerOrderPage> {
  final CustomerOrderController orderController = Get.put(CustomerOrderController());

  @override
  void initState() {
    super.initState();
    orderController.loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.dialog(AddCustomerOrderDialog());
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
                    DataColumn(label: Text("Sr.No.")),
                    DataColumn(label: Text("Customer")),
                    DataColumn(label: Text("Product")),
                    DataColumn(label: Text("Quantity")),
                    DataColumn(label: Text("Amount")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: orderController.orderItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final order = entry.value;
                    return DataRow(cells: [
                      DataCell(Text('${index + 1}')), // Serial number starting at 1
                      DataCell(Text(order.customerName)),
                      DataCell(Text(order.productName)),
                      DataCell(Text(order.quantity.toString())),
                      DataCell(Text(order.amount.toStringAsFixed(2))),
                      DataCell(
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: const Text("Edit"),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Get.dialog(
                                      EditCustomerOrderDialog(order: order));
                                });
                              },
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: const Text("Delete"),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Get.dialog(DeleteDialog(
                                    itemName: 'Order Item ${order.id}',
                                    onConfirm: () {
                                      orderController.deleteOrder(order);
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
