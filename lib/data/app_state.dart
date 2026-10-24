import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';
import 'seed_data.dart';

/// Instancia global única del estado de la app (asignada en main()).
late final AppState appState;

/// Estado global de la aplicación con persistencia local.
/// Un solo ChangeNotifier mantiene todo consistente entre pantallas.
class AppState extends ChangeNotifier {
  AppState() {
    _load();
  }

  late List<Opportunity> oportunidades = SeedData.oportunidades();
  List<AppNotification> _notificaciones = SeedData.notificaciones();
  final Set<String> _guardadas = {};
  final Set<String> _recordatoriosActivos = {};
  UserPrefs prefs = UserPrefs();

  bool _cargado = false;

  List<AppNotification> get notificaciones => _notificaciones;
  int get noLeidas => _notificaciones.where((n) => !n.leida).length;
  bool get cargado => _cargado;

  bool estaGuardada(String id) => _guardadas.contains(id);
  bool tieneRecordatorio(String id) => _recordatoriosActivos.contains(id);
  List<String> get guardadasIds => _guardadas.toList();
  int get totalGuardadas => _guardadas.length;
  int get alertasActivas =>
      _recordatoriosActivos.length + _notificaciones.where((n) => !n.leida).length;

  List<Opportunity> get guardadas =>
      oportunidades.where((o) => _guardadas.contains(o.id)).toList()
        ..sort((a, b) => a.deadline.compareTo(b.deadline));

  // ── Carga / guardado ────────────────────────────────────────────────
  Future<void> _load() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final guardadas = sp.getStringList('guardadas');
      if (guardadas != null) _guardadas.addAll(guardadas);
      final rec = sp.getStringList('recordatorios');
      if (rec != null) _recordatoriosActivos.addAll(rec);
      final prefsJson = sp.getString('prefs');
      if (prefsJson != null) prefs = _prefsFromJson(jsonDecode(prefsJson));
      final notsJson = sp.getString('notificaciones');
      if (notsJson != null) {
        _notificaciones = (jsonDecode(notsJson) as List)
            .map((e) => _notifFromJson(e))
            .toList();
      }
    } catch (_) {
      // Primera ejecución o datos corruptos: mantener semillas.
    }
    _cargado = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList('guardadas', _guardadas.toList());
    await sp.setStringList('recordatorios', _recordatoriosActivos.toList());
    await sp.setString('prefs', jsonEncode(_prefsToJson(prefs)));
    await sp.setString(
        'notificaciones', jsonEncode(_notificaciones.map(_notifToJson).toList()));
    // Clave leída por main() al arrancar: sin esto el onboarding se repite
    // en cada reinicio de la app.
    await sp.setBool('onboarding_visto', prefs.onboardingHecho);
  }

  // ── Guardados ───────────────────────────────────────────────────────
  void toggleGuardada(String id) {
    if (!_guardadas.add(id)) _guardadas.remove(id);
    _persist();
    notifyListeners();
  }

  // ── Recordatorios ───────────────────────────────────────────────────
  void setRecordatorio(String id, bool activo) {
    if (activo) {
      _recordatoriosActivos.add(id);
    } else {
      _recordatoriosActivos.remove(id);
    }
    _persist();
    notifyListeners();
  }

  // ── Notificaciones ──────────────────────────────────────────────────
  void marcarLeida(String id) {
    _notificaciones =
        _notificaciones.map((n) => n.id == id ? n.copyWith(leida: true) : n).toList();
    _persist();
    notifyListeners();
  }

  void marcarTodasLeidas() {
    _notificaciones = _notificaciones.map((n) => n.copyWith(leida: true)).toList();
    _persist();
    notifyListeners();
  }

  void eliminarNotificacion(String id) {
    _notificaciones.removeWhere((n) => n.id == id);
    _persist();
    notifyListeners();
  }

  void pushAlerta(AppNotification n) {
    _notificaciones.insert(0, n);
    _persist();
    notifyListeners();
  }

  // ── Preferencias ────────────────────────────────────────────────────
  void updatePrefs(UserPrefs Function(UserPrefs) updater) {
    prefs = updater(prefs);
    _persist();
    notifyListeners();
  }

  void terminarOnboarding(Set<Categoria> intereses) {
    // IMPORTANTE: crear un mapa NUEVO. El mapa por defecto de UserPrefs es
    // `const` (inmutable) y mutarlo directo lanza UnsupportedError en release,
    // lo que bloqueaba el avance del onboarding de forma silenciosa.
    final cats = Map<Categoria, bool>.from(prefs.categoriasActivas);
    for (final c in Categoria.values) {
      cats[c] = intereses.contains(c);
    }
    prefs = prefs.copyWith(
      onboardingHecho: true,
      interests: intereses,
      categoriasActivas: cats,
    );
    _persist();
    notifyListeners();
  }

  // ── Serialización ───────────────────────────────────────────────────
  Map<String, dynamic> _prefsToJson(UserPrefs p) => {
        'onboardingHecho': p.onboardingHecho,
        'pushMaster': p.pushMaster,
        'alertasSonoras': p.alertasSonoras,
        'resumenSemanal': p.resumenSemanal,
        'categorias': p.categoriasActivas.map((k, v) => MapEntry(k.name, v)),
        'interests': p.interests.map((c) => c.name).toList(),
        'recordar7': p.recordar7,
        'recordar3': p.recordar3,
        'recordar1': p.recordar1,
        'recordarMismoDia': p.recordarMismoDia,
        'silencioActivo': p.silencioActivo,
        'silencioInicio': p.silencioInicio,
        'silencioFin': p.silencioFin,
        'tema': p.tema,
      };

  UserPrefs _prefsFromJson(Map<String, dynamic> j) => UserPrefs(
        onboardingHecho: j['onboardingHecho'] ?? false,
        pushMaster: j['pushMaster'] ?? true,
        alertasSonoras: j['alertasSonoras'] ?? true,
        resumenSemanal: j['resumenSemanal'] ?? false,
        categoriasActivas: {
          for (final c in Categoria.values)
            c: (j['categorias'] as Map<String, dynamic>?)?[c.name] ?? false,
        },
        interests: {
          for (final n in (j['interests'] as List? ?? []))
            Categoria.values.firstWhere((c) => c.name == n, orElse: () => Categoria.becas),
        },
        recordar7: j['recordar7'] ?? true,
        recordar3: j['recordar3'] ?? true,
        recordar1: j['recordar1'] ?? true,
        recordarMismoDia: j['recordarMismoDia'] ?? false,
        silencioActivo: j['silencioActivo'] ?? true,
        silencioInicio: j['silencioInicio'] ?? '23:00',
        silencioFin: j['silencioFin'] ?? '07:00',
        tema: j['tema'] ?? 'sistema',
      );

  Map<String, dynamic> _notifToJson(AppNotification n) => {
        'id': n.id,
        'tipo': n.tipo.name,
        'titulo': n.titulo,
        'cuerpo': n.cuerpo,
        'createdAt': n.createdAt.toIso8601String(),
        'leida': n.leida,
        'opportunityId': n.opportunityId,
      };

  AppNotification _notifFromJson(Map<String, dynamic> j) => AppNotification(
        id: j['id'],
        tipo: TipoAlerta.values.firstWhere((t) => t.name == j['tipo'],
            orElse: () => TipoAlerta.nueva),
        titulo: j['titulo'],
        cuerpo: j['cuerpo'],
        createdAt: DateTime.parse(j['createdAt']),
        leida: j['leida'] ?? false,
        opportunityId: j['opportunityId'],
      );
}
