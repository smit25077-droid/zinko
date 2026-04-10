import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_state.dart';
import '../../../user/presentation/bloc/user_event.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';
import '../bloc/otp_bloc.dart';

class OtpScreen extends StatelessWidget {
  final String type;
  final String target;
  final String userCode;
  const OtpScreen({
    super.key,
    required this.type,
    required this.target,
    required this.userCode,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpBloc(),
      child: _OtpContent(
        type: type,
        target: target,
        userCode: userCode,
      ),
    );
  }
}

class _OtpContent extends StatefulWidget {
  final String type;
  final String target;
  final String userCode;

  const _OtpContent({
    required this.type,
    required this.target,
    required this.userCode,
  });

  @override
  State<_OtpContent> createState() => _OtpContentState();
}

class _OtpContentState extends State<_OtpContent> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onVerify(BuildContext context) {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all 6 digits')),
      );
      return;
    }

    context.read<OtpBloc>().add(SetOtpVerifying(true));

    if (widget.type == 'Email') {
      context.read<UserBloc>().add(VerifyEmailOtpEvent(
            userCode: widget.userCode,
            otp: otp,
          ));
    } else {
      // Logic for phone verification if applicable
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        final otpBloc = context.read<OtpBloc>();
        if (state is UserLoaded && otpBloc.state.isVerifying) {
          // Success!
          otpBloc.add(SetOtpVerifying(false));
          otpBloc.add(SetOtpSuccess(true));
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted && context.mounted) Navigator.pop(context);
          });
        } else if (state is UserError && otpBloc.state.isVerifying) {
          // Failure
          otpBloc.add(SetOtpVerifying(false));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      child: BlocBuilder<OtpBloc, OtpState>(
        builder: (context, otpState) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text('VERIFICATION',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      fontSize: 16)),
              centerTitle: true,
            ),
            body: ZinkoBackground(
              child: Stack(
                children: [
                  SafeArea(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 48),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: GlassTheme.textColor(context)
                                  .withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: GlassTheme.glassBorder(context)),
                            ),
                            child: Icon(
                              widget.type == 'Email'
                                  ? Icons.mail_outline_rounded
                                  : Icons.phone_iphone_rounded,
                              color: GlassTheme.textColor(context),
                              size: 44,
                            ),
                          )
                              .animate()
                              .scale(curve: Curves.easeOutBack, duration: 800.ms)
                              .fadeIn(),
                          const SizedBox(height: 32),
                          Text('IDENTITY VERIFICATION',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: GlassTheme.textColor(context),
                                  letterSpacing: -0.5)),
                          const SizedBox(height: 12),
                          Text(
                            'We sent a 6-digit security code to\n${widget.target}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                color: GlassTheme.secondaryTextColor(context)
                                    .withValues(alpha: 0.5),
                                fontWeight: FontWeight.w600,
                                height: 1.5),
                          ),
                          const SizedBox(height: 48),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                                6, (index) => _buildOtpBox(index)),
                          ),
                          const SizedBox(height: 48),
                          _GlassButton(
                            onPressed: otpState.isVerifying
                                ? () {}
                                : () => _onVerify(context),
                            child: otpState.isVerifying
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        color: Colors.black, strokeWidth: 2))
                                : const Text('VERIFY ACCOUNT',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 1.0,
                                        fontSize: 13)),
                          ).animate(delay: 400.ms).fadeIn(),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<UserBloc>()
                                  .add(SendEmailOtpEvent(widget.target));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('OTP Resent Successfully')),
                              );
                            },
                            child: Text('RESEND CODE',
                                style: TextStyle(
                                    color:
                                        GlassTheme.secondaryTextColor(context)
                                            .withValues(alpha: 0.5),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.0,
                                    fontSize: 11)),
                          ).animate(delay: 600.ms).fadeIn(),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                  if (otpState.isSuccess)
                    Container(
                      color: const Color(0xFF0B1220),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: const BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              child: const Icon(Icons.check_rounded,
                                  color: Colors.black, size: 50),
                            )
                                .animate()
                                .scale(
                                    curve: Curves.easeOutBack, duration: 800.ms),
                            const SizedBox(height: 24),
                            const Text('VERIFIED',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0)),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: GlassTheme.textColor(context).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GlassTheme.glassBorder(context)),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: GlassTheme.textColor(context)),
        decoration:
            const InputDecoration(counterText: "", border: InputBorder.none),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}

class _GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const _GlassButton({required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18)),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
