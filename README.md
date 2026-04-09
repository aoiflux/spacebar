# Spacebar — DUES Workspace

A cross-platform Flutter frontend for the **DUES** (Digital Unified Evidence System) backend. It provides a modern UI for uploading, browsing, and managing forensic evidence files over gRPC.

---

## Features

| Feature | Description |
|---|---|
| **Evidence Store** | Upload disk image files via file picker or drag-and-drop. Deduplicates by hash before streaming to the server. |
| **Evidence List** | Browse evidence files in a collapsible tree: Evidence → Partitions → Indexed files. Click any tile to view full details. |
| **Dashboard** | At-a-glance workspace overview. |
| **Evidence Restore** | *(In development)* |
| **Evidence Search** | *(In development)* |

---

## Architecture

The project follows **Clean Architecture** with a feature-first directory layout.

```
lib/
├── core/
│   ├── cnst/          # App-wide constants (gRPC host, port, file types)
│   ├── common/        # Shared entities, models, and widgets
│   ├── error/         # Failure types
│   ├── iusecase/      # Base use-case interface
│   ├── theme/         # App theme
│   └── utils/         # Platform-conditional helpers (gRPC channel, file picker, crypto)
├── features/
│   ├── evi_store/     # Upload evidence  (data / domain / presentation)
│   ├── evi_list/      # Browse evidence  (data / domain / presentation)
│   ├── evi_restore/   # Restore evidence (stub)
│   ├── evi_search/    # Search evidence  (stub)
│   ├── dashboard/     # Dashboard view
│   └── home/          # Root shell / navigation
├── generated/         # Dart protobuf/gRPC generated code
└── init_deps.dart     # Dependency injection (get_it)
```

**State management:** `flutter_bloc` (BLoC pattern)
**Dependency injection:** `get_it`
**Functional error handling:** `fpdart` (`Either`)

---

## Prerequisites

| Tool | Version |
|---|---|
| Flutter SDK | ≥ 3.x |
| Dart SDK | ^3.9.0 |
| `protoc` | Latest |
| DUES gRPC backend | Running on `localhost:50051` |

---

## Getting Started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Generate protobuf / gRPC code

Run this once (or whenever `protos/dues.proto` changes):

```bash
dart pub global activate protoc_plugin
protoc --dart_out=grpc:lib/generated protos/dues.proto
```

### 3. Start the DUES backend

Ensure the gRPC server is reachable at `localhost:50051` before launching the app.
The host and port can be changed in `lib/core/cnst/cnst.dart`:

```dart
class GrpCnst {
  static const host = "localhost";
  static const port  = 50051;
}
```

### 4. Run the app

```bash
# Web
flutter run -d chrome

# Windows
flutter run -d windows
```

---

## gRPC Service

The app communicates exclusively through `DuesService` (defined in `protos/dues.proto`).

| RPC | Direction | Purpose |
|---|---|---|
| `AppendIfExists` | Unary | Deduplication check by file hash |
| `StreamFile` | Client-streaming | Upload a disk image in chunks |
| `GetEviFiles` | Unary | List all evidence files |
| `GetPartiFiles` | Unary | List partitions for a given evidence file |
| `GetIdxFiles` | Unary | List indexed files for a given partition |
| `Search` | Unary | Keyword search across indexed content |

---

## Key Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc` | BLoC state management |
| `get_it` | Service locator / DI |
| `fpdart` | Functional types (`Either`, `Option`) |
| `grpc` + `protobuf` | gRPC transport and serialization |
| `file_picker` | Native file picker dialog |
| `desktop_drop` / `flutter_dropzone` | Drag-and-drop file upload |
| `crypto` + `pointycastle` | File hashing for deduplication |
| `logger` | Structured console logging |

---

## Project Structure Notes

- Platform-conditional imports (web vs. native) are handled with stub/io/web file triples (e.g. `grpc_channel_stub.dart`, `grpc_channel_io.dart`, `grpc_channel_web.dart`).
- All BLoC providers are registered at the root in `main.dart` via `MultiBlocProvider`.
- The `generated/` directory is committed for convenience but should be regenerated from `protos/` as the source of truth.
