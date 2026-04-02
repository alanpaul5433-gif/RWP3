# DEVELOPMENT.md - RWP3 Development Guide

## Prerequisites

| Tool | Version | Purpose |
|------|---------|---------|
| Flutter SDK | >= 3.2.6 | Frontend framework |
| Dart SDK | >= 3.2.6 | Programming language |
| Node.js | v24 | Cloud Functions runtime |
| Firebase CLI | Latest | Deploy & manage Firebase |
| FlutterFire CLI | Latest | Generate firebase_options.dart |
| Android Studio | Latest | Android build & emulator |
| Xcode | Latest (macOS) | iOS build |
| Git | Latest | Version control |
| Google Maps API Key | - | Maps integration |
| Stripe Account | - | Payment processing |

---

## Initial Setup

### 1. Firebase Project Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Create a new Firebase project
firebase projects:create rwp3-project

# Enable required services in Firebase Console:
# - Authentication (Phone, Google, Apple)
# - Cloud Firestore
# - Cloud Storage
# - Cloud Messaging
# - Cloud Functions (requires Blaze plan)
```

### 2. Create the Core Shared Package

```bash
cd C:\Projects\RWP3

# Create core package (shared entities, models, utils)
mkdir -p core/lib
cd core
# Create pubspec.yaml for the core package
```

Core `pubspec.yaml`:
```yaml
name: core
description: Shared package for RWP3 apps
version: 1.0.0

environment:
  sdk: '>=3.2.6 <4.0.0'

dependencies:
  cloud_firestore: ^6.1.2
  firebase_auth: ^6.1.4
  equatable: ^2.0.5
  dartz: ^0.10.1
```

### 3. Flutter App Setup

```bash
cd C:\Projects\RWP3

# Create the three Flutter apps
flutter create customer
flutter create driver
flutter create admin

# Add core package dependency to each app's pubspec.yaml:
# dependencies:
#   core:
#     path: ../core

# Configure Firebase for each app
cd customer && flutterfire configure --project=rwp3-project
cd ../driver && flutterfire configure --project=rwp3-project
cd ../admin && flutterfire configure --project=rwp3-project
```

### 4. Cloud Functions Setup

```bash
cd C:\Projects\RWP3
mkdir -p functions
cd functions
firebase init functions
# Select: JavaScript, Node.js v24, ESLint: Yes
npm install firebase-admin firebase-functions
```

### 5. Database Seeding

```bash
cd C:\Projects\RWP3/database
npm install firebase-admin
# Configure config.json with service account
node import.js
```

### 6. Google Maps API Key

1. Go to Google Cloud Console
2. Enable Maps SDK for Android, Maps SDK for iOS, Directions API, Geocoding API, Places API
3. Create API key with app restrictions
4. Store key in Firestore `settings/constant.mapAPIKey`

### 7. Stripe Setup

1. Create Stripe account at stripe.com
2. Get publishable key and secret key
3. Store in Firestore `settings/payment.strip`

---

## Project Structure

```
RWP3/
├── core/                           # Shared Dart package
│   ├── lib/
│   │   ├── core.dart               # Barrel export
│   │   ├── constants/              # CollectionNames, BookingStatus
│   │   ├── entities/               # Domain entities (pure Dart, Equatable)
│   │   ├── models/                 # Data models (extend entities, toJson/fromJson)
│   │   ├── errors/                 # Failures, Exceptions
│   │   ├── usecases/               # Base UseCase interface
│   │   └── utils/                  # Firestore helpers, validators
│   └── pubspec.yaml
│
├── customer/                       # Customer mobile app
│   ├── lib/
│   │   ├── main.dart               # Entry point
│   │   ├── firebase_options.dart    # Auto-generated
│   │   ├── injection_container.dart # get_it DI registration
│   │   ├── app/
│   │   │   ├── app.dart            # MaterialApp + MultiBlocProvider
│   │   │   ├── router.dart         # go_router configuration
│   │   │   └── theme.dart          # ThemeData (light/dark)
│   │   └── features/               # Feature modules (Clean Architecture)
│   │       ├── auth/
│   │       │   ├── data/
│   │       │   │   ├── datasources/
│   │       │   │   ├── models/
│   │       │   │   └── repositories/
│   │       │   ├── domain/
│   │       │   │   ├── repositories/
│   │       │   │   └── usecases/
│   │       │   └── presentation/
│   │       │       ├── bloc/
│   │       │       ├── pages/
│   │       │       └── widgets/
│   │       ├── booking/
│   │       ├── tracking/
│   │       ├── payment/
│   │       ├── wallet/
│   │       └── ...
│   ├── test/                       # Unit & widget tests
│   └── pubspec.yaml
│
├── driver/                         # Same structure as customer
├── admin/                          # Same structure as customer
├── functions/                      # Firebase Cloud Functions
├── database/                       # Seed data & migration scripts
├── firestore_indexes/              # Composite index definitions
├── CLAUDE.md                       # AI agent rules
├── ARCHITECTURE.md                 # Technical architecture
├── DESIGN.md                       # Design specification
├── DEVELOPMENT.md                  # This file
└── PROJECT.md                      # Project overview
```

---

## Feature Module Creation Guide

### Step 1: Define Entity (Domain Layer)

```dart
// features/booking/domain/entities/booking_entity.dart
import 'package:equatable/equatable.dart';
import 'package:core/entities/location_latlng.dart';

