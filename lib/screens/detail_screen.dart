import 'dart:async';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/app_state.dart';
import '../models/models.dart';
import '../services/notification_service.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

/// S5 — Detalle de oportunidad: hero, countdown vivo, contenido en acordeones
/// y CTA fija inferior ("Postular" + "Avisarme").
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.oportunidadId});
  final String oportunidadId;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Opportunity _o;
  Timer? _timer;
  DateTime _ahora = DateTime.now();
  final NotificationService _notif = NotificationService();
  bool _activando = false;

  @override
  void initState() {
    super.initState();
    _o = appState.oportunidades.firstWhere((x) => x.id == widget.oportunidadId);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _ahora = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Map<String, int> get _falta {
    final d = _o.deadline.difference(_ahora);
    if (d.isNegative) return {'d': 0, 'h': 0, 'm': 0, 's': 0};
    return {
      'd': d.inDays,
      'h': d.inHours % 24,
      'm': d.inMinutes % 60,
      's': d.inSeconds % 60,
    };
  }

  Future<void> _toggleAvisarme() async {
    setState(() => _activando = true);
    final activo = !appState.tieneRecordatorio(_o.id);
    if (activo) {
      await _notif.pedirPermiso();
      await _notif.programarRecordatorios(_o, appState.prefs);
      await _notif.mostrarConfirmacion(_o, appState.prefs.offsetsDias);
    } else {
      await _notif.cancelarRecordatorios(_o.id);
    }
    appState.setRecordatorio(_o.id, activo);
    if (mounted) setState(() => _activando = false);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final u = _o.urgenciaAhora(_ahora);
    final guardada = appState.estaGuardada(_o.id);
    final conRecordatorio = appState.tieneRecordatorio(_o.id);
    final urgente = u == Urgencia.urgente || u == Urgencia.cerrada;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // ── Hero ──
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: _o.categoria.color,
                leading: _btnCirculo(
                  Icons.arrow_back_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                actions: [
                  _btnCirculo(
                    guardada
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    onTap: () => appState.toggleGuardada(_o.id),
                    color: guardada ? AppColors.urgUrgente : null,
                  ),
                  const SizedBox(width: 4),
                  _btnCirculo(
                    Icons.ios_share_rounded,
                    onTap: () => SharePlus.instance.share(ShareParams(
                        text:
                            '${_o.titulo} — ${_o.organizacion}. Cierra el ${Fechas.ddMmm(_o.deadline)}. Postula aquí: ${_o.url}')),
                  ),
                  const SizedBox(width: 12),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              _o.categoria.color,
                              _o.categoria.color.withValues(alpha: .6),
                            ],
                          ),
                        ),
                        child: Icon(_o.categoria.icon,
                            size: 120, color: Colors.white.withValues(alpha: .15)),
                      ),
                      // gradiente inferior
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: .45),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 14,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .35),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_o.categoria.label.toUpperCase()} · ${_o.modalidad.toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: .5,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Sheet de contenido ──
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CategoriaBadge(categoria: _o.categoria),
                            const SizedBox(width: 8),
                            UrgenciaBadge(o: _o, ahora: _ahora),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _o.titulo,
                          style: TextStyle(
                            fontSize: 23,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -.5,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: _o.categoria.colorSuave,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_o.categoria.icon,
                                  size: 16, color: _o.categoria.color),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _o.organizacion,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: cs.onSurface,
                                ),
                              ),
                            ),
                            if (_o.orgVerificada)
                              Icon(Icons.verified_rounded,
                                  size: 16, color: cs.primary),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // ── Countdown vivo ──
                        _CountdownCard(
                          faltan: _falta,
                          urgente: urgente,
                          cerrada: u == Urgencia.cerrada,
                          deadline: _o.deadline,
                        ),
                        const SizedBox(height: 14),
                        // ── Meta fila ──
                        Row(
                          children: [
                            Expanded(
                                child: _metaItem(cs, Icons.location_on_outlined,
                                    _o.lugar)),
                            Expanded(
                                child: _metaItem(
                                    cs, Icons.payments_outlined, _o.costo)),
                            Expanded(
                                child:
                                    _metaItem(cs, Icons.people_outline, _o.publico)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // ── Acordeones ──
                        _Acordeon(
                          titulo: 'Descripción',
                          icon: Icons.description_outlined,
                          child: Text(
                            _o.descripcion,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: cs.onSurface.withValues(alpha: .9),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _Acordeon(
                          titulo: 'Requisitos',
                          icon: Icons.checklist_rounded,
                          child: Column(
                            children: [
                              for (final r in _o.requisitos)
                                _filaCheck(cs, r),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _Acordeon(
                          titulo: 'Premios y beneficios',
                          icon: Icons.emoji_events_outlined,
                          child: Column(
                            children: [
                              for (final b in _o.beneficios)
                                _filaPunto(cs, b),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _Acordeon(
                          titulo: 'Cómo postular',
                          icon: Icons.format_list_numbered_rounded,
                          child: Column(
                            children: [
                              for (var i = 0; i < _o.pasos.length; i++)
                                _filaPaso(cs, i + 1, _o.pasos[i]),
                            ],
                          ),
                        ),
                        const SizedBox(height: 96),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // ── CTA fija inferior (sticky) ──
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    cs.surface.withValues(alpha: 0),
                    cs.surface,
                    cs.surface,
                  ],
                  stops: const [0, .25, 1],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: u == Urgencia.cerrada
                          ? null
                          : () async {
                              final url = Uri.parse(_o.url);
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              }
                            },
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: Text(
                        u == Urgencia.cerrada
                            ? 'Convocatoria cerrada'
                            : 'Postular en sitio oficial',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: conRecordatorio
                              ? AppColors.urgAbierto
                              : cs.outlineVariant,
                        ),
                        backgroundColor: conRecordatorio
                            ? AppColors.urgAbiertoBg
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _activando ? null : _toggleAvisarme,
                      icon: _activando
                          ? const SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(strokeWidth: 2))
                          : Icon(
                              conRecordatorio
                                  ? Icons.check_circle_rounded
                                  : Icons.notifications_active_rounded,
                              size: 18,
                              color: conRecordatorio
                                  ? AppColors.urgAbierto
                                  : cs.primary,
                            ),
                      label: Text(
                        conRecordatorio
                            ? 'Te avisaremos 7 · 3 · 1 día(s) antes'
                            : 'Avisarme antes del cierre',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: conRecordatorio
                              ? Color(0xFF047857)
                              : cs.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnCirculo(IconData icon, {required VoidCallback onTap, Color? color}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: const BoxDecoration(
              color: Colors.white, shape: BoxShape.circle),
          child: Icon(icon, size: 20, color: color ?? AppColors.primary),
        ),
      );

  Widget _metaItem(ColorScheme cs, IconData icon, String texto) => Column(
        children: [
          Icon(icon, size: 18, color: cs.onSurfaceVariant),
          const SizedBox(height: 4),
          Text(
            texto,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      );

  Widget _filaCheck(ColorScheme cs, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.check_circle_outline_rounded,
                size: 16, color: AppColors.urgAbierto),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(fontSize: 13, height: 1.45, color: cs.onSurface),
              ),
            ),
          ],
        ),
      );

  Widget _filaPunto(ColorScheme cs, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.only(top: 6),
              decoration:
                  BoxDecoration(color: cs.primary, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(fontSize: 13, height: 1.45, color: cs.onSurface),
              ),
            ),
          ],
        ),
      );

  Widget _filaPaso(ColorScheme cs, int n, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: cs.primary, borderRadius: BorderRadius.circular(7)),
              child: Text(
                '$n',
                style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(fontSize: 13, height: 1.45, color: cs.onSurface),
              ),
            ),
          ],
        ),
      );
}

