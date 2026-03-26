import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/user_provider.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const TaskMasterApp(),
    ),
  );
}

class TaskMasterApp extends StatelessWidget {
  const TaskMasterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Task Master',
          theme: ThemeData(
            primaryColor: const Color(0xFF2E6562),
            scaffoldBackgroundColor: const Color(0xFFFAF8F5),
            brightness: Brightness.light,
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Color(0xFF2E6562)),
            ),
          ),
          darkTheme: ThemeData(
            primaryColor: const Color(0xFF2E6562),
            scaffoldBackgroundColor: const Color(0xFF0F172A), // Deeper Midnight Blue
            brightness: Brightness.dark,
            fontFamily: 'Roboto',
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const MainLayout(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
