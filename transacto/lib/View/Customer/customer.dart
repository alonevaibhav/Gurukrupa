import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Controller/customer_controller.dart';
import '../Mobile_AppBar/AppBar.dart';
import 'add_customer.dart';

class CustomerPage extends StatefulWidget {
  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  final CustomerController controller = Get.put(CustomerController());


  @override
  void initState() {
    super.initState();

    controller.loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Get.dialog(AddCustomerDialog());
            },
            child: const Text('Add Customer'),
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
            child: Obx(() {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Sr.No.')),
                    DataColumn(label: Text('Customer Name')),
                    DataColumn(label: Text('Phone Number')),
                    DataColumn(label: Text('Address')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: controller.paginatedCustomers.map((customer) {
                    final serialNumber = (controller.currentPage.value - 1) * controller.itemsPerPage.value + controller.paginatedCustomers.indexOf(customer) + 1;

                    return DataRow(
                      cells: [
                        DataCell(Text(serialNumber.toString())),  // Display the serial number here
                        DataCell(Text(customer.name)),
                        DataCell(Text(customer.phoneNumber)),
                        DataCell(Text(customer.address)),
                        DataCell(PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: const Text('Edit'),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Get.dialog(EditCustomerDialog(customer: customer));
                                });
                              },
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: const Text('Delete'),
                              onTap: () {
                                Future.delayed(Duration.zero, () {
                                  Get.dialog(DeleteDialog(
                                    itemName: customer.name,
                                    // Pass the deleteCustomerAPI call instead of the local deleteCustomer method
                                    onConfirm: () => controller.deleteCustomerAPI(customer),
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
              );
            }),
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

class EditCustomerDialog extends StatelessWidget {
  final CustomerController controller = Get.find<CustomerController>();
  final Customer customer;

  EditCustomerDialog({required this.customer});

  @override
  Widget build(BuildContext context) {
    // Pre-fill the text fields with existing customer data
    controller.nameController.text = customer.name;
    controller.phoneController.text = customer.phoneNumber;
    controller.addressController.text = customer.address;

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
              'Edit Customer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controller.nameController,
              decoration: InputDecoration(
                labelText: 'Customer Name',
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
                  // Call the update method with the customer data
                  controller.updateCustomerAPI(customer);  // Call the API method here
                  Get.back();  // Close the dialog after updating
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Update Customer'),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
