# Activation — Especificación de Pantallas (UX/UI Spec v1)

App de descubrimiento oportuno de oportunidades: hackathons, eventos (educación, trabajo, gaming), becas y más.
**Problema que resuelve**: enterarte de todo a tiempo, nunca después.
**Stack previsto**: Flutter (Material 3) + Firebase (FCM) + DB local.

---

## 0. Sistema de diseño global (editable, pero mantén consistencia)

### Colores
| Rol | Claro | Oscuro | Uso |
|---|---|---|---|
| Primario | `#4F46E5` índigo | `#818CF8` | Botones acción, tabs activos, enlaces |
| Acento/urgencia | `#F59E0B` ámbar | `#FBBF24` | Badges de deadline 7–30 días |
| Urgente | `#EF4444` rojo | `#F87171` | Deadlines < 7 días, errores |
| Éxito | `#10B981` verde | `#34D399` | "Inscrito", "Guardado" |
| Fondo | `#FFFFFF` | `#0F172A` | Base |
| Superficie/card | `#F8FAFC` | `#1E293B` | Cards, chips |
| Texto principal | `#0F172A` | `#F1F5F9` | Títulos, body |
| Texto secundario | `#64748B` | `#94A3B8` | Captions, metadatos |

### Tipografía (Inter o Roboto)
- H1: 28/34 bold · H2: 22/28 bold · H3: 18/24 semibold
- Body: 16/24 regular · Caption: 12/16 medium
- Números de countdown: tabular figures (no bailan al cambiar)

### Espaciado y forma
- Grilla de 8dp · márgenes laterales de pantalla: 16dp
- Radio: cards 16dp · botones 12dp · chips pill (24dp) · inputs 12dp
- Iconos: Material Symbols Rounded, 24dp (nav) / 20dp (inline)

### Regla de badges de deadline (aparece en TODAS las pantallas con oportunidades)
| Estado | Color | Texto |
|---|---|---|
| Abierto (>30 días) | Verde suave | "Abierto" |
| Próximo (7–30 días) | Ámbar | "Cierra en Xd" |
| Urgente (<7 días) | Rojo + pulso sutil | "¡ÚLTIMOS Xd!" |
| Cerrada/vencida | Gris | "Cerrada" |

---

## 1. Mapa de navegación

```
BottomNavigationBar fija (5 tabs, visible en Inicio/Explorar/Agenda/Alertas/Perfil):
[🏠 Inicio] [🧭 Explorar] [📅 Agenda] [🔔 Alertas] [👤 Perfil]

Flujos secundarios (push fullscreen, con botón ← arriba-izq):
Inicio → Detalle de Oportunidad → (Recordatorio/Compartir)
Inicio → Guardados (icono bookmark en AppBar) → Detalle
Inicio/Explorar → Buscar → Detalle
Explorar → lista por categoría → Detalle
Perfil → Mis Intereses / Notificaciones (S9) / Guardados / Acerca de
Onboarding → Inicio (una sola vez)
```

Reglas globales:
- Detalle SIEMPRE abre como página nueva con transición horizontal.
- Banner offline fijo bajo el AppBar cuando no hay red: franja ámbar "Sin conexión — mostrando guardadas".
- Pull-to-refresh en todas las listas.

---

## S1. Splash
- **Propósito**: branding + carga inicial.
- **Layout**: fondo primario (índigo) degradado a violeta oscuro. Logo (rayo/campana estilizado) centrado 120dp. Tagline debajo: "Nunca más te pierdas una oportunidad" blanco 16/24. Barra de progreso lineal blanca 40% ancho, centrada, a 120dp del fondo.
- **Navega a**: Onboarding (1ª vez) o Inicio.
- Brief de generación: pantalla vertical índigo, logo centrado, minimalista.

