// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ComponentGroupDecoration extends StatefulWidget {
  const ComponentGroupDecoration({super.key, required this.child});

  final Widget child;

  @override
  State<ComponentGroupDecoration> createState() =>
      _ComponentGroupDecorationState();
}

class _ComponentGroupDecorationState extends State<ComponentGroupDecoration> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Focus(
        focusNode: focusNode,
        canRequestFocus: true,
        child: GestureDetector(
          onTapDown: (_) {
            focusNode.requestFocus();
          },
          behavior: HitTestBehavior.opaque,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
