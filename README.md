# Product Catalog with Local Cart

A Flutter app that lists products from [fakestoreapi.com](https://fakestoreapi.com/products),
with search, favorites, product details, and a Sqflite-backed shopping cart.

## Features

- Responsive product grid with pull-to-refresh, skeleton loading, and error states.
- Local search, sort by price/rating, and category filter.
- Favorites persisted via SharedPreferences.
- Cart (Sqflite): add / remove / adjust quantity, subtotals, and total.
- Checkout with local order history, plus a persisted light/dark theme.

## Architecture

Feature-first **Clean Architecture** — three layers per feature with a single
dependency direction: `presentation → domain ← data`.

```
lib/
  core/         network (Dio), database (Sqflite), errors, usecases, di (get_it)
  features/<feature>/
    domain/         entities · repositories (abstract) · usecases
    data/           models · datasources · repositories (impl)
    presentation/   viewmodel (Cubit) · view (screens · widgets)
```

- **domain** — pure entities, abstract repository contracts, and use cases.
- **data** — models, data sources (Dio / Sqflite / SharedPreferences), and
  repository implementations that map exceptions to `Failure`s.
- **presentation** — `Cubit` view models depend on use cases; views use `flutter_bloc`.

Repositories and use cases return `Either<Failure, T>` (`fpdart`) for explicit
error handling.

## Stack

flutter_bloc · get_it · go_router · dio · sqflite · shared_preferences · fpdart · equatable

## Run

```bash
flutter pub get
flutter run
```
