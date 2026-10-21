import 'package:intl/intl.dart';

class Formatters {
  Formatters._();

  static final NumberFormat _currency = NumberFormat('#,##0', 'en_US');
  static final DateFormat _date = DateFormat('dd/MM/yyyy');
  static final DateFormat _dateTime = DateFormat('dd/MM/yyyy HH:mm');
  static final DateFormat _time = DateFormat('HH:mm');

  /// 2490000 -> "2,490,000 ₭"
  static String money(num? value) => '${_currency.format(value ?? 0)} ₭';

  static String number(num? value) => _currency.format(value ?? 0);

  static String date(DateTime? value) => value == null ? '-' : _date.format(value.toLocal());

  static String dateTime(DateTime? value) => value == null ? '-' : _dateTime.format(value.toLocal());

  static String time(DateTime? value) => value == null ? '-' : _time.format(value.toLocal());

  static String timeAgo(DateTime? value) {
    if (value == null) return '-';
    final diff = DateTime.now().difference(value.toLocal());
    if (diff.inMinutes < 1) return 'ດຽວນີ້';
    if (diff.inMinutes < 60) return '${diff.inMinutes} ນາທີກ່ອນ';
    if (diff.inHours < 24) return '${diff.inHours} ຊົ່ວໂມງກ່ອນ';
    if (diff.inDays < 30) return '${diff.inDays} ມື້ກ່ອນ';
    return date(value);
  }

  /// 0.152 -> "15%"
  static String percent(num? value) => '${((value ?? 0) * 100).round()}%';

  static DateTime? parse(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static double toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static int toInt(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
