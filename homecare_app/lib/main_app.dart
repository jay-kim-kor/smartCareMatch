import 'package:flutter/material.dart';
import 'design_system/radix_design_system.dart';
import 'screens/home_screen.dart';
import 'screens/schedule_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ScheduleScreen(),
  ];

  final List<RadixNavigationItem> _navigationItems = [
    const RadixNavigationItem(
      icon: Icons.home_outlined,
      label: '홈',
    ),
    const RadixNavigationItem(
      icon: Icons.schedule_outlined,
      label: '일정',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: RadixNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navigationItems,
        centerButton: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: RadixTokens.indigo9,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: () {
                Navigator.pushNamed(context, '/service-request');
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ),
      ),
    );
  }
}