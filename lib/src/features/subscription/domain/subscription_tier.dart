enum SubscriptionTier {
  free,
  adFree,
  premium;

  String get displayName {
    switch (this) {
      case SubscriptionTier.free:
        return 'Free';
      case SubscriptionTier.adFree:
        return 'Ad-Free';
      case SubscriptionTier.premium:
        return 'Premium';
    }
  }

  bool get hasAds => this == SubscriptionTier.free;
  bool get isPremium => this == SubscriptionTier.premium;
}
