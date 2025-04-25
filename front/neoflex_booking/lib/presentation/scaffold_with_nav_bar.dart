import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithNavBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  String _previousRoute = '/home';

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).location;
    final isProfileRoute = location.startsWith('/profile');

    // Сохраняем предыдущий маршрут только если это не профиль
    if (!isProfileRoute && location != _previousRoute) {
      _previousRoute = location;
    }

    return Scaffold(
      appBar: AppBar(
        title: _getTitle(location),
        leading: isProfileRoute
            ? BackButton(
                onPressed: () => context.go(_previousRoute),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => context.go('/profile'),
                  child: Hero(
                    tag: 'profile_avatar',
                    child: CircleAvatar(
                      backgroundColor: isProfileRoute
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade300,
                      child: Icon(
                        Icons.person,
                        color: isProfileRoute
                            ? Colors.white
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Карта',
          ),
        ],
        currentIndex: isProfileRoute
            ? _calculateSelectedIndex(_previousRoute)
            : _calculateSelectedIndex(location),
        onTap: (int idx) => _onItemTapped(idx, context),
        selectedItemColor:
            isProfileRoute ? Colors.grey : Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  Widget _getTitle(String location) {
    if (location.startsWith('/home')) {
      return const Text('Neoflex Booking');
    } else if (location.startsWith('/map')) {
      return const Text('Бронирование');
    } else if (location.startsWith('/profile')) {
      return const Text('Мой профиль');
    }
    return const SizedBox.shrink();
  }

  static int _calculateSelectedIndex(String location) {
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/map')) {
      return 1;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/map');
        break;
    }
  }
}
