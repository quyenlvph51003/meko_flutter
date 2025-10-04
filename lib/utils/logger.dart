import 'package:logger/logger.dart';

class MyLogger {
  static Logger logger = Logger();

  static void v(dynamic message) {
    logger.v("🤍 VERBOSE: $message");
  }

  static void d(dynamic message) {
    logger.d("💙 DEBUG: $message");
  }

  static void i(dynamic message) {
    logger.i("💚️ INFO: $message");
  }

  static void w(dynamic message) {
    logger.w("💛 WARNING: $message");
  }

  static void e(dynamic message) {
    logger.e("❤️ ERROR: $message");
  }
}