## S2. Onboarding (4 pasos)
- **Propósito**: vender el valor + pedir permisos + capturar intereses.
- **Layout común**: ilustración centrada 45% superior; título H1 centrado; body centrado 2–3 líneas; indicador de progreso (3 puntos) centro-inferior.
  - **S2.1 Problema/Solución**: ilustración calendario con campana. Título: "¿Te enteras cuando ya pasó?" Body: "Activation te avisa antes de que cierre cada convocatoria".
  - **S2.2 Alertas**: ilustración teléfono con notificación. Título: "Alertas antes del cierre". Body: "Elige tus temas y te avisamos 7, 3 y 1 día antes".
  - **S2.3 Permisos**: título "Activa las notificaciones". Ilustración campana con check. Botón primario "Permitir notificaciones" (dispara permiso OS) + debajo texto-link "Más tarde".
  - **S2.4 Intereses**: título "¿Qué te interesa?". **Chips multi-selección** en flujo envolvente centrado: Becas, Hackathons, Gaming, Educación, Trabajo, Tecnología, Arte, Ciencia (selected = fill primario texto blanco; unselected = outline). Mínimo 1 para avanzar.
- **Botones**: "Siguiente" filled primario, **abajo-derecha**, 48dp alto; "Saltar" texto gris **arriba-derecha**; último paso: "Empezar" filled full-width bottom con safe-area.
- Brief: 4 mockups, misma plantilla, cambia ilustración y textos.

## S3. Inicio / Descubrir (tab 1) — pantalla principal
- **Propósito**: feed priorizado por urgencia + relevancia.
- **Layout de arriba a abajo**:
  1. **AppBar** (56dp, fondo = fondo de pantalla, sin sombra): logo wordmark "Activation" izquierda (16dp del borde); derecha: icono `bookmark` (→ Guardados) y `notifications` con **badge rojo punto** (→ Alertas), separados 24dp.
  2. **Barra de búsqueda**: pill 48dp alto, full-width, fondo superficie, lupa 20dp izquierda, placeholder "Buscar becas, hackathons…", icono micrófono derecha (opcional v2). Tap → pantalla Buscar.
  3. **Chips de categorías** (scroll horizontal, altura 32dp): `Todas · Becas · Hackathones · Gaming · Educación · Trabajo`. Seleccionado = fill primario + texto blanco; resto = outline gris. Márgenes 8dp entre chips.
  4. **Banner urgente** (condicional, solo si hay oportunidades que cierran ≤7d): card fondo rojo-suave `#FEF2F2`, borde rojo 1dp, radio 12dp, altura ~64dp: icono `alarm` rojo + texto semibold "3 oportunidades cierran esta semana" + chevron `›` derecha. Tap → Agenda filtrada a urgentes.
  5. **Feed de oportunidades** (lista vertical, separación 12dp). **Card de oportunidad** (radio 16dp, fondo superficie, sombra sutil y=2 blur 8):
     - Imagen 16:9 top con bordes redondeados superiores (placeholder color según categoría).
     - Fila de badges sobre la imagen (esquina sup-izq, 8dp inset): badge categoría (pill primario 11sp) + badge urgencia (regla global).
     - Cuerpo (padding 12dp): título semibold 16/22 **máx 2 líneas** (ellipsis); organización caption gris con avatar 16dp; fila inferior: `event` 14dp + "12 oct" · `location_on` + "Remoto/Perú" · **botón corazón 40dp derecha** (outline; tap = fill rojo + haptic).
  6. **Skeleton loading**: 3 cards gris con shimmer.
  7. **Empty state**: ilustración brújula, "No hay oportunidades aquí todavía", botón "Explorar categorías".
- **Estados**: pull-to-refresh; scroll infinito; sin conexión → banner + cache.
- Brief: feed mobile, cards con imagen, chips arriba, banner rojo suave.

