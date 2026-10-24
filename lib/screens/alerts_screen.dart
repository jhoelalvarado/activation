import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';

/// S7 — Bandeja de alertas in-app: filtros, no leídas, swipe para eliminar.
class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});
  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

enum _Filtro { todas, urgentes, nuevas }

class _AlertsScreenState extends State<AlertsScreen> {
  _Filtro _filtro = _Filtro.todas;

  List<AppNotification> _filtradas() {
    switch (_filtro) {
      case _Filtro.todas:
        return appState.notificaciones;
      case _Filtro.urgentes:
        return appState.notificaciones
            .where((n) => n.tipo == TipoAlerta.urgente)
            .toList();
      case _Filtro.nuevas:
        return appState.notificaciones
            .where((n) => !n.leida)
            .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ahora = DateTime.now();
    final lista = _filtradas();
    final noLeidas = appState.noLeidas;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Alertas',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.7,
                            color: cs.onSurface,
                          ),
                        ),
                        if (noLeidas > 0) ...[
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.urgUrgenteBg,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$noLeidas nuevas',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColors.urgUrgente,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert_rounded,
                        color: cs.onSurfaceVariant),
                    onSelected: (v) {
                      if (v == 'marcar') appState.marcarTodasLeidas();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                          value: 'marcar',
                          child: Text('Marcar todas como leídas')),
                    ],
                  ),
                ],
              ),
            ),
            // Resumen de sin leer
            if (noLeidas > 0)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mark_email_unread_rounded,
                          size: 16, color: cs.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '$noLeidas alertas sin leer',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: appState.marcarTodasLeidas,
                        child: Text(
                          'Marcar todas',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: cs.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            // Filtros
            SizedBox(
              height: 34,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _chip(_Filtro.todas, 'Todas', null, cs),
                  const SizedBox(width: 8),
                  _chip(_Filtro.urgentes, 'Urgentes',
                      AppColors.urgUrgente, cs),
                  const SizedBox(width: 8),
                  _chip(_Filtro.nuevas, 'Nuevas', cs.primary, cs),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Lista
            Expanded(
              child: lista.isEmpty
                  ? const EmptyState(
                      icon: Icons.notifications_off_rounded,
                      titulo: 'Aquí verás tus alertas',
                      mensaje:
                          'Cuando una convocatoria se acerque a su cierre o publiquemos algo nuevo según tus intereses, aparecerá en esta bandeja.',
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                      itemCount: lista.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        final n = lista[i];
                        return Dismissible(
                          key: ValueKey(n.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            decoration: BoxDecoration(
                              color: AppColors.urgUrgente,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.delete_rounded,
                                color: Colors.white),
                          ),
                          onDismissed: (_) =>
                              appState.eliminarNotificacion(n.id),
                          child: _NotificacionCard(
                            notif: n,
                            ahora: ahora,
                            onTap: () {
                              appState.marcarLeida(n.id);
                              if (n.opportunityId != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DetailScreen(
                                            oportunidadId:
                                                n.opportunityId!)));
                              }
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(_Filtro f, String label, Color? color, ColorScheme cs) {
    final activo = _filtro == f;
    return GestureDetector(
      onTap: () => setState(() => _filtro = f),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activo ? AppColors.primary : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
              color: activo ? AppColors.primary : cs.outlineVariant),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (color != null && !activo) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: activo ? Colors.white : cs.onSurface,
            ),
          ),
        ]),
      ),
    );
  }
}

class _NotificacionCard extends StatelessWidget {
  const _NotificacionCard({
    required this.notif,
    required this.ahora,
    required this.onTap,
  });
  final AppNotification notif;
  final DateTime ahora;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final (icon, color, label) = switch (notif.tipo) {
      TipoAlerta.urgente => (
          Icons.alarm_rounded,
          AppColors.urgUrgente,
          'URGENTE <24H'
        ),
      TipoAlerta.nueva => (Icons.school_rounded, AppColors.catBecas, 'NUEVA'),
      TipoAlerta.recordatorio => (
          Icons.schedule_rounded,
          AppColors.urgProximo,
          'RECORDATORIO'
        ),
      TipoAlerta.aceptado => (
          Icons.celebration_rounded,
          AppColors.catHackathones,
          'ACEPTADO'
        ),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: !notif.leida
              ? cs.primaryContainer.withValues(alpha: .08)
              : cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .4,
                            color: color,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        Fechas.hace(notif.createdAt, ahora),
                        style: TextStyle(
                          fontSize: 11,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                      if (!notif.leida) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: cs.primary, shape: BoxShape.circle),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notif.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notif.cuerpo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
