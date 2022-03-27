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
  ///Header collapsed height
  final minHeight = 120.0;

  ///Header expanded height
  final maxHeight = 400.0;

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      tabs: <Widget>[Text('Tab1'), Text('Tab2')],
    );
    final topHeight = MediaQuery.of(context).padding.top;
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: CustomNestedScrollView(
              overscrollType: CustomOverscroll.outer,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              headerSliverBuilder: (context, innerScrolled) => <Widget>[
                    CustomSliverOverlapAbsorber(
                      overscrollType: CustomOverscroll.outer,
                      handle:
                          CustomNestedScrollView.sliverOverlapAbsorberHandleFor(
                        context,
                      ),
                      sliver: SliverAppBar(
                        pinned: true,
                        stretch: true,
                        toolbarHeight:
                            minHeight - tabBar.preferredSize.height - topHeight,
                        collapsedHeight:
                            minHeight - tabBar.preferredSize.height - topHeight,
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
                    ),
                  ],
              body: TabBarView(children: [
                Center(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    slivers: <Widget>[
                      Builder(
                        builder: (context) => CustomSliverOverlapInjector(
                          overscrollType: CustomOverscroll.outer,
                          handle: CustomNestedScrollView
                              .sliverOverlapAbsorberHandleFor(context),
                        ),
                      ),
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
                ),
                CustomScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  slivers: <Widget>[
                    Builder(
                      builder: (context) => CustomSliverOverlapInjector(
                        overscrollType: CustomOverscroll.outer,
                        handle:
                            NestedScrollViewY.sliverOverlapAbsorberHandleFor(
                                context),
                      ),
                    ),
                    SliverFillRemaining(
                      child: Center(
                        child: Text('Test'),
                      ),
                    ),
                  ],
                ),
              ])),
        ));
  }
}
