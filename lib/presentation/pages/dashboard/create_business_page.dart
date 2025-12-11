import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../controllers/category_controller.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';
import '../../../domain/repositories/business_repository.dart';
import '../../../domain/entities/category_entity.dart';
import '../../../core/utils/snackbar_helper.dart';

class CreateBusinessPage extends StatefulWidget {
  const CreateBusinessPage({Key? key}) : super(key: key);

  @override
  State<CreateBusinessPage> createState() => _CreateBusinessPageState();
}

class _CreateBusinessPageState extends State<CreateBusinessPage> {
  final formKey = GlobalKey<FormState>();
  
  // English fields
  final nameEnController = TextEditingController();
  final descriptionEnController = TextEditingController();
  final addressEnController = TextEditingController();
  
  // Arabic fields
  final nameArController = TextEditingController();
  final descriptionArController = TextEditingController();
  final addressArController = TextEditingController();
  
  // Common fields
  final phoneController = TextEditingController();
  final whatsappController = TextEditingController();
  final emailController = TextEditingController();
  final websiteController = TextEditingController();
  final cityController = TextEditingController();
  final openingHoursController = TextEditingController();
  
  final selectedCategoryId = ''.obs;
  final selectedCategory = Rx<CategoryEntity?>(null);
  final selectedImages = <File>[].obs;
  final isLoading = false.obs;
  final currentStep = 0.obs;
  final ImagePicker _picker = ImagePicker();
  
  late CategoryController categoryController;

  @override
  void initState() {
    super.initState();
    categoryController = Get.find<CategoryController>();
    // Auto-fill WhatsApp with phone number
    phoneController.addListener(() {
      if (whatsappController.text.isEmpty) {
        whatsappController.text = phoneController.text;
      }
    });
  }