class BookingEntity extends Equatable {
  final String id;
  final String customerId;
  final String? driverId;
  final String bookingStatus;
  final LocationLatLng pickupLocation;
  final LocationLatLng dropLocation;
  final double totalAmount;
  final String paymentType;
  final DateTime createdAt;

  const BookingEntity({
    required this.id,
    required this.customerId,
    this.driverId,
    required this.bookingStatus,
    required this.pickupLocation,
    required this.dropLocation,
    required this.totalAmount,
    required this.paymentType,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, customerId, driverId, bookingStatus];
}
```

### Step 2: Define Repository Interface (Domain Layer)

```dart
// features/booking/domain/repositories/booking_repository.dart
import 'package:dartz/dartz.dart';
import 'package:core/errors/failures.dart';

abstract class BookingRepository {
  Future<Either<Failure, BookingEntity>> createBooking(CreateBookingParams params);
  Future<Either<Failure, BookingEntity>> getBooking(String id);
  Future<Either<Failure, List<BookingEntity>>> getBookingsByStatus(String userId, String status);
  Stream<Either<Failure, BookingEntity>> watchBooking(String id);
}
```

### Step 3: Create UseCases (Domain Layer)

```dart
// features/booking/domain/usecases/create_booking.dart
import 'package:dartz/dartz.dart';
import 'package:core/usecases/usecase.dart';
import 'package:core/errors/failures.dart';

class CreateBooking implements UseCase<BookingEntity, CreateBookingParams> {
  final BookingRepository repository;
  CreateBooking(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(CreateBookingParams params) {
    return repository.createBooking(params);
  }
}

class CreateBookingParams extends Equatable {
  final String customerId;
  final LocationLatLng pickup;
  final LocationLatLng drop;
  final String vehicleTypeId;
  final String paymentType;

  const CreateBookingParams({
    required this.customerId,
    required this.pickup,
    required this.drop,
    required this.vehicleTypeId,
    required this.paymentType,
  });

