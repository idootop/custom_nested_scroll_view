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
      ref: flutter_3.0 # flutter_2.x flutter_3.0 flutter_3.4
```

|    Git branch   | Supported flutter versions |
|---------------|--------------------------|
| main            | >= 3.4.0-27.0.pre          |
| flutter-3.4-pre | >= 3.4.0-17.0.pre < 3.4.0-27.0.pre |
| flutter-3.0     | >= 2.12.0-4.0.pre < 3.4.0-17.0.pre |
| flutter-2.x     | < 2.12.0-4.0.pre           |

```dart
import 'package:flutter/material.dart';
import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: CustomNestedScrollView(
          overscrollType: CustomOverscroll.outer,
          // !important
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          headerSliverBuilder: (context, innerScrolled) => <Widget>[
            MySliverAppBar(),
          ],
          body: TabBarView(
            children: [
              CustomScrollView(
                // !important
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: <Widget>[
                  TopOverlapInjector(),
                  // scroll view
                  SliverFixedExtentList(
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
                  ),
                ],
              ),
              CustomScrollView(
                physics: NeverScrollableScrollPhysics(),
                slivers: <Widget>[
                  TopOverlapInjector(),
                  // some widget
                  SliverFillRemaining(
                    child: Center(
                      child: Text('Test'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopOverlapInjector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomSliverOverlapInjector(
        overscrollType: CustomOverscroll.outer,
        handle: CustomNestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
    );
  }
}

class MySliverAppBar extends StatelessWidget {
  ///Header collapsed height
  final minHeight = 120.0;

  ///Header expanded height
  final maxHeight = 400.0;

  final tabBar = TabBar(
    tabs: <Widget>[Text('Tab1'), Text('Tab2')],
  );

  @override
  Widget build(BuildContext context) {
    final topHeight = MediaQuery.of(context).padding.top;
    return CustomSliverOverlapAbsorber(
      overscrollType: CustomOverscroll.outer,
      handle: CustomNestedScrollView.sliverOverlapAbsorberHandleFor(
        context,
      ),
      sliver: SliverAppBar(
        pinned: true,
        stretch: true,
        toolbarHeight: minHeight - tabBar.preferredSize.height - topHeight,
        collapsedHeight: minHeight - tabBar.preferredSize.height - topHeight,
        expandedHeight: maxHeight - topHeight,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Center(child: Text('Example')),
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
      ),
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
