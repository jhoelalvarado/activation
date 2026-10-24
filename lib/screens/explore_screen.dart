import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/opportunity_card.dart';
import 'detail_screen.dart';

/// S4 — Explorar: grid de categorías + carruseles "Cierran pronto" y "Nuevas".
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ahora = DateTime.now();
    final activas = appState.oportunidades
        .where((o) => o.urgenciaAhora(ahora) != Urgencia.cerrada)
        .toList();
    final cierranPronto = activas
        .where((o) => o.urgenciaAhora(ahora) == Urgencia.urgente)
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    final nuevas = activas.toList()
      ..sort((a, b) => b.publicadoAt.compareTo(a.publicadoAt));

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Text(
              'Explorar',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -.7,
                color: cs.onSurface,
              ),
            ),
            Text(
              'Descubre convocatorias por categoría y tendencias',
              style: TextStyle(fontSize: 13.5, color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            // ── Grid de categorías ──
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.55,
              children: [
                for (final c in Categoria.values)
                  _CategoriaCard(
                    categoria: c,
                    count: activas.where((o) => o.categoria == c).length,
                  ),
              ],
            ),
            // ── Contador vivo ──
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: AppColors.urgAbierto, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Actualización en vivo: ${activas.length} oportunidades activas',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            // ── Cierran pronto ──
            SectionHeader(
              titulo: 'Cierran pronto',
              icon: Icons.alarm_rounded,
              accionColor: AppColors.urgUrgente,
              accionLabel: 'ver todas',
            ),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: cierranPronto.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) => CompactOpportunityCard(
                  o: cierranPronto[i],
                  ahora: ahora,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              DetailScreen(oportunidadId: cierranPronto[i].id))),
                ),
              ),
            ),
            // ── Nuevas esta semana ──
            SectionHeader(
              titulo: 'Nuevas esta semana',
              icon: Icons.fiber_new_rounded,
            ),
            SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: nuevas.length.clamp(0, 8),
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (context, i) => CompactOpportunityCard(
                  o: nuevas[i],
                  ahora: ahora,
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              DetailScreen(oportunidadId: nuevas[i].id))),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // ── Card comunidad (UGC) ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  AppColors.primary,
                  AppColors.secondaryContainer
                ]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'COMUNIDAD',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: .5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '¿Conoces una oportunidad que falta?',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sugiere una convocatoria para que más jóvenes peruanos se enteren a tiempo.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: Colors.white.withValues(alpha: .85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Gracias! La función de sugerencias llega muy pronto.')),
                    ),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.add_rounded, color: cs.primary),
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

class _CategoriaCard extends StatelessWidget {
  const _CategoriaCard({required this.categoria, required this.count});
  final Categoria categoria;
  final int count;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _ListaCategoriaScreen(categoria: categoria),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: categoria.colorSuave,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      Icon(categoria.icon, size: 20, color: categoria.color),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: categoria.colorSuave,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$count activas',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: categoria.color,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              categoria.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: cs.onSurface,
              ),
            ),
            Text(
              switch (categoria) {
                Categoria.becas => 'PRONABEC, OEA, Santander…',
                Categoria.hackathones => 'IA, Web3 y builders',
                Categoria.gaming => 'Torneos y ligas',
                Categoria.educacion => 'Bootcamps y cursos',
                Categoria.empleo => 'Trainee y pasantías',
                Categoria.ciencia => 'Startups e innovación',
              },
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lista filtrada por categoría (desde Explorar).
class _ListaCategoriaScreen extends StatelessWidget {
  const _ListaCategoriaScreen({required this.categoria});
  final Categoria categoria;

  @override
  Widget build(BuildContext context) {
    final ahora = DateTime.now();
    final lista = appState.oportunidades
        .where((o) => o.categoria == categoria)
        .toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));

    return Scaffold(
      appBar: AppBar(title: Text(categoria.label)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final o in lista) ...[
            OpportunityCard(
              o: o,
              ahora: ahora,
              guardada: appState.estaGuardada(o.id),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => DetailScreen(oportunidadId: o.id))),
              onCorazon: () => appState.toggleGuardada(o.id),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
