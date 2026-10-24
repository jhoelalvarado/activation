import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// S9 — Ajustes de notificaciones (basada en el mockup S9 del usuario):
/// canales generales, categorías activas, recordatorios de deadline y
/// horario de silencio con excepción de urgencia.
class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = appState.prefs;

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones (Ajustes)')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Text(
            'Personaliza cómo y cuándo recibir alertas de convocatorias, becas activas y deadlines críticos.',
            style: TextStyle(
                fontSize: 13, height: 1.5, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          // ── 1. Canales generales ──
          _grupoHeader(cs, 'Canales generales', verde: true),
          _grupoCard(cs, [
            _switchTile(
              cs,
              icon: Icons.notifications_active_rounded,
              iconBg: cs.primary.withValues(alpha: .1),
              iconColor: cs.primary,
              titulo: 'Notificaciones push',
              sub: 'Permitir avisos en tiempo real en este dispositivo',
              value: p.pushMaster,
              onChanged: (v) => appState.updatePrefs((x) => x.copyWith(pushMaster: v)),
            ),
            _div(cs),
            _switchTile(
              cs,
              icon: Icons.volume_up_rounded,
              titulo: 'Alertas sonoras y vibración',
              sub: 'Tono dinámico y háptico suave',
              value: p.alertasSonoras,
              onChanged: (v) =>
                  appState.updatePrefs((x) => x.copyWith(alertasSonoras: v)),
            ),
            _div(cs),
            _switchTile(
              cs,
              icon: Icons.mark_email_read_rounded,
              titulo: 'Resumen semanal por correo',
              sub: 'Compilado de convocatorias que cierran esta semana',
              value: p.resumenSemanal,
              onChanged: (v) =>
                  appState.updatePrefs((x) => x.copyWith(resumenSemanal: v)),
            ),
            if (p.resumenSemanal)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 15, color: cs.primary),
                      const SizedBox(width: 6),
                      Text('Frecuencia:',
                          style: TextStyle(
                              fontSize: 11.5, color: cs.onSurfaceVariant)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: cs.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Lunes 08:00 AM',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 20),
          // ── 2. Categorías activas ──
          Row(
            children: [
              Expanded(
                child: Text('Categorías activas',
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface)),
              ),
              Text(
                '${p.categoriasActivas.values.where((v) => v).length} de ${Categoria.values.length} activas',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: cs.primary),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Recibirás avisos solo de las disciplinas que mantengas habilitadas:',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          _grupoCard(cs, [
            for (final c in Categoria.values) ...[
              _switchTile(
                cs,
                icon: c.icon,
                iconBg: c.colorSuave,
                iconColor: c.color,
                titulo: c.label,
                sub: switch (c) {
                  Categoria.becas =>
                    'Grants universitarios, movilidad y financiamiento',
                  Categoria.hackathones => 'Retos Web3, IA y builders',
                  Categoria.gaming => 'Torneos competitivos y ligas',
                  Categoria.educacion => 'Cursos, certificaciones y talleres',
                  Categoria.empleo => 'Trainee, fellowships y vacantes junior',
                  Categoria.ciencia => 'Incubadoras, aceleradoras y seed',
                },
                value: p.categoriasActivas[c] ?? false,
                onChanged: (v) {
                  final map = {...p.categoriasActivas};
                  map[c] = v;
                  appState.updatePrefs((x) => x.copyWith(categoriasActivas: map));
                },
                dim: !(p.categoriasActivas[c] ?? false),
              ),
              if (c != Categoria.values.last) _div(cs),
            ],
          ]),
          const SizedBox(height: 20),
          // ── 3. Recordatorios de deadline ──
          Row(
            children: [
              Icon(Icons.timer_rounded, size: 15, color: AppColors.urgUrgente),
              const SizedBox(width: 6),
              Text('TEMPORIZADORES DE CIERRE',
                  style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .6,
                      color: AppColors.urgUrgente)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Recordatorios de cierre (Deadlines)',
            style: TextStyle(
                fontSize: 16.5, fontWeight: FontWeight.w800, color: cs.onSurface),
          ),
          Text(
            '¿Con cuánta anticipación deseas que te avisemos antes del cierre definitivo?',
            style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 10),
          _deadlineCard(
            cs,
            titulo: '7 días antes',
            badge: 'Recomendado',
            badgeColor: cs.primary,
            sub: 'Tiempo óptimo para preparar documentación, cartas y portafolio.',
            value: p.recordar7,
            onChanged: (v) =>
                appState.updatePrefs((x) => x.copyWith(recordar7: v)),
          ),
          _deadlineCard(
            cs,
            titulo: '3 días antes',
            sub: 'Recordatorio de avance para revisar borradores y ensayos finales.',
            value: p.recordar3,
            onChanged: (v) =>
                appState.updatePrefs((x) => x.copyWith(recordar3: v)),
          ),
          _deadlineCard(
            cs,
            titulo: '1 día antes',
            badge: 'Urgente',
            badgeColor: AppColors.urgUrgente,
            sub: 'Alerta de últimas 24 horas para enviar antes del cierre.',
            value: p.recordar1,
            onChanged: (v) =>
                appState.updatePrefs((x) => x.copyWith(recordar1: v)),
          ),
          _deadlineCard(
            cs,
            titulo: 'El mismo día',
            sub: 'Cierre inminente a 6 horas del plazo final. Solo para convocatorias flash.',
            value: p.recordarMismoDia,
            onChanged: (v) =>
                appState.updatePrefs((x) => x.copyWith(recordarMismoDia: v)),
          ),
          const SizedBox(height: 20),
          // ── 4. Horario de silencio ──
          Row(
            children: [
              Expanded(
                child: Text('Modo enfoque',
                    style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface)),
              ),
              Icon(Icons.bedtime_rounded, size: 20, color: cs.primary),
            ],
          ),
          const SizedBox(height: 10),
          _grupoCard(cs, [
            _switchTile(
              cs,
              icon: Icons.dark_mode_rounded,
              titulo: 'Activar horario de silencio',
              sub: 'Pausar avisos sonoros para proteger tu descanso',
              value: p.silencioActivo,
              onChanged: (v) =>
                  appState.updatePrefs((x) => x.copyWith(silencioActivo: v)),
            ),
            if (p.silencioActivo) ...[
              _div(cs),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Ventana de silencio programada',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '8 horas',
                          style: TextStyle(
                              fontSize: 11, color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _horaChip(cs, 'Desde', p.silencioInicio,
                            Icons.nights_stay_rounded),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 16, color: cs.onSurfaceVariant),
                        ),
                        _horaChip(cs, 'Hasta', p.silencioFin,
                            Icons.wb_sunny_rounded),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ]),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.urgProximoBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.warning_amber_rounded,
                    size: 18, color: AppColors.urgProximo),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Excepción de urgencia: las alertas de deadline crítico (<24h) pueden sonar fuera del horario de silencio para evitar que pierdas la postulación.',
                    style: TextStyle(
                      fontSize: 11.5,
                      height: 1.45,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // ── Confirmación de sync + guardar ──
          Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.cloud_done_rounded,
                      size: 15, color: AppColors.catBecas),
                  const SizedBox(width: 6),
                  Text(
                    'Preferencias guardadas en este dispositivo',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Row(children: [
                    Icon(Icons.check_circle_rounded,
                        color: AppColors.urgAbierto, size: 18),
                    SizedBox(width: 8),
                    Text('¡Preferencias actualizadas!'),
                  ]),
                  backgroundColor: cs.inverseSurface,
                ));
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save_rounded, size: 18),
              label: const Text('Guardar preferencias',
                  style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _grupoHeader(ColorScheme cs, String label, {bool verde = false}) =>
      Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          const Spacer(),
          if (verde)
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                      color: AppColors.urgAbierto, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
                Text(
                  'Servicio activo',
                  style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.catBecas),
                ),
              ],
            ),
        ],
      );

  Widget _grupoCard(ColorScheme cs, List<Widget> children) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
        ),
        child: Column(children: children),
      );

  Widget _div(ColorScheme cs) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Divider(height: 1, color: cs.outlineVariant.withValues(alpha: .6)),
      );

  Widget _switchTile(
    ColorScheme cs, {
    required IconData icon,
    Color? iconBg,
    Color? iconColor,
    required String titulo,
    required String sub,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool dim = false,
  }) =>
      Opacity(
        opacity: dim ? .6 : 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: iconBg ?? cs.surfaceContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Icon(icon, size: 19, color: iconColor ?? cs.onSurfaceVariant),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                  Text(
                    sub,
                    style: TextStyle(
                        fontSize: 11, height: 1.3, color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      );

  Widget _deadlineCard(
    ColorScheme cs, {
    required String titulo,
    required String sub,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? badge,
    Color? badgeColor,
  }) =>
      GestureDetector(
        onTap: () => onChanged(!value),
        child: Opacity(
          opacity: value ? 1 : .8,
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: value ? AppColors.primary : cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: value
                      ? const Icon(Icons.check_rounded,
                          size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            titulo,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: badgeColor!.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                badge,
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  color: badgeColor,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        sub,
                        style: TextStyle(
                          fontSize: 11.5,
                          height: 1.35,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _horaChip(ColorScheme cs, String label, String hora, IconData icon) =>
      Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 10, color: cs.onSurfaceVariant),
                    ),
                    Text(
                      hora,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(icon, size: 17, color: cs.primary),
            ],
          ),
        ),
      );
}