  @override
  void dispose() {
    nameEnController.dispose();
    nameArController.dispose();
    descriptionEnController.dispose();
    descriptionArController.dispose();
    addressEnController.dispose();
    addressArController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    emailController.dispose();
    websiteController.dispose();
    cityController.dispose();
    openingHoursController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (images.isNotEmpty) {
        if (selectedImages.length + images.length > 10) {
          SnackbarHelper.showError('Error', 'Maximum 10 images allowed');
          return;
        }
        selectedImages.addAll(images.map((xFile) => File(xFile.path)));
      }
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to pick images: $e');
    }
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1920,
      );
      if (image != null) {
        if (selectedImages.length >= 10) {
          SnackbarHelper.showError('Error', 'Maximum 10 images allowed');
          return;
        }
        selectedImages.add(File(image.path));
      }
    } catch (e) {
      SnackbarHelper.showError('Error', 'Failed to capture image: $e');
    }
  }

  void _showCategoryPicker() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (categoryController.categories.isEmpty) {
                  return const Center(child: Text('No categories available'));
                }
                
                return ListView.builder(
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];
                    final isSelected = selectedCategoryId.value == category.id.toString();
                    
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor.withOpacity(0.2)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.category,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade600,
                        ),
                      ),
                      title: Text(
                        category.nameEn,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      subtitle: Text(category.nameAr),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                          : null,
                      selected: isSelected,
                      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      onTap: () {
                        selectedCategoryId.value = category.id.toString();
                        selectedCategory.value = category;
                        Get.back();
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  bool _validateStep(int step) {
    switch (step) {
      case 0: // Basic Info
        if (nameEnController.text.trim().isEmpty) {
          SnackbarHelper.showError('Required', 'Business name (English) is required');
          return false;
        }
        if (descriptionEnController.text.trim().isEmpty) {
          SnackbarHelper.showError('Required', 'Description (English) is required');
          return false;
        }
        if (selectedCategoryId.value.isEmpty) {
          SnackbarHelper.showError('Required', 'Please select a category');
          return false;
        }
        return true;
        
      case 1: // Contact Info
        if (phoneController.text.trim().isEmpty) {
          SnackbarHelper.showError('Required', 'Phone number is required');
          return false;
        }
        if (emailController.text.trim().isEmpty) {
          SnackbarHelper.showError('Required', 'Email is required');
          return false;
        }
        if (!GetUtils.isEmail(emailController.text.trim())) {
          SnackbarHelper.showError('Invalid', 'Please enter a valid email');
          return false;
        }
        return true;
        
      case 2: // Location
        if (addressEnController.text.trim().isEmpty) {
          SnackbarHelper.showError('Required', 'Address is required');
          return false;
        }
        if (cityController.text.trim().isEmpty) {
          SnackbarHelper.showError('Required', 'City is required');
          return false;
        }
        return true;
        
      case 3: // Images
        if (selectedImages.isEmpty) {
          SnackbarHelper.showError('Required', 'Please add at least one image');
          return false;
        }
        return true;
        
      default:
        return true;
    }
  }

  void _nextStep() {
    if (_validateStep(currentStep.value)) {
      if (currentStep.value < 3) {
        currentStep.value++;
      } else {
        _createBusiness();
      }
    }
  }

  void _previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  Future<void> _createBusiness() async {
    if (!formKey.currentState!.validate()) return;
    
    if (!_validateStep(0) || !_validateStep(1) || !_validateStep(2) || !_validateStep(3)) {
      return;
    }

    try {
      isLoading.value = true;
      final repository = Get.find<BusinessRepository>();
      
      // Use English name as fallback if Arabic is empty
      final nameAr = nameArController.text.trim().isEmpty 
          ? nameEnController.text.trim() 
          : nameArController.text.trim();
      final descAr = descriptionArController.text.trim().isEmpty 
          ? descriptionEnController.text.trim() 
          : descriptionArController.text.trim();
      final addrAr = addressArController.text.trim().isEmpty 
          ? addressEnController.text.trim() 
          : addressArController.text.trim();
      
      final result = await repository.createBusiness(
        name: nameEnController.text.trim(),
        description: descriptionEnController.text.trim(),
        categoryId: selectedCategoryId.value,
        address: addressEnController.text.trim(),
        latitude: 24.7136, // TODO: Get from map picker
        longitude: 46.6753, // TODO: Get from map picker
        phone: phoneController.text.trim(),
        email: emailController.text.trim(),
        website: websiteController.text.trim().isEmpty ? null : websiteController.text.trim(),
        imagePath: null, // TODO: Backend doesn't support image upload on create yet
      );
      
      result.fold(
        (failure) {
          SnackbarHelper.showError('Error', failure.message);
        },
        (business) {
          SnackbarHelper.showSuccess('Success', 'Business created successfully! Pending admin approval.');
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
        title: const Text('Add Your Business'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          Obx(() => Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: List.generate(4, (index) {
                    final isActive = index == currentStep.value;
                    final isCompleted = index < currentStep.value;
                    
                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: isCompleted || isActive
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade300,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: isCompleted
                                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                                        : Text(
                                            '${index + 1}',
                                            style: TextStyle(
                                              color: isActive ? Colors.white : Colors.grey.shade600,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getStepTitle(index),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isActive
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey.shade600,
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          if (index < 3)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: isCompleted
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey.shade300,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              )),
          
          // Step Content
          Expanded(
            child: Form(
              key: formKey,
              child: Obx(() {
                switch (currentStep.value) {
                  case 0:
                    return _buildBasicInfoStep(context);
                  case 1:
                    return _buildContactInfoStep(context);
                  case 2:
                    return _buildLocationStep(context);
                  case 3:
                    return _buildImagesStep(context);
                  default:
                    return const SizedBox();
                }
              }),
            ),
          ),
          
          // Navigation Buttons
          Obx(() => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (currentStep.value > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading.value ? null : _previousStep,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: Theme.of(context).primaryColor),
                          ),
                          child: const Text('Previous'),
                        ),
                      ),
                    if (currentStep.value > 0) const SizedBox(width: 16),
                    Expanded(
                      flex: currentStep.value == 0 ? 1 : 1,
                      child: CustomButton(
                        text: currentStep.value == 3 ? 'Submit' : 'Next',
                        isLoading: isLoading.value,
                        onPressed: _nextStep,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  String _getStepTitle(int index) {
    switch (index) {
      case 0:
        return 'Basic Info';
      case 1:
        return 'Contact';
      case 2:
        return 'Location';
      case 3:
        return 'Images';
      default:
        return '';
    }
  }

  Widget _buildBasicInfoStep(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Business Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tell us about your business',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 24),
        
        // Category Selection
        Obx(() => InkWell(
              onTap: _showCategoryPicker,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedCategoryId.value.isEmpty
                        ? Colors.grey.shade300
                        : Theme.of(context).primaryColor,
                    width: selectedCategoryId.value.isEmpty ? 1 : 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: selectedCategoryId.value.isEmpty
                      ? Colors.transparent
                      : Theme.of(context).primaryColor.withOpacity(0.05),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedCategoryId.value.isEmpty
                            ? Colors.grey.shade200
                            : Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.category,
                        color: selectedCategoryId.value.isEmpty
                            ? Colors.grey.shade600
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedCategory.value?.nameEn ?? 'Select category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: selectedCategoryId.value.isEmpty
                                  ? Colors.grey.shade500
                                  : Colors.black87,
                            ),
                          ),
                          if (selectedCategory.value != null)
                            Text(
                              selectedCategory.value!.nameAr,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 20),
        
        // English Name
        CustomTextField(
          controller: nameEnController,
          label: 'Business Name (English) *',
          hintText: 'e.g., Premium Coffee House',
          prefixIcon: Icons.business,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Business name is required';
            }
            if (value.length < 3) {
              return 'Name must be at least 3 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Arabic Name
        CustomTextField(
          controller: nameArController,
          label: 'Business Name (Arabic)',
          hintText: 'اسم العمل بالعربية',
          prefixIcon: Icons.business_outlined,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 20),
        
        // English Description
        CustomTextField(
          controller: descriptionEnController,
          label: 'Description (English) *',
          hintText: 'Describe what makes your business unique...',
          prefixIcon: Icons.description,
          maxLines: 5,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Description is required';
            }
            if (value.length < 20) {
              return 'Description must be at least 20 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Arabic Description
        CustomTextField(
          controller: descriptionArController,
          label: 'Description (Arabic)',
          hintText: 'وصف عملك بالعربية...',
          prefixIcon: Icons.description_outlined,
          maxLines: 5,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildContactInfoStep(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'How can customers reach you?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 24),
        
        // Phone
        CustomTextField(
          controller: phoneController,
          label: 'Phone Number *',
          hintText: '+966 50 123 4567',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.phone,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phone number is required';
            }
            if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
              return 'Enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // WhatsApp
        CustomTextField(
          controller: whatsappController,
          label: 'WhatsApp Number',
          hintText: 'Same as phone or different',
          keyboardType: TextInputType.phone,
          prefixIcon: Icons.chat,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
          ],
        ),
        const SizedBox(height: 16),
        
        // Email
        CustomTextField(
          controller: emailController,
          label: 'Email Address *',
          hintText: 'business@example.com',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Email is required';
            }
            if (!GetUtils.isEmail(value)) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Website
        CustomTextField(
          controller: websiteController,
          label: 'Website (Optional)',
          hintText: 'https://www.example.com',
          keyboardType: TextInputType.url,
          prefixIcon: Icons.language,
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              if (!GetUtils.isURL(value) && !value.startsWith('http')) {
                return 'Enter a valid URL';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Opening Hours
        CustomTextField(
          controller: openingHoursController,
          label: 'Opening Hours (Optional)',
          hintText: 'e.g., Mon-Fri: 9AM-6PM, Sat: 10AM-4PM',
          prefixIcon: Icons.access_time,
          maxLines: 2,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildLocationStep(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Location Details',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Help customers find you',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 24),
        
        // English Address
        CustomTextField(
          controller: addressEnController,
          label: 'Full Address (English) *',
          hintText: 'Street, Building, District',
          prefixIcon: Icons.location_on,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Address is required';
            }
            if (value.length < 10) {
              return 'Please enter a complete address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        
        // Arabic Address
        CustomTextField(
          controller: addressArController,
          label: 'Full Address (Arabic)',
          hintText: 'الشارع، المبنى، الحي',
          prefixIcon: Icons.location_on_outlined,
          maxLines: 3,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 16),
        
        // City
        CustomTextField(
          controller: cityController,
          label: 'City *',
          hintText: 'e.g., Riyadh, Jeddah, Dubai',
          prefixIcon: Icons.location_city,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'City is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        
        // Map Placeholder
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 48, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                Text(
                  'Map picker coming soon',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  'Using default coordinates',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildImagesStep(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Business Images',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Add photos to showcase your business (Max 10 images)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
        const SizedBox(height: 24),
        
        // Image Grid
        Obx(() => selectedImages.isEmpty
            ? _buildEmptyImageState(context)
            : _buildImageGrid(context)),
        
        const SizedBox(height: 16),
        
        // Add Image Buttons
        Obx(() => selectedImages.length < 10
            ? Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImages,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickImageFromCamera,
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              )
            : Container()),
        
        const SizedBox(height: 16),
        
        // Image Tips
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Image Tips',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Use high-quality, well-lit photos\n'
                      '• Show your products/services clearly\n'
                      '• Include interior and exterior shots\n'
                      '• First image will be the cover photo',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEmptyImageState(BuildContext context) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 2, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No images added yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add at least one image to continue',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: selectedImages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: index == 0
                    ? Border.all(color: Theme.of(context).primaryColor, width: 3)
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  selectedImages[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (index == 0)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Cover',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => selectedImages.removeAt(index),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