  @override
  List<Object?> get props => [customerId, pickup, drop, vehicleTypeId, paymentType];
}
```

### Step 4: Create Model (Data Layer)

```dart
// features/booking/data/models/booking_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.customerId,
    super.driverId,
    required super.bookingStatus,
    required super.pickupLocation,
    required super.dropLocation,
    required super.totalAmount,
    required super.paymentType,
    required super.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      customerId: json['customerId'] ?? '',
      driverId: json['driverId'],
      bookingStatus: json['bookingStatus'] ?? '',
      pickupLocation: LocationLatLng.fromJson(json['pickupLocation'] ?? {}),
      dropLocation: LocationLatLng.fromJson(json['dropLocation'] ?? {}),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      paymentType: json['paymentType'] ?? 'cash',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'driverId': driverId,
      'bookingStatus': bookingStatus,
      'pickupLocation': pickupLocation.toJson(),
      'dropLocation': dropLocation.toJson(),
      'totalAmount': totalAmount,
      'paymentType': paymentType,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.now(),
    };
  }

  BookingEntity toEntity() => BookingEntity(
    id: id,
    customerId: customerId,
    driverId: driverId,
    bookingStatus: bookingStatus,
    pickupLocation: pickupLocation,
    dropLocation: dropLocation,
    totalAmount: totalAmount,
    paymentType: paymentType,
    createdAt: createdAt,
  );
}
```

### Step 5: Create DataSource (Data Layer)

```dart
// features/booking/data/datasources/booking_remote_datasource.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/constants/collection_names.dart';
import 'package:core/errors/exceptions.dart';

abstract class BookingRemoteDataSource {
  Future<BookingModel> createBooking(CreateBookingParams params);
  Future<BookingModel> getBooking(String id);
  Stream<BookingModel> watchBooking(String id);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final FirebaseFirestore firestore;
  BookingRemoteDataSourceImpl({required this.firestore});

  @override
  Future<BookingModel> createBooking(CreateBookingParams params) async {
    try {
      final doc = firestore.collection(CollectionName.bookings).doc();
      final model = BookingModel(
        id: doc.id,
        customerId: params.customerId,
        bookingStatus: BookingStatus.placed,
        pickupLocation: params.pickup,
        dropLocation: params.drop,
        totalAmount: 0, // calculated server-side or in use case
        paymentType: params.paymentType,
        createdAt: DateTime.now(),
      );
      await doc.set(model.toJson());
      return model;
    } catch (e) {
      throw ServerException('Failed to create booking: $e');
    }
  }

