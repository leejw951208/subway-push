import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_colors.dart';

class SubwayPushApp extends StatelessWidget {
  const SubwayPushApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Subway Push',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: appBlue),
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
