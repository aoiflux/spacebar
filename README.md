# Spacebar - DUES gRPC Client

A Flutter application for the Indicer gRPC file indexing and deduplication service.

## Features

### Implemented ✅

1. **File Upload with Deduplication**
   - Automatic SHA3-256 hash computation
   - Check if file exists before uploading (AppendIfExists)
   - Stream file upload with 64KB chunks
   - Display chunk map and file statistics

2. **gRPC Integration**
   - AppendIfExists endpoint
   - StreamFile endpoint (client streaming)
   - GetEviFiles endpoint (ready for backend implementation)

3. **UI Features**
   - File picker integration
   - Upload progress indication
   - Success view with chunk map visualization
   - Error handling with snackbar notifications

### Architecture

The app follows Clean Architecture with BLoC pattern:

```
lib/
├── core/
│   ├── common/
│   │   ├── entities/     # Domain entities
│   │   └── widgets/      # Reusable widgets
│   ├── error/            # Error handling
│   └── utils/            # Utilities
├── features/
│   └── evi_list/
│       ├── data/
│       │   ├── models/   # Data models
│       │   ├── repos/    # Repository implementations
│       │   └── sources/  # gRPC data source
│       ├── domain/
│       │   ├── repo/     # Repository interfaces
│       │   └── usecases/ # Business logic
│       └── presentation/
│           ├── bloc/     # State management
│           └── pages/    # UI screens
└── generated/            # Proto-generated files
```

## Getting Started

### Prerequisites

- Flutter SDK ^3.9.0
- Dart SDK
- gRPC server running on localhost:50051

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Ensure the gRPC server is running on port 50051

4. Run the app:
   ```bash
   flutter run
   ```

## Generate Proto Files

If you need to regenerate the proto files:

```bash
dart pub global activate protoc_plugin
protoc --dart_out=grpc:lib/generated protos/dues.proto
```

## Usage

1. **Upload a File**
   - Click the "Upload File" button
   - Select a file from your device
   - The app will:
     - Compute SHA3-256 hash
     - Check if file exists in database
     - Upload if new, or reference if exists
     - Display chunk map and statistics

2. **View File Information**
   - After upload, see file details
   - View chunk distribution
   - Check deduplication statistics

## gRPC Configuration

Server configuration in `lib/core/cnst/cnst.dart`:
```dart
class GrpCnst {
  static const host = "localhost";
  static const port = 50051;
}
```

## Dependencies

- `grpc: ^4.0.1` - gRPC client
- `protobuf: ^4.0.0` - Protocol buffers
- `flutter_bloc: ^9.0.0` - State management
- `get_it: ^8.0.2` - Dependency injection
- `fpdart: ^1.1.0` - Functional programming
- `pointycastle: ^3.9.1` - SHA3-256 hashing
- `file_picker: ^10.0.0` - File selection
- `logger: ^2.4.0` - Logging

## Future Enhancements

- GetPartitionFiles implementation
- GetIndexedFiles implementation
- Search functionality
- File type detection
- Upload progress tracking
- Resume capability for interrupted uploads
- Multiple file uploads