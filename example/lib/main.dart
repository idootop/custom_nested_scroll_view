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
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
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
