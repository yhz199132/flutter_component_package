import 'package:flutter/material.dart';

import 'catalogue_page.dart';

/// 作者：袁汉章 on 2023年11月01日 18:06
/// 邮箱：yhz199132@163.com
class ToolsTestPage extends StatefulWidget {
  const ToolsTestPage({super.key});

  @override
  State<ToolsTestPage> createState() => _ToolsTestPageState();
}

class _ToolsTestPageState extends State<ToolsTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CataloguePage()));
            },
            child: const Text('条目对齐方式'),
          ),
        ],
      ),
    );
  }
}