  @override
  Stream<BookingModel> watchBooking(String id) {
    return firestore
        .collection(CollectionName.bookings)
        .doc(id)
        .snapshots()
        .map((doc) => BookingModel.fromJson(doc.data()!));
  }
}
```

### Step 6: Implement Repository (Data Layer)

```dart
// features/booking/data/repositories/booking_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:core/errors/failures.dart';
import 'package:core/errors/exceptions.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  BookingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, BookingEntity>> createBooking(CreateBookingParams params) async {
    try {
      final model = await remoteDataSource.createBooking(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Stream<Either<Failure, BookingEntity>> watchBooking(String id) {
    return remoteDataSource.watchBooking(id).map(
      (model) => Right<Failure, BookingEntity>(model.toEntity()),
    ).handleError(
      (e) => Left<Failure, BookingEntity>(ServerFailure(e.toString())),
    );
  }
}
```

### Step 7: Create BLoC (Presentation Layer)

```dart
// features/booking/presentation/bloc/booking_event.dart
sealed class BookingEvent extends Equatable {
  const BookingEvent();
}

class BookingCreated extends BookingEvent {
  final CreateBookingParams params;
  const BookingCreated(this.params);
  @override
  List<Object?> get props => [params];
}

class BookingStreamStarted extends BookingEvent {
  final String bookingId;
  const BookingStreamStarted(this.bookingId);
  @override
  List<Object?> get props => [bookingId];
}

class BookingCancelRequested extends BookingEvent {
  final String bookingId;
  final String reason;
  const BookingCancelRequested(this.bookingId, this.reason);
  @override
  List<Object?> get props => [bookingId, reason];
}
```

```dart
// features/booking/presentation/bloc/booking_state.dart
sealed class BookingState extends Equatable {
  const BookingState();
}

class BookingInitial extends BookingState {
  @override
  List<Object?> get props => [];
}

class BookingLoading extends BookingState {
  @override
  List<Object?> get props => [];
}

class BookingPlacedState extends BookingState {
  final BookingEntity booking;
  const BookingPlacedState(this.booking);
  @override
  List<Object?> get props => [booking];
}

class BookingUpdated extends BookingState {
  final BookingEntity booking;
  const BookingUpdated(this.booking);
  @override
  List<Object?> get props => [booking];
}

class BookingError extends BookingState {
  final String message;
  const BookingError(this.message);
  @override
  List<Object?> get props => [message];
}
```

```dart
// features/booking/presentation/bloc/booking_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBooking createBooking;
  final GetBooking getBooking;
  final CancelBooking cancelBooking;

  StreamSubscription? _bookingSubscription;

  BookingBloc({
    required this.createBooking,
    required this.getBooking,
    required this.cancelBooking,
  }) : super(BookingInitial()) {
    on<BookingCreated>(_onBookingCreated);
    on<BookingStreamStarted>(_onBookingStreamStarted);
    on<BookingCancelRequested>(_onBookingCancelRequested);
  }

  Future<void> _onBookingCreated(
    BookingCreated event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    final result = await createBooking(event.params);
    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (booking) => emit(BookingPlacedState(booking)),
    );
  }

  Future<void> _onBookingStreamStarted(
    BookingStreamStarted event,
    Emitter<BookingState> emit,
  ) async {
    await _bookingSubscription?.cancel();
    await emit.forEach(
      getBooking.watch(event.bookingId),
      onData: (Either<Failure, BookingEntity> result) {
        return result.fold(
          (failure) => BookingError(failure.message),
          (booking) => BookingUpdated(booking),
        );
      },
    );
  }

  @override
  Future<void> close() {
    _bookingSubscription?.cancel();
    return super.close();
  }
}
```

### Step 8: Create Page (Presentation Layer)

```dart
// features/booking/presentation/pages/booking_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Book a Ride')),
        body: BlocConsumer<BookingBloc, BookingState>(
          listener: (context, state) {
            if (state is BookingError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
            if (state is BookingPlacedState) {
              context.go('/tracking/${state.booking.id}');
            }
          },
          builder: (context, state) {
            return switch (state) {
              BookingInitial() => const BookingForm(),
              BookingLoading() => const Center(child: CircularProgressIndicator()),
              BookingPlacedState(:final booking) => BookingConfirmation(booking: booking),
              BookingError(:final message) => ErrorDisplay(message: message),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }
}
```

### Step 9: Register in Dependency Injection

```dart
// injection_container.dart
void initBookingFeature() {
  // BLoC
  sl.registerFactory(() => BookingBloc(
    createBooking: sl(),
    getBooking: sl(),
    cancelBooking: sl(),
  ));

  // UseCases
  sl.registerLazySingleton(() => CreateBooking(sl()));
  sl.registerLazySingleton(() => GetBooking(sl()));
  sl.registerLazySingleton(() => CancelBooking(sl()));

  // Repository
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );

  // DataSource
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(firestore: sl()),
  );
}
```

### Step 10: Add Route

```dart
// app/router.dart
GoRoute(
  path: '/booking/:type',
  builder: (context, state) => BookingPage(
    rideType: state.pathParameters['type']!,
  ),
),
```

---

## Key Dependencies

### All Apps (Customer, Driver, Admin)
```yaml
dependencies:
  flutter:
    sdk: flutter

  # Core shared package
  core:
    path: ../core

  # Firebase
  firebase_core: ^4.4.0
  cloud_firestore: ^6.1.2
  firebase_auth: ^6.1.4
  firebase_storage: ^13.0.6
  firebase_messaging: ^16.1.1

  # State Management (BLoC)
  flutter_bloc: ^8.1.0
  bloc: ^8.1.0

  # Dependency Injection
  get_it: ^7.6.0
  injectable: ^2.3.0

  # Functional Programming
  dartz: ^0.10.1

  # Equality
  equatable: ^2.0.5

  # Navigation
  go_router: ^14.0.0

  # Maps & Location
  google_maps_flutter: latest
  geolocator: latest
  geocoding: latest
  geo_flutter_fire2: latest

  # Payment
  flutter_stripe: ^12.2.0

  # UI
  flutter_screenutil: latest
  flutter_svg: latest
  cached_network_image: latest
  flutter_rating_bar: latest

  # Utilities
  uuid: latest
  image_picker: latest
  flutter_image_compress: latest
  path_provider: latest
  url_launcher: latest

  # Notifications
  flutter_local_notifications: latest

  # Analytics & Crash Reporting
  firebase_analytics: latest
  firebase_crashlytics: latest
  firebase_performance: latest

  # Connectivity (offline detection)
  connectivity_plus: latest

  # Animations
  lottie: latest

