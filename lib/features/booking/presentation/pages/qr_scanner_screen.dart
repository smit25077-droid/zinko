import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import 'cafe_menu_screen.dart';
import 'event_registration_success_screen.dart';
import '../../domain/entities/booking_entity.dart';
import '../../../../widgets/zinko_success_overlay.dart';

class QRScannerScreen extends StatefulWidget {
  static const String routeName = '/qr-scanner';

  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  bool _hasPermission = false;
  bool _isScanning = true;
  final MobileScannerController _controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermission();
    });
  }

  Future<void> _checkPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    if (mounted) {
      setState(() => _hasPermission = status.isGranted);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_hasPermission)
            MobileScanner(
              controller: _controller,
              onDetect: (capture) {
                if (!_isScanning) return;
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  setState(() => _isScanning = false);

                  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                  final bookingId = args?['bookingId'] as String?;
                  final placeType = args?['placeType'] as BookingPlaceType?;
                  final bool isEvent = placeType == BookingPlaceType.event;

                  if (placeType == BookingPlaceType.cafe || isEvent) {
                    Navigator.pushReplacementNamed(
                      context,
                      isEvent ? EventRegistrationSuccessScreen.routeName : CafeMenuScreen.routeName,
                      arguments: {'bookingId': bookingId, 'placeType': placeType, 'isCheckIn': true},
                    );
                  } else {
                    if (bookingId != null) {
                      context.read<BookingBloc>().add(CompleteBookingEvent(bookingId));
                    }
                    ZinkoSuccessOverlay.show(
                      context,
                      title: 'CHECKED IN!',
                      subtitle: 'Order placed. Enjoy your workspace!',
                      onFinish: () => Navigator.pop(context),
                    );
                  }
                }
              },
            )
          else
            Container(
              width: double.infinity, height: double.infinity, color: const Color(0xFF121212),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.camera_alt_rounded, color: Colors.white24, size: 64),
                    const SizedBox(height: 16),
                    Text('Camera permission required', style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 16)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _checkPermission,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E88E5), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: const Text('Grant Permission'),
                    ),
                  ],
                ),
              ),
            ),
          _buildOverlay(context),
        ],
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black.withAlpha(150), BlendMode.srcOut),
          child: Stack(
            children: [
              Container(decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut)),
              Center(child: Container(width: 280, height: 280, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)))),
            ],
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
                const Text('Scan QR Code', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
          ),
        ),
        Center(
          child: Stack(
            children: [
              Container(width: 280, height: 280, decoration: BoxDecoration(border: Border.all(color: Colors.white.withAlpha(30)), borderRadius: BorderRadius.circular(20))),
              _buildCorner(top: 0, left: 0, isTop: true, isLeft: true),
              _buildCorner(top: 0, right: 0, isTop: true, isLeft: false),
              _buildCorner(bottom: 0, left: 0, isTop: false, isLeft: true),
              _buildCorner(bottom: 0, right: 0, isTop: false, isLeft: false),
            ],
          ),
        ).animate().shimmer(duration: 2000.ms, color: Colors.white.withAlpha(50)),
        Positioned(
          bottom: 100, left: 0, right: 0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(color: Colors.black.withAlpha(200), borderRadius: BorderRadius.circular(30)),
                child: const Text('Align QR code within the frame', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 48),
              GestureDetector(
                onTap: () {
                  final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
                  final bookingId = args?['bookingId'] as String?;
                  final placeType = args?['placeType'] as BookingPlaceType?;
                  final bool isEvent = placeType == BookingPlaceType.event;

                  if (placeType == BookingPlaceType.cafe || isEvent) {
                    Navigator.pushReplacementNamed(
                      context,
                      isEvent ? EventRegistrationSuccessScreen.routeName : CafeMenuScreen.routeName,
                      arguments: {'bookingId': bookingId, 'placeType': placeType, 'isCheckIn': true},
                    );
                  } else {
                    if (bookingId != null) {
                      context.read<BookingBloc>().add(CompleteBookingEvent(bookingId));
                    }
                    ZinkoSuccessOverlay.show(
                      context,
                      title: 'CHECKED IN!',
                      subtitle: 'Order placed. Enjoy your workspace!',
                      onFinish: () => Navigator.pop(context),
                    );
                  }
                },
                child: Text('Zinko Scan (Skip)', style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 17, fontWeight: FontWeight.w700, decoration: TextDecoration.underline, decorationColor: Colors.white.withAlpha(180))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCorner({double? top, double? bottom, double? left, double? right, required bool isTop, required bool isLeft}) {
    const double size = 35.0;
    const double thickness = 6.0;
    const Color cornerColor = Color(0xFF1E88E5);
    const double radius = 10.0;

    return Positioned(
      top: top, bottom: bottom, left: left, right: right,
      child: SizedBox(
        width: size, height: size,
        child: Stack(
          children: [
            Positioned(
              top: isTop ? 0 : null, bottom: isTop ? null : 0, left: 0, right: 0,
              child: Container(height: thickness, decoration: BoxDecoration(color: cornerColor, borderRadius: BorderRadius.circular(radius))),
            ),
            Positioned(
              left: isLeft ? 0 : null, right: isLeft ? null : 0, top: 0, bottom: 0,
              child: Container(width: thickness, decoration: BoxDecoration(color: cornerColor, borderRadius: BorderRadius.circular(radius))),
            ),
          ],
        ),
      ),
    );
  }
}
