import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

final logger = Logger();

final shorebirdUpdateServiceProvider = Provider<ShorebirdUpdateService>((ref) {
  return ShorebirdUpdateService();
});

class ShorebirdUpdateService {
  final ShorebirdUpdater _shorebirdUpdater = ShorebirdUpdater();

  /// Check if there's a patch update available
  Future<bool> checkForUpdate() async {
    try {
      final updateStatus = await _shorebirdUpdater.checkForUpdate();
      final isUpdateAvailable = updateStatus == UpdateStatus.outdated;
      logger.d(
          'Shorebird patch update status: $updateStatus, available: $isUpdateAvailable');
      return isUpdateAvailable;
    } catch (e) {
      logger.e('Error checking for Shorebird update: $e');
      return false;
    }
  }

  /// Download and install the patch update
  Future<bool> downloadUpdate({
    required Function() onProgress,
    Function(String)? onError,
  }) async {
    try {
      await _shorebirdUpdater.update();
      logger.d('Shorebird patch update downloaded successfully');
      return true;
    } catch (e) {
      final errorMessage = 'Failed to download update: ${e.toString()}';
      logger.e('Error downloading Shorebird update: $errorMessage');
      onError?.call(errorMessage);
      return false;
    }
  }

  /// Check if update is already downloaded
  Future<bool> isUpdateDownloaded() async {
    try {
      final updateStatus = await _shorebirdUpdater.checkForUpdate();
      return updateStatus == UpdateStatus.outdated;
    } catch (e) {
      logger.e('Error checking if update is downloaded: $e');
      return false;
    }
  }
}
