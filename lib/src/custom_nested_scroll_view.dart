part of 'nested_scroll_view.dart';

enum CustomOverscroll {
  ///allow inner scroller to overscroll
  inner,

  ///allow outer scroller to overscroll
  outer,
}

class CustomNestedScrollView extends StatelessWidget {
  ///A NestedScrollView that supports outer scroller to top overscroll.
  ///
  /// **Does not support floatHeaderSlivers**
  ///
  /// If you want to access the inner or outer scroll controller of a [CustomNestedScrollView],
  /// you can get its state by using a `GlobalKey<CustomNestedScrollViewState>`.
  ///
  ///```dart
  /// import 'package:flutter/material.dart';
  /// import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';
  ///
  /// void main() => runApp(
  ///       MaterialApp(
  ///         title: 'Example',
  ///         home: Example(),
  ///       ),
  ///     );
  ///
  /// class Example extends StatefulWidget {
  ///   const Example({Key? key}) : super(key: key);
  ///
  ///   @override
  ///   State<Example> createState() => _ExampleState();
  /// }
  ///
  /// class _ExampleState extends State<Example> {
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return Scaffold(
  ///       body: DefaultTabController(
  ///         length: 2,
  ///         child: CustomNestedScrollView(
  ///           // use key to access CustomNestedScrollViewState
  ///           key: myKey,
  ///           headerSliverBuilder: (context, innerScrolled) => <Widget>[
  ///             // use CustomOverlapAbsorber to wrap your SliverAppBar
  ///             CustomOverlapAbsorber(
  ///               sliver: MySliverAppBar(),
  ///             ),
  ///           ],
  ///           body: TabBarView(
  ///             children: [
  ///               CustomScrollView(
  ///                 slivers: <Widget>[
  ///                   // use CustomOverlapInjector on top of your inner CustomScrollView
  ///                   CustomOverlapInjector(),
  ///                   _tabBody1,
  ///                 ],
  ///               ),
  ///               CustomScrollView(
  ///                 slivers: <Widget>[
  ///                   // use CustomOverlapInjector on top of your inner CustomScrollView
  ///                   CustomOverlapInjector(),
  ///                   _tabBody2,
  ///                 ],
  ///               ),
  ///             ],
  ///           ),
  ///         ),
  ///       ),
  ///     );
  ///   }
  ///
  ///   final GlobalKey<CustomNestedScrollViewState> myKey = GlobalKey();
  ///
  ///   @override
  ///   void initState() {
  ///     super.initState();
  ///     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
  ///       // use GlobalKey<CustomNestedScrollViewState> to access inner or outer scroll controller
  ///       myKey.currentState?.innerController.addListener(() {
  ///         final innerController = myKey.currentState!.innerController;
  ///         print('>>> Scrolling inner nested scrollview: ${innerController.positions}');
  ///       });
  ///       myKey.currentState?.outerController.addListener(() {
  ///         final outerController = myKey.currentState!.outerController;
  ///         print('>>> Scrolling outer nested scrollview: ${outerController.positions}');
  ///       });
  ///     });
  ///   }
  ///
  ///   final _tabBody1 = SliverFixedExtentList(
  ///     delegate: SliverChildBuilderDelegate(
  ///       (_, index) => ListTile(
  ///         key: Key('$index'),
  ///         title: Center(
  ///           child: Text('ListTile ${index + 1}'),
  ///         ),
  ///       ),
  ///       childCount: 30,
  ///     ),
  ///     itemExtent: 50,
  ///   );
  ///
  ///   final _tabBody2 = const SliverFillRemaining(
  ///     child: Center(
  ///       child: Text('Test'),
  ///     ),
  ///   );
  /// }
  ///
  /// class MySliverAppBar extends StatelessWidget {
  ///   ///Header collapsed height
  ///   final minHeight = 120.0;
  ///
  ///   ///Header expanded height
  ///   final maxHeight = 400.0;
  ///
  ///   final tabBar = const TabBar(
  ///     tabs: <Widget>[Text('Tab1'), Text('Tab2')],
  ///   );
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     final topHeight = MediaQuery.of(context).padding.top;
  ///     return SliverAppBar(
  ///       pinned: true,
  ///       stretch: true,
  ///       toolbarHeight: minHeight - tabBar.preferredSize.height - topHeight,
  ///       collapsedHeight: minHeight - tabBar.preferredSize.height - topHeight,
  ///       expandedHeight: maxHeight - topHeight,
  ///       flexibleSpace: FlexibleSpaceBar(
  ///         centerTitle: true,
  ///         title: const Center(child: Text('Example')),
  ///         stretchModes: <StretchMode>[
  ///           StretchMode.zoomBackground,
  ///           StretchMode.blurBackground,
  ///         ],
  ///         background: Image.network(
  ///           'https://pic1.zhimg.com/80/v2-fc35089cfe6c50f97324c98f963930c9_720w.jpg',
  ///           fit: BoxFit.cover,
  ///         ),
  ///       ),
  ///       bottom: tabBar,
  ///     );
  ///   }
  /// }
  ///```
  const CustomNestedScrollView({
    Key? key,
    this.controller,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.physics = const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    ),
    required this.headerSliverBuilder,
    required this.body,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.scrollBehavior,
    this.overscrollType = CustomOverscroll.outer,
  })  : _key = key,
        super();

