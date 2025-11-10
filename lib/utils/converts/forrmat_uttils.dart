import 'package:intl/intl.dart';

class FormatUtils {
  /// 1. Bao nhiêu giờ/phút/ngày trước
  static String timeAgo(String date) {
    final now = DateTime.now();
    final diff = now.difference(DateTime.parse(date).toLocal());
    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s trước';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes} phút trước';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} giờ trước';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} ngày trước';
    } else if (diff.inDays < 30) {
      return '${diff.inDays} ngày trước';
    } else {
      // Nếu > 7 ngày, hiện dạng ngày/tháng/năm
      return DateFormat('dd/MM/yyyy').format(DateTime.parse(date));
    }
  }

  /// 2. Format ngày
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(pattern).format(date);
  }

  /// 3. Format số thành nghìn đồng
  static String formatCurrency(num amount) {
    final formatter = NumberFormat('#,###', 'vi_VN');
    return '${formatter.format(amount)} ₫';
  }
}
