// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.inbox_rounded, 'Inbox'),
  Destination(Icons.widgets_outlined, 'Components'),
  Destination(Icons.format_paint_outlined, 'Color'),
  Destination(Icons.text_snippet_outlined, 'Typography'),
  Destination(Icons.invert_colors_on_outlined, 'Elevation'),
];

// const List<Destination> destinations = <Destination>[
//   Destination(Icons.inbox_rounded, 'Inbox'),
//   Destination(Icons.article_outlined, 'Articles'),
//   Destination(Icons.messenger_outline_rounded, 'Messages'),
//   Destination(Icons.group_outlined, 'Groups'),
// ];


// const List<NavigationDestination> appBarDestinations = [
//   NavigationDestination(
//     tooltip: '',
//     icon: Icon(Icons.widgets_outlined),
//     label: 'Components',
//     selectedIcon: Icon(Icons.widgets),
//   ),
//   NavigationDestination(
//     tooltip: '',
//     icon: Icon(Icons.format_paint_outlined),
//     label: 'Color',
//     selectedIcon: Icon(Icons.format_paint),
//   ),
//   NavigationDestination(
//     tooltip: '',
//     icon: Icon(Icons.text_snippet_outlined),
//     label: 'Typography',
//     selectedIcon: Icon(Icons.text_snippet),
//   ),
//   NavigationDestination(
//     tooltip: '',
//     icon: Icon(Icons.invert_colors_on_outlined),
//     label: 'Elevation',
//     selectedIcon: Icon(Icons.opacity),
//   )
// ];
