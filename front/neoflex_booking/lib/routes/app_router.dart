import 'package:neoflex_booking/presentation/auth/auth_screen.dart';
import 'package:neoflex_booking/presentation/home/home_screen.dart';
import 'package:neoflex_booking/presentation/home/map_screen.dart';
import 'package:neoflex_booking/presentation/home/profile_screen.dart';
import 'package:neoflex_booking/presentation/scaffold_with_nav_bar.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => AuthScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/map',
          builder: (context, state) => MapScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
  ],
);