## S4. Explorar (tab 2)
- **Propósito**: descubrir por categoría; navegación guiada.
- **Layout**:
  1. Título grande "Explorar" H1, 16dp margen top.
  2. **Grid 2 columnas** de categorías (cards 160dp alto, radio 16dp, fondo superficie): icono 32dp centrado superior con tinte de color por categoría (Becas=verde, Hackathons=violeta, Gaming=fucsia, Educación=azul, Trabajo=ámbar, Tecnología=cian), nombre semibold 16, contador caption "12 activas".
  3. Sección **"Cierran pronto"**: título fila + "Ver todo ›" derecha; **scroll horizontal** de cards compactas 200dp ancho (mini imagen, título 1 línea, countdown rojo).
  4. Sección **"Nuevas esta semana"**: mismo patrón horizontal.
- Brief: grid de categorías colorido + dos carruseles.

## S5. Detalle de Oportunidad
- **Propósito**: decidir y actuar a tiempo.
- **Layout**:
  1. **Hero**: imagen full-bleed 40% pantalla, **gradiente negro→transparente** inferior. Superpuestos: botón `←` círculo blanco 40dp **arriba-izquierda** (16dp inset); `♥` y `share` círculos blancos **arriba-derecha** apilados horizontal 8dp.
  2. **Sheet de contenido** (radio top 24dp, -24dp solapado al hero, fondo de pantalla):
     - Fila badges: categoría + urgencia.
     - **Título H1** 2–3 líneas.
     - **Organización**: avatar 32dp + nombre semibold + badge `verified` azul 14dp + "organiza" caption.
     - **Countdown card** (destacada, full-width, 72dp, radio 12dp): fondo ámbar-suave (o rojo-suave si <7d): icono `timer` 28dp + "Cierra en **4 días**" semibold 18 + "12 oct, 23:59" caption. Si vencida: gris "Cerrada el 12 oct".
     - **Fila meta** (3 iconos con caption, separados uniformes): `location_on` Presencial/Online · `payments` Gratis/S/50 · `people` Para jóvenes 18–29.
     - **Secciones** (scroll): "Descripción" (body), "Requisitos" (lista con check verde), "Premios/Beneficios" (lista), "Cómo postular" (pasos numerados).
     - Espacio inferior 96dp para CTA fija.
  3. **CTA fija bottom** (fondo con degradado al fondo de pantalla, safe-area): botón primario full-width 52dp **"Postular en sitio oficial ↗"** (abre URL externa en browser/custom tab); debajo botón secundario outline full-width 44dp **"🔔 Avisarme antes del cierre"** → si activo: verde con "✓ Te avisaremos 7/3/1 días antes" (tap desactiva).
- Brief: hero arriba, countdown ámbar, botones dobles abajo.

## S6. Agenda / Calendario (tab 3)
- **Propósito**: ver TODOS tus deadlines en el tiempo.
- **Layout**:
  1. Header: título "Agenda" H1 + botón `today` derecha (volver a hoy).
  2. **Selector de mes**: `< Octubre 2026 >` centrado semibold, chevrons 40dp tap.
  3. **Calendario mensual compacto** (grid 7 columnas, celdas 44dp): día actual = círculo primario; días con deadline = **punto 6dp bajo el número** (color = urgencia); días seleccionados = fondo superficie.
  4. **Lista agrupada** bajo el calendario: encabezados de día "JUE 12 OCT" caption gris; cada item (altura 72dp, radio 12dp, fondo superficie): fecha-numérica 20dp bold izquierda; centro: título semibold 15 (1 línea) + org caption; derecha: badge mini countdown.
  5. Fila final: botón tintado "Sincronizar con Google Calendar" con icono (solo si hay ≥1 guardada).
- **Estados**: empty → "Sin deadlines este mes. Guarda oportunidades y aparecerán aquí." + botón "Explorar".
- Brief: calendario compacto arriba, lista por días abajo.

