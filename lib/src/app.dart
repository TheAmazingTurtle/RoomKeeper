import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'features/food/food_screen.dart';
import 'features/home/home_screen.dart';
import 'features/inventory/inventory_screen.dart';
import 'features/room/room_screen.dart';
import 'features/tasks/tasks_screen.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return RoomKeeperShell(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/inventory',
            builder: (context, state) => const InventoryScreen(),
          ),
          GoRoute(
            path: '/food',
            builder: (context, state) => const FoodScreen(),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksScreen(),
          ),
          GoRoute(
            path: '/room',
            builder: (context, state) => const RoomScreen(),
          ),
        ],
      ),
    ],
  );
});

class RoomKeeperApp extends ConsumerWidget {
  const RoomKeeperApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final startup = ref.watch(appStartupProvider);
    final theme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF0F766E),
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8F5),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFFF7F8F5),
        foregroundColor: Color(0xFF17201D),
        titleTextStyle: TextStyle(
          color: Color(0xFF17201D),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 72,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      cardTheme: CardThemeData(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: Color(0xFFE3E7E1)),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        elevation: 2,
        extendedPadding: EdgeInsets.symmetric(horizontal: 18),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD7DED8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0F766E), width: 1.6),
        ),
      ),
      chipTheme: const ChipThemeData(
        shape: StadiumBorder(),
        side: BorderSide(color: Color(0xFFE3E7E1)),
      ),
    );

    return startup.when(
      loading: () => MaterialApp(
        title: 'RoomKeeper',
        theme: theme,
        home: const _StartupScaffold(message: 'Preparing your room log...'),
      ),
      error: (error, stackTrace) => MaterialApp(
        title: 'RoomKeeper',
        theme: theme,
        home: _StartupScaffold(
          message: 'RoomKeeper could not open your local data. $error',
        ),
      ),
      data: (_) => MaterialApp.router(
        title: 'RoomKeeper',
        debugShowCheckedModeBanner: false,
        theme: theme,
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}

class RoomKeeperShell extends StatelessWidget {
  const RoomKeeperShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex(location),
        onDestinationSelected: (index) => context.go(_pathForIndex(index)),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen),
            label: 'Food',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view),
            label: 'Layout',
          ),
        ],
      ),
    );
  }

  int _selectedIndex(String location) {
    if (location.startsWith('/inventory')) return 1;
    if (location.startsWith('/food')) return 2;
    if (location.startsWith('/tasks')) return 3;
    if (location.startsWith('/room')) return 4;
    return 0;
  }

  String _pathForIndex(int index) {
    return switch (index) {
      1 => '/inventory',
      2 => '/food',
      3 => '/tasks',
      4 => '/room',
      _ => '/',
    };
  }
}

class _StartupScaffold extends StatelessWidget {
  const _StartupScaffold({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 18),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
