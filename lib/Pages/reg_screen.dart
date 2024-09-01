import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:slam_pakistan_1/Contrtoller/regform_controller.dart';

class RegistrationForm extends StatelessWidget {
  final RegistrationController controller = Get.put(RegistrationController());

  RegistrationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Form'),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        return controller.isSubmitting.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Serial Number: ${controller.serialNumber}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Obx(() => controller.isLoadingImage.value
                            ? const CircularProgressIndicator()
                            : controller.imagePath.value.isEmpty
                                ? GestureDetector(
                                    onTap: controller.pickImage,
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.add_a_photo,
                                        size: 50,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      Get.to(() => ImagePreviewScreen(
                                            imagePath:
                                                controller.imagePath.value,
                                          ));
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              controller.imagePath.value),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                          "Applicant Name", controller.applicantName),
                      _buildTextField("Father Name", controller.fatherName),
                      _buildTextField(
                          "School/College", controller.schoolCollege),
                      _buildTextField("Class", controller.studentClass),
                      _buildDateField(
                          context, "Date of Birth", controller.dateOfBirth),
                      _buildDropdownField("Category", controller.category),
                      _buildTextField(
                          "Contact Number 1", controller.contactNumber1),
                      _buildTextField(
                          "Contact Number 2", controller.contactNumber2),
                      _buildTextField("Address", controller.address,
                          maxLines: 3),
                      const SizedBox(height: 20),

                      // Date of Birth Field

                      const SizedBox(height: 20),

                      // Terms and Conditions Section
                      const Text(
                        'Please review and accept the following terms and conditions to proceed:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      // Displaying the first image for terms and conditions
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ImagePreviewScreen(
                                imagePath: 'images/term_1.jpeg',
                              ));
                        },
                        child: Image.asset(
                          'images/term_1.jpeg',
                          height: 200,
                        ), // Replace with your image path
                      ),
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: controller.isFirstTermAccepted.value,
                                onChanged: (value) {
                                  controller.isFirstTermAccepted.value =
                                      value ?? false;
                                },
                              )),
                          const Text('I accept the above terms and conditions.')
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Displaying the second image for terms and conditions
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const ImagePreviewScreen(
                                imagePath: 'images/term_2.jpeg',
                              ));
                        },
                        child: Image.asset(
                          'images/term_2.jpeg',
                          height: 200,
                        ), // Replace with your image path
                      ),
                      Row(
                        children: [
                          Obx(() => Checkbox(
                                value: controller.isSecondTermAccepted.value,
                                onChanged: (value) {
                                  controller.isSecondTermAccepted.value =
                                      value ?? false;
                                },
                              )),
                          const Text('I accept the above terms and conditions.')
                        ],
                      ),

                      const SizedBox(height: 20),

                      Center(
                        child: Obx(() => ElevatedButton(
                              onPressed: (controller
                                          .isFirstTermAccepted.value &&
                                      controller.isSecondTermAccepted.value)
                                  ? controller.submitForm
                                  : null, // Button is disabled unless both terms are accepted
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ).copyWith(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color?>(
                                  (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.hovered)) {
                                      return Colors.teal.shade700;
                                    }
                                    return Colors.teal;
                                  },
                                ),
                              ),
                              child: const Text("Apply"),
                            )),
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }

  Widget _buildTextField(String label, RxString controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        onChanged: (value) => controller.value = value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDropdownField(String label, RxString controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownButtonFormField<String>(
        value: controller.value.isEmpty ? null : controller.value,
        items: ["Primary", "Middle", "High", "College"]
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category),
                ))
            .toList(),
        onChanged: (value) => controller.value = value ?? '',
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(
      BuildContext context, String label, RxString controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            controller.value = "${picked.toLocal()}".split(' ')[0];
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.value.isEmpty
                    ? 'Select your date of birth'
                    : controller.value,
                style: TextStyle(
                  color: controller.value.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
              const Icon(Icons.calendar_today, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class ImagePreviewScreen extends StatelessWidget {
  final String imagePath;

  const ImagePreviewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: PhotoView(
          imageProvider: AssetImage(imagePath),
          backgroundDecoration: const BoxDecoration(color: Colors.black),
        ),
      ),
    );
  }
}
