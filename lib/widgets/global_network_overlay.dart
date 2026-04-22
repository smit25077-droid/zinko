import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zinko_app/core/bloc/network_bloc.dart';

/// A key that the overlay uses to show dialogs outside [MaterialApp]'s builder.
/// Assign this to [MaterialApp.navigatorKey].
final GlobalKey<NavigatorState> zinkoNavigatorKey = GlobalKey<NavigatorState>();

class GlobalNetworkOverlay extends StatelessWidget {
  final Widget child;

  const GlobalNetworkOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NetworkBloc(),
      child: _OverlayContent(child: child),
    );
  }
}

class _OverlayContent extends StatefulWidget {
  final Widget child;
  const _OverlayContent({required this.child});

  @override
  State<_OverlayContent> createState() => _OverlayContentState();
}

class _OverlayContentState extends State<_OverlayContent>
    with SingleTickerProviderStateMixin {
  bool _dialogShowing = false;
  late AnimationController _bannerCtrl;
  late Animation<Offset> _bannerSlide;

  @override
  void initState() {
    super.initState();
    _bannerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _bannerSlide = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _bannerCtrl, curve: Curves.easeOut));
  }

  void _onStatusChanged(bool connected) {
    if (!connected) {
      _bannerCtrl.forward();
      _showDialog();
    } else {
      _bannerCtrl.reverse();
      if (_dialogShowing) {
        zinkoNavigatorKey.currentState?.pop();
        _dialogShowing = false;
      }
    }
  }

  void _showDialog() {
    final nav = zinkoNavigatorKey.currentState;
    if (nav == null || _dialogShowing) return;
    _dialogShowing = true;

    nav.push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      pageBuilder: (ctx, _, __) => _NoInternetDialog(
        onRetry: () async {
          final bloc = context.read<NetworkBloc>();
          await bloc.checkNow();
          if (bloc.state.isConnected) {
            nav.pop();
            _dialogShowing = false;
            _bannerCtrl.reverse();
          }
        },
      ),
    ));
  }

  @override
  void dispose() {
    _bannerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkBloc, NetworkState>(
      listenWhen: (prev, curr) => prev.isConnected != curr.isConnected,
      listener: (context, state) => _onStatusChanged(state.isConnected),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            widget.child,
            // Animated top banner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _bannerSlide,
                child: SafeArea(
                  bottom: false,
                  child: Material(
                    color: Colors.transparent,
                    child: ClipRRect(
                      child: Container(
                        color: const Color(0xFFC62828),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Row(
                          children: [
                            const Icon(Icons.wifi_off_rounded,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'No Internet Connection',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  color: Colors.white54,
                                  shape: BoxShape.circle),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoInternetDialog extends StatefulWidget {
  final VoidCallback onRetry;
  const _NoInternetDialog({required this.onRetry});

  @override
  State<_NoInternetDialog> createState() => _NoInternetDialogState();
}

class _NoInternetDialogState extends State<_NoInternetDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 350));
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E2A) : Colors.white;
    final fgText = isDark ? Colors.white : Colors.black87;
    final subText = isDark ? Colors.white60 : Colors.black45;

    return PopScope(
      canPop: false,
      child: Center(
        child: ScaleTransition(
          scale: _scale,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.wifi_off_rounded,
                        size: 40, color: Colors.red.shade400),
                  ),
                  const SizedBox(height: 20),
                  Text('No Internet',
                      style: TextStyle(
                          color: fgText,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          letterSpacing: -0.5)),
                  const SizedBox(height: 10),
                  Text(
                    'Please check your Wi-Fi or mobile data and try again.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subText, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _checking
                          ? null
                          : () async {
                              setState(() => _checking = true);
                              await Future.delayed(
                                  const Duration(milliseconds: 500));
                              widget.onRetry();
                              if (mounted) setState(() => _checking = false);
                            },
                      icon: _checking
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.5, color: Colors.white),
                            )
                          : const Icon(Icons.refresh_rounded, size: 20),
                      label: Text(_checking ? 'Checking…' : 'Try Again',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
