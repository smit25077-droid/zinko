import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/routes/app_router.dart';
import 'package:zinko_app/core/theme/optimized_colors.dart';
import 'package:zinko_app/widgets/global_network_overlay.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_bloc.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_event.dart';
import 'package:zinko_app/features/user/presentation/bloc/user_state.dart';
import 'package:intl/intl.dart';
import 'package:zinko_app/utils/glass_theme.dart';
import 'package:zinko_app/widgets/zinko_scroll_body.dart';
import 'package:zinko_app/widgets/zinko_text_field.dart';
import 'package:zinko_app/widgets/zinko_background.dart';
import 'package:zinko_app/widgets/zinko_app_bar.dart';
import 'package:zinko_app/features/user/presentation/bloc/edit_profile_form_bloc.dart';
import 'package:zinko_app/widgets/zinko_common_card.dart';
import 'package:zinko_app/utils/zinko_flushbar.dart';
import 'package:zinko_app/utils/common_util.dart';

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
          final rawDate = state.user.birthdate;
          if (rawDate.isNotEmpty && RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(rawDate)) {
            try {
              final date = DateTime.parse(rawDate);
              birthdate = DateFormat('dd MMMM yyyy').format(date);
            } catch (_) {
              birthdate = rawDate;
            }
          } else {
            birthdate = rawDate;
          }
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

  bool _processedSuccess = false;

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
      final formattedDate = DateFormat('dd MMMM yyyy').format(picked);
      if (context.mounted) {
        context.read<EditProfileFormBloc>().add(SetBirthdate(formattedDate));
      }
    }
  }

  String _toApiDate(String prettyDate) {
    if (prettyDate.isEmpty) return prettyDate;
    try {
      if (RegExp(r'^\d{4}-\d{2}-\d{2}').hasMatch(prettyDate)) return prettyDate;
      final date = DateFormat('dd MMMM yyyy').parse(prettyDate);
      return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    } catch (_) {
      return prettyDate;
    }
  }

  void _onSave(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final formState = context.read<EditProfileFormBloc>().state;
    final userState = context.read<UserBloc>().state;
    final int userCode = (userState is UserLoaded) ? userState.user.userCode : 0;

    _processedSuccess = false; // Reset before starting new update

    context.read<UserBloc>().add(
          UpdateUserProfileEvent(
            name: _fullNameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            role: _roleController.text.trim(),
            bio: _bioController.text.trim(),
            userCode: userCode,
            city: _cityController.text.trim(),
            state: _stateController.text.trim(),
            gender: formState.gender,
            birthdate: _toApiDate(formState.birthdate),
            companyName: _companyNameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ZinkoBackground(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: ZinkoAppBar(
          title: 'Edit Identity',
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
            CommonUtil.hGap8,
          ],
        ),
        body: SafeArea(
          child: BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                if (_processedSuccess) return; // Prevent double execution
                _processedSuccess = true;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (Navigator.of(context).canPop()) {
                    AppRouter.safetyPop(context);
                  }
                  context.read<UserBloc>().add(GetUserProfileEvent());
                  
                  if (zinkoNavigatorKey.currentContext != null) {
                    ZinkoFlushbar.showSuccess(
                      context: zinkoNavigatorKey.currentContext!,
                      message: 'Profile updated successfully',
                    );
                  }
                });
              } else if (state is UserError) {
                _processedSuccess = false; // Reset on error to allow retry
                ZinkoFlushbar.showError(context: context, message: state.message);
              }
            },
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state is UserLoading) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: theme.primaryColor));
                }
                // final user = (state is UserLoaded) ? state.user : null;
                return BlocBuilder<EditProfileFormBloc, EditProfileFormState>(
                  builder: (context, formState) {
                    return ZinkoScrollBody(
                  // physics: const BouncingScrollPhysics(),
                  // padding: CommonUtil.pH24,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CommonUtil.vGap12,
                        // Center(
                        //   child: (user != null
                        //       ? Container(
                        //           padding: const EdgeInsets.all(4),
                        //           decoration: BoxDecoration(
                        //             shape: BoxShape.circle,
                        //             border: Border.all(
                        //               color:
                        //                   theme.primaryColor.withValues(alpha: 0.3),
                        //               width: 2,
                        //             ),
                        //           ),
                        //           child: ClipRRect(
                        //             borderRadius: BorderRadius.circular(100),
                        //             child: ZinkoNetworkImage(
                        //               imageUrl: user.profileImage,
                        //               width: 120,
                        //               height: 120,
                        //               fit: BoxFit.cover,
                        //             ),
                        //           ),
                        //         )
                        //             .animate()
                        //             .scale(curve: Curves.elasticOut, duration: 800.ms)
                        //       : const SizedBox()),
                        // ),
                        // const SizedBox(height: 24),
                        ZinkoCommonCard(
                          padding: CommonUtil.pAll24,
                          child: Column(
                            children: [
                              ZinkoTextField(
                                label: 'FULL NAME',
                                controller: _fullNameController,
                                icon: Icons.person_outline_rounded,
                                isPascalCase: true,
                              ),
                              CommonUtil.vGap20,
                              ZinkoTextField(
                                label: 'JOB TITLE',
                                controller: _roleController,
                                icon: Icons.badge_outlined,
                              ),
                              CommonUtil.vGap20,
                              ZinkoTextField(
                                label: 'EMAIL ADDRESS',
                                controller: _emailController,
                                icon: Icons.alternate_email_rounded,
                                keyboardType: TextInputType.emailAddress,
                                readOnly: true,
                              ),
                              CommonUtil.vGap20,
                              ZinkoTextField(
                                label: 'PHONE NUMBER',
                                controller: _phoneController,
                                icon: Icons.phone_android_rounded,
                                keyboardType: TextInputType.phone,
                                readOnly: true,
                              ),
                              CommonUtil.vGap20,
                              ZinkoTextField(
                                label: 'CITY',
                                controller: _cityController,
                                icon: Icons.location_city_rounded,
                                isPascalCase: true,
                              ),
                              CommonUtil.vGap20,
                              ZinkoTextField(
                                label: 'STATE',
                                controller: _stateController,
                                icon: Icons.map_rounded,
                                isPascalCase: true,
                              ),
                              CommonUtil.vGap20,
                              _buildGenderRadio(context, formState),
                              CommonUtil.vGap20,
                              ZinkoTextField(
                                label: 'BIRTHDATE',
                                controller: TextEditingController(
                                    text: formState.birthdate),
                                icon: Icons.calendar_today_rounded,
                                hintText: 'Select Birthday',
                                onTap: () => _selectDate(context),
                              ),
                              CommonUtil.vGap20,
                              ZinkoTextField(
                                label: 'COMPANY NAME',
                                controller: _companyNameController,
                                icon: Icons.business_rounded,
                                isRequired: false,
                              ),
                              CommonUtil.vGap20,
                              ZinkoTextField(
                                label: 'BIO',
                                controller: _bioController,
                                icon: Icons.notes_rounded,
                                maxLines: 3,
                                isRequired: false,
                              ),
                            ],
                           ),
                        ).animate(delay: 200.ms).fadeIn(),
                        CommonUtil.vGap40,
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
        CommonUtil.vGap12,
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
          margin: CommonUtil.pRight8,
          padding: CommonUtil.pV12,
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                : OptimizedColors.white12,
            borderRadius: CommonUtil.bRadius12,
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

