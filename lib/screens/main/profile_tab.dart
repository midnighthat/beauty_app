import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../themes/app_theme.dart';
import '../../widgets/common/index.dart';
import '../../providers/auth_provider.dart';
import '../../providers/skin_profile_provider.dart';
import '../../services/preferences_service.dart';

class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authService = ref.read(authServiceProvider);
    final user = authService.currentUser;
    final profile = ref.watch(skinProfileProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : AppColors.creamBackground,
        foregroundColor: isDark ? AppColors.creamBackground : AppColors.darkText,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? AppColors.creamBackground : AppColors.darkText,
          ),
          onPressed: () {},
        ),
        title: TitleText(
          'Profile',
          color: isDark ? AppColors.creamBackground : AppColors.darkText,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // Profile Picture Section
            Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryPink.withOpacity(0.2),
                  ),
                  child: user?.photoURL != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            user!.photoURL!,
                            fit: BoxFit.cover,
                            width: 120,
                            height: 120,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 60,
                          color: AppColors.primaryPink,
                        ),
                ),
                // Edit icon
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPink,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBackground : AppColors.creamBackground,
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      color: AppColors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // User Name
            HeadingText(
              user?.displayName ?? 'Jelly Grande',
              textAlign: TextAlign.center,
              color: isDark ? AppColors.creamBackground : AppColors.darkText,
            ),
            
            const SizedBox(height: 12),
            
            // Skin Type Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryPink.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CustomText(
                    profile?.skinType ?? 'Normal Skin',
                    type: TextType.bodyMedium,
                    color: AppColors.primaryPink,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 50),
            
            // Menu Items
            _buildMenuItem(
              icon: Icons.lock_outline,
              title: 'Privacy & Setting',
              onTap: () {
                // TODO: Implement privacy settings
              },
              isDark: isDark,
            ),
            
            _buildMenuItem(
              icon: Icons.notifications_outline,
              title: 'Notifications',
              onTap: () {
                // TODO: Implement notifications
              },
              isDark: isDark,
            ),
            
            _buildMenuItem(
              icon: Icons.quiz_outlined,
              title: 'Skin Type Quiz',
              onTap: () => Navigator.pushNamed(context, '/quiz'),
              isDark: isDark,
            ),
            
            _buildMenuItem(
              icon: Icons.history,
              title: 'Order History',
              onTap: () {
                // TODO: Implement order history
              },
              isDark: isDark,
            ),
            
            _buildMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Shipping Address',
              onTap: () {
                // TODO: Implement shipping address
              },
              isDark: isDark,
            ),
            
            const SizedBox(height: 40),
            
            // Sign Out
            GestureDetector(
              onTap: () async {
                try {
                  await authService.signOut();
                  await PreferencesService.clearAll();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/signin',
                      (route) => false,
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sign out failed: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.logout,
                        color: AppColors.primaryPink,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    TitleText(
                      'Sign Out',
                      color: AppColors.primaryPink,
                    ),
                  ],
                ),
              ),
            ),
            
            // Add bottom padding for the island tab bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryPink.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryPink,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TitleText(
                title,
                color: isDark ? AppColors.creamBackground : AppColors.darkText,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? AppColors.creamBackground.withOpacity(0.5) : AppColors.lightText,
            ),
          ],
        ),
      ),
    );
  }
}