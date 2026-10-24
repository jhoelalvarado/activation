import 'package:flutter/material.dart';

import '../models/models.dart';
import 'common.dart';

/// Card de oportunidad del feed (S3) — imagen de gradiente por categoría,
/// badges sobre la imagen, cuerpo con título/org/meta y corazón.
class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    super.key,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imagen (gradiente de categoría con icono gigante) ──
            SizedBox(
              height: 130,
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
                          o.categoria.color.withValues(alpha: .55),
                          o.categoria.color.withValues(alpha: .25),
                        ],
                      ),
                    ),
                    child: Icon(
                      o.categoria.icon,
                      size: 72,
                      color: Colors.white.withValues(alpha: .18),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: CategoriaBadge(categoria: o.categoria),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: UrgenciaBadge(o: o, ahora: ahora),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 12,
                    right: 12,
                    child: Text(
                      o.titulo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.25,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: Colors.black45, blurRadius: 8),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ── Cuerpo ──
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: o.categoria.colorSuave,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(o.categoria.icon,
                            size: 12, color: o.categoria.color),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          o.organizacion,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (o.orgVerificada)
                        Icon(Icons.verified_rounded,
                            size: 14, color: cs.primary),
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
                          icon: Icons.location_on_outlined,
                          texto: o.lugar),
                      if (o.premio != null)
                        MetaChip(
                            icon: Icons.emoji_events_rounded,
                            texto: o.premio!)
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          o.costo,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                          ),
                        ),
                      ),
                      CorazonButton(
                        activo: guardada,
                        onTap: onCorazon,
                      ),
                    ],
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

/// Card compacta horizontal para carruseles (Explorar / Cierran pronto).
class CompactOpportunityCard extends StatelessWidget {
  const CompactOpportunityCard({
    super.key,
    required this.o,
    required this.ahora,
    required this.onTap,
  });
  final Opportunity o;
  final DateTime ahora;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final u = o.urgenciaAhora(ahora);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 210,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: o.categoria.colorSuave,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(o.categoria.icon, size: 17, color: o.categoria.color),
                ),
                const Spacer(),
                UrgenciaBadge(o: o, ahora: ahora),
              ],
            ),
            const Spacer(),
            Text(
              o.titulo,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                height: 1.25,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              o.organizacion,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 13, color: u.color),
                const SizedBox(width: 4),
                Text(
                  u.texto(ahora, o.deadline),
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: u.color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
