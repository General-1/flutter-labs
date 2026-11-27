import 'package:flutter/material.dart';

import '../models/home_feed.dart';
import '../theme/app_colors.dart';
import 'network_avatar.dart';

/// Avatar + salut + clopoțel (cu punct roșu dacă există notificări necitite).
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.user,
    required this.hasUnread,
    required this.onBellTap,
  });

  final UserProfile user;
  final bool hasUnread;
  final VoidCallback onBellTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NetworkAvatar(
          imageUrl: user.avatarUrl,
          initials: user.name.isEmpty ? '' : user.name[0],
          size: 44,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.greeting,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              Text(
                user.subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: onBellTap,
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none, color: AppColors.textDark),
              if (hasUnread)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
