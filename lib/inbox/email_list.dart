// Copyright 2021 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'avatar_button.dart';
import 'models/data.dart';
import 'models/models.dart';
import 'star_button.dart';

class EmailList extends StatefulWidget {
  const EmailList({super.key});

  @override
  State<EmailList> createState() => _EmailListState();
}

class _EmailListState extends State<EmailList> {
  Email _selected = emails.first;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8.0,
      alignment: WrapAlignment.spaceEvenly,
      children: emails.map((e) {
        return e == _selected
            ? _FilledCard(e)
            : _ElevatedCard(e, onPressed: () => setState(() => _selected = e));
      }).toList(),
    );
  }
}

class _FilledCard extends StatelessWidget {
  const _FilledCard(this.value);

  final Email value;

  @override
  Widget build(BuildContext context) {
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
              leading: AvatarButton(child: Image.asset(value.sender.avatarUrl)),
              trailing: const StarButton(),
              title: Text(value.sender.name.fullName),
              subtitle: Text(value.sender.lastActiveLabel),
            ),
            // const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              isThreeLine: true,
              title: Text(value.subject),
              subtitle: Text(value.content),
            ),
          ],
        ),
      ),
    );
  }
}

class _ElevatedCard extends StatelessWidget {
  const _ElevatedCard(this.value, {this.onPressed});

  final Email value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: onPressed,
      child: Container(
        // padding: const EdgeInsets.fromLTRB(10, 5, 5, 10),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              leading: AvatarButton(child: Image.asset(value.sender.avatarUrl)),
              trailing: const StarButton(),
              title: Text(value.sender.name.fullName),
              subtitle: Text(value.sender.lastActiveLabel),
            ),
            // const SizedBox(height: 20),
            ListTile(
              contentPadding: EdgeInsets.zero,
              isThreeLine: true,
              title: Text(value.subject),
              subtitle: Text(value.content),
            ),
          ],
        ),
      ),
    );
  }
}
