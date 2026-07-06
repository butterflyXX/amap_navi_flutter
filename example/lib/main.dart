import 'package:amap_navi_flutter_example/app_permission_utils.dart';
import 'package:amap_navi_flutter_example/calculate_route_page.dart';
import 'package:amap_navi_flutter_example/keys.dart';
import 'package:amap_navi_flutter_example/no_ui_navi.dart';
import 'package:flutter/material.dart';
import 'package:amap_navi_flutter/amap_navi_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AMapServices.setAppKey(amapKey);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('高德导航flutter demo')),
      body: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildItem(NoUINavi()),
          _buildItem(
            TextButton(
              onPressed: () async {
                final result = await checkAndAcceptPrivacy();
                if (!result || !context.mounted) return;
                Navigator.push(context, MaterialPageRoute(builder: (context) => const CalculateRoutePage()));
              },
              child: const Text('有UI导航测试'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: Theme.of(context).secondaryHeaderColor, borderRadius: BorderRadius.circular(10)),
      child: child,
    );
  }

  Future<bool> checkAndAcceptPrivacy() async {
    var areTermsAccepted = await AMapNaviConfig.areTermsAccepted();
    if (!areTermsAccepted) {
      AMapNaviConfig.updatePrivacyShow(true, true);
      areTermsAccepted = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('隐私政策'),
          content: const Text('在使用此应用之前，请您仔细阅读并同意《隐私政策》。'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('同意')),
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('不同意')),
          ],
        ),
      );
    }

    if (!areTermsAccepted) return false;
    AMapNaviConfig.updatePrivacyAgree(true);
    AMapNaviConfig.setTermsAccepted(true);

    final permissionFailure = await AppPermissionUtils.ensurePermissionsInOrder([
      Permission.locationWhenInUse,
      Permission.locationAlways,
    ]);

    if (permissionFailure != null) return false;
    return true;
  }
}
