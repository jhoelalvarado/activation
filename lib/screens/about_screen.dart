import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Acerca de Activation.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de Activation')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  AppColors.primary,
                  AppColors.primaryContainer
                ]),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(Icons.bolt_rounded,
                  size: 44, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Activation',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          const Center(
            child: Text('v1.0.0 · Build 2026',
                style: TextStyle(fontSize: 12.5, color: Colors.grey)),
          ),
          const SizedBox(height: 20),
          Text(
            'Activation ayuda a jóvenes y profesionales de Perú a descubrir a tiempo becas, hackathons, torneos de gaming, programas de empleo y convocatorias de innovación — con alertas anticipadas antes de cada deadline.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.6,
              color: cs.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _titulo('Cómo funciona'),
          _punto(cs, 'Centraliza convocatorias de fuentes confiables'),
          _punto(cs, 'Calcula la urgencia de cada deadline en tiempo real'),
          _punto(cs, 'Te alerta 7, 3 y 1 día antes, y el mismo día si lo activas'),
          _punto(cs, 'Respeta tu descanso con el horario de silencio'),
          const SizedBox(height: 16),
          _titulo('Tecnología'),
          _punto(cs, 'Flutter 3 · Material 3 · Riverpod'),
          _punto(cs, 'Notificaciones locales programadas'),
          _punto(cs, '100% offline-first: tus datos viven en tu dispositivo'),
          const SizedBox(height: 16),
          _titulo('Licencia'),
          const Text(
            'Código abierto bajo licencia MIT. Hecho con ⚡ en Perú.',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _titulo(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          t,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      );

  Widget _punto(ColorScheme cs, String texto) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 5,
              height: 5,
              margin: const EdgeInsets.only(top: 7),
              decoration:
                  BoxDecoration(color: cs.primary, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(fontSize: 13, height: 1.45, color: cs.onSurfaceVariant),
              ),
            ),
          ],
        ),
      );
}