/// Card del countdown con dígitos vivos.
class _CountdownCard extends StatelessWidget {
  const _CountdownCard({
    required this.faltan,
    required this.urgente,
    required this.cerrada,
    required this.deadline,
  });
  final Map<String, int> faltan;
  final bool urgente;
  final bool cerrada;
  final DateTime deadline;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = cerrada
        ? AppColors.urgCerradaBg
        : urgente
            ? AppColors.urgUrgenteBg
            : AppColors.urgProximoBg;
    final fg = cerrada
        ? AppColors.urgCerrada
        : urgente
            ? AppColors.urgUrgente
            : AppColors.urgProximo;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: fg.withValues(alpha: .3)),
      ),
      child: cerrada
          ? Row(children: [
              Icon(Icons.event_busy_rounded, color: fg, size: 22),
              const SizedBox(width: 10),
              Text(
                'Cerrada el ${Fechas.ddMmm(deadline)}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: fg),
              ),
            ])
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.timer_outlined, color: fg, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      'CIERRE DE INSCRIPCIONES',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .8,
                        color: fg,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _digito(faltan['d']!, 'días', fg),
                    _sep(fg),
                    _digito(faltan['h']!, 'hrs', fg),
                    _sep(fg),
                    _digito(faltan['m']!, 'min', fg),
                    _sep(fg),
                    _digito(faltan['s']!, 'seg', fg),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Fecha límite: ${Fechas.ddMmm(deadline)} · ${Fechas.hhmm(deadline)}',
                  style: TextStyle(fontSize: 11.5, color: cs.onSurfaceVariant),
                ),
              ],
            ),
    );
  }

  Widget _digito(int v, String label, Color fg) => Column(
        children: [
          Text(
            v.toString().padLeft(2, '0'),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: fg,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: .5,
              color: fg.withValues(alpha: .8),
            ),
          ),
        ],
      );

  Widget _sep(Color fg) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(':', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: fg)),
      );
}

/// Acordeón de sección de contenido.
class _Acordeon extends StatefulWidget {
  const _Acordeon({
    required this.titulo,
    required this.icon,
    required this.child,
  });
  final String titulo;
  final IconData icon;
  final Widget child;

  @override
  State<_Acordeon> createState() => _AcordeonState();
}

class _AcordeonState extends State<_Acordeon> {
  bool _abierto = true;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: .5)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: true,
          tilePadding: const EdgeInsets.symmetric(horizontal: 14),
          childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          onExpansionChanged: (v) => setState(() => _abierto = v),
          leading: Icon(widget.icon, size: 20, color: cs.primary),
          title: Text(
            widget.titulo,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: cs.onSurface,
            ),
          ),
          trailing: Icon(
            _abierto
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: cs.onSurfaceVariant,
          ),
          children: [widget.child],
        ),
      ),
    );
  }
}
