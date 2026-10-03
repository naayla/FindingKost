import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_state.dart';
import 'category_screen.dart';
import 'favorites_screen.dart';
import 'form_item_screen.dart';
import 'home_screen.dart';
import 'map_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isOwner = context.select<AppState, bool>((s) => s.isOwner);

    // Define navigation items based on User Role with explicit keys
    final List<Widget> screens = isOwner
        ? const [
            HomeScreen(key: ValueKey('owner-home')),
            FormItemScreen(key: ValueKey('owner-form')),
            MapScreen(key: ValueKey('owner-map')),
            CategoryScreen(key: ValueKey('owner-category')),
            ProfileScreen(key: ValueKey('owner-profile')),
          ]
        : const [
            HomeScreen(key: ValueKey('seeker-home')),
            MapScreen(key: ValueKey('seeker-map')),
            FavoritesScreen(key: ValueKey('seeker-favorites')),
            ProfileScreen(key: ValueKey('seeker-profile')),
          ];

    final List<NavigationDestination> destinations = isOwner
        ? const [
            NavigationDestination(
              key: ValueKey('nav-owner-katalog'),
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard_rounded),
              label: 'Katalog Saya',
            ),
            NavigationDestination(
              key: ValueKey('nav-owner-tambah'),
              icon: Icon(Icons.add_circle_outline_rounded),
              selectedIcon: Icon(Icons.add_circle_rounded),
              label: 'Tambah Kos',
            ),
            NavigationDestination(
              key: ValueKey('nav-owner-peta'),
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map_rounded),
              label: 'Peta Sebaran',
            ),
            NavigationDestination(
              key: ValueKey('nav-owner-kategori'),
              icon: Icon(Icons.category_outlined),
              selectedIcon: Icon(Icons.category_rounded),
              label: 'Kategori',
            ),
            NavigationDestination(
              key: ValueKey('nav-owner-profil'),
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil Saya',
            ),
          ]
        : const [
            NavigationDestination(
              key: ValueKey('nav-seeker-home'),
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Beranda',
            ),
            NavigationDestination(
              key: ValueKey('nav-seeker-peta'),
              icon: Icon(Icons.map_outlined),
              selectedIcon: Icon(Icons.map_rounded),
              label: 'Peta Kos',
            ),
            NavigationDestination(
              key: ValueKey('nav-seeker-favorit'),
              icon: Icon(Icons.bookmark_outline_rounded),
              selectedIcon: Icon(Icons.bookmark_rounded),
              label: 'Tersimpan',
            ),
            NavigationDestination(
              key: ValueKey('nav-seeker-profil'),
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ];

    final safeIndex = _currentIndex < screens.length ? _currentIndex : 0;

    return Scaffold(
      body: IndexedStack(
        key: ValueKey('main-navigation-stack-$isOwner'),
        index: safeIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: destinations,
      ),
    );
  }
}
