import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/subscription_repository.dart';

class AdBannerWidget extends ConsumerWidget {
  const AdBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionAsync = ref.watch(userSubscriptionProvider);

    return subscriptionAsync.when(
      data: (tier) {
        if (!tier.hasAds) {
          return const SizedBox.shrink(); // No ads for paid users
        }

        return Container(
          width: double.infinity,
          height: 60,
          color: Colors.grey[200],
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ad Banner Placeholder',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Text(
                'Upgrade to remove ads',
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
