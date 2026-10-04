# Wiki Movies

A small Flutter application that lists popular movies from [The Movie Database (TMDB)](https://www.themoviedb.org/)
and lets you search them by title and filter them by rating.

| Feature | Description |
| --- | --- |
| Movie list | Fetches the most popular movies (`/discover/movie`, sorted by `popularity.desc`) and shows poster, title and release date. |
| Search | Filters the loaded movies by title, case-insensitive, with a clear (`x`) button. |
| Rating filter | Chips for `All`, `Bad` (4–6), `Good` (6–8), `Great` (8–9), `Recommend` (9+). |
| Totals counter | Shows how many movies are currently visible. |
| States | Shimmer placeholder while loading, empty state when nothing matches, error state with a retry button. |

---

## Running the application

### 1. Prerequisites

- Flutter SDK **3.47.6** (the version pinned in `.fvmrc`). The project is set up with
  [FVM](https://fvm.app/), so the easiest way is:

  ```bash
  dart pub global activate fvm   # if FVM is not installed yet
  fvm install
  fvm use
  ```

  All commands below can be prefixed with `fvm` (e.g. `fvm flutter run`) to use the pinned SDK.
- Dart SDK `^3.10.4` (bundled with the Flutter version above).
- An Android/iOS emulator, a physical device, or Chrome for the web target.

### 2. Configure the environment

The API base URL and API key are **not** committed (`.env` is git-ignored). Create a `.env` file
in the project root:

```dotenv
ENDPOINT=https://api.themoviedb.org/3
API_KEY=<your_tmdb_api_key>
```

You can obtain a free API key from <https://www.themoviedb.org/settings/api>.

> `.env` is already registered as an asset in `pubspec.yaml`, so no extra setup is required.

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Generate the code

The project uses `injectable` (dependency injection) and `json_serializable` (model parsing),
both of which rely on generated files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. Run

```bash
flutter run                 # on the connected device / emulator
```

### 6. Analyze

```bash
flutter analyze
```

---

## Implementation overview

### Project structure

```
lib/
├── common/
│   ├── exception/      # MovieException hierarchy (TimeOutException, UnknownException)
│   ├── injection/      # get_it + injectable setup (injection.dart, injection.config.dart)
│   └── network/        # Dio factory + HttpServices wrapper
├── features/
│   └── movies/
│       ├── data/
│       │   └── data_source/        # MovieDataSource – talks to the TMDB API
│       ├── domain/
│       │   ├── entities/           # MovieCategory (request), Movie / MovieList (response)
│       │   └── repositories/       # MovieRepositories – single entry point for the bloc
│       └── presentation/
│           ├── bloc/               # MovieListBloc, events and state
│           ├── page/               # MovieScreen
│           └── widget/             # loading / empty / failure / shimmer widgets
└── main.dart
```

### Data flow

```
MovieScreen → MovieListBloc → MovieRepositories → MovieDataSource → HttpServices (Dio) → TMDB API
```

The UI only talks to the bloc, the bloc only talks to the repository, and the repository is the
only layer aware of the data source. This keeps each layer replaceable and easy to test in
isolation.

### Design decisions

- **Feature-first, layered architecture.** Code is grouped by feature (`features/movies`) and then
  by layer (`data` / `domain` / `presentation`) instead of by type. Adding a new feature means
  adding one folder, not touching five shared ones. Cross-cutting concerns live in `common/`.
- **BLoC for state management.** `flutter_bloc` was chosen because the screen has several
  interacting inputs (fetch, search, rating filter) that must be reduced into one consistent
  state. A single `MovieListState` with a `FetchStatus` enum (`initial`, `loading`, `empty`,
  `success`, `failure`) makes the UI a pure function of the state and avoids impossible
  combinations such as "loading + error".
- **Single immutable state object.** `MovieListState` is `Equatable` and exposed through
  `copyWith`, so rebuilds only happen when something actually changes. The raw `movieList` is kept
  separately from `filteredList`, which means search and rating filters can be combined and reset
  without re-fetching from the network.
- **Client-side filtering.** TMDB returns one page of popular movies; search and rating filters are
  applied in memory. This keeps the UX instant, avoids burning API quota on every keystroke, and
  keeps the filtering logic unit-testable without a network.
- **Debounced search.** `MovieListSearchEvent` waits ~200 ms and re-checks that the query is still
  the latest one before emitting results, which prevents flicker and out-of-order emissions while
  typing.
- **Rating categories as a value object.** `MovieCategory` is a closed set of constants with
  `minRate` / `maxRate` and a `matches()` method instead of a plain enum plus `if` chains. Adding a
  new bucket is a one-line change, and the boundary rule (`>= min && < max`) lives in a single
  place.
- **Dependency injection with get_it + injectable.** Dependencies are annotated
  (`@LazySingleton`, `@Injectable`, `@module`) and wired by code generation, so `main.dart` only
  calls `configureDependencies()`. The bloc receives the repository via the constructor, which
  makes it trivial to inject a fake repository in tests.
- **Centralised networking and error mapping.** `HttpServices` wraps Dio and translates
  `DioException` into domain-level exceptions (`TimeoutException`, `UnknownException`), so the
  upper layers never deal with transport-specific types. The bloc catches `MovieException` and
  turns it into a `failure` state with a message and a retry action.
- **Secrets in `.env`.** `flutter_dotenv` loads the base URL and the API key at startup; the file
  is git-ignored so credentials never reach the repository.
- **Perceived performance.** A `shimmer` skeleton list is shown instead of a spinner while loading,
  and posters are loaded lazily by `ListView.separated`, which only builds visible rows.