import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/di/injection_container.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDependencies();

  runApp(const MedicineApp());
}

class MedicineApp extends StatelessWidget {
  const MedicineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => sl<AuthProvider>()..checkAuthStatus(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: appRoutes,
        theme: ThemeData(
          fontFamily: 'Inter',
        ),
      ),
    );
  }
}
