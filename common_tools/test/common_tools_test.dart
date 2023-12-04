import 'package:common_tools/utils/regular_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('adds one to input values', () {
    print(RegularUtils.textAddPlaceholder('性别sex拉科技阿是阿里打卡塞德里克公司领导科技',
        criterionLength: 6,
        isAlignRight: true,
        textAlignMode: TextAlignMode.lineFeed));
    // for (var e in strs) {
    //   print(RegularUtils.textAddPlaceholder(e,
    //       criterionLength: 4, isAlignRight: false));
    // }
    // final lineNumber = (14 / 4).ceil();
    // print(lineNumber);
  });
}
