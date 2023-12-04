import 'package:intl/intl.dart';

/// 作者：袁汉章 on 2022年10月12日 14:08
/// 邮箱：yhz199132@163.com
/// 时间工具类
//星期
const weeks = [
  '星期一',
  '星期二',
  '星期三',
  '星期四',
  '星期五',
  '星期六',
  '星期日',
];
//大月
const theOddMonth = [1, 3, 5, 7, 8, 10, 12];

class DateTimeUtil {
  //获取当前时间戳
  static int get nowTimestamp => DateTime.now().millisecondsSinceEpoch;

  //获取当前日期
  static String get nowDate =>
      format(DateTime.now(), dataTimePattern: DateTimeFormat.defaultDateStyle);

  //当前时间星期几
  static String get nowWeek => weeks[DateTime.now().weekday - 1];

  //获取当前日期和时间
  static String get nowDateTime =>
      format(DateTime.now(), dataTimePattern: DateTimeFormat.defaultStyle);

  //获取当前日期和时间
  static String get nowTimeTest {
    final now = DateTime.now();
    return '${now.second}:${now.millisecond}';
  }

  //获取当前月份天数
  static int currentDateCount(DateTime dateTime) {
    if (theOddMonth.contains(dateTime.month)) {
      return 31;
    } else if (dateTime.month == 2) {
      final year = dateTime.year;
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }

  //使用预设类型转换格式
  static String formatString(
    String dateTime, {
    DateTimeFormat? dataTimePattern,
  }) {
    try {
      return format(DateTime.parse(dateTime), dataTimePattern: dataTimePattern);
    } catch (e) {
      return '';
    }
  }

  //使用预设类型转换格式
  static String format(
    DateTime dateTime, {
    DateTimeFormat? dataTimePattern,
  }) {
    return dateTimeFormat(dateTime,
        dataTimePattern:
            (dataTimePattern ?? DateTimeFormat.defaultStyle).getValue);
  }

  //使用int类型转换格式
  static String? formatFromInt(int? time,
      {DateTimeFormat? dataTimePattern, bool isUtc = false}) {
    try {
      if (time == null) return null;
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(time, isUtc: isUtc);
      return dateTimeFormat(dateTime,
          dataTimePattern:
              (dataTimePattern ?? DateTimeFormat.defaultStyle).getValue);
    } catch (e) {
      return null;
    }
  }

  //计算两个日期的周数
  static int? countDistanceWeek(String? startTime, String? endTime,
      {DateTimeFormat? dataTimePattern}) {
    try {
      if (startTime == null || endTime == null) return null;
      DateTime startDateTime = DateTime.parse(startTime);
      DateTime endDateTime = DateTime.parse(endTime);
      return endDateTime.difference(startDateTime).inDays ~/ 7;
    } catch (e) {
      return null;
    }
  }

  //根据周期计算日期
  static String? getEndDateFromWeek({String? week, String? startDate}) {
    try {
      return DateTime.tryParse(startDate ?? '')
          ?.add(Duration(days: (int.tryParse(week ?? '') ?? 0) * 7))
          .defaultDate;
    } catch (e) {
      return null;
    }
  }

  //根据传入DateTime和日期格式转换时间
  static String dateTimeFormat(DateTime dateTime,
      {required String dataTimePattern}) {
    final dateFormat = DateFormat(dataTimePattern);
    return dateFormat.format(dateTime);
  }

  //对比当前时间是否超过某个时间段
  static bool exceedDuration(int timestamp, {int? millisecondsSinceEpoch}) {
    final now = DateTime.now().timestamp - timestamp;
    return now > (millisecondsSinceEpoch ?? 1000 * 60 * 2);
  }

  ///根据年月日获取年龄
  static int getAge(int y, int m, int d) {
    int age = 0;
    final dateTime = DateTime.now();
    final int yearNow = dateTime.year;
    final int monthNow = dateTime.month;
    final int dayOfMonthNow = dateTime.day;
    final int yearBirth = y;
    final int monthBirth = m;
    final int dayOfMonthBirth = d;
    age = yearNow - yearBirth; //计算整岁数
    if (monthNow <= monthBirth) {
      if (monthNow == monthBirth) {
        if (dayOfMonthNow < dayOfMonthBirth) age--;
      } else {
        age--; //当前月份在生日之前，年龄减一
      }
    }
    return age;
  }

  //计算闰年，月份
  static int calcDateCount(int year, int month) {
    if (theOddMonth.contains(month)) {
      return 31;
    } else if (month == 2) {
      if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return 29;
      }
      return 28;
    }
    return 30;
  }
}

