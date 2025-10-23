import '../notifiers/wallet_notifier.dart';
import 'storage_service.dart';

final StorageService storageService = StorageService();
final WalletNotifier walletNotifier = WalletNotifier(storageService);

Future<void> setupServices() async {
  await walletNotifier.refresh();
}
