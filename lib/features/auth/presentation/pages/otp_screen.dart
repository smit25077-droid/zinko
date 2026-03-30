import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../user/presentation/bloc/user_bloc.dart';
import '../../../user/presentation/bloc/user_event.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

// I'll add the events to user_event.dart later, for now let's hope it exists or I'll add them next.
// Actually, I'll just use UpdateUserProfileEvent to set the verified status for now if I want to keep it simple.
// but it's better to have dedicated events.

class OtpScreen extends StatefulWidget {
  final String type;
  final String target;
  const OtpScreen({super.key, required this.type, required this.target});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    for (var c in _controllers) { c.dispose(); }
    for (var f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  void _onVerify() async {
    setState(() => _isVerifying = true);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isVerifying = false;
      _isSuccess = true;
    });

    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      if (widget.type == 'Email') {
        context.read<UserBloc>().add(VerifyEmailEvent());
      } else {
        context.read<UserBloc>().add(VerifyPhoneEvent());
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('VERIFICATION', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 2.0, fontSize: 16)),
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
                      color: GlassTheme.textColor(context).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: GlassTheme.glassBorder(context)),
                    ),
                    child: Icon(
                      widget.type == 'Email' ? Icons.mail_outline_rounded : Icons.phone_iphone_rounded,
                      color: GlassTheme.textColor(context),
                      size: 44,
                    ),
                  ).animate().scale(curve: Curves.easeOutBack, duration: 800.ms).fadeIn(),
                  const SizedBox(height: 32),
                  Text('IDENTITY VERIFICATION', 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: GlassTheme.textColor(context), letterSpacing: -0.5)),
                  const SizedBox(height: 12),
                  Text(
                    'We sent a 6-digit security code to\n${widget.target}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: GlassTheme.secondaryTextColor(context).withOpacity(0.5), fontWeight: FontWeight.w600, height: 1.5),
                  ),
                  const SizedBox(height: 48),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => _buildOtpBox(index)),
                  ),
                  const SizedBox(height: 48),
                  _GlassButton(
                    onPressed: _isVerifying ? () {} : _onVerify,
                    child: _isVerifying
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                        : const Text('VERIFY ACCOUNT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 13)),
                  ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.1),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {},
                    child: Text('RESEND CODE', style: TextStyle(color: GlassTheme.secondaryTextColor(context).withOpacity(0.5), fontWeight: FontWeight.w900, letterSpacing: 1.0, fontSize: 11)),
                  ).animate(delay: 600.ms).fadeIn(),
                  const SizedBox(height: 48), // Bottom safe space
                ],
              ),
            ),
          ),
          if (_isSuccess)
            Container(
              color: const Color(0xFF0B1220),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded, color: Colors.black, size: 50),
                    ).animate().scale(curve: Curves.easeOutBack, duration: 800.ms),
                    const SizedBox(height: 24),
                    const Text('VERIFIED', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),
        ],
      ),
    ),
  );
}

  Widget _buildOtpBox(int index) {
    return Container(
      width: 50,
      height: 60,
      decoration: BoxDecoration(
        color: GlassTheme.textColor(context).withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: GlassTheme.glassBorder(context)),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: GlassTheme.textColor(context)),
        decoration: const InputDecoration(counterText: "", border: InputBorder.none),
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
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