//预设时间格式
const String defaultStyle = 'yyyy-MM-dd HH:mm:ss';
const String defaultDateMStyle = 'yyyy-MM-dd HH:mm';
const String defaultDateStyle = 'yyyy-MM-dd';
const String defaultTimeStyle = 'HH:mm:ss';
const String defaultHMTimeStyle = 'HH:mm';
const String defaultMMStyle = 'MM-dd HH:mm:ss';
const String defaultMTimeStyle = 'MM-dd HH:mm';
const String defaultChineseStyle = 'yyyy年MM月dd日 HH:mm:ss';
const String defaultChineseTimeStyle = 'HH时mm分ss秒';
const String defaultChineseDateStyle = 'yyyy年MM月dd日';
const String defaultDateTimeStyle = 'yyyyMMddHHmmss';

enum DateTimeFormat {
  defaultStyle, //yyyy-MM-dd HH:mm:ss
  defaultDateMStyle, //yyyy-MM-dd HH:mm
  defaultDateStyle, // yyyy-MM-dd
  defaultTimeStyle, // HH:mm:ss
  defaultMMStyle, // MM-dd HH:mm:ss
  defaultMTimeStyle, // MM-dd HH:mm
  defaultHMTimeStyle, // HH:mm
  defaultChineseStyle, // yyyy年MM月dd日 HH:mm:ss
  defaultChineseTimeStyle, // HH时mm分ss秒
  defaultChineseDateStyle, // yyyy年MM月dd日
  defaultDateTimeStyle, // yyyyMMddHHmmss
}

extension DateTimeFormatExtension on DateTimeFormat {
  String get getValue {
    switch (this) {
      case DateTimeFormat.defaultStyle:
        return defaultStyle;
      case DateTimeFormat.defaultChineseStyle:
        return defaultChineseStyle;
      case DateTimeFormat.defaultDateStyle:
        return defaultDateStyle;
      case DateTimeFormat.defaultChineseDateStyle:
        return defaultChineseDateStyle;
      case DateTimeFormat.defaultTimeStyle:
        return defaultTimeStyle;
      case DateTimeFormat.defaultHMTimeStyle:
        return defaultHMTimeStyle;
      case DateTimeFormat.defaultChineseTimeStyle:
        return defaultChineseTimeStyle;
      case DateTimeFormat.defaultMMStyle:
        return defaultMMStyle;
      case DateTimeFormat.defaultDateTimeStyle:
        return defaultDateTimeStyle;
      case DateTimeFormat.defaultDateMStyle:
        return defaultDateMStyle;
      case DateTimeFormat.defaultMTimeStyle:
        return defaultMTimeStyle;
    }
  }
}

extension DateTimeExtension on DateTime {
  //本月第一天
  String get startDayDate => startDayDateTime.defaultDate;

  //本月最后一天
  String get endDayDate => endDayDateTime.defaultDate;

  //本月第一天
  DateTime get startDayDateTime => DateTime(year, month, 1);

  //本月最后一天
  DateTime get endDayDateTime =>
      DateTime(year, month, DateTimeUtil.currentDateCount(this));

  //获取时间戳
  int get timestamp => millisecondsSinceEpoch;

  //获取秒数
  int get seconds => (millisecondsSinceEpoch / 1000).round();

  //获取年龄
  int get age => DateTimeUtil.getAge(year, month, day);

  //获取日期
  String get defaultDate => DateTimeUtil.format(this,
      dataTimePattern: DateTimeFormat.defaultDateStyle);

  //获取yyyyMMddHHmmss日期时间当天0点的值
  String get testDateTime => DateTimeUtil.format(DateTime(year, month, day),
      dataTimePattern: DateTimeFormat.defaultDateTimeStyle);

  //获取日期
  String get defaultChineseDateStyle => DateTimeUtil.format(this,
      dataTimePattern: DateTimeFormat.defaultChineseDateStyle);

