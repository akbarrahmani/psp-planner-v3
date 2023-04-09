// ignore_for_file: unnecessary_const, library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';
import 'components/one_ui_scroll_physics.dart';

const Divider _kBottomDivider = const Divider(
  height: 0,
  color: Colors.white54,
);

const double _kExpendedAppBarHeightRatio = 3 / 8;

class OneUiScrollView extends StatefulWidget {
  const OneUiScrollView({
    Key? key,
    @required this.expandedTitle,
    @required this.collapsedTitle,
    this.actions,
    this.children = const [],
    this.childrenPadding = EdgeInsets.zero,
    this.bottomDivider = _kBottomDivider,
    this.expandedHeight,
    this.toolbarHeight = kToolbarHeight,
    this.actionSpacing = 0,
    this.backgroundColor,
    this.elevation = 12.0,
    this.globalKey,
  })  : assert(expandedTitle != null),
        assert(collapsedTitle != null),
        super(key: key);

  final Widget? expandedTitle;
  final Widget? collapsedTitle;
  final List<Widget>? actions;
  final List<Widget> children;
  final EdgeInsetsGeometry childrenPadding;
  final Divider bottomDivider;
  final double? expandedHeight;
  final double toolbarHeight;
  final double actionSpacing;
  final Color? backgroundColor;
  final double elevation;

  /// The globalKey that is used to get innerScrollController
  /// of [NestedScrollViewState].
  ///
  /// - How to use
  ///
  /// {@animation 464 192 https://api.flutter.dev/flutter/widgets/NestedScrollViewState-class.html}
  final GlobalKey<NestedScrollViewState>? globalKey;

  @override
  _OneUiScrollViewState createState() => _OneUiScrollViewState();
}

class _OneUiScrollViewState extends State<OneUiScrollView>
    with SingleTickerProviderStateMixin {
  late GlobalKey<NestedScrollViewState> _nestedScrollViewStateKey;
  late double _expandedHeight;
  // late Future<void> _scrollAnimate;

  @override
  void initState() {
    super.initState();
    _nestedScrollViewStateKey = widget.globalKey ?? GlobalKey();
  }

  void _snapAppBar(ScrollController controller, double snapOffset) async {
    // await _scrollAnimate;

    // _scrollAnimate =
    controller.animateTo(
      snapOffset,
      curve: Curves.ease,
      duration: const Duration(milliseconds: 150),
    );
  }

  bool _onNotification(ScrollEndNotification notification) {
    final scrollViewState = _nestedScrollViewStateKey.currentState;
    final outerController = scrollViewState?.outerController;

    if (scrollViewState!.innerController.position.pixels == 0 &&
        !outerController!.position.atEdge) {
      final range = _expandedHeight - widget.toolbarHeight;
      final snapOffset = (outerController.offset / range) > 0.5 ? range : 0.0;

      Future.microtask(() => _snapAppBar(outerController, snapOffset));
    }
    return false;
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio = (constraints.maxHeight - widget.toolbarHeight) /
        (_expandedHeight - widget.toolbarHeight);

    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;

    return expandRatio;
  }

  Widget _extendedTitle(Animation<double> animation) {
    return FadeTransition(
        opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
        )),
        child: animation.value > 0.1 ? widget.expandedTitle : Container());
  }

  Widget _collapsedTitle(Animation<double> animation) {
    return FadeTransition(
      opacity: Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      )),
      child: animation.value < 0.9 ? widget.collapsedTitle : Container(),
    );
  }

  Widget _actions() {
    if (widget.actions == null) return Container();
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(right: widget.actionSpacing),
        height: widget.toolbarHeight,
        child: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: widget.actions!,
          ),
        ),
      ),
    );
  }

  List<Widget> _getAppBar(context, innerBoxIsScrolled) {
    return [
      SliverOverlapAbsorber(
        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        sliver: SliverAppBar(
          backgroundColor: widget.backgroundColor,
          pinned: true,
          expandedHeight: _expandedHeight,
          toolbarHeight: widget.toolbarHeight,
          elevation: 12,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              final expandRatio = _calculateExpandRatio(constraints);
              final animation = AlwaysStoppedAnimation(expandRatio);

              return Stack(
                //  fit: StackFit.expand,
                children: [
                  _collapsedTitle(animation),
                  _extendedTitle(animation),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: widget.bottomDivider,
                  )
                ],
              );
            },
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _expandedHeight = widget.expandedHeight ??
        (MediaQuery.of(context).size.height * _kExpendedAppBarHeightRatio);

    final Widget body = SafeArea(
      top: false,
      bottom: false,
      child: Builder(
        builder: (BuildContext context) => CustomScrollView(
          slivers: <Widget>[
            SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            ),
            SliverPadding(
              padding: widget.childrenPadding,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) => widget.children[i],
                  childCount: widget.children.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return SafeArea(
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowIndicator();
          return true;
        },
        child: NotificationListener<ScrollEndNotification>(
          onNotification: _onNotification,
          child: NestedScrollView(
            key: _nestedScrollViewStateKey,
            physics: OneUiScrollPhysics(_expandedHeight),
            headerSliverBuilder: _getAppBar,
            body: body,
          ),
        ),
      ),
    );
  }
}
