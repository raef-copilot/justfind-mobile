import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/loading_widget.dart';
import '../../../domain/repositories/business_repository.dart';
import '../../../domain/entities/business_entity.dart';
import '../../../core/utils/snackbar_helper.dart';

class EditBusinessPage extends StatefulWidget {
  const EditBusinessPage({Key? key}) : super(key: key);

  @override
  State<EditBusinessPage> createState() => _EditBusinessPageState();
}

class _EditBusinessPageState extends State<EditBusinessPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final openingHoursController = TextEditingController();
  
  final selectedCategoryId = ''.obs;
  final existingImages = <String>[].obs;
  final newImages = <File>[].obs;
  final isLoading = false.obs;
  final isLoadingData = true.obs;
  final ImagePicker _picker = ImagePicker();
  
  late String businessId;
  BusinessEntity? business;

  @override
  void initState() {
    super.initState();
    businessId = Get.parameters['id'] ?? '';
    _loadBusinessData();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    cityController.dispose();
    phoneController.dispose();
    emailController.dispose();
    websiteController.dispose();
    openingHoursController.dispose();
    super.dispose();
  }

  Future<void> _loadBusinessData() async {
    try {
      isLoadingData.value = true;
      final repository = Get.find<BusinessRepository>();
      final result = await repository.getBusinessById(businessId);
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
          Get.back();
        },
        (businessData) {
          business = businessData;
          nameController.text = businessData.name;
          descriptionController.text = businessData.description;
          addressController.text = businessData.address;
          cityController.text = businessData.city ?? '';
          phoneController.text = businessData.phone;
          emailController.text = businessData.email ?? '';
          websiteController.text = businessData.website ?? '';
          openingHoursController.text = businessData.openingHours ?? '';
          selectedCategoryId.value = businessData.categoryId.toString();
          existingImages.value = businessData.images;
        },
      );
    } finally {
      isLoadingData.value = false;
    }
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      newImages.addAll(images.map((xFile) => File(xFile.path)));
    }
  }

  Future<void> _updateBusiness() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final repository = Get.find<BusinessRepository>();
      
      final result = await repository.updateBusiness(
        id: businessId,
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        categoryId: selectedCategoryId.value,
        address: addressController.text.trim(),
        latitude: 24.7136,
        longitude: 46.6753,
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        website: websiteController.text.trim(),
      );
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
        },
        (business) {
          SnackbarHelper.showSuccess('Success', 'Business updated successfully');
          Get.back(result: true);
        },
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Business'),
      ),
      body: Obx(() {
        if (isLoadingData.value) {
          return const LoadingWidget();
        }
        
        return Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(
                'Business Information',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: nameController,
                label: 'Business Name',
                hintText: 'Enter business name',
                prefixIcon: Icons.business,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Business name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: descriptionController,
                label: 'Description',
                hintText: 'Describe your business',
                prefixIcon: Icons.description,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              Text(
                'Contact Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: phoneController,
                label: 'Phone',
                hintText: 'Enter phone number',
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: emailController,
                label: 'Email',
                hintText: 'Enter email address',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!GetUtils.isEmail(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: websiteController,
                label: 'Website (Optional)',
                hintText: 'Enter website URL',
                keyboardType: TextInputType.url,
                prefixIcon: Icons.language,
              ),
              const SizedBox(height: 24),
              
              Text(
                'Location',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: addressController,
                label: 'Address',
                hintText: 'Enter full address',
                prefixIcon: Icons.location_on,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: cityController,
                label: 'City',
                hintText: 'Enter city',
                prefixIcon: Icons.location_city,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                controller: openingHoursController,
                label: 'Opening Hours (Optional)',
                hintText: 'e.g., Mon-Fri: 9AM-5PM',
                prefixIcon: Icons.access_time,
              ),
              const SizedBox(height: 24),
              
              Text(
                'Images',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              
              // Existing Images
              Obx(() {
                if (existingImages.isEmpty && newImages.isEmpty) {
                  return OutlinedButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.add_photo_alternate),
                    label: const Text('Add Images'),
                  );
                }
                
                return Column(
                  children: [
                    if (existingImages.isNotEmpty) ...[
                      const Text('Existing Images:'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: existingImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      existingImages[index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () {
                                        existingImages.removeAt(index);
                                      },
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (newImages.isNotEmpty) ...[
                      const Text('New Images:'),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: newImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      newImages[index],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onPressed: () {
                                        newImages.removeAt(index);
                                      },
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    OutlinedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: const Text('Add More Images'),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 32),
              
              // Submit Button
              Obx(() => CustomButton(
                    text: 'Update Business',
                    isLoading: isLoading.value,
                    onPressed: _updateBusiness,
                  )),
            ],
          ),
        );
      }),
    );
  }
}
