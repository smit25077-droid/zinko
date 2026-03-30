import 'dart:io';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../../utils/glass_theme.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '/edit-profile';
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _bioController;
  String? _pickedImagePath;

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    String name = '';
    String phone = '';
    String email = '';
    String role = '';
    String bio = '';

    if (userState is UserLoaded) {
      name = userState.user.name;
      phone = userState.user.phone;
      email = userState.user.email;
      role = userState.user.role;
      bio = userState.user.bio;
    }

    _fullNameController = TextEditingController(text: name);
    _phoneController = TextEditingController(text: phone);
    _emailController = TextEditingController(text: email);
    _roleController = TextEditingController(text: role);
    _bioController = TextEditingController(text: bio);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      setState(() {
        _pickedImagePath = result.path;
      });
    }
  }

  void _onSave() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<UserBloc>().add(
          UpdateUserProfileEvent(
            name: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            role: _roleController.text.trim(),
            bio: _bioController.text.trim(),
            profileImage: _pickedImagePath, // Passes the path (mocked)
          ),
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _GlassHeaderButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
        ),
        title: Text(
          'EDIT IDENTITY',
          style: TextStyle(
            color: GlassTheme.textColor(context),
            fontWeight: FontWeight.w900,
            fontSize: 16,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _onSave,
            child: Text(
              'SAVE',
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/cafe_hotel_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(color: GlassTheme.backgroundOverlay(context)),
            ),
          ),
          SafeArea(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return Center(child: CircularProgressIndicator(color: theme.primaryColor));
                }
                if (state is UserLoaded) {
                  final user = state.user;
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          Center(
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: theme.primaryColor.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: _pickedImagePath != null
                                          ? Image.file(
                                              File(_pickedImagePath!),
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              user.profileImage,
                                              width: 120,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(color: Colors.grey, width: 120, height: 120),
                                            ),
                                    ),
                                  ).animate().scale(curve: Curves.elasticOut, duration: 800.ms),
                                  Positioned(
                                    bottom: 4,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: theme.primaryColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 10,
                                          )
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ).animate(delay: 400.ms).fadeIn().scale(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: GlassTheme.glassColor(context),
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: GlassTheme.glassBorder(context),
                                    width: 1.2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildPremiumField(
                                      context,
                                      label: 'FULL NAME',
                                      controller: _fullNameController,
                                      icon: Icons.person_outline_rounded,
                                    ),
                                    const SizedBox(height: 20),
                                    _buildPremiumField(
                                      context,
                                      label: 'JOB TITLE',
                                      controller: _roleController,
                                      icon: Icons.badge_outlined,
                                    ),
                                    const SizedBox(height: 20),
                                    _buildPremiumField(
                                      context,
                                      label: 'EMAIL ADDRESS',
                                      controller: _emailController,
                                      icon: Icons.alternate_email_rounded,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    const SizedBox(height: 20),
                                    _buildPremiumField(
                                      context,
                                      label: 'PHONE NUMBER',
                                      controller: _phoneController,
                                      icon: Icons.phone_android_rounded,
                                      keyboardType: TextInputType.phone,
                                    ),
                                    const SizedBox(height: 20),
                                    _buildPremiumField(
                                      context,
                                      label: 'BIO',
                                      controller: _bioController,
                                      icon: Icons.notes_rounded,
                                      maxLines: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1, end: 0),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  );
                }
                return const Center(child: Text('Data context missing'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumField(
    BuildContext context, {
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: GlassTheme.secondaryTextColor(context).withOpacity(0.4),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: TextStyle(color: GlassTheme.textColor(context), fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: GlassTheme.textColor(context).withOpacity(0.03),
            prefixIcon: Icon(icon, color: GlassTheme.iconColor(context).withOpacity(0.4), size: 18),
            hintText: 'Enter $label',
            hintStyle: TextStyle(color: GlassTheme.secondaryTextColor(context).withOpacity(0.2), fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: GlassTheme.glassBorder(context)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: GlassTheme.glassBorder(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.primaryColor, width: 1.5),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) return 'Required';
            return null;
          },
        ),
      ],
    );
  }
}

class _GlassHeaderButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _GlassHeaderButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: GlassTheme.glassColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: GlassTheme.glassBorder(context)),
            ),
            child: Icon(icon, color: GlassTheme.iconColor(context), size: 18),
          ),
        ),
      ),
    );
  }
}
