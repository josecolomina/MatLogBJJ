import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/subscription_repository.dart';
import '../domain/subscription_tier.dart';
import 'paywall_screen.dart';

class FeatureLockedWidget extends ConsumerWidget {
  final Widget child;
  final SubscriptionTier requiredTier;
  final String featureName;

  const FeatureLockedWidget({
    super.key,
    required this.child,
    this.requiredTier = SubscriptionTier.premium,
    required this.featureName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync = ref.watch(userSubscriptionProvider);

    return subscriptionAsync.when(
      data: (currentTier) {
        final hasAccess = currentTier.index >= requiredTier.index;

        if (hasAccess) {
          return child;
        }

        return Stack(
          children: [
            // Blurred content
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: AbsorbPointer(child: child),
            ),
            // Lock Overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.lock_outline, color: Colors.white, size: 48),
                      const SizedBox(height: 16),
                      Text(
                        '$featureName is a Premium Feature',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const PaywallScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Upgrade to Unlock'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => child, // Fallback to showing content on error
    );
  }
}
