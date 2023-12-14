// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../sample/animations.dart';
import '../sample/constants.dart';
import '../sample/models/models.dart';
import '../sample/transitions/list_detail_transition.dart';
import '../sample/widgets/animated_floating_action_button.dart';
import '../sample/widgets/disappearing_bottom_navigation_bar.dart';
import '../sample/widgets/disappearing_navigation_rail.dart';
import '../sample/widgets/email_list_view.dart';
import '../sample/widgets/reply_list_view.dart';
import '../sample/widgets/avatar_button.dart';
import '../sample/widgets/search_bar.dart' as sb;
import '../sample/widgets/search_anchor.dart' as search_anchor;

class Feed extends StatefulWidget {
  const Feed({
    super.key,
    required this.currentUser,
    required this.useLightMode,
    required this.colorSelected,
    required this.handleBrightnessChange,
    required this.handleColorSelect,
    required this.handleImageSelect,
    required this.colorSelectionMethod,
    required this.imageSelected,
  });

  final User currentUser;

  final bool useLightMode;
  final ColorSeed colorSelected;
  final ColorImageProvider imageSelected;
  final ColorSelectionMethod colorSelectionMethod;

  final void Function(bool useLightMode) handleBrightnessChange;
  final void Function(int value) handleColorSelect;
  final void Function(int value) handleImageSelect;

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
      // duration: Duration.zero,
      duration: const Duration(milliseconds: 1000),
      reverseDuration: const Duration(milliseconds: 1250),
      value: 0,
      vsync: this);
  late final _railAnimation = RailAnimation(parent: _controller);
  late final _railFabAnimation = RailFabAnimation(parent: _controller);
  late final _barAnimation = BarAnimation(parent: _controller);

  late final scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedIndex = 0;

  WindowClasses window = WindowClasses.compact;

  bool controllerInitialized = false;
  // bool showMediumSizeLayout = false;
  // bool showLargeSizeLayout = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   final double width = MediaQuery.of(context).size.width;
  //   final AnimationStatus status = _controller.status;
  //   if (width > 600) {
  //     if (status != AnimationStatus.forward &&
  //         status != AnimationStatus.completed) {
  //       _controller.forward();
  //     }
  //   } else {
  //     if (status != AnimationStatus.reverse &&
  //         status != AnimationStatus.dismissed) {
  //       _controller.reverse();
  //     }
  //   }
  //   if (!controllerInitialized) {
  //     controllerInitialized = true;
  //     _controller.value = width > 600 ? 1 : 0;
  //   }
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final double width = MediaQuery.of(context).size.width;
    final AnimationStatus status = _controller.status;
    if (width > mediumWidthBreakpoint) {
      if (width > largeWidthBreakpoint) {
        // showMediumSizeLayout = false;
        // showLargeSizeLayout = true;
        window = WindowClasses.expanded;
      } else {
        window = WindowClasses.medium;
        // showMediumSizeLayout = true;
        // showLargeSizeLayout = false;
      }
      if (status != AnimationStatus.forward &&
          status != AnimationStatus.completed) {
        _controller.forward();
      }
    } else {
      window = WindowClasses.compact;
      // showMediumSizeLayout = false;
      // showLargeSizeLayout = false;
      if (status != AnimationStatus.reverse &&
          status != AnimationStatus.dismissed) {
        _controller.reverse();
      }
    }
    if (!controllerInitialized) {
      controllerInitialized = true;
      _controller.value = width > mediumWidthBreakpoint ? 1 : 0;
    }
  }

  Widget _trailingActions() => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: _BrightnessButton(
              handleBrightnessChange: widget.handleBrightnessChange,
              showTooltipBelow: false,
            ),
          ),
          Flexible(
            child: _ColorSeedButton(
              handleColorSelect: widget.handleColorSelect,
              colorSelected: widget.colorSelected,
              colorSelectionMethod: widget.colorSelectionMethod,
            ),
          ),
          Flexible(
            child: _ColorImageButton(
              handleImageSelect: widget.handleImageSelect,
              imageSelected: widget.imageSelected,
              colorSelectionMethod: widget.colorSelectionMethod,
            ),
          ),
        ],
      );

  PreferredSizeWidget appBar() {
    return AppBar(
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      // title: search_anchor.RepliesSearchAnchor(
      //   barTrailing: [
      //     AvatarButton(child: Image.asset(widget.currentUser.avatarUrl))
      //   ],
      // ),
      // title: sb.SearchBar(currentUser: widget.currentUser),
      // title: const Text('Material 3'),
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(50),
      //   child: search_anchor.RepliesSearchAnchor(
      //     barTrailing: [
      //       AvatarButton(child: Image.asset(widget.currentUser.avatarUrl))
      //     ],
      //   ),
      // ),
      actions: [
        _BrightnessButton(
          handleBrightnessChange: widget.handleBrightnessChange,
        ),
        _ColorSeedButton(
          handleColorSelect: widget.handleColorSelect,
          colorSelected: widget.colorSelected,
          colorSelectionMethod: widget.colorSelectionMethod,
        ),
        _ColorImageButton(
          handleImageSelect: widget.handleImageSelect,
          imageSelected: widget.imageSelected,
          colorSelectionMethod: widget.colorSelectionMethod,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Scaffold(
          // appBar: switch (window) {
          //   WindowClasses.compact => appBar(),
          //   _ => appBar(),
          // },
          body: Row(
            children: [
              DisappearingNavigationRail(
                railAnimation: _railAnimation,
                railFabAnimation: _railFabAnimation,
                selectedIndex: selectedIndex,
                trailing: Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _trailingActions(),
                  ),
                ),
                onDestinationSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
              Expanded(
                child: ListDetailTransition(
                  animation: _railAnimation,
                  one: SliverEmailListView(
                    // top: switch (window) {
                    //   WindowClasses.compact => null,
                    //   // _ => search_anchor.RepliesSearchAnchor(barTrailing: [
                    //   //     AvatarButton(
                    //   //       child: Image.asset(widget.currentUser.avatarUrl),
                    //   //     )
                    //   //   ]),
                    //   _ => appBar(),
                    // },
                    // top: SliverAppBar(
                    //   // snap: true,
                    //   // floating: true,
                    //   // elevation: 0,
                    //   expandedHeight: 150,
                    //   // title: const SizedBox(),
                    //   flexibleSpace: FlexibleSpaceBar(
                    //     title: search_anchor.RepliesSearchAnchor(
                    //       barTrailing: [
                    //         AvatarButton(
                    //             child:
                    //                 Image.asset(widget.currentUser.avatarUrl))
                    //       ],
                    //     ),
                    //     background: search_anchor.RepliesSearchAnchor(
                    //       barTrailing: [
                    //         AvatarButton(
                    //             child:
                    //                 Image.asset(widget.currentUser.avatarUrl))
                    //       ],
                    //     ),
                    //   ),
                    //   // title: search_anchor.RepliesSearchAnchor(
                    //   //   barTrailing: [
                    //   //     AvatarButton(
                    //   //         child: Image.asset(widget.currentUser.avatarUrl))
                    //   //   ],
                    //   // ),
                    //   // bottom: PreferredSize(
                    //   //   preferredSize: const Size.fromHeight(0),
                    //   //   child: search_anchor.RepliesSearchAnchor(
                    //   //     barTrailing: [
                    //   //       AvatarButton(
                    //   //           child:
                    //   //               Image.asset(widget.currentUser.avatarUrl))
                    //   //     ],
                    //   //   ),
                    //   // ),
                    // ),
                    selectedIndex: selectedIndex,
                    onSelected: (index) {},
                  ),
                  two: const ReplyListView(),
                ),
              ),

              // Expanded(
              //   child: ListDetailTransition(
              //     animation: _railAnimation,
              //     one: EmailListView(
              //       // top: switch (window) {
              //       //   WindowClasses.compact => null,
              //       //   // _ => search_anchor.RepliesSearchAnchor(barTrailing: [
              //       //   //     AvatarButton(
              //       //   //       child: Image.asset(widget.currentUser.avatarUrl),
              //       //   //     )
              //       //   //   ]),
              //       //   _ => appBar(),
              //       // },
              //       selectedIndex: selectedIndex,
              //       onSelected: (index) {},
              //       currentUser: widget.currentUser,
              //     ),
              //     two: const ReplyListView(),
              //   ),
              // ),
            ],
          ),
          floatingActionButton: AnimatedFloatingActionButton(
            animation: _barAnimation,
            onPressed: () {},
            child: const Icon(Icons.add),
          ),
          bottomNavigationBar: DisappearingBottomNavigationBar(
            barAnimation: _barAnimation,
            selectedIndex: selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
          ),
        );
      },
    );
  }
}

