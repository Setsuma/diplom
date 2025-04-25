import 'package:flutter/material.dart';
import '../../domain/models/user_profile.dart';

class UserProfileWidget extends StatelessWidget {
  final UserProfile user;
  final VoidCallback? onEditPressed;

  const UserProfileWidget({
    super.key,
    required this.user,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: user.avatarUrl != null
                      ? NetworkImage(user.avatarUrl!)
                      : null,
                  child: user.avatarUrl == null
                      ? Text(
                          user.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(fontSize: 24),
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                if (onEditPressed != null)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: onEditPressed,
                    tooltip: 'Редактировать профиль',
                  ),
              ],
            ),
            if (user.department != null || user.position != null) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              if (user.department != null)
                Text(
                  'Отдел: ${user.department}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              if (user.position != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Должность: ${user.position}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
