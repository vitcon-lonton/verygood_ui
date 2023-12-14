// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../models/data.dart' as data;
import '../models/models.dart';
import 'email_widget.dart';
import 'search_bar.dart' as search_bar;

class EmailListView extends StatelessWidget {
  const EmailListView({
    super.key,
    this.selectedIndex,
    this.onSelected,
    this.top,
    required this.currentUser,
  });

  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  final User currentUser;
  final Widget? top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        children: [
          // const SizedBox(height: 8),
          // search_bar.SearchBar(currentUser: currentUser),
          // const SizedBox(height: 8),
          if (top != null) ...[
            const SizedBox(height: 8),
            top!,
          ],
          const SizedBox(height: 8),
          ...List.generate(
            data.emails.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: EmailWidget(
                  email: data.emails[index],
                  onSelected: onSelected != null
                      ? () {
                          onSelected!(index);
                        }
                      : null,
                  isSelected: selectedIndex == index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SliverEmailListView extends StatelessWidget {
  const SliverEmailListView({
    super.key,
    this.selectedIndex,
    this.onSelected,
    this.top,
  });

  final int? selectedIndex;
  final ValueChanged<int>? onSelected;
  final Widget? top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0).copyWith(top: 12),
      child: CustomScrollView(
        slivers: [
          // const SizedBox(height: 8),
          // search_bar.SearchBar(currentUser: currentUser),
          // const SizedBox(height: 8),
          // if (top != null) ...[
          //   const SliverToBoxAdapter(child: SizedBox(height: 12)),
          //   top!,
          // ],
          // const SliverFillRemaining(child: SizedBox(height: 12)),
          // const SliverToBoxAdapter(child: SizedBox(height: 12)),

          if (top != null) ...[
            SliverAppBar.medium(
              // backgroundColor: Colors.amberAccent,
              // title: TextFormField(),
              expandedHeight: 0,
              toolbarHeight: 0,
              pinned: true,
              collapsedHeight: 68,
              // elevation: 2,
              scrolledUnderElevation: 0,
              floating: true,
              // collapsedHeight: 200,
              flexibleSpace: PreferredSize(
                preferredSize: const Size.fromHeight(68),
                child: Container(child: top),
              ),
              // title: TextField(),
              // bottom:   TextFormField(),
            ),
          ],

          // SliverAppBar.medium(
          //   // backgroundColor: Colors.amberAccent,
          //   // title: TextFormField(),
          //   expandedHeight: 0,
          //   toolbarHeight: 0,
          //   pinned: true,
          //   collapsedHeight: 64,
          //   elevation: 2,
          //   scrolledUnderElevation: 0,
          //   floating: true,
          //   // collapsedHeight: 200,
          //   flexibleSpace: PreferredSize(
          //     preferredSize: Size.fromHeight(64),
          //     child: Container(
          //       color: Colors.amberAccent,
          //       child: TextField(
          //         decoration: InputDecoration(
          //           border: OutlineInputBorder(gapPadding: 0),
          //         ),
          //       ),
          //     ),
          //   ),
          //   // title: TextField(),
          //   // bottom:   TextFormField(),
          // ),

          // const SliverToBoxAdapter(child: SizedBox(height: 8)),

          SliverList.separated(
            itemCount: data.emails.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4.0),
            itemBuilder: (context, index) {
              return EmailWidget(
                email: data.emails[index],
                onSelected:
                    onSelected != null ? () => onSelected!(index) : null,
                isSelected: selectedIndex == index,
              );
            },
          ),

          // SliverList.separated(
          //   itemCount: data.emails.length,
          //   separatorBuilder: (_, __) => const SizedBox(height: 8.0),
          //   itemBuilder: (context, index) {
          //     return Padding(
          //       padding: const EdgeInsets.only(bottom: 8.0),
          //       child: EmailWidget(
          //         email: data.emails[index],
          //         onSelected:
          //             onSelected != null ? () => onSelected!(index) : null,
          //         isSelected: selectedIndex == index,
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomScrollView(
        slivers: [
          // const SizedBox(height: 8),
          // search_bar.SearchBar(currentUser: currentUser),
          // const SizedBox(height: 8),
          if (top != null) ...[
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            top!,
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          SliverList.separated(
            itemCount: data.emails.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: EmailWidget(
                  email: data.emails[index],
                  onSelected:
                      onSelected != null ? () => onSelected!(index) : null,
                  isSelected: selectedIndex == index,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
