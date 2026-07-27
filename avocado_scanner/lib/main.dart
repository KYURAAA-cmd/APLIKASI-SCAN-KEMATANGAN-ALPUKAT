import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'data/database/service_locator.dart' as di;
import 'presentation/providers/app_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi service locator (database, repository, services)
  await di.initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Avocado Scanner',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.green,
            primary: Colors.green.shade700,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
          ),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.HOME,
        onGenerateRoute: AppPages.generateRoute,
      ),
    );
}
