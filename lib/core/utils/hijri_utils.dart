import 'package:hijri/hijri_calendar.dart';

class HijriUtils {
  HijriUtils._();

  static const _months = [
    'Mouharram',
    'Safar',
    'Rabīʿ al-Awwal',
    'Rabīʿ ath-Thānī',
    'Jumāda al-Ūlā',
    'Jumāda al-Ākhira',
    'Rajab',
    'Shaʿbān',
    'Ramaḍān',
    'Shawwāl',
    'Dhū al-Qaʿda',
    'Dhū al-Ḥijja',
  ];

  static String format(HijriCalendar h) =>
      '${h.hDay} ${_months[h.hMonth - 1]} ${h.hYear}';
}
