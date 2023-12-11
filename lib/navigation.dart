// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum _Variant { combine, rail, drawer }

class Destination {
  const Destination(
    this.tooltip,
    this.label,
    this.icon,
    this.selectedIcon,
  );

  final String tooltip;
  final String label;
  final Widget icon;
  final Widget selectedIcon;
}

class ExpandedLabel extends StatelessWidget {
  const ExpandedLabel(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(children: [
        Text(data),
        const Spacer(),
        Badge.count(count: 2),
        const SizedBox(width: 16)
      ]),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    this.onDestinationSelected,
    this.extended = false,
    this.leading,
    this.trailing,
  }) : variant = _Variant.combine;

  const SideBar.drawer({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    this.onDestinationSelected,
    this.extended = false,
    this.leading,
    this.trailing,
  }) : variant = _Variant.drawer;

  const SideBar.rail({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    this.onDestinationSelected,
    this.extended = false,
    this.leading,
    this.trailing,
  }) : variant = _Variant.rail;

  final int selectedIndex;
  final List<Destination> destinations;
  final ValueChanged<int>? onDestinationSelected;
  final bool extended;
  final Widget? leading;
  final Widget? trailing;
  // ignore: library_private_types_in_public_api
  final _Variant variant;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      _Variant.drawer => _SideDrawer(
          key: key,
          selectedIndex: selectedIndex,
          destinations: destinations,
          onDestinationSelected: onDestinationSelected,
          leading: leading,
          trailing: trailing,
        ),
      _Variant.rail => _SideRail(
          key: key,
          extended: extended,
          selectedIndex: selectedIndex,
          destinations: destinations,
          onDestinationSelected: onDestinationSelected,
          leading: leading,
          trailing: trailing,
        ),
      _Variant.combine => _SideRail(
          key: key,
          extended: extended,
          selectedIndex: selectedIndex,
          destinations: destinations,
          onDestinationSelected: onDestinationSelected,
          leading: leading,
          trailing: trailing,
        ),
    };
  }
}

class _SideRail extends StatelessWidget {
  const _SideRail({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    this.onDestinationSelected,
    this.extended = false,
    this.trailing,
    this.leading,
  });

  final int selectedIndex;
  final List<Destination> destinations;
  final ValueChanged<int>? onDestinationSelected;
  final bool extended;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return NavigationRailTheme(
      data: NavigationRailTheme.of(context).copyWith(
        // labelType: NavigationRailLabelType.all,
        // elevation: 4,
        groupAlignment: 1,
        // groupAlignment: -0.85,
        backgroundColor: Colors.transparent,
        // indicatorShape: CircleBorder(),
      ),
      child: Card(
        margin: const EdgeInsets.only(right: 4.0),
        // margin: EdgeInsets.zero,
        // margin: const EdgeInsets.symmetric(vertical: 36),
        shadowColor: Colors.transparent,
        child: NavigationRail(
          extended: extended,
          selectedIndex: selectedIndex,
          destinations: destinations.railDestinations,
          onDestinationSelected: onDestinationSelected,
          leading: leading,
          trailing: trailing,
        ),
      ),
    );
  }
}

class _SideDrawer extends StatelessWidget {
  const _SideDrawer({
    super.key,
    required this.selectedIndex,
    required this.destinations,
    this.onDestinationSelected,
    this.leading,
    this.trailing,
  });

  final int selectedIndex;
  final List<Destination> destinations;
  final ValueChanged<int>? onDestinationSelected;
  final Widget? leading;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      key: key,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      children: [
        if (leading != null) ...[
          const SizedBox(height: 14),
          leading!,
          const SizedBox(height: 14),
        ],
        if (destinations.isNotEmpty) ...[
          const SizedBox(height: 14),
          ...destinations.drawerDestinations,
        ],
        if (trailing != null) ...[
          const SizedBox(height: 14),
          trailing!,
        ]
      ],
    );
  }
}

const List<Destination> destinations = <Destination>[
  Destination(
    'Inbox',
    'Inbox',
    Icon(Icons.mail_outline_rounded),
    Icon(Icons.mail_rounded),
  ),
  Destination(
    'Components',
    'Components',
    Icon(Icons.widgets_outlined),
    Icon(Icons.widgets),
  ),
  Destination(
    'Color',
    'Color',
    Icon(Icons.format_paint_outlined),
    Icon(Icons.format_paint),
  ),
  Destination(
    'Typography',
    'Typography',
    Icon(Icons.text_snippet_outlined),
    Icon(Icons.text_snippet),
  ),
  Destination(
    'Elevation',
    'Elevation',
    Icon(Icons.invert_colors_on_outlined),
    Icon(Icons.opacity),
  ),
];

extension on List<Destination> {
  List<NavigationRailDestination> get railDestinations {
    return map((destination) {
      return NavigationRailDestination(
        icon: Tooltip(message: destination.label, child: destination.icon),
        selectedIcon: Tooltip(
          message: destination.label,
          child: destination.selectedIcon,
        ),
        label: Text(destination.label),
      );
    }).toList();
  }

  List<NavigationDrawerDestination> get drawerDestinations {
    return map((destination) {
      return NavigationDrawerDestination(
        // label: Text(destination.label),
        label: destination.label != 'Inbox'
            ? Text(destination.label)
            : ExpandedLabel(destination.label),
        icon: destination.icon,
        selectedIcon: destination.selectedIcon,
      );
    }).toList();
  }
}
