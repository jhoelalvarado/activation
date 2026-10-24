import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'about_screen.dart';
import 'notification_settings_screen.dart';
import 'saved_screen.dart';

/// S8 — Perfil: avatar, stats, preferencias, tema y sesión.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final guardadas = appState.totalGuardadas;
    final alertas = appState.alertasActivas;
    final intereses = appState.prefs.interests;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          children: [
            // ── Header ──
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            AppColors.primary,
                            AppColors.secondaryContainer
                          ]),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerLowest,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.edit_rounded,
                              size: 14, color: cs.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Invitado',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Inicia sesión para sincronizar tus guardados',
                    style: TextStyle(
                        fontSize: 12.5, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt_rounded, size: 13, color: cs.primary),
                        const SizedBox(width: 4),
                        Text(
                          'Explorador de oportunidades',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // ── Stats ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _stat(cs, '$guardadas', 'Guardadas'),
                  _divider(cs),
                  _stat(cs, '$alertas', 'Alertas activas'),
                  _divider(cs),
                  _stat(cs, '${intereses.length}', 'Intereses'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Intereses ──
            SectionHeader(titulo: 'Mis intereses', icon: Icons.tune_rounded),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in Categoria.values)
                  _interesChip(context, c, cs),
              ],
            ),
            const SizedBox(height: 20),
            // ── Lista de opciones ──
            SectionHeader(
                titulo: 'Preferencias y notificaciones',
                icon: Icons.settings_outlined),
            _opcion(
              context,
              icon: Icons.notifications_rounded,
              label: 'Notificaciones inteligentes',
              sub: 'Recordatorios 7 · 3 · 1 día(s) antes',
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const NotificationSettingsScreen())),
            ),
            _opcion(
              context,
              icon: Icons.bookmark_border_rounded,
              label: 'Guardados',
              sub: '$guardadas convocatorias',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SavedScreen())),
            ),
            SwitchListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              secondary: Icon(Icons.calendar_month_rounded,
                  size: 22, color: cs.primary),
              title: const Text('Google Calendar',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700)),
              subtitle: const Text('Sincroniza hitos y entregas',
                  style: TextStyle(fontSize: 12)),
              value: true,
              onChanged: (_) {},
            ),
            _opcion(
              context,
              icon: Icons.language_rounded,
              label: 'Idioma',
              sub: 'Español (Latinoamérica)',
              onTap: () {},
            ),
            // ── Tema ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.contrast_rounded, size: 22, color: cs.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text('Tema de la app',
                          style: TextStyle(
                              fontSize: 14.5, fontWeight: FontWeight.w700)),
                    ),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                            value: 'sistema',
                            icon: Icon(Icons.settings_suggest_outlined, size: 16)),
                        ButtonSegment(
                            value: 'claro',
                            icon: Icon(Icons.light_mode_outlined, size: 16)),
                        ButtonSegment(
                            value: 'oscuro',
                            icon: Icon(Icons.dark_mode_outlined, size: 16)),
                      ],
                      selected: {appState.prefs.tema},
                      showSelectedIcon: false,
                      style: const ButtonStyle(
                          visualDensity: VisualDensity.compact),
                      onSelectionChanged: (s) => appState
                          .updatePrefs((p) => p.copyWith(tema: s.first)),
                    ),
                  ],
                ),
              ),
            ),
            _opcion(
              context,
              icon: Icons.info_outline_rounded,
              label: 'Acerca de Activation',
              sub: 'v1.0.0 · Build 2026',
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const AboutScreen())),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton.tonal(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.urgUrgenteBg,
                  foregroundColor: AppColors.urgUrgente,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content:
                          Text('El login con cuenta llega en la próxima versión')));
                },
                child: const Text('Iniciar sesión',
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Activation Mobile · Hecho en Perú ⚡',
                style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(ColorScheme cs, String valor, String label) => Expanded(
        child: Column(
          children: [
            Text(
              valor,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: cs.primary,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      );

  Widget _divider(ColorScheme cs) => Container(
        width: 1,
        height: 30,
        color: cs.outlineVariant,
      );

  Widget _interesChip(BuildContext context, Categoria c, ColorScheme cs) {
    final activo = appState.prefs.interests.contains(c);
    return GestureDetector(
      onTap: () {
        final setActual = {...appState.prefs.interests};
        if (!setActual.add(c)) setActual.remove(c);
        appState.updatePrefs((p) => p.copyWith(interests: setActual));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: activo ? c.color : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: activo ? c.color : cs.outlineVariant),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(c.icon, size: 14, color: activo ? Colors.white : c.color),
          const SizedBox(width: 6),
          Text(
            c.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: activo ? Colors.white : cs.onSurface,
            ),
          ),
          if (activo) ...[
            const SizedBox(width: 4),
            const Icon(Icons.check_rounded, size: 13, color: Colors.white),
          ],
        ]),
      ),
    );
  }

  Widget _opcion(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String sub,
    required VoidCallback onTap,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 22, color: cs.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      sub,
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 20, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