dev_dependencies:
  # Code Generation (for injectable)
  injectable_generator: ^2.4.0
  build_runner: ^2.4.0

  # Testing
  bloc_test: ^9.1.0
  mocktail: ^1.0.0
```

### Admin Panel (Additional)
```yaml
dependencies:
  html_editor_enhanced: latest
  syncfusion_flutter_datepicker: latest
  excel: latest
```

### Cloud Functions
```json
{
  "dependencies": {
    "firebase-admin": "^13.6.0",
    "firebase-functions": "^7.0.0"
  },
  "engines": { "node": "24" }
}
```

---

## Coding Conventions

### Clean Architecture Rules
- **Domain layer:** Pure Dart only — no Flutter, no Firebase, no packages except `equatable` and `dartz`
- **Data layer:** Implements domain interfaces — can use Firebase, HTTP, local storage
- **Presentation layer:** Flutter UI + BLoC — can use Flutter and `flutter_bloc`
- **Dependency direction:** Presentation → Domain ← Data (NEVER reversed)

### BLoC Conventions
- One BLoC per feature (or sub-feature if complex)
- Events: sealed class, past tense or descriptive (`BookingCreated`, `PaymentRequested`)
- States: sealed class, descriptive (`BookingLoading`, `BookingPlacedState`)
- **NEVER** use generic `Loading` / `Error` — always prefix with feature name
- Use `Emitter<State>` pattern (not deprecated `mapEventToState`)
- Handle streams with `emit.forEach()` or `StreamSubscription`

### Dart/Flutter
- **File names:** `snake_case.dart`
- **Class names:** `PascalCase`
- **Variables/methods:** `camelCase`
- **Constants:** `camelCase` (runtime), `SCREAMING_SNAKE` (compile-time)
- **Nullable fields:** Always use `?` suffix
- **Async:** Always use `async/await`
- **Error handling:** Return `Either<Failure, T>` from repositories, never throw

### Firestore
- **Collection names:** Always use `CollectionName` constants (in core/)
- **Document IDs:** Auto-generated unless business logic requires custom IDs
- **Timestamps:** Always include `createdAt` and `updatedAt`
- **Numeric values:** Use `double` for monetary amounts
- **Search:** Include `searchKeywords` array on searchable documents

### Git
- **Branch naming:** `feature/feature-name`, `fix/bug-description`, `chore/task-name`
- **Commit messages:** Concise, present tense ("Add booking bloc", "Fix wallet balance")
- **Never commit:** `firebase_options.dart` with real keys, `.env` files, API keys

---

## Testing Guide

### BLoC Testing (Most Important)

```dart
// test/features/booking/presentation/bloc/booking_bloc_test.dart
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateBooking extends Mock implements CreateBooking {}
class MockGetBooking extends Mock implements GetBooking {}

