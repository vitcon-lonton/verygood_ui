// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../animations.dart';
import 'search_anchor.dart';

class AnimatedSearchAnchor extends StatefulWidget {
  const AnimatedSearchAnchor({
    super.key,
    required this.animation,
    this.barTrailing,
  });

  final Animation<double> animation;
  final Iterable<Widget>? barTrailing;

  @override
  State<AnimatedSearchAnchor> createState() => _AnimatedSearchAnchor();
}

class _AnimatedSearchAnchor extends State<AnimatedSearchAnchor> {
  late final Animation<double> _scaleAnimation =
      ScaleAnimation(parent: widget.animation);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: RepliesSearchAnchor(barTrailing: widget.barTrailing),
    );
  }
}
