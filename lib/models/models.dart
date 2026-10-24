/// Categorías de oportunidades enfocadas en Perú.
enum Categoria {
  becas('Becas & Ayudas', 'school'),
  hackathones('Hackathons', 'terminal'),
  gaming('Gaming & Esports', 'sports_esports'),
  educacion('Educación & Bootcamps', 'menu_book'),
  empleo('Empleo Tech & Pasantías', 'work'),
  ciencia('Ciencia, DeepTech & Startups', 'rocket_launch');

  const Categoria(this.label, this.iconName);
  final String label;
  final String iconName;
}

/// Nivel de urgencia derivado del deadline.
enum Urgencia { abierto, proximo, urgente, cerrada }

/// Modelo central de la app: una convocatoria/oportunidad.
class Opportunity {
  const Opportunity({
    required this.id,
    required this.titulo,
    required this.organizacion,
    required this.orgVerificada,
    required this.categoria,
    required this.descripcion,
    required this.requisitos,
    required this.beneficios,
    required this.pasos,
    required this.deadline,
    required this.publicadoAt,
    required this.modalidad,
    required this.lugar,
    required this.costo,
    required this.publico,
    required this.url,
    this.destacada = false,
    this.premio,
  });

  final String id;
  final String titulo;
  final String organizacion;
  final bool orgVerificada;
  final Categoria categoria;
  final String descripcion;
  final List<String> requisitos;
  final List<String> beneficios;
  final List<String> pasos;
  final DateTime deadline;
  final DateTime publicadoAt;
  final String modalidad; // Presencial / Online / Híbrido
  final String lugar; // Lima, Remoto / Perú…
  final String costo; // Gratis / S/ 50 / Cobertura 100%
  final String publico; // Jóvenes 18-29, universitarios…
  final String url;
  final bool destacada;
  final String? premio;

  Urgencia urgenciaAhora(DateTime ahora) {
    final d = deadline;
    if (d.isBefore(ahora)) return Urgencia.cerrada;
    final dias = d.difference(ahora).inDays;
    if (dias < 7) return Urgencia.urgente;
    if (dias < 30) return Urgencia.proximo;
    return Urgencia.abierto;
  }

  /// Progreso 0..1 del tiempo transcurrido desde la publicación hasta el cierre.
  double progresoTranscurrido(DateTime ahora) {
    final total = deadline.difference(publicadoAt).inMinutes;
    if (total <= 0) return 1;
    final usado = ahora.difference(publicadoAt).inMinutes;
    if (usado <= 0) return 0;
    return (usado / total).clamp(0.0, 1.0);
  }

  factory Opportunity.fromJson(Map<String, dynamic> j) => Opportunity(
        id: j['id'],
        titulo: j['titulo'],
        organizacion: j['organizacion'],
        orgVerificada: j['orgVerificada'] ?? true,
        categoria: Categoria.values.firstWhere((c) => c.name == j['categoria']),
        descripcion: j['descripcion'],
        requisitos: List<String>.from(j['requisitos']),
        beneficios: List<String>.from(j['beneficios']),
        pasos: List<String>.from(j['pasos']),
        deadline: DateTime.parse(j['deadline']),
        publicadoAt: DateTime.parse(j['publicadoAt']),
        modalidad: j['modalidad'],
        lugar: j['lugar'],
        costo: j['costo'],
        publico: j['publico'],
        url: j['url'],
        destacada: j['destacada'] ?? false,
        premio: j['premio'],
      );
}

/// Notificación in-app de la bandeja de alertas.
enum TipoAlerta { urgente, nueva, recordatorio, aceptado }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.tipo,
    required this.titulo,
    required this.cuerpo,
    required this.createdAt,
    required this.leida,
    this.opportunityId,
  });

  final String id;
  final TipoAlerta tipo;
  final String titulo;
  final String cuerpo;
  final DateTime createdAt;
  final bool leida;
  final String? opportunityId;

  AppNotification copyWith({bool? leida}) => AppNotification(
        id: id,
        tipo: tipo,
        titulo: titulo,
        cuerpo: cuerpo,
        createdAt: createdAt,
        leida: leida ?? this.leida,
        opportunityId: opportunityId,
      );
}

/// Preferencias del usuario (persistidas).
class UserPrefs {
  UserPrefs({
    this.onboardingHecho = false,
    this.pushMaster = true,
    this.alertasSonoras = true,
    this.resumenSemanal = false,
    this.categoriasActivas = const {
      Categoria.becas: true,
      Categoria.hackathones: true,
      Categoria.gaming: true,
      Categoria.educacion: false,
      Categoria.empleo: true,
      Categoria.ciencia: true,
    },
    this.interests = const {
      Categoria.hackathones,
      Categoria.becas,
      Categoria.gaming,
      Categoria.ciencia,
    },
    this.recordar7 = true,
    this.recordar3 = true,
    this.recordar1 = true,
    this.recordarMismoDia = false,
    this.silencioActivo = true,
    this.silencioInicio = '23:00',
    this.silencioFin = '07:00',
    this.tema = 'sistema', // sistema | claro | oscuro
  });

  final bool onboardingHecho;
  final bool pushMaster;
  final bool alertasSonoras;
  final bool resumenSemanal;
  final Map<Categoria, bool> categoriasActivas;
  final Set<Categoria> interests;
  final bool recordar7;
  final bool recordar3;
  final bool recordar1;
  final bool recordarMismoDia;
  final bool silencioActivo;
  final String silencioInicio;
  final String silencioFin;
  final String tema;

  UserPrefs copyWith({
    bool? onboardingHecho,
    bool? pushMaster,
    bool? alertasSonoras,
    bool? resumenSemanal,
    Map<Categoria, bool>? categoriasActivas,
    Set<Categoria>? interests,
    bool? recordar7,
    bool? recordar3,
    bool? recordar1,
    bool? recordarMismoDia,
    bool? silencioActivo,
    String? silencioInicio,
    String? silencioFin,
    String? tema,
  }) =>
      UserPrefs(
        onboardingHecho: onboardingHecho ?? this.onboardingHecho,
        pushMaster: pushMaster ?? this.pushMaster,
        alertasSonoras: alertasSonoras ?? this.alertasSonoras,
        resumenSemanal: resumenSemanal ?? this.resumenSemanal,
        categoriasActivas: categoriasActivas ?? this.categoriasActivas,
        interests: interests ?? this.interests,
        recordar7: recordar7 ?? this.recordar7,
        recordar3: recordar3 ?? this.recordar3,
        recordar1: recordar1 ?? this.recordar1,
        recordarMismoDia: recordarMismoDia ?? this.recordarMismoDia,
        silencioActivo: silencioActivo ?? this.silencioActivo,
        silencioInicio: silencioInicio ?? this.silencioInicio,
        silencioFin: silencioFin ?? this.silencioFin,
        tema: tema ?? this.tema,
      );

  List<int> get offsetsDias {
    final l = <int>[];
    if (recordar7) l.add(7);
    if (recordar3) l.add(3);
    if (recordar1) l.add(1);
    if (recordarMismoDia) l.add(0);
    return l;
  }
}
