import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Controller/order_vendor_controller.dart';
import '../../../../Controller/vendor_controller.dart';
import '../../../../Controller/product_controller.dart';

/// Dialog for adding a new order item
class AddOrderDialog extends StatelessWidget {
  final VendorOrderController controller = Get.find<VendorOrderController>();
  final VendorController vendorController = Get.find<VendorController>();
  final ProductController productController = Get.find<ProductController>();

  // Local observables for dropdown selections
  final Rx<Vendor?> selectedVendor = Rx<Vendor?>(null);
  final Rx<Product?> selectedProduct = Rx<Product?>(null);

  // Local controllers for quantity and amount
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  AddOrderDialog({Key? key}) : super(key: key) {
    // Initialize defaults
    if (vendorController.vendors.isNotEmpty) {
      selectedVendor.value = vendorController.vendors.first;
    }
    if (productController.products.isNotEmpty) {
      selectedProduct.value = productController.products.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
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
                'Add Order Item',
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
              // Add button placed nicely in the dialog
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // Validate inputs
                    if (selectedVendor.value == null ||
                        selectedProduct.value == null ||
                        quantityController.text.trim().isEmpty ||
                        amountController.text.trim().isEmpty) {
                      Get.snackbar('Error', 'Please fill all fields properly',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    final int? quantity =
                    int.tryParse(quantityController.text.trim());
                    final double? amount =
                    double.tryParse(amountController.text.trim());
                    if (quantity == null || amount == null) {
                      Get.snackbar('Error', 'Invalid number format',
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    await Get.find<VendorOrderController>().postOrder(
                      selectedVendor.value!.id as String,
                      selectedProduct.value!.id as String ,
                      quantity,
                      amount,
                    );

                    Get.snackbar('Success', 'Order item added successfully',
                        snackPosition: SnackPosition.BOTTOM);
                    Get.back(); // Close dialog after adding
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Add Order Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

