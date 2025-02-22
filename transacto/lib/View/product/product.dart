import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/product_controller.dart';
import '../Mobile_AppBar/AppBar.dart';
import 'add_product.dart';

class ProductPage extends StatelessWidget {
  final ProductController controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.dialog(AddProductDialog());
            },
            child: const Text('Add Product'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Sr.No.')),
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Unit')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: controller.paginatedProducts.map((product) {
                  final serialNumber = (controller.currentPage.value - 1) * controller.itemsPerPage.value + controller.paginatedProducts.indexOf(product) + 1;
                  return DataRow(
                    cells: [
                      DataCell(Text(serialNumber.toString())),
                      DataCell(Text(product.name)),
                      DataCell(Text(product.unit)),
                      DataCell(PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text('Edit'),
                            onTap: () {
                              Future.delayed(Duration.zero, () {
                                Get.dialog(EditProductDialog(product: product));
                              });
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text('Delete'),
                            onTap: () {
                              Future.delayed(Duration.zero, () {
                                Get.dialog(DeleteDialog(
                                  itemName: product.name,
                                  onConfirm: () => controller.deleteProductAPI(product),
                                ));
                              });
                            },
                          ),
                        ],
                      )),
                    ],
                  );
                }).toList(),
              ),
            )),
          ),
          Obx(() => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: controller.currentPage.value > 1
                      ? controller.previousPage
                      : null,
                ),
                Text(
                  'Page ${controller.currentPage.value} of ${controller.totalPages.value}',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: controller.currentPage.value < controller.totalPages.value
                      ? controller.nextPage
                      : null,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}




class DeleteDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback onConfirm;

  DeleteDialog({required this.itemName, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete $itemName?'),
      content: const Text('Are you sure you want to delete this item? This action cannot be undone.'),
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
          child: const Text('Delete'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
        ),
      ],
    );
  }
}




class EditProductDialog extends StatelessWidget {
  final ProductController controller = Get.find<ProductController>();
  final Product product;

  EditProductDialog({required this.product});

  @override
  Widget build(BuildContext context) {
    // Pre-fill the text fields with existing product data
    controller.productNameController.text = product.name;
    controller.selectedUnit.value = product.unit;

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Product',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.productNameController,
              decoration: InputDecoration(
                labelText: 'Product Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Product Unit',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Obx(() => DropdownButtonFormField<String>(
              value: controller.selectedUnit.value,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: controller.availableUnits.map((String unit) {
                return DropdownMenuItem<String>(
                  value: unit,
                  child: Text(unit),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  controller.selectedUnit.value = newValue;
                }
              },
            )),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateProductAPI(product);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Update Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
