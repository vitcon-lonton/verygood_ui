// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const rowDivider = SizedBox(width: 20);
const colDivider = SizedBox(height: 10);
const tinySpacing = 4.0;
// const tinySpacing = 3.0;
const smallSpacing = 10.0;

class FirstInboxList extends StatelessWidget {
  const FirstInboxList({
    super.key,
    required this.showNavBottomBar,
    required this.showSecondList,
  });

  final bool showNavBottomBar;
  final bool showSecondList;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      // colDivider,
      // AppBar(
      //   elevation: 0,
      //   scrolledUnderElevation: 0,
      //   flexibleSpace: const SearchAnchors(),
      // ),
      colDivider,
      const SearchAnchors(),
      colDivider,
      const CardsInbox(),
      if (!showSecondList) ...[
        colDivider,
        const CardsDetails(),
      ],
      colDivider,
    ];
    List<double?> heights = List.filled(children.length, null);

    // Fully traverse this list before moving on.
    return FocusTraversalGroup(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: smallSpacing,
            ),
            sliver: SliverList(
              delegate: BuildSlivers(
                heights: heights,
                builder: (context, index) {
                  return _CacheHeight(
                    heights: heights,
                    index: index,
                    child: children[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondInboxList extends StatelessWidget {
  const SecondInboxList({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      colDivider,
      const CardsDetails(),
      colDivider,
    ];
    List<double?> heights = List.filled(children.length, null);

    // Fully traverse this list before moving on.
    return FocusTraversalGroup(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: smallSpacing,
            ),
            sliver: SliverList(
              delegate: BuildSlivers(
                heights: heights,
                builder: (context, index) {
                  return _CacheHeight(
                    heights: heights,
                    index: index,
                    child: children[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// If the content of a CustomScrollView does not change, then it's
// safe to cache the heights of each item as they are laid out. The
// sum of the cached heights are returned by an override of
// `SliverChildDelegate.estimateMaxScrollOffset`. The default version
// of this method bases its estimate on the average height of the
// visible items. The override ensures that the scrollbar thumb's
// size, which depends on the max scroll offset, will shrink smoothly
// as the contents of the list are exposed for the first time, and
// then remain fixed.
class _CacheHeight extends SingleChildRenderObjectWidget {
  const _CacheHeight({
    super.child,
    required this.heights,
    required this.index,
  });

  final List<double?> heights;
  final int index;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCacheHeight(
      heights: heights,
      index: index,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderCacheHeight renderObject) {
    renderObject
      ..heights = heights
      ..index = index;
  }
}

class _RenderCacheHeight extends RenderProxyBox {
  _RenderCacheHeight({
    required List<double?> heights,
    required int index,
  })  : _heights = heights,
        _index = index,
        super();

  List<double?> _heights;
  List<double?> get heights => _heights;
  set heights(List<double?> value) {
    if (value == _heights) {
      return;
    }
    _heights = value;
    markNeedsLayout();
  }

  int _index;
  int get index => _index;
  set index(int value) {
    if (value == index) {
      return;
    }
    _index = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    super.performLayout();
    heights[index] = size.height;
  }
}

// The heights information is used to override the `estimateMaxScrollOffset` and
// provide a more accurate estimation for the max scroll offset.
class BuildSlivers extends SliverChildBuilderDelegate {
  BuildSlivers({
    required NullableIndexedWidgetBuilder builder,
    required this.heights,
  }) : super(builder, childCount: heights.length);

  final List<double?> heights;

  @override
  double? estimateMaxScrollOffset(int firstIndex, int lastIndex,
      double leadingScrollOffset, double trailingScrollOffset) {
    return heights.reduce((sum, height) => (sum ?? 0) + (height ?? 0))!;
  }
}

class CardsInbox extends StatefulWidget {
  const CardsInbox({super.key});

  @override
  State<CardsInbox> createState() => _CardsInboxState();
}

class _CardsInboxState extends State<CardsInbox> {
  Inbox _selected = inboxes.first;

  Widget _elevated(BuildContext context, Inbox value) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        setState(() {
          _selected = value;
        });
      },
      child: Container(
        // padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              leading: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                padding: EdgeInsets.zero,
                icon: const CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(Icons.person_rounded)),
                onPressed: () {},
              ),
              trailing: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                onPressed: () {},
                icon: const Icon(Icons.star_border_rounded),
              ),
              title: Text(value.user),
              subtitle: Text(value.create),
            ),
            // const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              isThreeLine: true,
              title: Text(value.title),
              subtitle: Text(value.content),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filled(BuildContext context, Inbox value) {
    return FilledButton.tonal(
      style: FilledButton.styleFrom(
        padding: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
      child: Container(
        // padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              leading: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                padding: EdgeInsets.zero,
                icon: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.person_rounded),
                ),
                onPressed: () {},
              ),
              trailing: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
                onPressed: () {},
                icon: const Icon(Icons.star_border_rounded),
              ),
              title: Text(value.user),
              subtitle: Text(value.create),
            ),
            // const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              isThreeLine: true,
              title: Text(value.title),
              subtitle: Text(value.content),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ComponentGroupDecoration(
      child: FocusTraversalGroup(
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 8.0,
          children: inboxes.asMap().entries.map(
            (e) {
              return e.value != _selected
                  ? _elevated(context, e.value)
                  : _filled(context, e.value);
            },
          ).toList(),
        ),
      ),
    );
  }
}

class CardsDetails extends StatelessWidget {
  const CardsDetails({super.key});

  Widget _elevated(BuildContext context, Inbox value) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        margin: EdgeInsets.zero,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide.none,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {},
          child: Column(
            children: [
              ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
                isThreeLine: true,
                title: Text(value.title),
                subtitle: Text(value.content),
              ),
              ListTileTheme(
                contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      minLeadingWidth: 0,
                      leading: IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                        ),
                        padding: EdgeInsets.zero,
                        icon: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Icon(Icons.person_rounded)),
                        onPressed: () {},
                      ),
                      trailing: IconButton.filled(
                        style: IconButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.star_border_rounded),
                      ),
                      title: Text(value.user),
                      subtitle: Text(value.create),
                    ),
                    // const SizedBox(height: 20),
                    ListTile(
                      isThreeLine: true,
                      title: Text(value.title),
                      subtitle: Text(value.content),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: FilledButton.tonal(
                          onPressed: null, child: Text('Reply')),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ComponentGroupDecoration(
      child: FocusTraversalGroup(
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 8.0,
          children: inboxes.map((e) => _elevated(context, e)).toList(),
        ),
      ),
    );
  }
}

class SearchAnchors extends StatefulWidget {
  const SearchAnchors({super.key});

  @override
  State<SearchAnchors> createState() => _SearchAnchorsState();
}

class _SearchAnchorsState extends State<SearchAnchors> {
  String? selectedColor;
  List<ColorItem> searchHistory = <ColorItem>[];

  Iterable<Widget> getHistoryList(SearchController controller) {
    return searchHistory.map((color) => ListTile(
          leading: const Icon(Icons.history),
          title: Text(color.label),
          trailing: IconButton(
              icon: const Icon(Icons.call_missed),
              onPressed: () {
                controller.text = color.label;
                controller.selection =
                    TextSelection.collapsed(offset: controller.text.length);
              }),
          onTap: () {
            controller.closeView(color.label);
            handleSelection(color);
          },
        ));
  }

  Iterable<Widget> getSuggestions(SearchController controller) {
    final String input = controller.value.text;
    return ColorItem.values
        .where((color) => color.label.contains(input))
        .map((filteredColor) => ListTile(
              leading: CircleAvatar(backgroundColor: filteredColor.color),
              title: Text(filteredColor.label),
              trailing: IconButton(
                  icon: const Icon(Icons.call_missed),
                  onPressed: () {
                    controller.text = filteredColor.label;
                    controller.selection =
                        TextSelection.collapsed(offset: controller.text.length);
                  }),
              onTap: () {
                controller.closeView(filteredColor.label);
                handleSelection(filteredColor);
              },
            ));
  }

  void handleSelection(ColorItem color) {
    setState(() {
      selectedColor = color.label;
      if (searchHistory.length >= 5) {
        searchHistory.removeLast();
      }
      searchHistory.insert(0, color);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ComponentGroupDecoration(
      child: FocusTraversalGroup(
        child: SearchBarTheme(
          data: SearchBarTheme.of(context).copyWith(
            shadowColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: SearchAnchor.bar(
            isFullScreen: false,
            barHintText: 'Search colors',
            barElevation: MaterialStateProperty.all(2),
            suggestionsBuilder: (context, controller) {
              if (controller.text.isEmpty) {
                if (searchHistory.isNotEmpty) {
                  return getHistoryList(controller);
                }
                return <Widget>[
                  const Center(
                    child: Text('No search history.',
                        style: TextStyle(color: Colors.grey)),
                  )
                ];
              }
              return getSuggestions(controller);
            },
          ),
        ),
      ),
    );
  }
}

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
      child: Padding(
        padding: EdgeInsets.zero,
        // padding: const EdgeInsets.symmetric(vertical: smallSpacing),
        child: Focus(
          focusNode: focusNode,
          canRequestFocus: true,
          child: GestureDetector(
            onTapDown: (_) {
              focusNode.requestFocus();
            },
            behavior: HitTestBehavior.opaque,
            child: Card(
              color: Colors.transparent,
              // color: Theme.of(
              //   context,
              // ).colorScheme.surfaceVariant.withOpacity(0.3),
              elevation: 0,
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                // padding: const EdgeInsets.symmetric(
                //     horizontal: 5.0, vertical: 20.0),
                padding: EdgeInsets.zero,
                child: Center(child: widget.child),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum ColorItem {
  red('red', Colors.red),
  orange('orange', Colors.orange),
  yellow('yellow', Colors.yellow),
  green('green', Colors.green),
  blue('blue', Colors.blue),
  indigo('indigo', Colors.indigo),
  violet('violet', Color(0xFF8F00FF)),
  purple('purple', Colors.purple),
  pink('pink', Colors.pink),
  silver('silver', Color(0xFF808080)),
  gold('gold', Color(0xFFFFD700)),
  beige('beige', Color(0xFFF5F5DC)),
  brown('brown', Colors.brown),
  grey('grey', Colors.grey),
  black('black', Colors.black),
  white('white', Colors.white);

  const ColorItem(this.label, this.color);
  final String label;
  final Color color;
}

class Inbox {
  Inbox({
    required this.user,
    required this.create,
    required this.title,
    required this.content,
  });

  final String user;
  final String create;
  final String title;
  final String content;

  @override
  String toString() {
    return 'Inbox(user: $user, create: $create, title: $title, content: $content)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Inbox &&
        other.user == user &&
        other.create == create &&
        other.title == title &&
        other.content == content;
  }

  @override
  int get hashCode {
    return user.hashCode ^ create.hashCode ^ title.hashCode ^ content.hashCode;
  }
}

final inboxes = [
  Inbox(
    user: '老强',
    create: '10 min ago',
    title: '豆花鱼',
    content: '最近忙吗？昨晚我去了你最爱的那家饭馆，点了他们的特色豆花鱼，吃着吃着就想你了。有空咱们视频?',
  ),
  Inbox(
    user: 'So Puri',
    create: '20 min ago',
    title: 'Dinner club',
    content:
        '''I think it's time for us to finally try that new noodle shop downtown that doesn't use menus. Anyone else have other sug...''',
  ),
  Inbox(
    user: 'Lily MacDonald',
    create: '2 hours ago',
    title: 'This food show is made for you',
    content:
        '''Ping- you'd love this new food show I started watching. It's produced by a Thai drummer who started getting recognized for the amazing vegan fo...''',
  ),
  Inbox(
    user: 'Izard Aouad',
    create: '6 hours ago',
    title: '豆花鱼',
    content: '''点了他们的特色豆花鱼，吃着吃着就想你了。有空咱们视频. Think about it??''',
  ),
  Inbox(
    user: '豆花鱼',
    create: '10 hours ago',
    title: 'Volunteer EMT with me?',
    content:
        '''What do you think about training to be volunteer EMTs? We could do it together for moral support. Think about it??''',
  ),
  Inbox(
    user: '有空咱们视频',
    create: '24 hours ago',
    title: '''Think about it??''',
    content: '点了他们的特色豆花鱼，吃着吃着就想你了。有空咱们视频?. 最近忙吗？昨晚我去了你最爱的那家饭馆.',
  ),
];
