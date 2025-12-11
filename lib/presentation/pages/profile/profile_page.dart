import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/custom_button.dart';

class ProfilePage extends GetView<AuthController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final isEditing = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Obx(() {
        final user = controller.currentUser.value;
        if (user == null) {
          return const Center(
            child: Text('Please login to view your profile'),
          );
        }

        nameController.text = user.name;
        phoneController.text = user.phone ?? '';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profile Avatar
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // User Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Account Information',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Obx(() => IconButton(
                                icon: Icon(isEditing.value ? Icons.close : Icons.edit),
                                onPressed: () => isEditing.value = !isEditing.value,
                              )),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      Obx(() => isEditing.value
                          ? Column(
                              children: [
                                CustomTextField(
                                  controller: nameController,
                                  label: 'Name',
                                  prefixIcon: Icons.person,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: phoneController,
                                  label: 'Phone',
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 24),
                                Obx(() => CustomButton(
                                      text: 'Save Changes',
                                      isLoading: controller.isLoading.value,
                                      onPressed: () {
                                        controller.updateProfile(
                                          name: nameController.text.trim(),
                                          phone: phoneController.text.trim(),
                                        );
                                        isEditing.value = false;
                                      },
                                    )),
                              ],
                            )
                          : Column(
                              children: [
                                _buildInfoRow(Icons.person, 'Name', user.name),
                                const SizedBox(height: 12),
                                _buildInfoRow(Icons.email, 'Email', user.email),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  Icons.phone,
                                  'Phone',
                                  user.phone ?? 'Not provided',
                                ),
                                const SizedBox(height: 12),
                                _buildInfoRow(
                                  Icons.badge,
                                  'Role',
                                  user.role.toUpperCase(),
                                ),
                              ],
                            )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Quick Actions
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dashboard),
                      title: const Text('My Dashboard'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Get.toNamed(AppRoutes.dashboard),
                    ),
                    if (controller.isAdmin)
                      ListTile(
                        leading: const Icon(Icons.admin_panel_settings),
                        title: const Text('Admin Panel'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => Get.toNamed(AppRoutes.adminDashboard),
                      ),
                    ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text('My Favorites'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => Get.toNamed(AppRoutes.dashboard),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Logout Button
              OutlinedButton.icon(
                onPressed: controller.logout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
