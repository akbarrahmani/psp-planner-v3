// ignore_for_file: file_names

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/variables.dart';

// ignore: must_be_immutable
class MyScaffold extends GetView {
  Widget expandedAppBar;
  Widget appBar;
  Widget child;
  double? maxExtent;
  double? minExtent;
  MyScaffold(
      {super.key,
      required this.child,
      required this.appBar,
      required this.expandedAppBar,
      this.maxExtent,
      this.minExtent});
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                      appBar: appBar,
                      expandedAppBar: expandedAppBar,
                      initMaxExtent: maxExtent ?? (Platform.isIOS ? 285 : 275),
                      initMinExtent: minExtent ?? 55),
                ))
          ];
        },
        body: Container(
            padding: EdgeInsets.only(top: minExtent ?? 55), child: child));
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  Widget expandedAppBar;
  Widget appBar;
  double initMaxExtent;
  double initMinExtent;
  _SliverAppBarDelegate(
      {required this.appBar,
      required this.expandedAppBar,
      required this.initMaxExtent,
      required this.initMinExtent});
  double scrollAnimationValue(double shrinkOffset) {
    double maxScrollAllowed = maxExtent - minExtent;
    return ((maxScrollAllowed - shrinkOffset) / maxScrollAllowed)
        .clamp(0, 1)
        .toDouble();
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final double visibleMainHeight = max(maxExtent - shrinkOffset, minExtent);
    final double animationVal = scrollAnimationValue(shrinkOffset);
    return SizedBox(
      height: visibleMainHeight,
      width: MediaQuery.of(context).size.width,
      child: Stack(fit: StackFit.expand, children: <Widget>[
        Container(color: darkMode.isTrue ? Colors.grey.shade800 : Colors.white),
        Opacity(opacity: animationVal, child: expandedAppBar),
        Positioned(
            top: -(animationVal * 55),
            child: Container(
                color: darkMode.isTrue ? Colors.grey.shade800 : Colors.white,
                width: MediaQuery.of(context).size.width,
                height: 55,
                child: appBar))
      ]),
    );
  }

  @override
  double get maxExtent => initMaxExtent;

  @override
  double get minExtent => initMinExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
