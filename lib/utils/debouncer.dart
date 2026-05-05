import 'dart:async';
import 'dart:ui';

/// A utility class to debounce actions.
/// Useful for search fields to avoid calling APIs on every keystroke.
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
