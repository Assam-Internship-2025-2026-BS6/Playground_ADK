import 'dart:async';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

class WebUtils {
  static bool get isFullscreen => html.document.fullscreenElement != null;
  
  static double? get screenWidth => html.window.screen?.width?.toDouble();
  
  static Future<void> requestFullscreen() async {
    html.document.documentElement?.requestFullscreen();
  }
  
  static Future<void> exitFullscreen() async {
    html.document.exitFullscreen();
  }
  
  static Stream<void> get onFullscreenChange => html.document.onFullscreenChange;
}