  final Key? _key;
  final ScrollController? controller;
  final Axis scrollDirection;
  final bool reverse;
  final ScrollPhysics? physics;
  final _NestedScrollViewHeaderSliversBuilder headerSliverBuilder;
  final Widget body;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollBehavior? scrollBehavior;

  ///allow which scroller to overscroll
  final CustomOverscroll overscrollType;

  @override
  Widget build(BuildContext context) {
    return overscrollType == CustomOverscroll.outer
        ? NestedScrollViewX(
            key: _key,
            controller: controller,
            scrollDirection: scrollDirection,
            reverse: reverse,
            physics: physics,
            headerSliverBuilder: headerSliverBuilder,
            body: body,
            dragStartBehavior: dragStartBehavior,
            floatHeaderSlivers: false, //does not support floatHeaderSlivers
            clipBehavior: clipBehavior,
            restorationId: restorationId,
            scrollBehavior: scrollBehavior,
          )
        : NestedScrollViewY(
            key: _key,
            controller: controller,
            scrollDirection: scrollDirection,
            reverse: reverse,
            physics: physics,
            headerSliverBuilder: headerSliverBuilder,
            body: body,
            dragStartBehavior: dragStartBehavior,
            floatHeaderSlivers: false, //does not support floatHeaderSlivers
            clipBehavior: clipBehavior,
            restorationId: restorationId,
            scrollBehavior: scrollBehavior,
          );
  }

  static _SliverOverlapAbsorberHandle sliverOverlapAbsorberHandleFor(
      BuildContext context) {
    final target = context
        .dependOnInheritedWidgetOfExactType<_InheritedNestedScrollView>();
    assert(
      target != null,
      '_NestedScrollView.sliverOverlapAbsorberHandleFor must be called with a context that contains a _NestedScrollView.',
    );
    return target!.state._absorberHandle;
  }
}

class CustomSliverOverlapAbsorber extends _SliverOverlapAbsorber {
  CustomSliverOverlapAbsorber({
    Key? key,
    required _SliverOverlapAbsorberHandle handle,
    Widget? sliver,
    CustomOverscroll overscrollType = CustomOverscroll.outer,
  })  : _overscrollType = overscrollType,
        super(key: key, handle: handle, sliver: sliver);

  ///allow which scroller to overscroll
  final CustomOverscroll _overscrollType;

  @override
  _RenderSliverOverlapAbsorber createRenderObject(BuildContext context) {
    return _overscrollType == CustomOverscroll.outer
        ? _RenderSliverOverlapAbsorberX(handle: handle)
        : _RenderSliverOverlapAbsorberY(handle: handle);
  }
}

class CustomSliverOverlapInjector extends _SliverOverlapInjector {
  CustomSliverOverlapInjector({
    Key? key,
    required _SliverOverlapAbsorberHandle handle,
    Widget? sliver,
    CustomOverscroll overscrollType = CustomOverscroll.outer,
  })  : _overscrollType = overscrollType,
        super(key: key, handle: handle, sliver: sliver);

  ///allow which scroller to overscroll
  final CustomOverscroll _overscrollType;

  @override
  _RenderSliverOverlapInjector createRenderObject(BuildContext context) {
    return _overscrollType == CustomOverscroll.outer
        ? _RenderSliverOverlapInjectorX(handle: handle)
        : _RenderSliverOverlapInjectorY(handle: handle);
  }
}

class CustomOverlapInjector extends StatelessWidget {
  CustomOverlapInjector({
    this.overscrollType = CustomOverscroll.outer,
  });

  final CustomOverscroll overscrollType;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => CustomSliverOverlapInjector(
        overscrollType: overscrollType,
        handle: CustomNestedScrollView.sliverOverlapAbsorberHandleFor(context),
      ),
    );
  }
}

class CustomOverlapAbsorber extends StatelessWidget {
  CustomOverlapAbsorber({
    this.sliver,
    this.overscrollType = CustomOverscroll.outer,
  });

  final Widget? sliver;
  final CustomOverscroll overscrollType;

  @override
  Widget build(BuildContext context) {
    return CustomSliverOverlapAbsorber(
      overscrollType: overscrollType,
      handle: CustomNestedScrollView.sliverOverlapAbsorberHandleFor(
        context,
      ),
      sliver: sliver,
    );
  }
}
