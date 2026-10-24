import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../theme/app_theme.dart';
import 'agenda_screen.dart';
import 'alerts_screen.dart';
import 'explore_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';

/// Shell principal: bottom navigation de 5 tabs con estado propio.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override
  State<HomeShell> createState() => HomeShellState();
}

class HomeShellState extends State<HomeShell> {
  int _tab = 0;

  // Mantener estado de cada tab al alternar.
  final List<Widget> _tabs = const [
    HomeScreen(),
    ExploreScreen(),
    AgendaScreen(),
    AlertsScreen(),
    ProfileScreen(),
  ];

  void irA(int tab) => setState(() => _tab = tab);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(index: _tab, children: _tabs),
      floatingActionButton: null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: .06),
              blurRadius: 14,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _tabItem(0, Icons.home_rounded, 'Inicio', cs),
                _tabItem(1, Icons.explore_rounded, 'Explorar', cs),
                _tabItem(2, Icons.calendar_month_rounded, 'Agenda', cs),
                _alertasTab(cs),
                _tabItem(4, Icons.person_rounded, 'Perfil', cs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _alertasTab(ColorScheme cs) {
    final noLeidas = appState.noLeidas;
    return Expanded(
      child: InkWell(
        onTap: () => irA(3),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_rounded,
                  size: 24,
                  color: _tab == 3 ? cs.primary : cs.onSurfaceVariant,
                ),
                if (noLeidas > 0)
                  Positioned(
                    top: -5,
                    right: -9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.urgUrgente,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                            color: cs.surfaceContainerLowest, width: 1.5),
                      ),
                      child: Text(
                        '$noLeidas',
                        style: const TextStyle(
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              'Alertas',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: _tab == 3 ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabItem(int i, IconData icon, String label, ColorScheme cs) {
    final activo = _tab == i;
    return Expanded(
      child: InkWell(
        onTap: () => irA(i),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: activo ? cs.primary : cs.onSurfaceVariant),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: activo ? cs.primary : cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
