// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

library floating_bottom_bar;

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/floatingNavBar/util/event_bus.dart';
import 'package:planner/constant.dart';

import 'constants/enums.dart';

part 'constants/colors.dart';

part 'constants/dimens.dart';

part 'constants/images.dart';

part 'constants/strings.dart';

part 'curved_notch/circular_notch_and_corner_clipper.dart';

part 'curved_notch/circular_notched_and_cornered_shape.dart';

part 'models/bottom_bar_item_model.dart';

part 'models/bottom_bar_center_model.dart';

part 'widgets/animated_button.dart';

part 'widgets/center_button_child_animation.dart';

part 'widgets/center_buttons.dart';

part 'widgets/floating_center_button.dart';

part 'widgets/floating_center_button_child.dart';

part 'widgets/menu_items.dart';

part 'widgets/menu_items_child.dart';

class AnimatedBottomNavigationBar extends StatefulWidget {
  const AnimatedBottomNavigationBar({
    this.bottomBarCenterModel,
    required this.bottomBar,
    this.addBT,
    this.barColor = Colors.white,
    this.barGradient,
    Key? key,
  }) : super(key: key);
  final List<BottomBarItemsModel> bottomBar;
  final BottomBarCenterModel? bottomBarCenterModel;
  final addBT;
  final Color barColor;
  final Gradient? barGradient;

  @override
  _AnimatedBottomNavigationBarState createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState
    extends State<AnimatedBottomNavigationBar> with TickerProviderStateMixin {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _checkValidations();
    super.initState();
  }

  ///
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        fit: StackFit.loose,
        alignment: Alignment.bottomCenter,
        children: [
          BottomBarItems(
            barColor: widget.barColor,
            bottomBarItemsList: widget.bottomBar,
            barGradient: widget.barGradient,
          ),
          if (widget.bottomBarCenterModel != null)
            AnimatedButton(
                bottomBarCenterModel: widget.bottomBarCenterModel ??
                    BottomBarCenterModel(
                        centerIcon: const FloatingCenterButton(
                            child: Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                        centerIconChild: [
                          FloatingCenterButtonChild(
                            child: const Icon(
                              Iconsax.briefcase,
                              color: AppColors.white,
                            ),
                            onTap: () async {},
                          )
                        ])),
          widget.addBT ?? Container()
        ],
      ),
    );
  }

  /// Check tab bat items count is even.
  bool isEvenCount(int length) => length % 2 == 0;

  /// Check validations like maximum items exceed and item count is even.
  void _checkValidations() {
    assert(widget.bottomBar.length <= Dimens.maximumItems,
        Strings.menuItemsMaximum);
    assert(isEvenCount(widget.bottomBar.length), Strings.menuItemsMustBeEven);
  }
}