  String get formatMMddHHmm =>
      DateTimeUtil.format(this, dataTimePattern: DateTimeFormat.defaultMMStyle);

  String get defaultStyle =>
      DateTimeUtil.format(this, dataTimePattern: DateTimeFormat.defaultStyle);

  //时间前
  String get byTheTimeCircle {
    // 当前时间
    final now = DateTime.now();
    // 对比
    int distance = now.seconds - seconds;
    if (distance <= 60) {
      return '刚刚';
    } else if (distance <= 3600) {
      return '${(distance / 60).floor()}分钟前';
    } else if (distance <= 43200) {
      return '${(distance / 60 / 60).floor()}小时前';
    } else if (year == now.year && month == now.month) {
      return '${now.day - day}天前';
    } else if (year == now.year) {
      return '${now.month - month}月前';
    } else {
      return byTheTime;
    }
  }

  //时间前
  String get byTheTime {
    // 当前时间
    int time = DateTime.now().seconds;
    // 对比
    int distance = time - seconds;
    if (distance <= 60) {
      return '刚刚';
    } else if (distance <= 3600) {
      return '${(distance / 60).floor()}分钟前';
    } else if (distance <= 43200) {
      return '${(distance / 60 / 60).floor()}小时前';
    } else if (DateTime.fromMillisecondsSinceEpoch(time * 1000).year ==
        DateTime.fromMillisecondsSinceEpoch(seconds * 1000).year) {
      return formatMMddHHmm;
    } else {
      return defaultDate;
    }
  }

  //时间前
  String get byTheTimeIm {
    // 当前时间
    final now = DateTime.now();
    // 对比
    if (year == now.year && month == now.month && day == now.day) {
      return DateTimeUtil.dateTimeFormat(this, dataTimePattern: 'HH:mm:ss');
    } else if (year == now.year &&
        month == now.month &&
        day == now.subtract(const Duration(days: 1)).day) {
      return '昨天 ${DateTimeUtil.dateTimeFormat(this, dataTimePattern: 'HH:mm:ss')}';
    } else if (year == now.year) {
      return DateTimeUtil.dateTimeFormat(this,
          dataTimePattern: 'MM月dd日 HH:mm:ss');
    } else {
      return DateTimeUtil.dateTimeFormat(this,
          dataTimePattern: 'yyyy年MM月dd日 HH:mm:ss');
    }
  }
}

extension DurationExtension on Duration {
  //获取时间戳
  String get duration {
    var microseconds = inMicroseconds;
    final hours = microseconds ~/ Duration.microsecondsPerHour;
    microseconds = microseconds.remainder(Duration.microsecondsPerHour);

    if (microseconds < 0) microseconds = -microseconds;
    final hoursPadding = hours < 10 ? "0" : "";
    final minutes = microseconds ~/ Duration.microsecondsPerMinute;
    microseconds = microseconds.remainder(Duration.microsecondsPerMinute);

    final minutesPadding = minutes < 10 ? "0" : "";

    final seconds = microseconds ~/ Duration.microsecondsPerSecond;
    microseconds = microseconds.remainder(Duration.microsecondsPerSecond);

    final secondsPadding = seconds < 10 ? "0" : "";

    return "$hoursPadding$hours:$minutesPadding$minutes:$secondsPadding$seconds";
  }
}

extension DateTimeStringExtension on String {
  //获取时间戳
  int get timestamp => DateTime.parse(this).timestamp;

  //获取年龄
  int get age {
    final dateTime = DateTime.parse(this);
    return DateTimeUtil.getAge(dateTime.year, dateTime.month, dateTime.day);
  }

  //获取日期
  String get defaultDate => DateTime.parse(this).defaultDate;

  //获取时间状态
  String get byTheTime {
    final dateTime = DateTime.parse(this);
    return dateTime.byTheTime;
  }

//获取时间状态
  String get byTheTimeCircle {
    final dateTime = DateTime.parse(this);
    return dateTime.byTheTimeCircle;
  }

  //获取im时间状态
  String get byTheTimeIm {
    final dateTime = DateTime.parse(this);
    return dateTime.byTheTimeIm;
  }
}
