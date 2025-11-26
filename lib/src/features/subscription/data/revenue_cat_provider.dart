import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  Future<void> init() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration('test_UDprULdzhhqMJHcNbGtQVjCkjmr');
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration('test_UDprULdzhhqMJHcNbGtQVjCkjmr');
    }

    if (configuration != null) {
      await Purchases.configure(configuration);
    }
  }

  Stream<CustomerInfo> get customerInfoStream {
    return Stream.fromFuture(Purchases.getCustomerInfo()).asyncExpand((initialInfo) {
      return Stream.multi((controller) {
        controller.add(initialInfo);
        Purchases.addCustomerInfoUpdateListener((info) {
          controller.add(info);
        });
      });
    });
  }

  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();
}

final revenueCatServiceProvider = Provider<RevenueCatService>((ref) {
  return RevenueCatService();
});

final customerInfoProvider = StreamProvider<CustomerInfo>((ref) {
  final service = ref.watch(revenueCatServiceProvider);
  return service.customerInfoStream;
});
