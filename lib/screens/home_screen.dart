import 'package:flutter/material.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import '../widgets/opportunity_card.dart';
import 'detail_screen.dart';
import 'home_shell.dart';
import 'saved_screen.dart';

/// S3 — Inicio/Descubrir: AppBar, búsqueda, chips, banner urgente y feed.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  Categoria? _filtro;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    // Simula la carga inicial para mostrar skeletons (UX de mockup).
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _cargando = false);
    });
  }

  List<Opportunity> _filtradas(DateTime ahora) {
    var lista = appState.oportunidades.where((o) {
      if (o.urgenciaAhora(ahora) == Urgencia.cerrada) return false;
      final activa = appState.prefs.categoriasActivas[o.categoria] ?? true;
      if (!activa) return false;
      if (_filtro != null && o.categoria != _filtro) return false;
      if (_query.isNotEmpty) {
        final q = _query.toLowerCase();
        final match = o.titulo.toLowerCase().contains(q) ||
            o.organizacion.toLowerCase().contains(q) ||
            o.lugar.toLowerCase().contains(q) ||
            o.categoria.label.toLowerCase().contains(q);
        if (!match) return false;
      }
      return true;
    }).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    return lista;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ahora = DateTime.now();
    final lista = _filtradas(ahora);
    final urgentes = lista
        .where((o) => o.urgenciaAhora(ahora) == Urgencia.urgente)
        .toList();

    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) => Scaffold(
        body: SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(milliseconds: 600));
              if (mounted) setState(() {});
            },
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                // ── AppBar propia: logo + acciones ──
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [
                          AppColors.primary,
                          AppColors.primaryContainer
                        ]),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.bolt_rounded,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Activation',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -.4,
                              color: cs.onSurface,
                            ),
                          ),
                          Text(
                            'Descubre y conquista · Perú',
                            style: TextStyle(
                                fontSize: 11, color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Guardadas',
                      onPressed: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const SavedScreen())),
                      icon: const Icon(Icons.bookmark_border_rounded),
                    ),
                    IconButton(
                      tooltip: 'Alertas',
                      onPressed: () => context
                          .findAncestorStateOfType<HomeShellState>()
                          ?.irA(3),
                      icon: Badge(
                        isLabelVisible: appState.noLeidas > 0,
                        label: Text('${appState.noLeidas}'),
                        child: const Icon(Icons.notifications_none_rounded),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // ── Barra de búsqueda ──
                TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar becas, hackathons, empleo…',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () => setState(() => _query = ''),
                          )
                        : null,
                    filled: true,
                    fillColor: cs.surfaceContainerLow,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // ── Chips de categorías ──
                SizedBox(
                  height: 34,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _chip(null, 'Todas', cs),
                      const SizedBox(width: 8),
                      for (final c in Categoria.values) ...[
                        _chip(c, c.label.split(' ')[0], cs),
                        const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // ── Banner urgente ──
                if (urgentes.isNotEmpty)
                  GestureDetector(
                    onTap: () => context
                        .findAncestorStateOfType<HomeShellState>()
                        ?.irA(2),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.urgUrgenteBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.urgUrgente.withValues(alpha: .35)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.alarm_rounded,
                              color: AppColors.urgUrgente, size: 22),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${urgentes.length} ${urgentes.length == 1 ? 'cierra' : 'cierran'} esta semana',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFFB91C1C),
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded,
                              color: AppColors.urgUrgente),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // ── Feed ──
                if (_cargando)
                  ...[
                    const SizedBox(height: 8),
                    const SkeletonCard(alto: 250),
                    const SizedBox(height: 12),
                    const SkeletonCard(alto: 250),
                  ]
                else if (lista.isEmpty)
                  EmptyState(
                    icon: Icons.explore_off_rounded,
                    titulo: 'No hay oportunidades aquí todavía',
                    mensaje:
                        'Prueba con otra categoría o activa más categorías en tu perfil para ver más convocatorias.',
                    ctaLabel: 'Ir a Explorar',
                    onCta: () => context
                        .findAncestorStateOfType<HomeShellState>()
                        ?.irA(1),
                  )
                else
                  ...[
                    SectionHeader(
                      titulo: 'Oportunidades destacadas',
                      accionLabel: '${lista.length}',
                    ),
                    for (final o in lista) ...[
                      OpportunityCard(
                        o: o,
                        ahora: ahora,
                        guardada: appState.estaGuardada(o.id),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(oportunidadId: o.id),
                          ),
                        ),
                        onCorazon: () => appState.toggleGuardada(o.id),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _chip(Categoria? c, String label, ColorScheme cs) {
    final activo = _filtro == c;
    return GestureDetector(
      onTap: () => setState(() => _filtro = c),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activo ? AppColors.primary : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
              color: activo ? AppColors.primary : cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (c != null) ...[
              Icon(c.icon,
                  size: 13, color: activo ? Colors.white : c.color),
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
          ],
        ),
      ),
    );
  }
}
