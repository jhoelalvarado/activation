import '../models/models.dart';

/// Datos iniciales enfocados en Perú. Las fechas son RELATIVAS al primer
/// arranque (siempre habrá oportunidades urgentes, próximas y abiertas).
class SeedData {
  static final DateTime _t0 = DateTime.now();

  static DateTime _en(int dias, {int hora = 23, int min = 59}) {
    final d = _t0.add(Duration(days: dias));
    return DateTime(d.year, d.month, d.day, hora, min);
  }

  static DateTime _atras(int dias) => _t0.subtract(Duration(days: dias));

  static List<Opportunity> oportunidades() => [
        // ── URGENTES (< 7 días) ──────────────────────────────────────────
        Opportunity(
          id: 'hack-ia-nacional-2026',
          titulo: 'Hackathon Nacional IA 2026: Generative Intelligence for Impact',
          organizacion: 'Google Developers Lima · UNSA',
          orgVerificada: true,
          categoria: Categoria.hackathones,
          descripcion:
              '54 horas para diseñar y desplegable agentes de IA que resuelvan problemáticas críticas de educación, sostenibilidad y salud pública en Perú. Acceso irrestricto a modelos fundacionales (Claude 3.7 Sonnet y Vertex AI de Google Cloud), mentoría técnica en vivo y demo day con jurados de la industria.',
          requisitos: [
            'Estudiantes universitarios, graduados o entusiastas tech mayores de 18 años',
            'Repositorio de código abierto (GitHub/GitLab) con commit inicial fechado durante el evento',
            'Video pitch demostrativo (MVP funcional en vivo) no superior a 3 minutos',
          ],
          beneficios: [
            'Bolsa total garantizada de USD 50,000 en premios',
            '1er lugar: USD 25,000 cash + USD 10,000 en créditos Vertex AI',
            '2do y 3er lugar: USD 15,000 y USD 10,000 + créditos',
            'Fast-track: entrevistas directas de contratación técnica',
          ],
          pasos: [
            'Registro previo: completa el formulario en Devpost oficial antes del cierre',
            'Envío de MVP: sube tu código y el video pitch con acceso público',
            'Demo Day en vivo: los 10 mejores equipos presentarán ante jurados de Google y Anthropic',
          ],
          deadline: _en(2),
          publicadoAt: _atras(12),
          modalidad: 'Online',
          lugar: 'Remoto / Perú',
          costo: 'Gratis',
          publico: 'Mayores de 18 años',
          url: 'https://devpost.com',
          destacada: true,
          premio: 'USD 50,000',
        ),
        Opportunity(
          id: 'beca-santander-ia-robotica',
          titulo: 'Beca de Posgrado en Inteligencia Artificial y Robótica',
          organizacion: 'Fundación Santander & MIT Lab',
          orgVerificada: true,
          categoria: Categoria.becas,
          descripcion:
              'Programa de excelencia que financia maestrías y doctorados en IA y robótica en universidades asociadas de América Latina y Europa. Incluye matrícula completa, manutención mensual, pasaje aéreo y red de mentoring con investigadores del MIT CSAIL.',
          requisitos: [
            'Título de pregrado en carreras STEM con promedio ponderado mínimo de 16/20',
            'Carta de motivación enfocada en impacto para Latinoamérica',
            'Dos cartas de recomendación académicas',
            'Nivel de inglés B2 certificado (o examen en línea del programa)',
          ],
          beneficios: [
            'Cobertura 100% de matrícula y tasas académicas',
            'Asignación mensual de manutención durante toda la maestría',
            'Pasajes aéreos y seguro médico internacional',
            'Acceso a la red de alumni Santander Universities',
          ],
          pasos: [
            'Regístrate en el portal Santander Open Academy',
            'Completa el formulario con tus certificados de notas',
            'Adjunta cartas de recomendación y video de presentación',
            'Espera la preselección y entrevista con el comité académico',
          ],
          deadline: _en(6),
          publicadoAt: _atras(20),
          modalidad: 'Híbrido',
          lugar: 'Lima / Madrid',
          costo: 'Cobertura 100%',
          publico: 'Egresados STEM',
          url: 'https://www.becas-santander.com',
          destacada: true,
        ),
        Opportunity(
          id: 'torneo-valorant-uni-lima',
          titulo: 'Copa Universitaria Valorant — Torneo Clausura Lima',
          organizacion: 'Liga Universitaria Esports Perú',
          orgVerificada: true,
          categoria: Categoria.gaming,
          descripcion:
              'Torneo oficial interuniversitario con equipos de 5 jugadores de universidades de Lima. Fase de grupos online y playoffs presenciales en gaming house de San Isidro. Transmisión por stream con casting profesional.',
          requisitos: [
            'Equipo de 5 titulares + 1 suplente matriculados en la misma universidad',
            'Rango mínimo Radiante/Inmortal 2 en la cuenta principal',
            'Constancia de matrícula del ciclo vigente',
          ],
          beneficios: [
            'S/ 8,000 en premios para el campeón',
            'S/ 3,000 para el subcampeón y periféricos gaming',
            'Pase directo al nacional universitario 2027',
            'Sesión de scouting con orgs profesionales de la región',
          ],
          pasos: [
            'Inscribe a tu equipo en el formulario de la liga',
            'Verificación de cuentas y matrículas por el comité',
            'Fase de grupos: bo3 online en semanas 1-3',
            'Playoffs presenciales y gran final con público',
          ],
          deadline: _en(4),
          publicadoAt: _atras(9),
          modalidad: 'Híbrido',
          lugar: 'Lima',
          costo: 'S/ 30 por equipo',
          publico: 'Universitarios',
          url: 'https://www.ligaupe.edu.pe',
        ),

        // ── PRÓXIMOS (7-30 días) ─────────────────────────────────────────
        Opportunity(
          id: 'beca-oea-transformacion',
          titulo: 'Beca OEA – Transformación Digital para el Estado',
          organizacion: 'OEA & Red Clara',
          orgVerificada: true,
          categoria: Categoria.becas,
          descripcion:
              'Fondo global de la Organización de los Estados Americanos para formación de funcionarios y profesionales jóvenes en gobierno digital, ciberseguridad y datos abiertos. Modalidad online con certificación de universidades asociadas.',
          requisitos: [
            'Ser ciudadano de un Estado miembro de la OEA',
            'Grado universitario o último ciclo',
            'Formulario de compromiso institucional',
          ],
          beneficios: [
            'USD 15,000 en cobertura educativa por beneficiario',
            'Certificación internacional con aval académico',
            'Red de profesionales de gobierno digital de las Américas',
          ],
          pasos: [
            'Postula en el portal de becas académicas de la OEA',
            'Adjunta carta de compromiso y CV',
            'Entrevista virtual con el comité nacional',
          ],
          deadline: _en(12),
          publicadoAt: _atras(15),
          modalidad: 'Online',
          lugar: 'Remoto / Perú',
          costo: 'Cobertura 100%',
          publico: 'Profesionales jóvenes',
          url: 'https://www.educoas.org',
          premio: 'USD 15,000',
        ),
        Opportunity(
          id: 'startup-peru-2026',
          titulo: 'Startup Perú 2026 — Fondo de Aceleración',
          organizacion: 'PRODUCE · Innovación Perú',
          orgVerificada: true,
          categoria: Categoria.ciencia,
          descripcion:
              'Concurso nacional de fondos concursables para startups en etapa temprana y de crecimiento. Financia validación comercial, desarrollo de producto y escalamiento de soluciones con impacto productivo.',
          requisitos: [
            'Startup constituida legalmente en Perú (o compromiseda a constituirse)',
            'Producto mínimo viable en operación',
            'Equipo fundador de al menos 2 personas dedicadas',
          ],
          beneficios: [
            'Hasta S/ 300,000 de financiamiento no reembolsable',
            'Mentoría de 6 meses con operadores de ecosistema',
            'Accesso a fondos de inversión ángel asociados',
          ],
          pasos: [
            'Registra tu startup en el portal PRODUCE',
            'Postula tu plan de negocio con modelo financiero',
            'Pitch ante el jurado evaluador',
          ],
          deadline: _en(18),
          publicadoAt: _atras(25),
          modalidad: 'Híbrido',
          lugar: 'Lima / Perú',
          costo: 'Gratis',
          publico: 'Fundadores',
          url: 'https://www.gob.pe/produce',
        ),
        Opportunity(
          id: 'trainee-bcp-2027',
          titulo: 'Programa Trainee BCP 2027 — Data & Product',
          organizacion: 'Banco de Crédito del Perú',
          orgVerificada: true,
          categoria: Categoria.empleo,
          descripcion:
              'Programa de desarrollo de líderes para recién graduados con rotación por áreas de datos, producto digital y core bancario. Incluye mentoría ejecutiva, rotaciones trimestrales y oportunidad de carrera en el grupo Credicorp.',
          requisitos: [
            'Egresado o titulado (menos de 2 años) de carreras STEM o economía',
            'Inglés intermedio-avanzado',
            'Disponibilidad full-time en Lima',
          ],
          beneficios: [
            'Remuneración competitiva + bonos por desempeño',
            'Rotación por 3 áreas estratégicas en 18 meses',
            'Mentoría 1:1 con gerentes senior',
          ],
          pasos: [
            'Postula online con CV actualizado',
            'Assessment online (lógica y análisis)',
            'Assessment center y entrevistas con área',
          ],
          deadline: _en(15),
          publicadoAt: _atras(18),
          modalidad: 'Presencial',
          lugar: 'Lima',
          costo: 'Gratis',
          publico: 'Recién graduados',
          url: 'https://empleos.viaempresa.pe',
        ),
        Opportunity(
          id: 'game-jam-lima-2026',
          titulo: 'Game Jam Lima 2026 — Edición Retro+',
          organizacion: 'IGDA Perú · PUCP',
          orgVerificada: true,
          categoria: Categoria.gaming,
          descripcion:
              '48 horas para crear un videojuego desde cero alrededor de un tema secreto. Participan artistas, programadores, músicos y game designers. Los mejores juegos se presentan en la feria de juegos independientes de Lima.',
          requisitos: [
            'Registro individual o en equipo (máx. 5 personas)',
            'Laptop propia (los labs de PUCP disponibles de noche)',
            'Ganas de construir algo jugable en 48 horas',
          ],
          beneficios: [
            'Premios por categoría: mejor juego, mejor arte, mejor audio',
            'Exposición en la feria indie de Lima',
            'Kit de assets y licencias de herramientas patrocinadas',
          ],
          pasos: [
            'Regístrate en la página de IGDA Perú',
            'Asiste a la apertura y conoce el tema secreto',
            'Construye y sube tu juego antes del plazo',
          ],
          deadline: _en(9),
          publicadoAt: _atras(7),
          modalidad: 'Presencial',
          lugar: 'Lima · PUCP',
          costo: 'S/ 20',
          publico: 'Público general',
          url: 'https://igda.pe',
        ),
        Opportunity(
          id: 'pronabec-tecnico-2026',
          titulo: 'Beca PRONABEC Talento Técnico Productivo',
          organizacion: 'PRONABEC · Minedu',
          orgVerificada: true,
          categoria: Categoria.becas,
          descripcion:
              'Beca del Estado peruano para estudiar carreras técnicas productivas en institutos de educación superior licenciados. Cubre matrícula, pensión, materiales y apoyo socioemocional durante toda la carrera.',
          requisitos: [
            'Egresado de secundaria en colegio público o privado',
            'Promedio mínimo de 14 en los dos últimos años',
            'Evaluar situación socioeconómica del hogar',
          ],
          beneficios: [
            'Matrícula y pensión cubiertas al 100%',
            'Kit de materiales y computadora portátil',
            'Acompañamiento socioemocional y tutorías',
          ],
          pasos: [
            'Crea tu cuenta en el portal único de PRONABEC',
            'Completa el formulario socioeconómico',
            'Presenta documentación y evalúa tu rendimiento',
          ],
          deadline: _en(21),
          publicadoAt: _atras(30),
          modalidad: 'Presencial',
          lugar: 'Todo el Perú',
          costo: 'Cobertura 100%',
          publico: 'Jóvenes de 16-29 años',
          url: 'https://www.pronabec.gob.pe',
        ),
        Opportunity(
          id: 'devfest-lima-2026',
          titulo: 'DevFest Lima 2026 — Google Developers Festival',
          organizacion: 'Google Developer Groups Lima',
          orgVerificada: true,
          categoria: Categoria.educacion,
          descripcion:
              'El festival anual de comunidades técnicas de Google en Perú: charlas de IA generativa, Android, cloud y web, workshops hands-on y networking con más de 500 developers.',
          requisitos: [
            'Registro previo (cupos limitados)',
            'Interés por las tecnologías de desarrollo actuales',
          ],
          beneficios: [
            'Acceso a todas las charlas y workshops',
            'Certificado de asistencia',
            'Kit de desarrollador y sorteos',
          ],
          pasos: [
            'Compra o reserva tu entrada en la web del evento',
            'Elige tus talleres (cupos por orden de registro)',
            'Asiste con tu QR de ingreso',
          ],
          deadline: _en(25),
          publicadoAt: _atras(12),
          modalidad: 'Presencial',
          lugar: 'Lima',
          costo: 'S/ 40',
          publico: 'Developers y estudiantes',
          url: 'https://gdg.community.dev',
        ),

        // ── ABIERTOS (> 30 días) ─────────────────────────────────────────
        Opportunity(
          id: 'beca-presidentes-2027',
          titulo: 'Beca Presidentes de la República 2027',
          organizacion: 'PRONABEC',
          orgVerificada: true,
          categoria: Categoria.becas,
          descripcion:
              'Beca de posgrado de alta competencia para estudiar maestrías y doctorados en las 100 mejores universidades del mundo, financiada por el Estado peruano.',
          requisitos: [
            'Titulado universitario con promedio sobresaliente',
            'Admisión a programa de posgrado de universidad top-100',
            'Compromiso de retorno y repatriación de conocimiento',
          ],
          beneficios: [
            'Cobertura total de estudios y manutención',
            'Pasajes y seguro internacional',
            'Red de becarizados en el mundo',
          ],
          pasos: [
            'Postula tu admisión a la universidad objetivo',
            'Registra tu postulación en el portal PRONABEC',
            'Evalúa tu expediente el comité nacional',
          ],
          deadline: _en(45),
          publicadoAt: _atras(5),
          modalidad: 'Presencial',
          lugar: 'Internacional',
          costo: 'Cobertura 100%',
          publico: 'Titulados peruanos',
          url: 'https://www.pronabec.gob.pe',
        ),
        Opportunity(
          id: 'gamergy-peru-2026',
          titulo: 'Gamergy Perú 2026 — Clasificatorias Abiertas',
          organizacion: 'IFEMA & Gamergy Latam',
          orgVerificada: true,
          categoria: Categoria.gaming,
          descripcion:
              'Las clasificatorias abiertas del mayor festival de esports y gaming de la región. Torneos abiertos de FIFA, League of Legends, Valorant y Rocket League con pase a la final internacional en Madrid.',
          requisitos: [
            'Registro en el portal oficial de Gamergy',
            'Edad mínima según torneo (13-18+)',
            'Cuenta original del juego en la región',
          ],
          beneficios: [
            'Pase directo a Gamergy Madrid para campeones',
            'Premios en efectivo y hardware gaming',
            'Meet & greet con creadores de contenido',
          ],
          pasos: [
            'Regístrate y elige tu torneo',
            'Participa en las clasificatorias online',
            'Asiste a la final presencial en Lima',
          ],
          deadline: _en(40),
          publicadoAt: _atras(10),
          modalidad: 'Híbrido',
          lugar: 'Lima',
          costo: 'S/ 25',
          publico: 'Gamers 13+',
          url: 'https://gamergy.es',
        ),
        Opportunity(
          id: 'pasantia-globant-peru',
          titulo: 'Pasantía Globant Perú — Engineering Studio',
          organizacion: 'Globant',
          orgVerificada: true,
          categoria: Categoria.empleo,
          descripcion:
              'Programa de pasantías semestrales en los studios de ingeniería de Globant Perú (backend, frontend, QA, data). Incluye un programa de formación interna y posibilidad de conversión a full-time.',
          requisitos: [
            'Estar cursando últimos ciclos de ingeniería de sistemas o afines',
            'Conocimientos en al menos un stack moderno',
            'Inglés técnico de lectura',
          ],
          beneficios: [
            'Subvención mensual competitiva',
            'Mentoría de ingenieros senior internacionales',
            'Conversión directa a empleo formal',
          ],
          pasos: [
            'Postula con tu CV y repos de GitHub',
            'Coding challenge en línea',
            'Entrevista técnica y cultural fit',
          ],
          deadline: _en(35),
          publicadoAt: _atras(8),
          modalidad: 'Híbrido',
          lugar: 'Lima',
          costo: 'Gratis',
          publico: 'Universitarios',
          url: 'https://career.globant.com',
        ),
        Opportunity(
          id: 'premio-nacional-innovacion',
          titulo: 'Premio Nacional a la Innovación 2026',
          organizacion: 'CONCYTEC · Premios Perú',
          orgVerificada: true,
          categoria: Categoria.ciencia,
          descripcion:
              'El máximo reconocimiento del Estado peruano a la innovación: categorías de innovación tecnológica, innovación social e investigación aplicada, con premios a proyectos que resuelvan problemas del país.',
          requisitos: [
            'Personas naturales o jurídicas peruanas',
            'Proyecto con prototipo o validación en campo',
            'Inscripción en la plataforma de Premios Perú',
          ],
          beneficios: [
            'Premio económico por categoría',
            'Visibilidad nacional y mediática',
            'Exhibición en la Semana de la Innovación',
          ],
          pasos: [
            'Inscríbete en la plataforma de Premios Perú',
            'Sube tu expediente técnico y evidencias',
            'Presenta tu proyecto ante el jurado',
          ],
          deadline: _en(60),
          publicadoAt: _atras(15),
          modalidad: 'Híbrido',
          lugar: 'Todo el Perú',
          costo: 'Gratis',
          publico: 'Innovadores peruanos',
          url: 'https://www.gob.pe/premiosperu',
        ),
        Opportunity(
          id: 'bootcamp-fundadores-2027',
          titulo: 'Bootcamp Full Stack Fundadores — Edición 2027',
          organizacion: 'Fundadores · Talleres Tech Perú',
          orgVerificada: true,
          categoria: Categoria.educacion,
          descripcion:
              'Bootcamp intensivo de 12 semanas para construir productos web completos con JavaScript moderno, backend en Node, bases de datos y despliegue en la nube. Ideal para fundadores técnicos en etapa de validación.',
          requisitos: [
            'Conocimientos básicos de programación',
            'Laptop propia con 8GB de RAM',
            'Compromiso de asistencia 20 h/semana',
          ],
          beneficios: [
            'Becas parciales al 50% para seleccionados',
            'Proyecto final con demo real',
            'Bolsa de empleo con startups asociadas',
          ],
          pasos: [
            'Aplica con el formulario y un mini reto técnico',
            'Entrevista con coordinación académica',
            'Elige horario: tarde o noche',
          ],
          deadline: _en(50),
          publicadoAt: _atras(6),
          modalidad: 'Online',
          lugar: 'Remoto / Perú',
          costo: 'S/ 950',
          publico: 'Público general',
          url: 'https://fundadores.pe',
        ),
      ];

