import 'messages.g.dart';

class AMapServices {
  AMapServices._();

  static final AMapServicesApi _api = AMapServicesApi();

  static Future<void> setAppKey(String appKey) async {
    return _api.setAppKey(appKey);
  }
}
