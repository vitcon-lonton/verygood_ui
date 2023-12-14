// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import '../animations.dart';

class AppBarTransition extends StatefulWidget {
  const AppBarTransition({
    super.key,
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  State<AppBarTransition> createState() => _AppBarTransition();
}

class _AppBarTransition extends State<AppBarTransition> {
  late final Animation<Offset> offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  ).animate(OffsetAnimation(parent: widget.animation));

  late final Animation<double> heightAnimation = Tween<double>(
    begin: 0,
    end: 1,
  ).animate(SizeAnimation(parent: widget.animation));

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      heightFactor: heightAnimation.value,
      child: FractionalTranslation(
        translation: offsetAnimation.value,
        child: widget.child,
      ),
    );
  }
}
