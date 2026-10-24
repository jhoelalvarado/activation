import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';

/// S10 — Guardadas: orden por deadline ascendente + barra de progreso del
/// tiempo transcurrido por convocatoria.
class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ahora = DateTime.now();
    final guardadas = appState.guardadas;

    return Scaffold(
      appBar: AppBar(
        title: Text('Guardadas (${guardadas.length})'),
        actions: [
          IconButton(
            tooltip: 'Ordenar por deadline (activo)',
            onPressed: () {},
            icon: const Icon(Icons.sort_rounded),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: guardadas.isEmpty
          ? const EmptyState(
              icon: Icons.bookmark_border_rounded,
              titulo: 'Sin oportunidades guardadas',
              mensaje:
                  'Explora el feed y toca el corazón para guardar lo que te interese. Te avisaremos antes de que cierren.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // Aviso de orden
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.schedule_rounded,
                          size: 14, color: cs.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Text(
                        'Ordenado por cierre más próximo',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                for (final o in guardadas) ...[
                  _GuardadaCard(
                    o: o,
                    ahora: ahora,
                    guardada: true,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                DetailScreen(oportunidadId: o.id))),
                    onCorazon: () => appState.toggleGuardada(o.id),
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
    );
  }
}

class _GuardadaCard extends StatelessWidget {
  const _GuardadaCard({
    required this.o,
    required this.ahora,
    required this.guardada,
    required this.onTap,
    required this.onCorazon,
  });
  final Opportunity o;
  final DateTime ahora;
  final bool guardada;
  final VoidCallback onTap;
  final VoidCallback onCorazon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final u = o.urgenciaAhora(ahora);
    final progreso = o.progresoTranscurrido(ahora);
    final restante = o.deadline.difference(ahora);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Cabecera con gradiente ──
            SizedBox(
              height: 92,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          o.categoria.color,
                          o.categoria.color.withValues(alpha: .5),
                        ],
                      ),
                    ),
                    child: Icon(o.categoria.icon,
                        size: 52, color: Colors.white.withValues(alpha: .2)),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CategoriaBadge(categoria: o.categoria),
                  ),
                  Positioned(
                    top: 10,
                    left: 10 + 96,
                    child: UrgenciaBadge(o: o, ahora: ahora),
                  ),
                  Positioned(
                    top: 8,
                    right: 10,
                    child: CorazonButton(
                      activo: guardada,
                      onTap: onCorazon,
                      tamano: 34,
                      fondo: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.3,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.corporate_fare_rounded,
                          size: 13, color: cs.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          o.organizacion,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 11.5, color: cs.onSurfaceVariant),
                        ),
                      ),
                      if (o.orgVerificada)
                        Icon(Icons.verified_rounded,
                            size: 13, color: cs.primary),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      MetaChip(
                          icon: Icons.event_rounded,
                          texto: Fechas.ddMmm(o.deadline)),
                      MetaChip(
                          icon: Icons.location_on_outlined, texto: o.lugar),
                      if (o.premio != null)
                        MetaChip(
                            icon: Icons.emoji_events_rounded,
                            texto: o.premio!),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ── Barra de progreso del tiempo transcurrido ──
                  Row(
                    children: [
                      Icon(
                        u == Urgencia.cerrada
                            ? Icons.event_busy_rounded
                            : Icons.hourglass_bottom_rounded,
                        size: 14,
                        color: u.color,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          u == Urgencia.cerrada
                              ? 'Convocatoria cerrada'
                              : _textoRestante(restante, progreso),
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: u.color,
                          ),
                        ),
                      ),
                      Text(
                        '${(progreso * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                          color: u.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progreso,
                      minHeight: 5,
                      backgroundColor: u.color.withValues(alpha: .15),
                      valueColor: AlwaysStoppedAnimation<Color>(u.color),
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

  String _textoRestante(Duration d, double progreso) {
    if (d.inDays >= 1) return 'Tiempo transcurrido · ${d.inDays}d restantes';
    if (d.inHours >= 1) return 'Tiempo transcurrido · ${d.inHours}h restantes';
    if (d.inMinutes >= 1) return '¡Últimos ${d.inMinutes} minutos!';
    return 'Cerrando…';
  }
}
