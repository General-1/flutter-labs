import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Starea Loading: un indicator în mijlocul ecranului și o explicație, fiindcă
/// serverul gratuit poate răspunde greu la prima cerere.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.primary),
          SizedBox(height: 16),
          Text(
            'Loading… the server may need a minute to wake up',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textGrey),
          ),
        ],
      ),
    );
  }
}

/// Mesaj cu iconiță și buton opțional — folosit pentru Empty și Error.
class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textGrey),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
