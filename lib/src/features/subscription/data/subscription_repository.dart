import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../domain/subscription_tier.dart';
import 'revenue_cat_provider.dart';

class SubscriptionRepository {
  final RevenueCatService _revenueCatService;

  SubscriptionRepository(this._revenueCatService);

  Stream<SubscriptionTier> watchUserSubscription() {
    return _revenueCatService.customerInfoStream.map((customerInfo) {
      if (customerInfo.entitlements.active.containsKey('premium')) {
        return SubscriptionTier.premium;
      } else if (customerInfo.entitlements.active.containsKey('ad_free')) {
        return SubscriptionTier.adFree;
      }
      return SubscriptionTier.free;
    });
  }
}

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.watch(revenueCatServiceProvider));
});

final userSubscriptionProvider = StreamProvider<SubscriptionTier>((ref) {
  return ref.watch(subscriptionRepositoryProvider).watchUserSubscription();
});
