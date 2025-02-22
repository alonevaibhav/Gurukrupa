import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/payment_vendor_controller.dart';
import 'package:transacto/Controller/vendor_controller.dart';

import '../../../Mobile_AppBar/AppBar.dart';
import 'AddVendorPayment.dart'; // Your existing VendorController

class VendorPaymentPage extends StatefulWidget {
  @override
  State<VendorPaymentPage> createState() => _VendorPaymentPageState();
}

class _VendorPaymentPageState extends State<VendorPaymentPage> {

  final PaymentVendorController paymentController = Get.put(PaymentVendorController());
  final VendorController vendorController = Get.find<VendorController>();


  @override
  void initState() {
    super.initState();
    paymentController.loadPayments();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.dialog(AddVendorPaymentDialog());
            },
            child: const Text("Add Payment"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search payments...',
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
                    DataColumn(label: Text("Vendor")),
                    DataColumn(label: Text("Account")),
                    DataColumn(label: Text("GST No")),
                    DataColumn(label: Text("Amount")),
                    DataColumn(label: Text("Payment Type")),
                    DataColumn(label: Text("Actions")),
                  ],
                  rows: paymentController.paymentItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final payment = entry.value;
                    return DataRow(cells: [
                      DataCell(Text('${index + 1}')),
                        DataCell(Text(payment.vendorName)),
                        DataCell(Text(payment.accountName)),
                        DataCell(Text(payment.gstNo)),
                        DataCell(Text(payment.amount.toStringAsFixed(2))),
                        DataCell(Text(payment.paymentType)),
                        DataCell(
                          PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: const Text("Edit"),
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    Get.dialog(EditVendorPaymentDialog(payment: payment));
                                  });
                                },
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: const Text("Delete"),
                                onTap: () {
                                  Future.delayed(Duration.zero, () {
                                    Get.dialog(DeleteDialog(
                                      itemName: 'Payment Item ${payment.id}',
                                      onConfirm: () {
                                        paymentController.deletePayment(payment);
                                        Get.back();
                                      },
                                    ));
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
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
