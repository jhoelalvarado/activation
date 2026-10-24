<div align="center">

# ⚡ Activation

**Nunca más te pierdas una oportunidad.**

App móvil para descubrir a tiempo **becas, hackathons, eventos gaming, empleo tech y ciencia** en Perú — con alertas **antes** de que cierre cada convocatoria.

[![Flutter](https://img.shields.io/badge/Flutter-3.47-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Material 3](https://img.shields.io/badge/Material_3-Design_System-4F46E5)](https://m3.material.io)
[![Plataforma](https://img.shields.io/badge/Android-7.0%2B-3DDC84?logo=android&logoColor=white)](https://android.com)
[![Licencia](https://img.shields.io/badge/Licencia-MIT-green)](LICENSE)

</div>

---

## 🎯 El problema que resuelve

En Perú, la información sobre becas (PRONABEC, OEA, Santander), hackathons, torneos de esports, programas trainee y convocatorias de innovación se publica de forma dispersa — y la mayoría se entera **cuando ya pasó el deadline**. Activation centraliza esas oportunidades y convierte cada fecha de cierre en un **sistema de alertas anticipadas**: 7, 3 y 1 día antes, más el mismo día.

## ✨ Funcionalidades

| | Función | Detalle |
|---|---|---|
| 🏠 | **Feed priorizado por urgencia** | Banner de oportunidades que cierran esta semana, chips por categoría, búsqueda en vivo |
| ⏱️ | **Countdown en vivo** | Cada oportunidad muestra cuánto falta exactamente (días · horas · min · seg) |
| 📅 | **Agenda con calendario** | Puntos de color por urgencia, agrupación por día, resumen "cierran hoy" |
| 🔔 | **Recordatorios programados** | Notificaciones locales a 7 / 3 / 1 día(s) y el mismo día del cierre (configurables) |
| 🎯 | **Intereses personalizados** | Onboarding con selección de categorías; el feed se adapta a lo que te importa |
| 🌙 | **Horario de silencio** | Pausa sonora nocturna con excepción para deadlines críticos (<24h) |
| 🔖 | **Guardados con progreso** | Barra visual de "tiempo transcurrido" por convocatoria, orden por deadline |
| 📤 | **Exportar a calendario** | Sincroniza tus deadlines con Google Calendar (.ics) |
| 🌓 | **Modo claro/oscuro** | Sistema de diseño Material 3 completo con tokens propios |
| ♿ | **Estados cuidados** | Skeletons, empty states, offline banner, pull-to-refresh en todas las listas |

## 🏗️ Arquitectura

```
lib/
├── main.dart                 # Bootstrap + tema + rutas
├── theme/app_theme.dart      # Material 3 con tokens propios (claro/oscuro)
├── models/                   # Opportunity, AppNotification, UserPrefs
├── data/
│   ├── seed_data.dart        # Oportunidades de Perú (fechas relativas, siempre vigentes)
│   └── repositories.dart     # Persistencia (prefs, guardados, alertas)
├── services/
│   └── notification_service.dart  # Recordatorios locales programados
├── providers.dart            # Estado (Riverpod)
├── widgets/                  # Cards, countdown, badges, skeletons…
└── screens/                  # S1 Splash · S2 Onboarding · S3 Inicio · S4 Explorar
                              # S5 Detalle · S6 Agenda · S7 Alertas · S8 Perfil
                              # S9 Notificaciones · S10 Guardadas
```

**Stack**: Flutter 3 · Dart 3 · Riverpod · Material 3 · flutter_local_notifications · shared_preferences · url_launcher · share_plus · google_fonts (Inter)

## 🚀 Compilar y ejecutar

```bash
flutter pub get
flutter run                    # desarrollo
flutter build apk --release    # APK release
```

## 📲 Descargar la app

APK listo para instalar en Android 7.0+:

**→ [Descargar activation (última versión, Releases)](https://github.com/jhoelalvarado/activation/releases/latest)**

1. Descarga el APK
2. Habilita "Instalar apps de fuentes desconocidas"
3. Instala y activa las notificaciones al finalizar el onboarding

El APK de cada versión se genera automáticamente con GitHub Actions y se publica en [Releases](https://github.com/jhoelalvarado/activation/releases).

## 🗺️ Roadmap

- [x] MVP: 10 pantallas + recordatorios locales + datos Perú
- [ ] Backend de ingesta multi-fuente (scraping de convocatorias oficiales)
- [ ] Push segmentado por tópicos (FCM)
- [ ] Perfil de usuario con login y sincronización multi-dispositivo
- [ ] Escalar a más países de Latinoamérica

## 📄 Licencia

[MIT](LICENSE) — hecho con ⚡ en Perú.
