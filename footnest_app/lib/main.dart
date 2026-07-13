import 'package:flutter/material.dart';
import 'package:footnest_app/config/app_theme.dart';
import 'services/service_locator.dart';
import 'routes/app_router.dart';

void main() {
  setupLocator();
  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {

  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Footnest 2.0',
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}