class _BrightnessButton extends StatelessWidget {
  const _BrightnessButton({
    required this.handleBrightnessChange,
    this.showTooltipBelow = true,
  });

  final Function handleBrightnessChange;
  final bool showTooltipBelow;

  @override
  Widget build(BuildContext context) {
    final isBright = Theme.of(context).brightness == Brightness.light;
    return Tooltip(
      preferBelow: showTooltipBelow,
      message: 'Toggle brightness',
      child: IconButton(
        icon: isBright
            ? const Icon(Icons.dark_mode_outlined)
            : const Icon(Icons.light_mode_outlined),
        onPressed: () => handleBrightnessChange(!isBright),
      ),
    );
  }
}

class _ColorSeedButton extends StatelessWidget {
  const _ColorSeedButton({
    required this.handleColorSelect,
    required this.colorSelected,
    required this.colorSelectionMethod,
  });

  final void Function(int) handleColorSelect;
  final ColorSeed colorSelected;
  final ColorSelectionMethod colorSelectionMethod;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.palette_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      tooltip: 'Select a seed color',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return List.generate(ColorSeed.values.length, (index) {
          ColorSeed currentColor = ColorSeed.values[index];

          return PopupMenuItem(
            value: index,
            enabled: currentColor != colorSelected ||
                colorSelectionMethod != ColorSelectionMethod.colorSeed,
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    currentColor == colorSelected &&
                            colorSelectionMethod != ColorSelectionMethod.image
                        ? Icons.color_lens
                        : Icons.color_lens_outlined,
                    color: currentColor.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(currentColor.label),
                ),
              ],
            ),
          );
        });
      },
      onSelected: handleColorSelect,
    );
  }
}

