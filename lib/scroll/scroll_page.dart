import 'package:common_tools/utils/regular_utils.dart';
import 'package:flutter/material.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

/// 作者：袁汉章 on 2023年10月25日 11:47
/// 邮箱：yhz199132@163.com
class ScrollPage extends StatefulWidget {
  const ScrollPage({super.key});

  @override
  State<ScrollPage> createState() => _ScrollPageState();
}

ScrollController scrollController = ScrollController();

class _ScrollPageState extends State<ScrollPage> {
  final list1 = ["热菜", "凉菜", "其他"];
  final list2 = [
    Cai("热菜", "烧肉"),
    Cai("热菜", "宫保"),
    Cai("热菜", "酸菜"),
    Cai("热菜", "酸菜鱼"),
    Cai("热菜", "酸菜鱼"),
    Cai("热菜", "酸菜鱼"),
    Cai("热菜", "酸菜鱼"),
    Cai("热菜", "菜鱼"),
    Cai("凉菜", "凉拌黄瓜"),
    Cai("凉菜", "口水鸡"),
    Cai("凉菜", "口水鸡"),
    Cai("凉菜", "口水鸡"),
    Cai("凉菜", "口水鸡"),
    Cai("凉菜", "口水鸡"),
    Cai("凉菜", "鸡"),
    Cai("凉菜", "蒜蓉西蓝花"),
    Cai("其他", "酸梅汤"),
    Cai("其他", "红薯"),
    Cai("其他", "薯"),
    Cai("其他", "红薯"),
    Cai("其他", "红薯"),
    Cai("其他", "红薯"),
    Cai("其他", "红薯"),
    Cai("其他", "玉米")
  ];
  ListObserverController observerController =
      ListObserverController(controller: scrollController);
  BuildContext? _sliverListViewContext;
  String caixi = "热菜";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                final text = list1[index];
                return TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (!states.contains(MaterialState.pressed)) {
                        return text == caixi ? Colors.amber : Colors.blueGrey;
                      }
                    }),
                  ),
                  onPressed: () {
                    setState(() {
                      caixi = text;
                    });
                    observerController.animateTo(
                      index: index + index * 7,
                      duration: const Duration(seconds: 1),
                      curve: Curves.ease,
                    );
                  },
                  child: Text(text),
                );
              },
              itemCount: list1.length,
              shrinkWrap: true,
            ),
          ),
          Expanded(
            flex: 5,
            child: ListViewObserver(
              controller: observerController,
              sliverListContexts: () {
                return [
                  if (_sliverListViewContext != null) _sliverListViewContext!
                ];
              },
              onObserve: (resultMap) {
                if (_sliverListViewContext != null) {
                  // 打印当前正在显示的第一个子部件
                  print('firstChild.index -- ${resultMap.firstChild?.index}');
                  final index = resultMap.firstChild?.index;
                  if (index != null) {
                    final cai = list2[index];
                    if (caixi != cai.caixi) {
                      setState(() {
                        caixi = cai.caixi;
                      });
                    }
                  }
                }
              },
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (_sliverListViewContext != context) {
                    _sliverListViewContext = context;
                  }
                  final cai = list2[index];
                  final cai2 = index > 0 ? list2[index - 1] : null;
                  final visible = cai2 == null || cai2.caixi != cai.caixi;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: visible,
                        child: Text(cai.caixi,
                            style: const TextStyle(
                                fontSize: 40, color: Colors.amber)),
                      ),
                      Row(
                        children: [
                          Text(
                            RegularUtils.textAddPlaceholder(cai.caipin,
                                criterionLength: 5, isAlignRight: true),
                            style: const TextStyle(fontSize: 60),
                          ),
                          Text(
                            cai.caixi,
                            style: const TextStyle(
                                fontSize: 60, color: Colors.blue),
                          )
                        ],
                      )
                    ],
                  );
                },
                itemCount: list2.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Cai {
  final String caixi;
  final String caipin;

  Cai(this.caixi, this.caipin);
}
