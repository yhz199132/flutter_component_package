import 'package:common_tools/sp/sp_util.dart';
import 'package:flutter/material.dart';

/// 作者：袁汉章 on 2023年10月23日 15:52
/// 邮箱：yhz199132@163.com
class SpPage extends StatefulWidget {
  const SpPage({super.key});

  @override
  State<SpPage> createState() => _SpPageState();
}

class _SpPageState extends State<SpPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () async {
            SpUtil().setValue("st", "你好");
          },
          child: const Text('保存字符串'),
        ),
        TextButton(
          onPressed: () async {
            print(SpUtil().getValue("st", defaultValue: "123"));
          },
          child: const Text('获取字符串'),
        ),
        TextButton(
          onPressed: () async {
            SpUtil().setValue("number", 1234);
          },
          child: const Text('保存整数'),
        ),
        TextButton(
          onPressed: () async {
            print(SpUtil().getValue("number", defaultValue: 123));
          },
          child: const Text('获取整数'),
        ),
        TextButton(
          onPressed: () async {
            SpUtil().setValue("br", true);
          },
          child: const Text('保存布尔'),
        ),
        TextButton(
          onPressed: () async {
            print(SpUtil().getValue("br", defaultValue: false));
          },
          child: const Text('获取布尔'),
        )
      ],
    );
  }
}
