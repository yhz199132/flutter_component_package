/// 作者：袁汉章 on 2023年11月01日 16:03
/// 邮箱：yhz199132@163.com
/// 规则工具
class RegularUtils {
  //判断手机号
  static bool phoneNumberHasMatch(String? text) {
    return RegExp(
            r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$')
        .hasMatch(text ?? '');
  }

  //判断身份证号
  static bool idCardHasMatch(String? text) {
    return RegExp(r'(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)')
        .hasMatch(text ?? '');
  }

  //判断PIN码（六位纯数字）
  static bool pinHasMatch(String? text) {
    return RegExp(r'^\d{6}$').hasMatch(text ?? '');
  }

  //判断是否汉字
  static bool chineseCharactersHasMatch(String? text) {
    return RegExp(r'[\u4e00-\u9fa5]').hasMatch(text ?? '');
  }

  //判断是否链接
  static bool linkHasMatch(String? text) {
    return RegExp(r'[a-zA-z]+://\S*').hasMatch(text ?? '');
  }

  ///中文文本添加占位符  标准字数默认4个字符  默认右对齐
  ///超长标题处理三种处理方式， 英文和数字只能大概对齐
  static String textAddPlaceholder(String text,
      {int criterionLength = 4,
      bool isAlignRight = true,
      TextAlignMode textAlignMode = TextAlignMode.none}) {
    //计算非汉字数量
    var noChineseCount =
        text.split('').where((e) => !e.chineseCharactersMatch).toList().length;
    final stringBuffer = StringBuffer();
    if (text.length > criterionLength) {
      switch (textAlignMode) {
        case TextAlignMode.none:
          return text;
        case TextAlignMode.cut:
          final cutText = text.substring(0, criterionLength);
          //计算非汉字数量
          noChineseCount = cutText
              .split('')
              .where((e) => !e.chineseCharactersMatch)
              .toList()
              .length;
          for (int i = 0; i < noChineseCount; i++) {
            stringBuffer.write('\u0020\u0020');
          }
          return isAlignRight
              ? '${stringBuffer.toString()}$cutText'
              : '$cutText${stringBuffer.toString()}';
        case TextAlignMode.lineFeed:
          //行数
          final lineNumber = (text.length / criterionLength).ceil();
          //最后一行字数
          final number = text.length % criterionLength;
          //不满一行的字数
          for (int i = 0; i < lineNumber; i++) {
            final lineText = (i == (lineNumber - 1))
                ? text.substring(i * criterionLength)
                : text.substring(
                    i * criterionLength, (i + 1) * criterionLength);
            final stringBufferChild = StringBuffer();
            //字数差值
            final difference = criterionLength - lineText.length;
            //计算非汉字数量
            noChineseCount = lineText
                .split('')
                .where((e) => !e.chineseCharactersMatch)
                .toList()
                .length;
            if (noChineseCount > 0) {
              for (int i = 0; i < noChineseCount; i++) {
                stringBufferChild.write('\u0020');
              }
            }
            if (difference > 0) {
              for (int i = 0; i < difference; i++) {
                stringBufferChild.write('\u3000');
              }
            }
            stringBuffer.write(isAlignRight
                ? '${stringBufferChild.toString()}$lineText'
                : '$lineText${stringBufferChild.toString()}');
            if (i < (lineNumber - 1)) {
              stringBuffer.write('\n');
            }
          }
          return stringBuffer.toString();
      }
    } else if (text.length < criterionLength) {
      //字数差值
      final difference = criterionLength - text.length;
      for (int i = 0; i < difference; i++) {
        stringBuffer.write('\u3000');
      }
      for (int i = 0; i < noChineseCount; i++) {
        stringBuffer.write('\u0020');
      }
      return isAlignRight
          ? '${stringBuffer.toString()}$text'
          : '$text${stringBuffer.toString()}';
    } else {
      for (int i = 0; i < noChineseCount; i++) {
        stringBuffer.write('\u0020\u0020');
      }
      return isAlignRight
          ? '${stringBuffer.toString()}$text'
          : '$text${stringBuffer.toString()}';
    }
  }

  //姓名脱敏
  static String nameHidden(String name) {
    if (name.isNotEmpty) {
      if (name.length == 2) {
        name = name.replaceAllMapped(RegExp(r"(.).+"), (Match m) => "${m[1]}*");
      }
      //姓名长度大于2，隐藏中间字符
      if (name.length > 2) {
        name = name.replaceAllMapped(
            RegExp(r"(.).+(.)"), (Match m) => "${m[1]}*${m[2]}");
      }
    }
    return name;
  }

  //获取文件类型
  static String? hasFileName(String? path) {
    return path?.substring(path.lastIndexOf("."), path.length);
  }
}

enum TextAlignMode { none, cut, lineFeed }

//规则扩展
extension RegularExtension on String? {
  //判断手机号
  bool get phoneNumberMatch => RegularUtils.phoneNumberHasMatch(this);

  //判断身份证号
  bool get idCardMatch => RegularUtils.idCardHasMatch(this);

  //判断PIN码（六位纯数字）
  bool get pinMatch => RegularUtils.pinHasMatch(this);

  //判断是否汉字
  bool get chineseCharactersMatch =>
      RegularUtils.chineseCharactersHasMatch(this);

  //判断是否链接
  bool get linkMatch => RegularUtils.linkHasMatch(this);

  //手机号脱敏
  String get phoneHidden =>
      this?.replaceAllMapped(
          RegExp(r"(\w{3})\w*(\w{4})"), (Match m) => "${m[1]}****${m[2]}") ??
      '';

  //姓名脱敏
  String get nameHidden => RegularUtils.nameHidden(this ?? '');

  //身份证脱敏
  String get idCardHidden =>
      this?.replaceAllMapped(RegExp(r"(\w{4})\w*(\w{4})"),
          (Match m) => "${m[1]}**********${m[2]}") ??
      '';
}
