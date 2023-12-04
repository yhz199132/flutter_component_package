import 'package:flutter/material.dart';

/// 作者：袁汉章 on 2023年11月01日 14:41
/// 邮箱：yhz199132@163.com
/// 可空文本组件
class NullableText extends Text {
  final String? text; //文本内容
  final String? defaultText; //默认文本，当文本内容为空时显示默认文本

  const NullableText(
    this.text, {
    this.defaultText = '',
    super.key,
    super.style,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
    super.selectionColor,
  }) : super((text ?? defaultText) ?? '');
}
