import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mdiho/features/profile/data/Model/response/platform_details/data.dart';

class VersionHelper {
  /// Compares version strings (e.g., "1.2.3" vs "1.2.4")
  /// Returns: -1 if current < required, 0 if equal, 1 if current > required
  static int compareVersions(String current, String required) {
    final currentParts =
        current.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final requiredParts =
        required.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Pad with zeros to make lengths equal
    final maxLength = currentParts.length > requiredParts.length
        ? currentParts.length
        : requiredParts.length;

    while (currentParts.length < maxLength) {
      currentParts.add(0);
    }
    while (requiredParts.length < maxLength) {
      requiredParts.add(0);
    }

    for (int i = 0; i < maxLength; i++) {
      if (currentParts[i] < requiredParts[i]) return -1;
      if (currentParts[i] > requiredParts[i]) return 1;
    }

    return 0;
  }

  /// Checks if an update is required
  /// Returns true if current version is less than required version
  static Future<bool> isUpdateRequired({
    required PlatformDetails platformData,
    required String currentVersion,
  }) async {
    try {
      String? requiredVersion;
      if (Platform.isIOS) {
        requiredVersion = platformData.iosVersion;
      } else if (Platform.isAndroid) {
        requiredVersion = platformData.androidVersion;
      }

      if (requiredVersion == null || requiredVersion.isEmpty) {
        return false; // No version requirement specified
      }

      final comparison = compareVersions(currentVersion, requiredVersion);
      return comparison < 0; // Current version is less than required
    } catch (e) {
      debugPrint('Error checking version: $e');
      return false;
    }
  }

  /// Checks if update should be forced (non-dismissible)
  static bool isForceUpdate(PlatformDetails platformData) {
    return platformData.forceVersion == true;
  }
}
