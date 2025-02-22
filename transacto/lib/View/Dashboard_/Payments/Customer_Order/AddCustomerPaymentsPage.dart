import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Controller/customer_controller.dart';
import '../../../../Controller/payment_customer_comtroller.dart';

// Dialog for adding a new payment
class AddPaymentDialog extends StatelessWidget {
  final PaymentController paymentController = Get.find<PaymentController>();
  final CustomerController customerController = Get.find<CustomerController>();

  // Observables for dropdown selections
  final Rx<Customer?> selectedCustomer = Rx<Customer?>(null);
  final RxString selectedAccount = ''.obs;
  final RxString selectedPaymentType = ''.obs;

  // Controllers for GST No and Amount fields
  final TextEditingController gstController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  AddPaymentDialog({Key? key}) : super(key: key) {
    // Initialize defaults
    if (customerController.customers.isNotEmpty) {
      selectedCustomer.value = customerController.customers.first;
    }
    if (paymentController.accountNames.isNotEmpty) {
      selectedAccount.value = paymentController.accountNames.first;
    }
    if (paymentController.paymentTypes.isNotEmpty) {
      selectedPaymentType.value = paymentController.paymentTypes.first;
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
              const Text(
                "Add Payment",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Customer Dropdown
              Obx(() => DropdownButton<Customer>(
                    isExpanded: true,
                    value: selectedCustomer.value,
                    onChanged: (Customer? newValue) {
                      selectedCustomer.value = newValue;
                    },
                    items: customerController.customers.map((customer) {
                      return DropdownMenuItem<Customer>(
                        value: customer,
                        child: Text(customer.name),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 16),
              // Account Name Dropdown
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    value: selectedAccount.value,
                    onChanged: (String? newValue) {
                      selectedAccount.value = newValue ?? '';
                    },
                    items: paymentController.accountNames.map((account) {
                      return DropdownMenuItem<String>(
                        value: account,
                        child: Text(account),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 16),
              // GST No Field
              TextField(
                controller: gstController,
                decoration: const InputDecoration(
                  labelText: "GST No",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Amount Field
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              // Payment Type Dropdown
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    value: selectedPaymentType.value,
                    onChanged: (String? newValue) {
                      selectedPaymentType.value = newValue ?? '';
                    },
                    items: paymentController.paymentTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 24),
              // Add button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedCustomer.value == null ||
                        gstController.text.trim().isEmpty ||
                        amountController.text.trim().isEmpty ||
                        selectedAccount.value.isEmpty ||
                        selectedPaymentType.value.isEmpty) {
                      Get.snackbar("Error", "Please fill all fields properly",
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    final double? amount =
                        double.tryParse(amountController.text.trim());
                    if (amount == null) {
                      Get.snackbar("Error", "Invalid amount",
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }

                    paymentController.postPayment(
                        selectedCustomer.value!.id,
                        gstController.text.trim(),
                        amount,
                        selectedPaymentType.value,
                        selectedAccount.value);
                    Get.back();

                    // paymentController.paymentItems.add(newPayment);
                    Get.snackbar("Success", "Payment added successfully",
                        snackPosition: SnackPosition.BOTTOM);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Add Payment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dialog for editing an existing payment
class EditPaymentDialog extends StatelessWidget {
  final PaymentItem payment;
  final PaymentController paymentController = Get.find<PaymentController>();
  final CustomerController customerController = Get.find<CustomerController>();

  final TextEditingController gstController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  final Rx<Customer?> selectedCustomer = Rx<Customer?>(null);
  final RxString selectedAccount = ''.obs;
  final RxString selectedPaymentType = ''.obs;

  EditPaymentDialog({required this.payment, Key? key}) : super(key: key) {
    gstController.text = payment.gstNo;
    amountController.text = payment.amount.toString();
    selectedCustomer.value = customerController.customers.firstWhere(
      (c) => c.id == payment.customerId,
      orElse: () => customerController.customers.first,
    );
    selectedAccount.value = payment.accountName;
    selectedPaymentType.value = payment.paymentType;
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
                "Edit Payment",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              // Customer Dropdown
              Obx(() => DropdownButton<Customer>(
                    isExpanded: true,
                    value: selectedCustomer.value,
                    onChanged: (Customer? newValue) {
                      selectedCustomer.value = newValue;
                    },
                    items: customerController.customers.map((customer) {
                      return DropdownMenuItem<Customer>(
                        value: customer,
                        child: Text(customer.name),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 16),
              // Account Name Dropdown
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    value: selectedAccount.value,
                    onChanged: (String? newValue) {
                      selectedAccount.value = newValue ?? '';
                    },
                    items: paymentController.accountNames.map((account) {
                      return DropdownMenuItem<String>(
                        value: account,
                        child: Text(account),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 16),
              // GST No Field
              TextField(
                controller: gstController,
                decoration: const InputDecoration(
                  labelText: "GST No",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // Amount Field
              TextField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),
              // Payment Type Dropdown
              Obx(() => DropdownButton<String>(
                    isExpanded: true,
                    value: selectedPaymentType.value,
                    onChanged: (String? newValue) {
                      selectedPaymentType.value = newValue ?? '';
                    },
                    items: paymentController.paymentTypes.map((type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  )),
              const SizedBox(height: 24),
              // Update button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final double? amount =
                        double.tryParse(amountController.text.trim());
                    if (selectedCustomer.value == null ||
                        gstController.text.trim().isEmpty ||
                        amount == null ||
                        selectedAccount.value.isEmpty ||
                        selectedPaymentType.value.isEmpty) {
                      Get.snackbar("Error", "Please fill all fields properly",
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }

                    final updatedOrder = PaymentItem(
                      id: payment.id,
                      customerId: selectedCustomer.value!.id as String,
                      customerName: selectedCustomer.value!.name,
                      accountName: selectedAccount.value,
                      paymentType: selectedPaymentType.value,
                      amount: amount,
                      gstNo: gstController.text.trim(),
                    );

                    await paymentController.updatePayment(updatedOrder);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Update Payment"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// A generic delete confirmation dialog (can be reused)
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
      content: const Text(
          "Are you sure you want to delete this item? This action cannot be undone."),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
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
