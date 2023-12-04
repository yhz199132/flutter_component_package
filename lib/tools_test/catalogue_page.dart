import 'package:common_tools/utils/regular_utils.dart';
import 'package:flutter/material.dart';

/// 作者：袁汉章 on 2023年11月01日 18:09
/// 邮箱：yhz199132@163.com
class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  bool groupValue = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '右对齐',
                    style: TextStyle(fontSize: 21),
                  ),
                  Radio(
                    value: true,
                    groupValue: groupValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          groupValue = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  const Text(
                    '左对齐',
                    style: TextStyle(fontSize: 21),
                  ),
                  Radio(
                    value: false,
                    groupValue: groupValue,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          groupValue = value;
                        });
                      }
                    },
                  )
                ],
              ),
              rows('姓名', '张三'),
              rows('age', '18'),
              rows('身份证号码', '610324191992399992'),
              rows('phone', '13013239876'),
              rows('性别sex', '男性'),
              rows('身份认证', '通过'),
              rows('用户名', '测试'),
              rows('s', '测试'),
              rows('卡', '测试'),
            ],
          ),
        ),
      ),
    );
  }

  Widget rows(String title, String content) {
    return Row(
      children: [
        Text(
          RegularUtils.textAddPlaceholder(title,
              criterionLength: 4,
              isAlignRight: groupValue,
              textAlignMode: TextAlignMode.lineFeed),
          style: const TextStyle(fontSize: 36),
        ),
        const Text(
          ' ',
          style: TextStyle(fontSize: 36),
        ),
        Text(
          content,
          style: const TextStyle(fontSize: 36, color: Colors.blue),
        )
      ],
    );
  }
}