class _ColorImageButton extends StatelessWidget {
  const _ColorImageButton({
    required this.handleImageSelect,
    required this.imageSelected,
    required this.colorSelectionMethod,
  });

  final void Function(int) handleImageSelect;
  final ColorImageProvider imageSelected;
  final ColorSelectionMethod colorSelectionMethod;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(
        Icons.image_outlined,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      tooltip: 'Select a color extraction image',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      itemBuilder: (context) {
        return List.generate(ColorImageProvider.values.length, (index) {
          ColorImageProvider currentImageProvider =
              ColorImageProvider.values[index];

          return PopupMenuItem(
            value: index,
            enabled: currentImageProvider != imageSelected ||
                colorSelectionMethod != ColorSelectionMethod.image,
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 48),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image(
                          image: NetworkImage(
                              ColorImageProvider.values[index].url),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(currentImageProvider.label),
                ),
              ],
            ),
          );
        });
      },
      onSelected: handleImageSelect,
    );
  }
}

// return AppBar(
//   leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
//   title: search_anchor.RepliesSearchAnchor(
//     barTrailing: [
//       AvatarButton(child: Image.asset(widget.currentUser.avatarUrl))
//     ],
//   ),
//   // title: sb.SearchBar(currentUser: widget.currentUser),
//   // title: const Text('Material 3'),
//   // bottom: PreferredSize(
//   //   preferredSize: Size.fromHeight(50),
//   //   child: sb.SearchBar(currentUser: widget.currentUser),
//   // ),
//   actions: !showMediumSizeLayout && !showLargeSizeLayout
//       ? [
//           _BrightnessButton(
//             handleBrightnessChange: widget.handleBrightnessChange,
//           ),
//           _ColorSeedButton(
//             handleColorSelect: widget.handleColorSelect,
//             colorSelected: widget.colorSelected,
//             colorSelectionMethod: widget.colorSelectionMethod,
//           ),
//           _ColorImageButton(
//             handleImageSelect: widget.handleImageSelect,
//             imageSelected: widget.imageSelected,
//             colorSelectionMethod: widget.colorSelectionMethod,
//           )
//         ]
//       : [Container()],
// );

