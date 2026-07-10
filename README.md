# Product Catalog with Local Cart

A Flutter app that lists products from a REST API with search, favorites,
product details, and a shopping cart persisted in Sqflite.

## Features

- Products from [fakestoreapi.com](https://fakestoreapi.com/products) in a
  responsive grid, with pull-to-refresh, skeleton loading, and error/empty states.
- Local, debounced, case-insensitive search.
- Sort by price / rating and filter by category.
- Favorites with an animated heart, persisted via SharedPreferences.
- Product details: Hero image, tap-to-zoom, and a persistent add-to-cart bar.
- Cart (Sqflite): add / remove / adjust quantity, subtotals, total, and a live badge.
- Checkout that places an order and lists order history (Sqflite).
- Light / dark theme, persisted across launches.

## Architecture

Feature-first **Clean Architecture** with three layers per feature —
`data`, `domain`, and `presentation` — and a single dependency direction:
`presentation → domain ← data` (the domain layer depends on nothing external).

```
lib/
  main.dart / app.dart
  core/           constants, network (Dio + NetworkInfo), database (Sqflite),
                  errors (failures + exceptions), usecases (base contract),
                  utils, theme, router (go_router), di (get_it), widgets
  features/
    products/
      domain/         entities · repositories (abstract) · usecases
      data/           models · datasources · repositories (impl)
      presentation/   viewmodel (Cubit) · view (screens · widgets)
    cart/         domain · data · presentation
    favorites/    domain · data · presentation
    orders/       domain · data · presentation
```

- **domain** — the business core. `entities` are pure data classes;
  `repositories` are abstract contracts; `usecases` are single, named
  operations (e.g. `GetProducts`, `AddToCart`, `PlaceOrder`).
- **data** — `models` extend entities and add JSON / DB-row mapping;
  `datasources` isolate Dio / Sqflite / SharedPreferences; repository
  implementations translate low-level `Exception`s into user-facing `Failure`s.
- **presentation** — a `Cubit` view model depends on **use cases** (never a
  repository directly); `view` reads view models via `flutter_bloc`.

Error handling is explicit: use cases and repositories return
`Either<Failure, T>` (via `fpdart`), so callers must handle both paths. The UI
never touches Dio or Sqflite directly.

## Stack

flutter_bloc, get_it, go_router, dio, sqflite, shared_preferences, fpdart, equatable.

## Run

```bash
flutter pub get
flutter run
```
