# Nhật Nguyệt — Lunar Calendar & Auspicious Day App

## Project

Flutter app for Vietnamese users — lunar calendar, auspicious days, traditional holidays, personal lunar events, widgets.

## Stack

- **Framework:** Flutter (Android + iOS single codebase)
- **Database:** Isar or SQLite
- **Notifications:** Local Notifications + background scheduler
- **Offline:** fully offline-first

## Key Directories (convention)

```
lib/
├── core/          # theme, constants, utils, extensions
├── models/        # data models
├── services/      # business logic, calendar algorithms, conversions
├── providers/     # state management
├── screens/       # full-screen pages
├── widgets/       # reusable widgets
├── notifications/ # scheduling & display
└── l10n/          # localization (vi, en)
```

## Domain Terms

| Term | Meaning |
|---|---|
| Can Chi | Heavenly Stems & Earthly Branches |
| Trực | Daily classification (12 values) |
| Ngũ Hành | Five Elements (Kim, Mộc, Thủy, Hỏa, Thổ) |
| Ngày tốt/xấu | Auspicious/inauspicious day |
| Giờ hoàng đạo | Auspicious hours (12 Earthly Branch periods) |
| Tuổi xung khắc | Zodiac conflicts |

## Core Logic

Lunar/solar conversion, Can Chi, auspicious hours, Trực, Ngũ Hành — all computed client-side. No server dependency.

## MVP (Phase 1)

- Lunar & solar calendar views (day/week/month)
- Auspicious day + hour info
- Notifications (holidays, personal events, full moon, first day)
- Home screen widgets (small + large)
- Lunar recurring events (death anniversaries, worship, etc.)

## Architecture Guidelines

- Minimal dependencies, prefer pure Dart for core logic
- All calendar algorithms must be deterministic (same input → same output)
- Widgets should share a single data source
- Dark mode supported throughout
- Vietnamese primary, English secondary (l10n)

## Code Conventions

- Follow existing patterns in neighboring files
- No superfluous comments
- Use l10n for all user-facing strings
- Mimic existing widget structure (stateless vs stateful, testing approach)
