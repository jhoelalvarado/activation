import 'dart:math';

import 'package:flutter/material.dart';

import '../models/models.dart';
import '../theme/app_theme.dart';

/// Helpers de formato de fechas en español (Perú).
class Fechas {
  static const _meses = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
  ];
  static const _dias = ['LUN', 'MAR', 'MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM'];
  static const _mesesLargos = [
    'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
  ];

  static String ddMmm(DateTime d) => '${d.day} ${_meses[d.month - 1]}';
  static String hhmm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  static String mesAnio(DateTime d) => '${_mesesLargos[d.month - 1]} ${d.year}';
  static String diaSemana(DateTime d) => _dias[d.weekday - 1];
  static String nombreMes(int m) => _mesesLargos[m - 1];

  static String hace(DateTime d, DateTime ahora) {
    final diff = ahora.difference(d);
    if (diff.inMinutes < 1) return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'hace ${diff.inHours} h';
    if (diff.inDays < 7) return 'hace ${diff.inDays} días';
    return '${d.day} ${_meses[d.month - 1]}';
  }
}

/// Color e icono por categoría.
extension CategoriaUI on Categoria {
  Color get color => switch (this) {
        Categoria.becas => AppColors.catBecas,
        Categoria.hackathones => AppColors.catHackathones,
        Categoria.gaming => AppColors.catGaming,
        Categoria.educacion => AppColors.catEducacion,
        Categoria.empleo => AppColors.catEmpleo,
        Categoria.ciencia => AppColors.catCiencia,
      };

  IconData get icon => switch (this) {
        Categoria.becas => Icons.school_rounded,
        Categoria.hackathones => Icons.terminal_rounded,
        Categoria.gaming => Icons.sports_esports_rounded,
        Categoria.educacion => Icons.menu_book_rounded,
        Categoria.empleo => Icons.work_rounded,
        Categoria.ciencia => Icons.rocket_launch_rounded,
      };

  Color get colorSuave => color.withValues(alpha: .12);
}

extension UrgenciaUI on Urgencia {
  Color get color => switch (this) {
        Urgencia.abierto => AppColors.urgAbierto,
        Urgencia.proximo => AppColors.urgProximo,
        Urgencia.urgente => AppColors.urgUrgente,
        Urgencia.cerrada => AppColors.urgCerrada,
      };

  Color get colorBg => switch (this) {
        Urgencia.abierto => AppColors.urgAbiertoBg,
        Urgencia.proximo => AppColors.urgProximoBg,
        Urgencia.urgente => AppColors.urgUrgenteBg,
        Urgencia.cerrada => AppColors.urgCerradaBg,
      };

  String texto(DateTime ahora, DateTime deadline) {
    final dias = deadline.difference(ahora).inDays;
    return switch (this) {
      Urgencia.abierto => 'Abierto (${dias}d)',
      Urgencia.proximo => 'Cierra en ${dias}d',
      Urgencia.urgente => '¡ÚLTIMOS ${max(dias, 0)}d!',
      Urgencia.cerrada => 'Cerrada',
    };
  }
}

/// Badge pill de categoría.
class CategoriaBadge extends StatelessWidget {
  const CategoriaBadge({super.key, required this.categoria, this.filled});
  final Categoria categoria;
  final bool? filled;

  @override
  Widget build(BuildContext context) {
    final f = filled ?? true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: f ? categoria.color : categoria.colorSuave,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        categoria.label.split(' ')[0].toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: .4,
          color: f ? Colors.white : categoria.color,
        ),
      ),
    );
  }
}

/// Badge de urgencia con la regla de colores global.
class UrgenciaBadge extends StatelessWidget {
  const UrgenciaBadge({super.key, required this.o, required this.ahora});
  final Opportunity o;
  final DateTime ahora;

  @override
  Widget build(BuildContext context) {
    final u = o.urgenciaAhora(ahora);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: u.colorBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: u.color.withValues(alpha: .35)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (u == Urgencia.urgente)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(Icons.local_fire_department_rounded,
                size: 12, color: u.color),
          ),
        if (u == Urgencia.abierto)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(Icons.radio_button_checked_rounded,
                size: 11, color: u.color),
          ),
        Text(
          u.texto(ahora, o.deadline),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: .3,
            color: u.color,
          ),
        ),
      ]),
    );
  }
}

/// Chip compacto de metadatos (fecha, lugar, costo).
class MetaChip extends StatelessWidget {
  const MetaChip({super.key, required this.icon, required this.texto});
  final IconData icon;
  final String texto;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: cs.onSurfaceVariant),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            texto,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: cs.onSurfaceVariant),
          ),
        ),
      ]),
    );
  }
}

/// Botón de corazón (guardar) con estado.
class CorazonButton extends StatelessWidget {
  const CorazonButton({
    super.key,
    required this.activo,
    required this.onTap,
    this.tamano = 40,
    this.fondo,
  });
  final bool activo;
  final VoidCallback onTap;
  final double tamano;
  final Color? fondo;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tamano,
        height: tamano,
        decoration: BoxDecoration(
          color: fondo ??
              (activo ? AppColors.urgUrgenteBg : cs.surfaceContainerLow),
          shape: BoxShape.circle,
        ),
        child: Icon(
          activo ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          size: tamano * 0.5,
          color: activo ? AppColors.urgUrgente : cs.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Cabecera de sección con acción "Ver todo".
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.titulo,
    this.icon,
    this.accionLabel,
    this.accionColor,
    this.onAccion,
  });
  final String titulo;
  final IconData? icon;
  final String? accionLabel;
  final Color? accionColor;
  final VoidCallback? onAccion;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 20),
      child: Row(children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: accionColor ?? cs.primary),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -.4,
              color: cs.onSurface,
            ),
          ),
        ),
        if (accionLabel != null)
          GestureDetector(
            onTap: onAccion,
            child: Row(children: [
              Text(
                accionLabel!,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: accionColor ?? cs.primary,
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  size: 18, color: accionColor ?? cs.primary),
            ]),
          ),
      ]),
    );
  }
}

/// Estado vacío ilustrado con CTA.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.titulo,
    required this.mensaje,
    this.ctaLabel,
    this.onCta,
  });
  final IconData icon;
  final String titulo;
  final String mensaje;
  final String? ctaLabel;
  final VoidCallback? onCta;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: .08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: cs.primary),
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.5,
                color: cs.onSurfaceVariant,
              ),
            ),
            if (ctaLabel != null) ...[
              const SizedBox(height: 20),
              FilledButton(onPressed: onCta, child: Text(ctaLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Skeleton con shimmer para estados de carga.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, required this.child, this.radius = 16});
  final Widget child;
  final double radius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
        ..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final t = _c.value;
        return ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(-1 + 2 * t, 0),
            end: Alignment(0 + 2 * t, 0),
            colors: [
              cs.surfaceContainer,
              cs.surfaceContainerHighest.withValues(alpha: .7),
              cs.surfaceContainer,
            ],
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Card skeleton para feed en carga.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.alto = 260});
  final double alto;

  @override
  Widget build(BuildContext context) {
    return ShimmerBox(
      child: Container(
        height: alto,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
