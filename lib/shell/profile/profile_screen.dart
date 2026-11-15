import 'dart:async';

import 'package:dice_party/core/constants/app_info.dart';
import 'package:dice_party/platform/settings/settings_providers.dart';
import 'package:dice_party/platform/theme/app_colors.dart';
import 'package:dice_party/platform/theme/spacing.dart';
import 'package:dice_party/platform/ui/assets.dart';
import 'package:dice_party/platform/ui/avatar_image.dart';
import 'package:dice_party/platform/ui/page_frame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Edits the player's name and avatar.
class ProfileScreen extends ConsumerStatefulWidget {
  /// Creates the screen.
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late final TextEditingController _name;
  late int _avatar;

  @override
  void initState() {
    super.initState();
    final p = ref.read(profileControllerProvider);
    _name = TextEditingController(text: p.name);
    _avatar = p.avatar;
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    ref
        .read(profileControllerProvider.notifier)
        .save(name: _name.text, avatar: _avatar);
    unawaited(Navigator.of(context).maybePop());
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return PageFrame(
      title: 'Profile',
      bottom: FilledButton(
        onPressed: _name.text.trim().isEmpty ? null : _save,
        child: const Text('Save'),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: AvatarImage(_avatar, size: 112)),
          const SizedBox(height: Space.l),
          TextField(
            controller: _name,
            maxLength: AppInfo.maxNameLength,
            inputFormatters: [
              LengthLimitingTextInputFormatter(AppInfo.maxNameLength),
            ],
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Your name',
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _save(),
          ),
          const SectionTitle('Avatar'),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: Space.m,
            crossAxisSpacing: Space.m,
            children: [
              for (var i = 0; i < AppInfo.avatarCount; i++)
                Semantics(
                  button: true,
                  selected: i == _avatar,
                  label: '${SharedAssets.avatarLabel(i)} avatar',
                  excludeSemantics: true,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => setState(() => _avatar = i),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: i == _avatar ? c.primary : c.background,
                          width: 3,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: AvatarImage(i, size: 64),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