  static List<AppNotification> notificaciones() {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n1',
        tipo: TipoAlerta.urgente,
        titulo: '¡ÚLTIMAS 24 HORAS! Global AI Hackathon',
        cuerpo: 'El registro de postulaciones cierra esta medianoche. ¿Tienes tu MVP listo?',
        createdAt: now.subtract(const Duration(minutes: 45)),
        leida: false,
        opportunityId: 'hack-ia-nacional-2026',
      ),
      AppNotification(
        id: 'n2',
        tipo: TipoAlerta.nueva,
        titulo: 'Nueva Beca Disponible: DeepTech Scholars',
        cuerpo: 'Beca de 100% de matrícula para posgrado en IA y Robótica. 6 días para postular.',
        createdAt: now.subtract(const Duration(hours: 3)),
        leida: false,
        opportunityId: 'beca-santander-ia-robotica',
      ),
      AppNotification(
        id: 'n3',
        tipo: TipoAlerta.recordatorio,
        titulo: 'Recordatorio programado: 3 días',
        cuerpo: 'Game Developers Latam Cup 2026 cierra inscripciones pronto. Revisa tus requisitos.',
        createdAt: now.subtract(const Duration(hours: 26)),
        leida: false,
        opportunityId: 'game-jam-lima-2026',
      ),
      AppNotification(
        id: 'n4',
        tipo: TipoAlerta.aceptado,
        titulo: 'Solana Radar Sprint aceptó tu perfil',
        cuerpo: 'Accede a las salas de mentoría técnica asignadas.',
        createdAt: now.subtract(const Duration(days: 2)),
        leida: true,
      ),
      AppNotification(
        id: 'n5',
        tipo: TipoAlerta.nueva,
        titulo: 'Nueva convocatoria: Trainee BCP 2027',
        cuerpo: 'Rotación por Data, Producto y Core bancario para recién graduados.',
        createdAt: now.subtract(const Duration(days: 3)),
        leida: true,
        opportunityId: 'trainee-bcp-2027',
      ),
    ];
  }
}
