import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    ),
  );
}

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: ScaffoldWithNavBar(
            location: state.matchedLocation,
            child: child,
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) {
            return NoTransitionPage(
              child: Scaffold(
                body: Center(
                  child: GestureDetector(
                    onTap: () {
                      context.push('/login');
                    },
                    child: Text("Home"),
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: '/discover',
          parentNavigatorKey: _shellNavigatorKey,
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: Scaffold(
                body: Center(child: Text("Discover")),
              ),
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/shop',
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: Scaffold(
                body: Center(child: Text("Shop")),
              ),
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _shellNavigatorKey,
          path: '/blah',
          pageBuilder: (context, state) {
            return const NoTransitionPage(
              child: Scaffold(
                body: Center(child: Text("blah")),
              ),
            );
          },
        ),
      ],
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/login',
      pageBuilder: (context, state) {
        return NoTransitionPage(
          key: UniqueKey(),
          child: Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text("Login"),
            ),
          ),
        );
      },
    ),
  ],
);

class ScaffoldWithNavBar extends StatefulWidget {
  String location;

  ScaffoldWithNavBar({super.key, required this.child, required this.location});

  final Widget child;

  @override
  State<ScaffoldWithNavBar> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _currentIndex = 0;

  static const List<MyCustomBottomNavBarItem> tabs = [
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.home),
      activeIcon: Icon(Icons.home),
      label: 'HOME',
      initialLocation: '/',
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.explore_outlined),
      activeIcon: Icon(Icons.explore),
      label: 'DISCOVER',
      initialLocation: '/discover',
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.storefront_outlined),
      activeIcon: Icon(Icons.storefront),
      label: 'SHOP',
      initialLocation: '/shop',
    ),
    MyCustomBottomNavBarItem(
      icon: Icon(Icons.account_circle_outlined),
      activeIcon: Icon(Icons.account_circle),
      label: 'MY',
      initialLocation: '/blah',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(fontFamily: 'Roboto');
    return Scaffold(
      body: SafeArea(child: widget.child),
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: labelStyle,
        unselectedLabelStyle: labelStyle,
        selectedItemColor: const Color(0xFF434343),
        selectedFontSize: 12,
        unselectedItemColor: const Color(0xFF838383),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          print(index);

          _goOtherTab(context, index);
        },
        currentIndex: widget.location == '/'
            ? 0
            : widget.location == '/discover'
                ? 1
                : widget.location == '/shop'
                    ? 2
                    : 3,
        items: tabs,
      ),
    );
  }

  void _goOtherTab(BuildContext context, int index) {
    if (index == _currentIndex) return;
    GoRouter router = GoRouter.of(context);
    String location = tabs[index].initialLocation;

    setState(() {
      _currentIndex = index;
    });
    router.go(location);

    // if (index == 3) {
    //   context.push('/login');
    // } else {
    //   router.go(location);
    // }
  }
}

class MyCustomBottomNavBarItem extends BottomNavigationBarItem {
  final String initialLocation;

  const MyCustomBottomNavBarItem(
      {required this.initialLocation,
      required Widget icon,
      String? label,
      Widget? activeIcon})
      : super(icon: icon, label: label, activeIcon: activeIcon ?? icon);
}
