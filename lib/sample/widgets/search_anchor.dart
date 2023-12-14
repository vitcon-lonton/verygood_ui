// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class RepliesSearchAnchor extends StatefulWidget {
  const RepliesSearchAnchor({
    super.key,
    this.barTrailing,
  });

  final Iterable<Widget>? barTrailing;

  @override
  State<RepliesSearchAnchor> createState() => _RepliesSearchAnchorState();
}

class _RepliesSearchAnchorState extends State<RepliesSearchAnchor> {
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
    return SizedBox(
      height: 56,
      child: SearchBarTheme(
        data: SearchBarTheme.of(context).copyWith(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: SearchAnchor.bar(
          barTrailing: widget.barTrailing,
          // viewElevation: 1,
          // isFullScreen: true,
          barHintText: 'Search replies',
          barElevation: MaterialStateProperty.all(2),
          suggestionsBuilder: (context, controller) {
            if (controller.text.isEmpty) {
              if (searchHistory.isNotEmpty) {
                return getHistoryList(controller);
              }
              return [
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
    );
  }
}

// class SearchAnchors extends StatefulWidget {
//   const SearchAnchors({
//     super.key,
//     this.barTrailing,
//   });

//   final Iterable<Widget>? barTrailing;

//   @override
//   State<SearchAnchors> createState() => _SearchAnchorsState();
// }

// class _SearchAnchorsState extends State<SearchAnchors> {
//   String? selectedColor;
//   List<ColorItem> searchHistory = <ColorItem>[];

//   Iterable<Widget> getHistoryList(SearchController controller) {
//     return searchHistory.map((color) => ListTile(
//           leading: const Icon(Icons.history),
//           title: Text(color.label),
//           trailing: IconButton(
//               icon: const Icon(Icons.call_missed),
//               onPressed: () {
//                 controller.text = color.label;
//                 controller.selection =
//                     TextSelection.collapsed(offset: controller.text.length);
//               }),
//           onTap: () {
//             controller.closeView(color.label);
//             handleSelection(color);
//           },
//         ));
//   }

//   Iterable<Widget> getSuggestions(SearchController controller) {
//     final String input = controller.value.text;
//     return ColorItem.values
//         .where((color) => color.label.contains(input))
//         .map((filteredColor) => ListTile(
//               leading: CircleAvatar(backgroundColor: filteredColor.color),
//               title: Text(filteredColor.label),
//               trailing: IconButton(
//                   icon: const Icon(Icons.call_missed),
//                   onPressed: () {
//                     controller.text = filteredColor.label;
//                     controller.selection =
//                         TextSelection.collapsed(offset: controller.text.length);
//                   }),
//               onTap: () {
//                 controller.closeView(filteredColor.label);
//                 handleSelection(filteredColor);
//               },
//             ));
//   }

//   void handleSelection(ColorItem color) {
//     setState(() {
//       selectedColor = color.label;
//       if (searchHistory.length >= 5) {
//         searchHistory.removeLast();
//       }
//       searchHistory.insert(0, color);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SearchBarTheme(
//       data: SearchBarTheme.of(context).copyWith(
//         shadowColor: MaterialStateProperty.all(Colors.transparent),
//       ),
//       child: SearchAnchor.bar(
//         barTrailing: widget.barTrailing,
//         // viewElevation: 1,
//         isFullScreen: false,
//         barHintText: 'Search colors',
//         barElevation: MaterialStateProperty.all(2),
//         suggestionsBuilder: (context, controller) {
//           if (controller.text.isEmpty) {
//             if (searchHistory.isNotEmpty) {
//               return getHistoryList(controller);
//             }
//             return [
//               const Center(
//                 child: Text('No search history.',
//                     style: TextStyle(color: Colors.grey)),
//               )
//             ];
//           }
//           return getSuggestions(controller);
//         },
//       ),
//     );
//   }
// }

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
