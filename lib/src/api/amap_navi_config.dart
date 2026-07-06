import 'messages.g.dart';

class AMapNaviConfig {
  AMapNaviConfig._();

  static final AMapNaviConfigApi _api = AMapNaviConfigApi();

  static Future<bool> areTermsAccepted() async {
    return _api.areTermsAccepted();
  }

  static Future<void> setTermsAccepted(bool accepted) async {
    return _api.setTermsAccepted(accepted);
  }

  static Future<void> updatePrivacyShow(bool hasShow, bool hasContains) async {
    return _api.updatePrivacyShow(hasShow, hasContains);
  }

  static Future<void> updatePrivacyAgree(bool hasAgree) async {
    return _api.updatePrivacyAgree(hasAgree);
  }

  static Future<void> setSpeechRate(double speechRate) async {
    return _api.setSpeechRate(speechRate);
  }
}
