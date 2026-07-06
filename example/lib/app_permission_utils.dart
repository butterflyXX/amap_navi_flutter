import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionRequestFailure {
  const AppPermissionRequestFailure({required this.permission, required this.status});

  final Permission permission;
  final PermissionStatus status;
}

class AppPermissionUtils {
  static Future<PermissionStatus> ensurePermission(Permission permission) async {
    var status = await permission.status;
    if (status.isGranted || status.isLimited) {
      return status;
    }
    if (status.isRestricted) {
      debugPrint('permanently denied or restricted: $permission');
      return status;
    }
    if (status.isPermanentlyDenied && permission != Permission.locationAlways) {
      debugPrint('permanently denied or restricted: $permission');
      return status;
    }
    status = await permission.request();
    return status;
  }

  /// 按传入顺序逐个检查并申请权限。
  ///
  /// 任一权限未通过时立即返回对应权限和状态；全部通过时返回 null。
  static Future<AppPermissionRequestFailure?> ensurePermissionsInOrder(List<Permission> permissions) async {
    for (final Permission permission in permissions) {
      final PermissionStatus status = await ensurePermission(permission);
      if (!isGrantedLike(status)) {
        return AppPermissionRequestFailure(permission: permission, status: status);
      }
    }
    return null;
  }

  static bool isGrantedLike(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }

  static bool shouldOpenSettings(PermissionStatus status) {
    return status.isPermanentlyDenied || status.isRestricted;
  }
}
