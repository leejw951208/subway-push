import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

class SubwayPushApp extends StatelessWidget {
  const SubwayPushApp({this.useOwnProviderScope = true, super.key});

  final bool useOwnProviderScope;

  @override
  Widget build(BuildContext context) {
    final app = MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Subway Push',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: appBlue),
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );

    if (!useOwnProviderScope) {
      return app;
    }

    return ProviderScope(child: app);
  }
}
