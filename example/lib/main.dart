import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler_package/permission_handler_package.dart';
import 'auth_theme.dart';
import 'home_page.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the permission handler package
  await PermissionHandler.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Permission Handler Demo',
          theme: authTheme(),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        );
      },
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializePermissions();
  }

  Future<void> _initializePermissions() async {
    final actionNotifier = ref.read(
      permissionActionProvider.notifier,
    );

    final granted = await actionNotifier
        .initializeRequiredPermissions(
          context: context,
          requiredPermissions: [
            PermissionType.camera,
            PermissionType.storage,
            PermissionType.location,
          ],
          title: 'Welcome to the App',
          message:
              'To provide you with the best experience, we need these permissions:',
        );

    if (granted && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 3.w,
              valueColor: AlwaysStoppedAnimation<Color>(
                AuthColors.yellow,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'Initializing...',
              style: AuthTextStyles.bodyM,
            ),
          ],
        ),
      ),
    );
  }
}
