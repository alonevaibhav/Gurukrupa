import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/vendor_controller.dart';
import '../Mobile_AppBar/AppBar.dart';
import 'add-vendor.dart';

class VendorPage extends StatelessWidget {
  final VendorController controller = Get.put(VendorController());

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.dialog(AddVendorDialog());
            },
            child: const Text('Add Vendor'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search vendors...',
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
                  DataColumn(label: Text('Vendor Name')),
                  DataColumn(label: Text('Phone Number')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Actions')),
                ],

    rows: controller.paginatedVendors.map((vendor) {
    final serialNumber = (controller.currentPage.value - 1) * controller.itemsPerPage.value + controller.paginatedVendors.indexOf(vendor) + 1;

    // rows: controller.paginatedVendors.map((vendor) {
                  return DataRow(
                    cells: [
                      DataCell(Text(serialNumber.toString())),
                      DataCell(Text(vendor.name)),
                      DataCell(Text(vendor.phoneNumber)),
                      DataCell(Text(vendor.address)),
                      DataCell(PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text('Edit'),
                            onTap: () {
                              Future.delayed(Duration.zero, () {
                                Get.dialog(EditVendorDialog(vendor: vendor));
                              });
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text('Delete'),
                            onTap: () {
                              Future.delayed(Duration.zero, () {
                                Get.dialog(DeleteDialog(
                                  itemName: vendor.name,
                                  onConfirm: () => controller.deleteVendorAPI(vendor),
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




class EditVendorDialog extends StatelessWidget {
  final VendorController controller = Get.find<VendorController>();
  final Vendor vendor;

  EditVendorDialog({required this.vendor});

  @override
  Widget build(BuildContext context) {
    // Pre-fill the text fields with existing vendor data
    controller.nameController.text = vendor.name;
    controller.phoneController.text = vendor.phoneNumber;
    controller.addressController.text = vendor.address;

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
              'Edit Vendor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Vendor Name',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateVendorAPI(vendor);
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Update Vendor'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
