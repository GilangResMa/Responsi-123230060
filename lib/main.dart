import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/bindings/app_binding.dart';
import 'app/routes/app_pages.dart';
import 'controllers/auth_controller.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.initHive();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Harry Potter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialBinding: AppBinding(),
      home: _getInitialPage(),
      getPages: AppPages.pages,
      initialRoute: _getInitialRoute(),
    );
  }

  String _getInitialRoute() {
    // This will be determined by checking login status
    return Routes.login;
  }

  Widget _getInitialPage() {
    return FutureBuilder(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const Placeholder(); // Will be replaced by GetX routing
        }

        return const Placeholder(); // Will be replaced by GetX routing
      },
    );
  }

  Future<bool> _checkLoginStatus() async {
    // Give GetX time to initialize
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final authController = Get.find<AuthController>();
      await authController.checkLoginStatus();

      if (authController.isLoggedIn.value) {
        Get.offAllNamed(Routes.home);
        return true;
      } else {
        Get.offAllNamed(Routes.login);
        return false;
      }
    } catch (e) {
      Get.offAllNamed(Routes.login);
      return false;
    }
  }
}
