# custom_nested_scroll_view

A NestedScrollView that supports outer scroller to top overscroll.

## 🌍 Preview

Web demo 👉 [Click Here](https://killer-1255480117.cos.ap-chongqing.myqcloud.com/web/scrollMaster/index.html)

## 🐛 Problem

### NestedScrollView with pinned and stretch SliverAppBar

**Problem: NestedScrollView does not support outer scroller to top overscroll, so its SliverAppBar cannot be stretched.**

_Related issue: [https://github.com/flutter/flutter/issues/54059](https://github.com/flutter/flutter/issues/54059)_

![](screenshots/case1.gif)

## ⚡️ Solution

Fixed by:

1. Override the applyUserOffset method of \_NestedScrollCoordinator to allow over-scroll the top of \_outerPosition.

2. Override the unnestOffset, nestOffset, \_getMetrics methods of \_NestedScrollCoordinator to fix the mapping between \_innerPosition and \_outerPosition to \_NestedScrollPosition (Coordinator).

_For more information, see:_

- `example/lib/main.dart`
- `lib/src/custom_nested_scroll_view.dart`

## 💡 Usage

```shell
dependencies:
  ...
  custom_nested_scroll_view:
    git:
      url: https://github.com/idootop/custom_nested_scroll_view.git
      # Which branch to use is based on your local flutter version
      ref: flutter-3.0 # main flutter-2.x flutter-3.0 flutter-3.4 flutter-3.7
```

| Git branch      | Supported flutter versions       |
| --------------- | -------------------------------- |
| flutter-3.7     | >=3.7.0-13.0.pre                 |
| flutter-3.4     | >=3.4.0-27.0.pre <3.7.0-13.0.pre |
| flutter-3.4-pre | >=3.4.0-17.0.pre <3.4.0-27.0.pre |
| flutter-3.0     | >=2.12.0-4.0.pre <3.4.0-17.0.pre |
| flutter-2.x     | <2.12.0-4.0.pre                  |
| main            | >=3.7.0-13.0.pre                 |

```dart
import 'package:flutter/material.dart';
import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';

void main() => runApp(
      MaterialApp(
        title: 'Example',
        home: Example(),
      ),
    );

class Example extends StatefulWidget {
  const Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomNestedScrollView(
          // use key to access CustomNestedScrollViewState
          key: myKey,
          headerSliverBuilder: (context, innerScrolled) => <Widget>[
            // use CustomOverlapAbsorber to wrap your SliverAppBar
            CustomOverlapAbsorber(
              sliver: MySliverAppBar(),
            ),
          ],
          body: TabBarView(
            children: [
              CustomScrollView(
                slivers: <Widget>[
                  // use CustomOverlapInjector on top of your inner CustomScrollView
                  CustomOverlapInjector(),
                  _tabBody1,
                ],
              ),
              CustomScrollView(
                slivers: <Widget>[
                  // use CustomOverlapInjector on top of your inner CustomScrollView
                  CustomOverlapInjector(),
                  _tabBody2,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<CustomNestedScrollViewState> myKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // use GlobalKey<CustomNestedScrollViewState> to access inner or outer scroll controller
      myKey.currentState?.innerController.addListener(() {
        final innerController = myKey.currentState!.innerController;
        print('>>> Scrolling inner nested scrollview: ${innerController.positions}');
      });
      myKey.currentState?.outerController.addListener(() {
        final outerController = myKey.currentState!.outerController;
        print('>>> Scrolling outer nested scrollview: ${outerController.positions}');
      });
    });
  }

  final _tabBody1 = SliverFixedExtentList(
    delegate: SliverChildBuilderDelegate(
      (_, index) => ListTile(
        key: Key('$index'),
        title: Center(
          child: Text('ListTile ${index + 1}'),
        ),
      ),
      childCount: 30,
    ),
    itemExtent: 50,
  );

  final _tabBody2 = const SliverFillRemaining(
    child: Center(
      child: Text('Test'),
    ),
  );
}

class MySliverAppBar extends StatelessWidget {
  ///Header collapsed height
  final minHeight = 120.0;

  ///Header expanded height
  final maxHeight = 400.0;

  final tabBar = const TabBar(
    tabs: <Widget>[Text('Tab1'), Text('Tab2')],
  );

  @override
  Widget build(BuildContext context) {
    final topHeight = MediaQuery.of(context).padding.top;
    return SliverAppBar(
      pinned: true,
      stretch: true,
      toolbarHeight: minHeight - tabBar.preferredSize.height - topHeight,
      collapsedHeight: minHeight - tabBar.preferredSize.height - topHeight,
      expandedHeight: maxHeight - topHeight,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Center(child: Text('Example')),
        stretchModes: <StretchMode>[
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: Image.network(
          'https://pic1.zhimg.com/80/v2-fc35089cfe6c50f97324c98f963930c9_720w.jpg',
          fit: BoxFit.cover,
        ),
      ),
      bottom: tabBar,
    );
  }
}
```

For more examples, see [https://github.com/idootop/scroll_master](https://github.com/idootop/scroll_master)（**Highly recommended**）

## ❤️ Acknowledgements

Thanks to [fluttercandies](https://github.com/fluttercandies)'s [extended_nested_scroll_view](https://github.com/fluttercandies/extended_nested_scroll_view).

## 📖 References

- [大道至简：Flutter 嵌套滑动冲突解决之路](http://vimerzhao.top/posts/flutter-nested-scroll-conflict/)
- [深入进阶-如何解决 Flutter 上的滑动冲突？ ](https://juejin.cn/post/6900751363173515278)
- [用 Flutter 实现 58App 的首页](https://blog.csdn.net/weixin_39891694/article/details/111217123)
- [不一样角度带你了解 Flutter 中的滑动列表实现](https://blog.csdn.net/ZuoYueLiang/article/details/116245138)
- [Flutter 滑动体系 ](https://juejin.cn/post/6983338779415150628)
