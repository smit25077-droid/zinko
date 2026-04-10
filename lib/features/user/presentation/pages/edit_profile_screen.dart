import 'dart:io';
import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zinko_app/core/routes/app_router.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';
import '../bloc/edit_profile_form_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/edit-profile';
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        String gender = '';
        String birthdate = '';
        if (state is UserLoaded) {
          gender = state.user.gender;
          birthdate = state.user.birthdate;
        }
        return BlocProvider(
          create: (context) => EditProfileFormBloc(
            initialGender: gender,
            initialBirthdate: birthdate,
          ),
          child: const _EditProfileContent(),
        );
      },
    );
  }
}

class _EditProfileContent extends StatefulWidget {
  const _EditProfileContent();

  @override
  State<_EditProfileContent> createState() => _EditProfileContentState();
}

class _EditProfileContentState extends State<_EditProfileContent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _roleController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _companyNameController;

  @override
  void initState() {
    super.initState();
    final userState = context.read<UserBloc>().state;
    String name = '';
    String phone = '';
    String email = '';
    String role = '';
    String bio = '';
    String city = '';
    String stateStr = '';
    String companyName = '';

    if (userState is UserLoaded) {
      name = userState.user.name;
      phone = userState.user.phone;
      email = userState.user.email;
      role = userState.user.role;
      bio = userState.user.bio;
      city = userState.user.city;
      stateStr = userState.user.state;
      companyName = userState.user.companyName;
    }

    _fullNameController = TextEditingController(text: name);
    _phoneController = TextEditingController(text: phone);
    _emailController = TextEditingController(text: email);
    _roleController = TextEditingController(text: role);
    _bioController = TextEditingController(text: bio);
    _cityController = TextEditingController(text: city);
    _stateController = TextEditingController(text: stateStr);
    _stateController = TextEditingController(text: stateStr);
    _companyNameController = TextEditingController(text: companyName);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _companyNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      if (context.mounted) {
        context.read<EditProfileFormBloc>().add(SetImagePath(result.path));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: GlassTheme.textColor(context),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      if (context.mounted) {
        context.read<EditProfileFormBloc>().add(SetBirthdate(formattedDate));
      }
    }
  }

  void _onSave(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final formState = context.read<EditProfileFormBloc>().state;

    context.read<UserBloc>().add(
          UpdateUserProfileEvent(
            name: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            role: _roleController.text.trim(),
            bio: _bioController.text.trim(),
            city: _cityController.text.trim(),
            state: _stateController.text.trim(),
            gender: formState.gender,
            birthdate: formState.birthdate,
            companyName: _companyNameController.text.trim(),
            profileImage: formState.pickedImagePath,
          ),
        );
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
            onTap: () => AppRouter.safetyPop(context),
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
            onPressed: () => _onSave(context),
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
      body: ZinkoBackground(
        child: SafeArea(
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully')),
                );
                AppRouter.safetyPop(context);
              } else if (state is UserError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: theme.primaryColor));
                }
                final user = (state is UserLoaded) ? state.user : null;
                return BlocBuilder<EditProfileFormBloc, EditProfileFormState>(
                  builder: (context, formState) {
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
                            onTap: () => _pickImage(context),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color:
                                          theme.primaryColor.withValues(alpha: 0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: formState.pickedImagePath != null
                                        ? Image.file(
                                            File(formState.pickedImagePath!),
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          )
                                        : (user != null
                                            ? Image.network(
                                                user.profileImage,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                        color: Colors.grey,
                                                        width: 120,
                                                        height: 120),
                                              )
                                            : Container(
                                                color: Colors.grey,
                                                width: 120,
                                                height: 120)),
                                  ),
                                ).animate().scale(
                                    curve: Curves.elasticOut, duration: 800.ms),
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
                                          color: Colors.black.withValues(alpha: 0.2),
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
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPremiumField(
                                    context,
                                    label: 'PHONE NUMBER',
                                    controller: _phoneController,
                                    icon: Icons.phone_android_rounded,
                                    keyboardType: TextInputType.phone,
                                    readOnly: true,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPremiumField(
                                    context,
                                    label: 'CITY',
                                    controller: _cityController,
                                    icon: Icons.location_city_rounded,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPremiumField(
                                    context,
                                    label: 'STATE',
                                    controller: _stateController,
                                    icon: Icons.map_rounded,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildGenderRadio(context, formState),
                                  const SizedBox(height: 20),
                                  _buildPremiumField(
                                    context,
                                    label: 'BIRTHDATE',
                                    controller: TextEditingController(
                                        text: formState.birthdate),
                                    icon: Icons.calendar_today_rounded,
                                    hintText: 'YYYY-MM-DD',
                                    onTap: () => _selectDate(context),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPremiumField(
                                    context,
                                    label: 'COMPANY NAME',
                                    controller: _companyNameController,
                                    icon: Icons.business_rounded,
                                    isRequired: false,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildPremiumField(
                                    context,
                                    label: 'BIO',
                                    controller: _bioController,
                                    icon: Icons.notes_rounded,
                                    maxLines: 3,
                                    isRequired: false,
                                  ),
                                ],
                              ),
                            ),
                          )
                              .animate(delay: 200.ms)
                              .fadeIn()
                              ,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                     ) );
                  },
                );
              },
            ),
          ),
        ),
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
    String? hintText,
    bool readOnly = false,
    bool isRequired = true,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly || onTap != null,
          onTap: onTap,
          keyboardType: keyboardType,
          style: TextStyle(
              color: GlassTheme.textColor(context)
                  .withValues(alpha: readOnly ? 0.5 : 1.0),
              fontSize: 14,
              fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly || onTap != null
                ? OptimizedColors.white12.withValues(alpha: 0.05)
                : OptimizedColors.white12,
            prefixIcon: Icon(icon,
                color: GlassTheme.iconColor(context)
                    .withValues(alpha: readOnly ? 0.2 : 0.4),
                size: 18),
            hintText: hintText ?? 'Enter $label',
            hintStyle: TextStyle(
                color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.2),
                fontSize: 13),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildGenderRadio(BuildContext context, EditProfileFormState formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENDER',
          style: TextStyle(
            color: GlassTheme.secondaryTextColor(context).withValues(alpha: 0.4),
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _genderOption(context, 'Male', formState),
            _genderOption(context, 'Female', formState),
            _genderOption(context, 'Other', formState),
          ],
        ),
      ],
    );
  }

  Widget _genderOption(
      BuildContext context, String value, EditProfileFormState formState) {
    bool isSelected = formState.gender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () =>
            context.read<EditProfileFormBloc>().add(SetGender(value)),
        child: Container(
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                : OptimizedColors.white12,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : GlassTheme.glassBorder(context),
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : GlassTheme.secondaryTextColor(context),
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ),
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

