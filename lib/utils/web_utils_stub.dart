import 'dart:async';

class WebUtils {
  static bool get isFullscreen => false;
  
  static double? get screenWidth => null;
  
  static Future<void> requestFullscreen() async {
    // No-op on non-web platforms
  }
  
  static Future<void> exitFullscreen() async {
    // No-op on non-web platforms
  }
  
  static Stream<void> get onFullscreenChange => const Stream.empty();
}
