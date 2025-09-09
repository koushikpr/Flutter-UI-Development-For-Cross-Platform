import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.iconData,
    this.selectedIconData,
    this.index = 0,
    this.isSelected = false,
    this.animationController,
  });

  IconData? iconData;           // Outline icon
  IconData? selectedIconData;   // Filled icon (optional)
  bool isSelected;
  int index;
  AnimationController? animationController;
}
