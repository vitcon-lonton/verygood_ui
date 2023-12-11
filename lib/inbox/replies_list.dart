// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'avatar_button.dart';
import 'component_group_decoration.dart';
import 'models/data.dart';
import 'models/models.dart';
import 'star_button.dart';

class ReplyList extends StatelessWidget {
  const ReplyList({super.key});

  @override
  Widget build(BuildContext context) {
    return ComponentGroupDecoration(
      child: FocusTraversalGroup(
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          runSpacing: 8.0,
          children: replies.map((e) => ReplyCard(e)).toList(),
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final Email value;

  const ReplyCard(this.value, {super.key});

  @override
  Widget build(BuildContext context) {
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
                contentPadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                tileColor: Theme.of(context).colorScheme.secondaryContainer,
                isThreeLine: true,
                title: Text(value.sender.name.fullName),
                subtitle: Text('${value.replies} message'),
                trailing: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [StarButton(), SizedBox(width: 4.0), StarButton()],
                ),
              ),
              ListTileTheme(
                contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      minLeadingWidth: 0,
                      leading: AvatarButton(
                        child: Image.asset(value.recipients.first.avatarUrl),
                      ),
                      trailing: const StarButton(),
                      title: Text(value.recipients.first.name.fullName),
                      subtitle: Text(value.sender.lastActiveLabel),
                    ),
                    ListTile(
                      isThreeLine: true,
                      title: Text(value.subject),
                      subtitle: Text(value.content),
                    ),
                    const Row(
                      children: [
                        SizedBox(width: 12.0),
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: null,
                            child: Text('Reply'),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: FilledButton.tonal(
                            onPressed: null,
                            child: Text('Reply All'),
                          ),
                        ),
                        SizedBox(width: 12.0),
                      ],
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
}
