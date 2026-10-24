import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'home_shell.dart';

/// S2 — Onboarding de 4 pasos: valor, alertas, permiso e intereses.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();
  int _paso = 0;
  final Set<Categoria> _intereses = {Categoria.hackathones, Categoria.becas};
  final NotificationService _notif = NotificationService();
  bool _pidiendoPermiso = false;

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  Future<void> _siguiente() async {
    if (_paso == 2) {
      // Paso de permiso
      setState(() => _pidiendoPermiso = true);
      await _notif.pedirPermiso();
      setState(() => _pidiendoPermiso = false);
    }
    if (_paso < 3) {
      _pc.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic);
    } else {
      appState.terminarOnboarding(_intereses);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const HomeShell(), fullscreenDialog: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {
                  appState.terminarOnboarding(_intereses);
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeShell()));
                },
                child: const Text('Saltar'),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pc,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _paso = i),
                children: [
                  _pasoValor(cs),
                  _pasoAlertas(cs),
                  _pasoPermiso(cs),
                  _pasoIntereses(cs),
                ],
              ),
            ),
            _footer(cs),
          ],
        ),
      ),
    );
  }

  Widget _ilustracion(IconData icon, Color bg, Color fg,
      {IconData? badge}) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Stack(alignment: Alignment.center, children: [
        Icon(icon, size: 54, color: fg),
        if (badge != null)
          Positioned(
            right: 18,
            bottom: 18,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                  color: AppColors.urgAbierto, shape: BoxShape.circle),
              child: Icon(badge, size: 18, color: Colors.white),
            ),
          ),
      ]),
    );
  }

  Widget _pasoValor(ColorScheme cs) => _plantilla(
        cs,
        ilustracion: _ilustracion(
          Icons.calendar_month_rounded,
          cs.primary.withValues(alpha: .1),
          cs.primary,
          badge: Icons.notifications_active_rounded,
        ),
        titulo: '¿Te enteras cuando ya pasó?',
        cuerpo:
            'Becas, hackathons, torneos y convocatorias en Perú se publican dispersos. Activation te avisa ANTES de que cierre cada una.',
      );

  Widget _pasoAlertas(ColorScheme cs) => _plantilla(
        cs,
        ilustracion: _ilustracion(
          Icons.phone_iphone_rounded,
          AppColors.urgProximoBg,
          AppColors.urgProximo,
          badge: Icons.alarm_rounded,
        ),
        titulo: 'Alertas antes del cierre',
        cuerpo:
            'Elige tus temas y te avisamos 7, 3 y 1 día antes del deadline. Activa también el aviso del mismo día para convocatorias flash.',
      );

  Widget _pasoPermiso(ColorScheme cs) => _plantilla(
        cs,
        ilustracion: _ilustracion(
          Icons.notifications_none_rounded,
          cs.primary.withValues(alpha: .1),
          cs.primary,
          badge: Icons.check_rounded,
        ),
        titulo: 'Activa las notificaciones',
        cuerpo:
            'Necesitamos permiso para enviarte los recordatorios de deadline. Sin spam: solo tus convocatorias.',
        accion: FilledButton.icon(
          onPressed: _pidiendoPermiso ? null : _siguiente,
          icon: _pidiendoPermiso
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.notifications_active_rounded, size: 18),
          label: Text(_pidiendoPermiso ? 'Pidiendo permiso…' : 'Permitir notificaciones'),
        ),
      );

  Widget _pasoIntereses(ColorScheme cs) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _ilustracion(cs.primary.withValues(alpha: .1) == Colors.red
                ? Icons.bolt
                : Icons.tune_rounded,
                cs.primary.withValues(alpha: .1), cs.primary),
            const SizedBox(height: 20),
            Text(
              '¿Qué oportunidades buscas?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -.6,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Te avisaremos 7, 3 y 1 día antes del cierre exacto de cada convocatoria. Elige al menos una.',
              style: TextStyle(
                  fontSize: 14, height: 1.5, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 8,
              runSpacing: 10,
              children: [
                for (final c in Categoria.values)
                  _chipInteres(c, cs),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.notifications_active_rounded,
                      size: 20, color: cs.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Recordatorios automáticos activos para ${_intereses.length} categor${_intereses.length == 1 ? 'ía' : 'ías'} seleccionadas',
                      style: TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w600,
                          color: cs.onSurface),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _chipInteres(Categoria c, ColorScheme cs) {
    final activo = _intereses.contains(c);
    return GestureDetector(
      onTap: () => setState(() {
        if (!_intereses.add(c)) _intereses.remove(c);
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: activo ? AppColors.primary : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: activo ? AppColors.primary : cs.outlineVariant,
          ),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(c.icon, size: 16, color: activo ? Colors.white : c.color),
          const SizedBox(width: 6),
          Text(
            c.label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: activo ? Colors.white : cs.onSurface,
            ),
          ),
          if (activo) ...[
            const SizedBox(width: 4),
            const Icon(Icons.check_rounded, size: 15, color: Colors.white),
          ],
        ]),
      ),
    );
  }

  Widget _plantilla(
    ColorScheme cs, {
    required Widget ilustracion,
    required String titulo,
    required String cuerpo,
    Widget? accion,
  }) =>
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: ilustracion),
            const SizedBox(height: 32),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: -.6,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              cuerpo,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.55,
                color: cs.onSurfaceVariant,
              ),
            ),
            if (accion != null) ...[
              const SizedBox(height: 24),
              Center(child: accion),
            ],
          ],
        ),
      );

  Widget _footer(ColorScheme cs) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final activo = i == _paso;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: activo ? 22 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: activo ? AppColors.primary : cs.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),
            if (_paso != 2)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _paso == 3 && _intereses.isEmpty
                      ? null
                      : _siguiente,
                  child: Text(
                    _paso == 3 ? 'Empezar a explorar convocatorias' : 'Siguiente',
                    style: const TextStyle(
                        fontSize: 15.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ),
      );
}
