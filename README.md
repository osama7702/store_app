# Product Catalog with Local Cart

A Flutter app that lists products from a REST API with local search, favorites,
product details, and a shopping cart persisted in **Sqflite**.

Built as a technical task with **Cubit** state management, **Repository Pattern**,
**Dio** for networking, and a clean, feature-first architecture.

## Features

- 🛍️ **Home** — products from [fakestoreapi.com](https://fakestoreapi.com/products)
  in a responsive grid (2 / 3 / 4 columns by width), pull-to-refresh, skeleton
  loading, error state with *Try Again*, and empty state.
- 🔍 **Search** — local, case-insensitive, debounced, with a clear button.
- 🧭 **Sort & Filter** — sort by price / rating, filter by category chips.
- ❤️ **Favorites** — animated heart, persisted with SharedPreferences (survives
  restart), plus a dedicated Favorites screen.
- 📄 **Details** — Hero image transition, tap-to-zoom full preview, rating,
  category, description, and a persistent bottom *Add to Cart* button.
- 🛒 **Cart (Sqflite)** — add / remove / increase / decrease quantity, subtotal
  per item, total price, adding an existing product increments its quantity,
  reaching zero removes it (with confirmation), clear-cart, and a live badge.
- 🌗 **Dark mode** — light/dark themes, toggle persisted across launches.

## Architecture

Feature-first, close to Clean Architecture. Each feature has `data` (models,
datasources, repository impl), `domain` (entities, repository contracts), and
`presentation` (cubit, screens, widgets) layers.

```
lib/
  main.dart / app.dart
  core/           constants, network (Dio), database (Sqflite), errors,
                  utils, theme, router (go_router), di (get_it), widgets
  features/
    products/     home + details, ProductsCubit (fetch/search/sort/filter)
    favorites/    FavoritesCubit, SharedPreferences persistence
    cart/         CartCubit, Sqflite persistence
```

**Rules respected:** UI never touches Dio or Sqflite directly — Cubits talk to
Repositories only. Null safety throughout, `Equatable` states/entities, reusable
widgets, and user-friendly error messages.

## State management

- `ProductsCubit` — initial / loading / success / error; holds `allProducts`,
  `filteredProducts`, `categories`, `selectedCategory`, `searchQuery`, `sortType`.
- `FavoritesCubit` — set of favorite ids, load/toggle, persisted.
- `CartCubit` — cart items, total price, total item count; every mutation writes
  to Sqflite then reloads so UI and DB stay in sync.

## Run

```bash
flutter pub get
flutter run
```

## Notes

- The empty-cart state uses a clean designed placeholder (the `lottie` dependency
  is included; swap in a Lottie asset if a designed animation is preferred).
- App icon / splash screen are left at Flutter defaults; add
  `flutter_launcher_icons` / `flutter_native_splash` for production polish.
