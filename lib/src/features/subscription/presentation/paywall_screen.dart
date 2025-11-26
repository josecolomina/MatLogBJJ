import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/subscription_repository.dart';
import '../domain/subscription_tier.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  Offerings? _offerings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOfferings();
  }

  Future<void> _fetchOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) {
        setState(() {
          _offerings = offerings;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching offerings: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _restorePurchases() async {
    try {
      setState(() => _isLoading = true);
      await Purchases.restorePurchases();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Purchases restored successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error restoring purchases: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _purchasePackage(Package package) async {
    try {
      setState(() => _isLoading = true);
      await Purchases.purchasePackage(package);
      if (mounted) {
        context.pop(); // Close paywall on success
      }
    } catch (e) {
      if (mounted) {
        // Don't show error if user cancelled
        if (e is PlatformException && e.code == 'PurchasesErrorOverlayCancelled') {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTierAsync = ref.watch(userSubscriptionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Plan'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentTierAsync.when(
              data: (currentTier) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const Text(
                    'Unlock Full Potential',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Fallback UI if no offerings (for development/testing without keys)
                  if (_offerings?.current == null) ...[
                     const Center(
                       child: Text(
                         'No offerings configured.\n(This is expected if API Keys are missing)',
                         textAlign: TextAlign.center,
                         style: TextStyle(color: Colors.red),
                       ),
                     ),
                     const SizedBox(height: 16),
                     // Show dummy cards for UI verification
                     _PlanCard(
                        title: 'Ad-Free (Demo)',
                        price: '2.99€',
                        features: const ['No Ads'],
                        isCurrent: currentTier == SubscriptionTier.adFree,
                        onTap: () {}, // No-op in demo
                     ),
                  ] else ...[
                    // Real Offerings
                    if (_offerings!.current!.monthly != null)
                      _PlanCard(
                        title: 'Premium Monthly',
                        price: _offerings!.current!.monthly!.storeProduct.priceString,
                        features: const ['No Ads', 'Advanced Stats', 'AI Analysis'],
                        isCurrent: currentTier == SubscriptionTier.premium,
                        onTap: () => _purchasePackage(_offerings!.current!.monthly!),
                      ),
                     const SizedBox(height: 12),
                     if (_offerings!.current!.annual != null)
                      _PlanCard(
                        title: 'Premium Annual',
                        price: _offerings!.current!.annual!.storeProduct.priceString,
                        features: const ['All Monthly features', 'Best Value'],
                        isCurrent: currentTier == SubscriptionTier.premium,
                        isPopular: true,
                        onTap: () => _purchasePackage(_offerings!.current!.annual!),
                      ),
                  ],

                  const SizedBox(height: 32),
                  const Divider(),
                  
                  // Legal Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _restorePurchases,
                          child: const Text('Restore Purchases'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () => _launchUrl('https://matlog-app.web.app/privacy'),
                              child: const Text('Privacy Policy', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ),
                            const Text('•', style: TextStyle(color: Colors.grey)),
                            TextButton(
                              onPressed: () => _launchUrl('https://matlog-app.web.app/terms'),
                              child: const Text('Terms of Service', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Your account will be charged for renewal within 24-hours prior to the end of the current period.',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isCurrent;
  final bool isPopular;
  final Color? color;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.features,
    required this.isCurrent,
    required this.onTap,
    this.isPopular = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? (isCurrent ? Colors.grey.shade100 : Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCurrent
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: isCurrent ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (isPopular)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'POPULAR',
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              ...features.map((f) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(f),
                      ],
                    ),
                  )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isCurrent ? null : onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCurrent ? Colors.grey : Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isCurrent ? 'Current Plan' : 'Subscribe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
