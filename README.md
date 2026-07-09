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
- Light / dark theme, persisted across launches.

## Architecture

Feature-first MVVM. Each feature has four folders:

```
lib/
  main.dart / app.dart
  core/           constants, network (Dio), database (Sqflite), errors,
                  utils, theme, router (go_router), di (get_it), widgets
  features/
    products/     model · repository · viewmodel · view
    favorites/    repository · viewmodel · view
    cart/         model · repository · viewmodel · view
```

- model — plain data classes that also parse themselves (JSON / DB rows).
- repository — data access; talks to Dio / Sqflite / SharedPreferences directly.
- viewmodel — a `Cubit` that owns state and calls the repository.
- view — screens and widgets; read view models via `flutter_bloc`.

The UI never touches Dio or Sqflite directly; view models talk to repositories
only. Repositories throw user-facing `Failure`s that view models surface to the UI.

## Stack

flutter_bloc, get_it, go_router, dio, sqflite, shared_preferences, equatable.

## Run

```bash
flutter pub get
flutter run
```