// class _ExpandedTrailingActions extends StatelessWidget {
//   const _ExpandedTrailingActions({
//     required this.useLightMode,
//     required this.handleBrightnessChange,
//     required this.handleColorSelect,
//     required this.handleImageSelect,
//     required this.imageSelected,
//     required this.colorSelected,
//     required this.colorSelectionMethod,
//   });

//   final void Function(bool) handleBrightnessChange;
//   final void Function(int) handleImageSelect;
//   final void Function(int) handleColorSelect;

//   final bool useLightMode;

//   final ColorImageProvider imageSelected;
//   final ColorSeed colorSelected;
//   final ColorSelectionMethod colorSelectionMethod;

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final trailingActionsBody = Container(
//       constraints: const BoxConstraints.tightFor(width: 250),
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Row(
//             children: [
//               const Text('Brightness'),
//               Expanded(child: Container()),
//               Switch(
//                   value: useLightMode,
//                   onChanged: (value) {
//                     handleBrightnessChange(value);
//                   })
//             ],
//           ),
//           const Divider(),
//           _ExpandedColorSeedAction(
//             handleColorSelect: handleColorSelect,
//             colorSelected: colorSelected,
//             colorSelectionMethod: colorSelectionMethod,
//           ),
//           const Divider(),
//           _ExpandedImageColorAction(
//             handleImageSelect: handleImageSelect,
//             imageSelected: imageSelected,
//             colorSelectionMethod: colorSelectionMethod,
//           ),
//         ],
//       ),
//     );
//     return screenHeight > 740
//         ? trailingActionsBody
//         : SingleChildScrollView(child: trailingActionsBody);
//   }
// }

// class _ExpandedColorSeedAction extends StatelessWidget {
//   const _ExpandedColorSeedAction({
//     required this.handleColorSelect,
//     required this.colorSelected,
//     required this.colorSelectionMethod,
//   });

//   final void Function(int) handleColorSelect;
//   final ColorSeed colorSelected;
//   final ColorSelectionMethod colorSelectionMethod;

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(maxHeight: 200.0),
//       child: GridView.count(
//         crossAxisCount: 3,
//         children: List.generate(
//           ColorSeed.values.length,
//           (i) => IconButton(
//             icon: const Icon(Icons.radio_button_unchecked),
//             color: ColorSeed.values[i].color,
//             isSelected: colorSelected.color == ColorSeed.values[i].color &&
//                 colorSelectionMethod == ColorSelectionMethod.colorSeed,
//             selectedIcon: const Icon(Icons.circle),
//             onPressed: () => handleColorSelect(i),
//             tooltip: ColorSeed.values[i].label,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _ExpandedImageColorAction extends StatelessWidget {
//   const _ExpandedImageColorAction({
//     required this.handleImageSelect,
//     required this.imageSelected,
//     required this.colorSelectionMethod,
//   });

//   final void Function(int) handleImageSelect;
//   final ColorImageProvider imageSelected;
//   final ColorSelectionMethod colorSelectionMethod;

//   @override
//   Widget build(BuildContext context) {
//     return ConstrainedBox(
//       constraints: const BoxConstraints(maxHeight: 150.0),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: GridView.count(
//           crossAxisCount: 3,
//           children: List.generate(
//             ColorImageProvider.values.length,
//             (i) => Tooltip(
//               message: ColorImageProvider.values[i].label,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(4.0),
//                 onTap: () => handleImageSelect(i),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Material(
//                     borderRadius: BorderRadius.circular(4.0),
//                     elevation: imageSelected == ColorImageProvider.values[i] &&
//                             colorSelectionMethod == ColorSelectionMethod.image
//                         ? 3
//                         : 0,
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(4.0),
//                         child: Image(
//                           image: NetworkImage(ColorImageProvider.values[i].url),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
