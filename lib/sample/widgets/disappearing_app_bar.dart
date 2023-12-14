// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../animations.dart';
import '../transitions/app_bar_transition.dart';

class DisappearingAppBar extends StatelessWidget {
  const DisappearingAppBar({
    super.key,
    required this.animation,
    this.leading,
    this.title,
    this.actions,
  });

  final BarAnimation animation;
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBarTransition(
      animation: animation,
      child: AppBar(
        // elevation: 0,
        leading: leading,
        title: title,
        actions: actions,
      ),
    );
  }
}
