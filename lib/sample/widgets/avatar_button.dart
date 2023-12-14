// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class AvatarButton extends StatelessWidget {
  const AvatarButton({
    this.child,
    this.image,
    super.key,
  });

  final Widget? child;
  final ImageProvider<Object>? image;

  @override
  Widget build(BuildContext context) {
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          padding: EdgeInsets.zero,
        ).merge(IconButtonTheme.of(context).style),
      ),
      child: IconButton(
        onPressed: null,
        icon: Stack(
          children: [
            CircleAvatar(backgroundImage: image, child: child),
            IconButton(icon: const SizedBox.shrink(), onPressed: () {})
          ],
        ),
      ),
    );
  }
}

// return IconButton(
//   padding: EdgeInsets.zero,
//   icon: CircleAvatar(child: child),
//   onPressed: () {},
// );
// return IconButton.filled(
//   style: IconButton.styleFrom(
//     backgroundColor: Theme.of(context).colorScheme.surface,
//   ),
//   padding: EdgeInsets.zero,
//   icon: CircleAvatar(backgroundColor: Colors.transparent, child: child),
//   onPressed: () {},
// );