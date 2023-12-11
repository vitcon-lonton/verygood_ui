// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class StarButton extends StatefulWidget {
  const StarButton({super.key});

  @override
  State<StarButton> createState() => _StarButtonState();
}

class _StarButtonState extends State<StarButton> {
  bool state = false;

  double get turns => state ? 1 : 0;

  Icon get icon {
    return Icon(state ? Icons.star_rounded : Icons.star_border_rounded);
  }

  void _toggle() {
    setState(() {
      state = !state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: turns,
      curve: Curves.decelerate,
      duration: const Duration(milliseconds: 300),
      child: IconButton.filled(
        icon: icon,
        onPressed: () => _toggle(),
        style: IconButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      ),
    );
  }
}