void main() {
  late BookingBloc bloc;
  late MockCreateBooking mockCreateBooking;

  setUp(() {
    mockCreateBooking = MockCreateBooking();
    bloc = BookingBloc(createBooking: mockCreateBooking, ...);
  });

  blocTest<BookingBloc, BookingState>(
    'emits [BookingLoading, BookingPlacedState] when BookingCreated succeeds',
    build: () {
      when(() => mockCreateBooking(any())).thenAnswer(
        (_) async => Right(testBookingEntity),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(BookingCreated(testParams)),
    expect: () => [
      BookingLoading(),
      BookingPlacedState(testBookingEntity),
    ],
  );

  blocTest<BookingBloc, BookingState>(
    'emits [BookingLoading, BookingError] when BookingCreated fails',
    build: () {
      when(() => mockCreateBooking(any())).thenAnswer(
        (_) async => Left(ServerFailure('Network error')),
      );
      return bloc;
    },
    act: (bloc) => bloc.add(BookingCreated(testParams)),
    expect: () => [
      BookingLoading(),
      BookingError('Network error'),
    ],
  );
}
```

### UseCase Testing

```dart
// test/features/booking/domain/usecases/create_booking_test.dart
class MockBookingRepository extends Mock implements BookingRepository {}

void main() {
  late CreateBooking useCase;
  late MockBookingRepository mockRepo;

  setUp(() {
    mockRepo = MockBookingRepository();
    useCase = CreateBooking(mockRepo);
  });

  test('should create booking via repository', () async {
    when(() => mockRepo.createBooking(any())).thenAnswer(
      (_) async => Right(testBookingEntity),
    );

    final result = await useCase(testParams);

    expect(result, Right(testBookingEntity));
    verify(() => mockRepo.createBooking(testParams)).called(1);
  });
}
```

### Model Testing

```dart
// test/features/booking/data/models/booking_model_test.dart
void main() {
  test('fromJson → toJson roundtrip', () {
    final json = { 'id': '123', 'customerId': 'c1', ... };
    final model = BookingModel.fromJson(json);
    final result = model.toJson();

    expect(result['id'], json['id']);
    expect(result['customerId'], json['customerId']);
  });

  test('toEntity returns correct BookingEntity', () {
    final model = BookingModel(...);
    final entity = model.toEntity();

    expect(entity, isA<BookingEntity>());
    expect(entity.id, model.id);
  });
}
```

### Running Tests

```bash
# Run all tests in an app
cd customer && flutter test

# Run specific test file
flutter test test/features/booking/presentation/bloc/booking_bloc_test.dart

# Run with coverage
flutter test --coverage
```

---

## Build & Deploy

### Customer App (Android)
```bash
cd customer
flutter clean && flutter pub get
flutter build apk --release
flutter build appbundle --release    # For Play Store
```

### Customer App (iOS)
```bash
cd customer
flutter clean && flutter pub get
flutter build ios --release
# Open Xcode → Archive → Distribute
```

### Driver App
```bash
# Same commands from driver/ directory
```

### Admin Panel (Web)
```bash
cd admin
flutter clean && flutter pub get
flutter build web --release
# Deploy build/web/ to Firebase Hosting
```

### Cloud Functions
```bash
cd functions
firebase deploy --only functions
```

### Firestore Indexes
```bash
firebase deploy --only firestore:indexes
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Firebase init fails | Run `flutterfire configure` again |
| Google Maps blank | Check API key in `settings/constant.mapAPIKey` |
| Stripe payment fails | Verify keys in `settings/payment.strip` |
| Push notifications not received | Check FCM token in user document |
| Build fails after model change | Run `flutter clean && flutter pub get` |
| Firestore permission denied | Check Firestore security rules |
| iOS build fails | Run `cd ios && pod install` |
| Admin login fails | Ensure admin document exists in `admin` collection |
| get_it not finding dependency | Ensure `initBookingFeature()` called in injection_container |
| BLoC not receiving events | Verify BlocProvider is above BlocBuilder in widget tree |
| Either/Failure import error | Add `dartz` to pubspec.yaml |
| injectable code gen fails | Run `dart run build_runner build --delete-conflicting-outputs` |
