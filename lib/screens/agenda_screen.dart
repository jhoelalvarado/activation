import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'detail_screen.dart';

/// S6 — Agenda: calendario mensual con puntos por urgencia + lista agrupada
/// por día + sincronización con calendario (.ics).
class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});
  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late DateTime _mesActual;
  int? _diaSeleccionado;

  @override
  void initState() {
    super.initState();
    final hoy = DateTime.now();
    _mesActual = DateTime(hoy.year, hoy.month, 1);
    _diaSeleccionado = hoy.day;
  }

  Map<int, List<Opportunity>> _deadlinePorDia(DateTime mes) {
    final map = <int, List<Opportunity>>{};
    for (final o in appState.oportunidades) {
      if (o.deadline.year == mes.year && o.deadline.month == mes.month) {
        map.putIfAbsent(o.deadline.day, () => []).add(o);
      }
    }
    return map;
  }

  List<Opportunity> get _guardadasConFecha =>
      appState.guardadas.where((o) => o.urgenciaAhora(DateTime.now()) != Urgencia.cerrada).toList();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ahora = DateTime.now();
    final deadlines = _deadlinePorDia(_mesActual);
    final listaDia = _diaSeleccionado != null
        ? (deadlines[_diaSeleccionado] ?? [])
        : <Opportunity>[];
    final guardadas = _guardadasConFecha;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Agenda',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.7,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() {
                    final hoy = DateTime.now();
                    _mesActual = DateTime(hoy.year, hoy.month, 1);
                    _diaSeleccionado = hoy.day;
                  }),
                  icon: Icon(Icons.today_rounded, size: 17, color: cs.primary),
                  label: Text('Hoy',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: cs.primary)),
                ),
              ],
            ),
            // ── Selector de mes ──
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      _mesActual =
                          DateTime(_mesActual.year, _mesActual.month - 1, 1);
                      _diaSeleccionado = null;
                    }),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Expanded(
                    child: Text(
                      '${Fechas.nombreMes(_mesActual.month)} ${_mesActual.year}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      _mesActual =
                          DateTime(_mesActual.year, _mesActual.month + 1, 1);
                      _diaSeleccionado = null;
                    }),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // ── Calendario ──
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      for (final d in const ['L', 'M', 'M', 'J', 'V', 'S', 'D'])
                        Expanded(
                          child: Center(
                            child: Text(
                              d,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._semanasDelMes(),
                  const SizedBox(height: 8),
                  // ── Leyenda ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _leyenda(AppColors.urgUrgente, 'Urgente (<7d)'),
                      _leyenda(AppColors.urgProximo, 'Próximo'),
                      _leyenda(AppColors.urgAbierto, 'Abierto'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // ── Lista del día seleccionado ──
            if (_diaSeleccionado != null) ...[
              Text(
                '${Fechas.diaSemana(DateTime(_mesActual.year, _mesActual.month, _diaSeleccionado!))} '
                '$_diaSeleccionado ${Fechas.nombreMes(_mesActual.month).substring(0, 3).toUpperCase()}'
                ' · ${listaDia.length} ${listaDia.length == 1 ? 'cierre' : 'cierres'}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .3,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              if (listaDia.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Sin deadlines este día.',
                    style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                  ),
                )
              else
                ...listaDia.map((o) => _itemAgenda(cs, o, ahora)),
            ],
            const SizedBox(height: 8),
            // ── Mis guardadas con deadline ──
            SectionHeader(
              titulo: 'Mis deadlines guardados',
              icon: Icons.bookmark_rounded,
            ),
            if (guardadas.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Guarda oportunidades desde el feed y aparecerán aquí.',
                  style: TextStyle(fontSize: 13, color: cs.onSurfaceVariant),
                ),
              )
            else
              ...guardadas.map((o) => _itemAgenda(cs, o, ahora)),
            const SizedBox(height: 16),
            // ── Sincronización ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cs.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sync_rounded, size: 18, color: cs.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Sincronización inteligente',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Recibe recordatorios en tu dispositivo y nunca te quedes fuera de un deadline por un minuto.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () async {
                        final sp = await SharedPreferences.getInstance();
                        await sp.setString('last_ics_export',
                            DateTime.now().toIso8601String());
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Exportando ${guardadas.length + listaDia.length} deadlines a tu calendario (.ics)…'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.calendar_month_rounded, size: 18),
                      label: const Text(
                        'Sincronizar con Google Calendar',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w800),
                      ),
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

  List<Widget> _semanasDelMes() {
    final cs = Theme.of(context).colorScheme;
    final deadlines = _deadlinePorDia(_mesActual);
    final ahora = DateTime.now();
    final hoy = DateTime.now();
    final esMesActual = _mesActual.year == hoy.year && _mesActual.month == hoy.month;

    final primerDia = DateTime(_mesActual.year, _mesActual.month, 1);
    final offset = (primerDia.weekday - 1) % 7; // lunes = 0
    final diasEnMes = DateTime(_mesActual.year, _mesActual.month + 1, 0).day;
    final celdas = offset + diasEnMes;
    final semanas = (celdas / 7).ceil();

    return List.generate(semanas, (s) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Row(
          children: List.generate(7, (d) {
            final index = s * 7 + d;
            final dia = index - offset + 1;
            if (dia < 1 || dia > diasEnMes) {
              return const Expanded(child: SizedBox(height: 42));
            }
            final lista = deadlines[dia];
            final esHoy = esMesActual && dia == hoy.day;
            final seleccionado = dia == _diaSeleccionado;
            Color? punto;
            if (lista != null && lista.isNotEmpty) {
              punto = lista
                  .map((o) => o.urgenciaAhora(ahora).color)
                  .reduce((a, b) =>
                      a.toARGB32() < b.toARGB32() ? a : b);
            }
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _diaSeleccionado = dia),
                child: Container(
                  height: 42,
                  margin: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: seleccionado
                        ? cs.primary.withValues(alpha: .1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (esHoy)
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: AppColors.primary, shape: BoxShape.circle),
                          child: Text(
                            '$dia',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        )
                      else
                        Text(
                          '$dia',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: seleccionado ? FontWeight.w800 : FontWeight.w500,
                            color: cs.onSurface,
                          ),
                        ),
                      const SizedBox(height: 3),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: punto ?? Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _leyenda(Color color, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 7, height: 7,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  fontSize: 10, fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ],
      );

  Widget _itemAgenda(ColorScheme cs, Opportunity o, DateTime ahora) {
    final u = o.urgenciaAhora(ahora);
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => DetailScreen(oportunidadId: o.id))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            // Barra de color por urgencia
            Container(
              width: 4,
              height: 64,
              decoration: BoxDecoration(
                color: u.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            // Fecha
            Container(
              width: 46,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: u.colorBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    '${o.deadline.day}',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: u.color,
                    ),
                  ),
                  Text(
                    Fechas.nombreMes(o.deadline.month).substring(0, 3).toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .4,
                      color: u.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    o.organizacion.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: .4,
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    o.titulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: u.colorBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          u.texto(ahora, o.deadline),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: u.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 20, color: cs.outline),
          ],
        ),
      ),
    );
  }
}
