import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../models/models.dart';

/// Servicio de notificaciones locales: programa recordatorios de deadline
/// a 7 / 3 / 1 día(s) y el mismo día, según preferencias del usuario.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _inicializado = false;

  Future<void> init() async {
    if (_inicializado) return;
    tzdata.initializeTimeZones();
    // Los deadlines se definieron en hora local del usuario (Perú). Sin esto,
    // tz.local queda en UTC y los recordatorios sonarían 5 h tarde.
    tz.setLocalLocation(tz.getLocation('America/Lima'));

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(initSettings);
    _inicializado = true;
  }

  /// Pide permiso de notificaciones (Android 13+) y devuelve la decisión.
  Future<bool> pedirPermiso() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final granted = await android?.requestNotificationsPermission();
    return granted ?? true;
  }

  /// Programa todos los recordatorios de una oportunidad según las prefs.
  Future<void> programarRecordatorios(
      Opportunity o, UserPrefs prefs) async {
    if (!prefs.pushMaster) return;
    await init();
    await cancelarRecordatorios(o.id);

    final ahora = DateTime.now();
    final offsets = prefs.offsetsDias;
    for (final dias in offsets) {
      final momento = o.deadline.subtract(Duration(days: dias));
      if (!momento.isAfter(ahora)) continue;
      if (momento.difference(ahora).inDays > 60) continue; // no programar muy lejos

      final titulo = dias == 0
          ? '⏰ ¡Cierra HOY! ${_recortar(o.titulo)}'
          : '⏰ Cierra en $dias día${dias == 1 ? '' : 's'}: ${_recortar(o.titulo)}';
      final cuerpo = dias == 0
          ? 'El deadline es hoy a las ${_hhmm(o.deadline)}. Envía tu postulación ya.'
          : 'Te quedan $dias días para postular. Deadline: ${_fecha(o.deadline)} a las ${_hhmm(o.deadline)}.';

      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'recordatorios_deadline',
          'Recordatorios de deadline',
          channelDescription: 'Alertas anticipadas antes del cierre de cada convocatoria',
          importance: Importance.high,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          styleInformation: BigTextStyleInformation(''),
        ),
      );

      try {
        await _plugin.zonedSchedule(
          o.id.hashCode + dias,
          titulo,
          cuerpo,
          tz.TZDateTime.from(momento, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      } catch (e) {
        debugPrint('No se pudo programar recordatorio: $e');
      }
    }
  }

  Future<void> cancelarRecordatorios(String opportunityId) async {
    if (!_inicializado) return;
    for (final dias in const [0, 1, 3, 7]) {
      await _plugin.cancel(opportunityId.hashCode + dias);
    }
  }

  /// Dispara una notificación inmediata (usada al activar un recordatorio
  /// para dar feedback real al usuario).
  Future<void> mostrarConfirmacion(Opportunity o, List<int> offsets) async {
    if (!_inicializado) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'confirmaciones',
        'Confirmaciones',
        channelDescription: 'Confirmación de recordatorios activados',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
    );
    final cuando =
        offsets.map((d) => d == 0 ? 'el mismo día' : '$d d antes').join(' · ');
    await _plugin.show(
      o.id.hashCode,
      '🔔 Recordatorio activado',
      'Te avisaremos $cuando del cierre de "${_recortar(o.titulo)}".',
      details,
    );
  }

  String _recortar(String s, [int max = 48]) =>
      s.length <= max ? s : '${s.substring(0, max)}…';

  String _fecha(DateTime d) =>
      '${d.day} ${_meses[d.month - 1]} ${d.year}';

  String _hhmm(DateTime d) =>
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  static const _meses = [
    'ene', 'feb', 'mar', 'abr', 'may', 'jun',
    'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
  ];
}