## S7. Alertas (tab 4)
- **Propósito**: bandeja in-app de notificaciones pasadas.
- **Layout**:
  1. AppBar: título "Alertas" + overflow `⋮` → "Marcar todas como leídas".
  2. Filtros chips: `Todas · Urgentes · Nuevas`.
  3. **Lista de notificaciones** (items 80dp, separadas 1dp divisoria):
     - Icono de categoría 40dp círculo tintado izquierda.
     - Título semibold 15 + body 13/18 máx 2 líneas + "hace 2 h" caption.
     - **No leída**: fondo `#EEF2FF` + punto primario 8dp derecha-arriba.
     - Leída: fondo normal, texto secundario.
  4. Acciones: tap → Detalle de la oportunidad; **swipe izquierda → eliminar** (fondo rojo, icono papelera).
- **Estados**: empty → campana tachada "Aquí verás tus alertas".
- Brief: bandeja tipo cliente de email con puntos de no leído.

## S8. Perfil (tab 5)
- **Propósito**: identidad, preferencias, sesión.
- **Layout**:
  1. Header centrado: avatar círculo 80dp (o inicial); nombre semibold 20; email caption (si invitado: "Invitado — inicia sesión para sincronizar").
  2. **Card stats** horizontal (3 columnas divididas por líneas): "Guardadas 12" / "Alertas 5" / "Asistirás 3" — número bold 20 + caption.
  3. **Lista de opciones** (tiles 56dp, icono 24 izquierda + label + chevron derecha):
     - 🎯 Mis intereses → chips editables inline
     - 🔔 Notificaciones → S9
     - 🔖 Guardados → S10
     - 📅 Google Calendar conectado (toggle inline)
     - 🌐 Idioma (Español ›)
     - 🎨 Tema (Sistema/Claro/Oscuro, selector inline)
     - ℹ️ Acerca de Activation
  4. Sesión al fondo: "Iniciar sesión" botón tintado full-width **o** "Cerrar sesión" texto rojo centrado.
- Brief: header avatar + card stats + lista settings estándar.

## S9. Notificaciones (ajustes)
- **Propósito**: control granular de alertas.
- **Layout** (lista simple, grupos con encabezado caption):
  1. Grupo "General": switch maestro "Notificaciones push".
  2. Grupo "Categorías": switch por categoría (Becas, Hackathons, Gaming, Educación, Trabajo, …).
  3. Grupo "Recordatorios de cierre": radios — `7 días antes · 3 días antes · 1 día antes · El mismo día` (multi-selección permitida).
  4. Grupo "Silencio": rango horario "23:00 – 07:00" (tap → time pickers).
  5. Nota al pie: "Las alertas de deadline urgente pueden llegar fuera del horario de silencio." (caption gris).

## S10. Guardados
- **Propósito**: lista de oportunidades con corazón/bookmark activo.
- **Layout**: AppBar título "Guardadas (12)" + orden `sort` (Por deadline / Recientes). Lista = mismas cards del feed S3, orden **deadline ascendente** (lo próximo arriba). Empty → bookmark ilustrado + "Explora y guarda lo que te interese".

## Estados transversales (aplican a todas las listas)
| Estado | Tratamiento |
|---|---|
| Cargando | 3 skeletons con shimmer |
| Sin resultados | Ilustración + texto específico + CTA alternativa |
| Error de red | Ilustración nube tachada + "Reintentar" (outline) |
| Offline | Banner ámbar fijo bajo AppBar |
| Pull refresh | Indicador primario |

---

## Orden sugerido para generar los mockups
1. S3 Inicio (define el ADN visual)
2. S5 Detalle (la pantalla de conversión)
3. S6 Agenda (el diferenciador)
4. S2 Onboarding + S4 Explorar
5. S7 Alertas + S8 Perfil + S9 Notificaciones + S10 Guardados
6. S1 Splash

## Qué enviarme de cada pantalla
- Imagen del mockup (o varias variantes)
- Si puedes: hex de colores si usas otros distintos a esta spec
- Cambios que quieras sobre esta spec (posición de botones, etc.)
