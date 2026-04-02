# ARCHITECTURE.md - RWP3 Technical Architecture Reference

## System Overview

RWP3 is a ride-sharing platform with 3 Flutter applications and a shared core package, all backed by a single Firebase project.

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│  Customer App │  │  Driver App   │  │  Admin Panel  │
│  (iOS/Android)│  │  (iOS/Android)│  │  (Flutter Web)│
└──────┬───────┘  └──────┬───────┘  └──────┬───────┘
       │                  │                  │
       └────────┬─────────┼─────────┬────────┘
                │         │         │
         ┌──────▼─────────▼─────────▼──────┐
         │        core/ (shared package)    │
         │  Entities, Repos, UseCases, Utils│
         └──────────────┬──────────────────┘
                        │
              ┌─────────┴─────────┐
              │   Firebase Backend │
              │  ┌───────────────┐│
              │  │Cloud Firestore ││
              │  │Authentication  ││
              │  │Cloud Functions  ││
              │  │Cloud Storage    ││
              │  │Cloud Messaging  ││
              │  └───────────────┘│
              └───────────────────┘
```

---

## Tech Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Frontend Framework | Flutter | >= 3.2.6 |
| Language | Dart | >= 3.2.6 |
| State Management | flutter_bloc | ^8.1.0+ |
| Architecture | Clean Architecture (3 layers) | - |
| Dependency Injection | get_it + injectable | Latest |
| Functional Programming | dartz (Either, Option) | Latest |
| Equality | equatable | Latest |
| Backend | Firebase | Latest |
| Database | Cloud Firestore | Latest |
| Auth | Firebase Authentication (Email, Phone, Google, Apple) | Latest |
| UI System | Material Design 3 (Material You) | Built-in |
| Cloud Functions | Node.js | v24 |
| Push Notifications | Firebase Cloud Messaging | Latest |
| File Storage | Firebase Storage | Latest |
| Maps | Google Maps Flutter | Latest |
| Routing | go_router | Latest |
| Payment | Stripe (flutter_stripe) | ^12.2.0 |

---

## Clean Architecture

### Three Layers

```
┌─────────────────────────────────────────────┐
│              PRESENTATION                    │
│  Pages, Widgets, BLoCs (Events + States)    │
│  Depends on: Domain only                     │
├─────────────────────────────────────────────┤
│                DOMAIN                        │
│  Entities, UseCases, Repository Interfaces   │
│  Depends on: NOTHING (pure Dart)             │
├─────────────────────────────────────────────┤
│                 DATA                         │
│  Models, DataSources, Repository Impls       │
│  Depends on: Domain (implements interfaces)  │
│  Uses: Firebase, HTTP, local storage         │
└─────────────────────────────────────────────┘
```

### Dependency Rule
```
Presentation → Domain ← Data
```
- Domain has ZERO external dependencies
- Presentation depends on Domain only (via UseCases)
- Data implements Domain interfaces, has Firebase/network dependencies
- **NEVER** violate this rule

### Data Flow
```
UI (Page) → BLoC Event → BLoC → UseCase → Repository (interface)
                                              ↓
                                    RepositoryImpl → DataSource → Firestore
                                              ↓
BLoC State ← BLoC ← Either<Failure, Entity> ← RepositoryImpl
     ↓
UI rebuilds via BlocBuilder/BlocListener
```

---

## Project Structure

### Monorepo Layout
```
RWP3/
├── core/                           # Shared Dart package
│   ├── lib/
│   │   ├── core.dart               # Barrel export
│   │   ├── constants/
│   │   │   ├── collection_names.dart
│   │   │   ├── booking_status.dart
│   │   │   └── app_constants.dart
│   │   ├── entities/               # Shared domain entities
│   │   │   ├── user_entity.dart
│   │   │   ├── driver_entity.dart
│   │   │   ├── booking_entity.dart
│   │   │   ├── intercity_entity.dart
│   │   │   ├── parcel_entity.dart
│   │   │   ├── rental_entity.dart
│   │   │   ├── vehicle_type_entity.dart
│   │   │   ├── location_latlng.dart
│   │   │   ├── payment_entity.dart
│   │   │   └── ...
│   │   ├── models/                 # Shared data models (extend entities)
│   │   │   ├── user_model.dart
│   │   │   ├── booking_model.dart
│   │   │   └── ...
│   │   ├── errors/
│   │   │   ├── failures.dart       # Failure sealed class hierarchy
│   │   │   └── exceptions.dart     # Exception types
│   │   ├── usecases/
│   │   │   └── usecase.dart        # Base UseCase<Type, Params> interface
│   │   └── utils/
│   │       ├── firestore_helpers.dart
│   │       └── validators.dart
│   └── pubspec.yaml
│
├── customer/                       # Customer mobile app
│   ├── lib/
│   │   ├── main.dart
│   │   ├── firebase_options.dart
│   │   ├── injection_container.dart  # get_it registration
│   │   ├── app/
│   │   │   ├── app.dart             # MaterialApp + BlocProviders
│   │   │   ├── router.dart          # go_router config
│   │   │   └── theme.dart           # App theme
│   │   └── features/
│   │       ├── auth/
│   │       │   ├── data/
│   │       │   │   ├── datasources/auth_remote_datasource.dart
│   │       │   │   ├── models/auth_model.dart
│   │       │   │   └── repositories/auth_repository_impl.dart
│   │       │   ├── domain/
│   │       │   │   ├── repositories/auth_repository.dart
│   │       │   │   └── usecases/
│   │       │   │       ├── login_with_email.dart
│   │       │   │       ├── signup_with_email.dart
│   │       │   │       ├── reset_password.dart
│   │       │   │       ├── login_with_phone.dart
│   │       │   │       ├── verify_otp.dart
│   │       │   │       ├── login_with_google.dart
│   │       │   │       └── signup_user.dart
│   │       │   └── presentation/
│   │       │       ├── bloc/
│   │       │       │   ├── auth_bloc.dart
│   │       │       │   ├── auth_event.dart
│   │       │       │   └── auth_state.dart
│   │       │       ├── pages/
│   │       │       │   ├── login_page.dart
│   │       │       │   ├── otp_page.dart
│   │       │       │   └── signup_page.dart
│   │       │       └── widgets/
│   │       ├── booking/
│   │       │   ├── data/
│   │       │   ├── domain/
│   │       │   └── presentation/
│   │       ├── tracking/
│   │       ├── payment/
│   │       ├── wallet/
│   │       ├── chat/
│   │       ├── profile/
│   │       ├── home/
│   │       ├── intercity/
│   │       ├── parcel/
│   │       ├── rental/
│   │       ├── review/
│   │       ├── coupon/
│   │       ├── loyalty/
│   │       ├── referral/
│   │       ├── support/
│   │       ├── sos/
│   │       ├── notification/
│   │       └── settings/
│   ├── android/
│   ├── ios/
│   └── pubspec.yaml
│
├── driver/                         # Driver mobile app (same clean arch)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── injection_container.dart
│   │   ├── app/
│   │   └── features/
│   │       ├── auth/
│   │       ├── home/
│   │       ├── booking/             # Ride acceptance, OTP, completion
│   │       ├── tracking/
│   │       ├── payment/
│   │       ├── wallet/
│   │       ├── bank/                # Bank details management
│   │       ├── documents/           # Document upload & verification
│   │       ├── vehicle/             # Vehicle management
│   │       ├── subscription/        # Subscription plans
│   │       ├── statement/           # Financial statements (Excel)
│   │       ├── chat/
│   │       ├── profile/
│   │       ├── intercity/
│   │       ├── parcel/
│   │       ├── rental/
│   │       ├── review/
│   │       ├── support/
│   │       ├── sos/
│   │       ├── referral/
│   │       ├── notification/
│   │       └── settings/
│   └── pubspec.yaml
│
├── admin/                          # Admin web panel (same clean arch)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── injection_container.dart
│   │   ├── app/
│   │   └── features/
│   │       ├── auth/
│   │       ├── dashboard/
│   │       ├── customers/
│   │       ├── drivers/
│   │       ├── bookings/            # All 4 ride types
│   │       ├── vehicles/            # Types, brands, models
│   │       ├── zones/
│   │       ├── payment_config/
│   │       ├── tax/
│   │       ├── currency/
│   │       ├── subscriptions/
│   │       ├── payouts/
│   │       ├── coupons/
│   │       ├── banners/
│   │       ├── documents/
│   │       ├── notifications/
│   │       ├── support/
│   │       ├── sos/
│   │       ├── roles/
│   │       ├── employees/
│   │       ├── onboarding/
│   │       ├── email_templates/
│   │       ├── settings/
│   │       └── rental_packages/
│   └── pubspec.yaml
│
├── functions/                      # Firebase Cloud Functions
│   ├── index.js
│   └── package.json
│
├── database/                       # Firestore seed data & scripts
│   ├── database.json
│   ├── import.js
│   ├── export.js
│   └── config.json
│
├── firestore_indexes/
│   └── firestore.indexes.json
│
├── CLAUDE.md
├── ARCHITECTURE.md
├── DESIGN.md
├── DEVELOPMENT.md
└── PROJECT.md
```

---

## BLoC Pattern Details

### Event-Driven State Machine

Every BLoC follows this pattern:

```dart
// Events (sealed class — exhaustive matching)
sealed class BookingEvent extends Equatable {}
class BookingRequested extends BookingEvent { ... }
class BookingStatusChanged extends BookingEvent { ... }
class BookingCancelled extends BookingEvent { ... }

// States (sealed class — exhaustive matching)
sealed class BookingState extends Equatable {}
class BookingInitial extends BookingState {}
class BookingLoading extends BookingState {}
class BookingLoaded extends BookingState { final BookingEntity booking; }
class BookingError extends BookingState { final String message; }

// BLoC
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBooking createBookingUseCase;
  final GetBooking getBookingUseCase;

  BookingBloc({required this.createBookingUseCase, required this.getBookingUseCase})
      : super(BookingInitial()) {
    on<BookingRequested>(_onBookingRequested);
    on<BookingStatusChanged>(_onBookingStatusChanged);
    on<BookingCancelled>(_onBookingCancelled);
  }

  Future<void> _onBookingRequested(BookingRequested event, Emitter<BookingState> emit) async {
    emit(BookingLoading());
    final result = await createBookingUseCase(event.params);
    result.fold(
      (failure) => emit(BookingError(message: failure.message)),
      (booking) => emit(BookingLoaded(booking: booking)),
    );
  }
}
```

### UseCase Pattern

```dart
// Base interface (in core/)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

// Concrete UseCase
class CreateBooking implements UseCase<BookingEntity, CreateBookingParams> {
  final BookingRepository repository;
  CreateBooking(this.repository);

  @override
  Future<Either<Failure, BookingEntity>> call(CreateBookingParams params) {
    return repository.createBooking(params);
  }
}
```

### Repository Pattern

```dart
// Domain layer (interface)
abstract class BookingRepository {
  Future<Either<Failure, BookingEntity>> createBooking(CreateBookingParams params);
  Future<Either<Failure, BookingEntity>> getBooking(String id);
  Stream<Either<Failure, List<BookingEntity>>> watchBookings(String userId);
}

// Data layer (implementation)
class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remoteDataSource;
  BookingRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, BookingEntity>> createBooking(CreateBookingParams params) async {
    try {
      final model = await remoteDataSource.createBooking(params);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
```

### Error Handling Pattern

```dart
// Domain failures (in core/)
sealed class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure { const ServerFailure(super.message); }
class CacheFailure extends Failure { const CacheFailure(super.message); }
class ValidationFailure extends Failure { const ValidationFailure(super.message); }
class AuthFailure extends Failure { const AuthFailure(super.message); }
class PaymentFailure extends Failure { const PaymentFailure(super.message); }

// Data exceptions
class ServerException implements Exception { final String message; ServerException(this.message); }
class CacheException implements Exception { final String message; CacheException(this.message); }
```

---

## Dependency Injection

Using **get_it** as service locator:

```dart
// injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(() => BookingBloc(
    createBooking: sl(),
    getBooking: sl(),
  ));

  // UseCases
  sl.registerLazySingleton(() => CreateBooking(sl()));
  sl.registerLazySingleton(() => GetBooking(sl()));

  // Repositories
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(remoteDataSource: sl()),
  );

  // DataSources
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(firestore: sl()),
  );

  // External
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);
}
```

---

## Navigation (go_router)

```dart
final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    if (!isLoggedIn && !state.matchedLocation.startsWith('/auth')) {
      return '/auth/login';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
    GoRoute(path: '/auth/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/auth/otp', builder: (_, __) => const OtpPage()),
    GoRoute(path: '/auth/signup', builder: (_, __) => const SignupPage()),
    ShellRoute(
      builder: (_, __, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomePage()),
        GoRoute(path: '/booking/:type', builder: (_, state) => BookingPage(type: state.pathParameters['type']!)),
        GoRoute(path: '/tracking/:id', builder: (_, state) => TrackingPage(bookingId: state.pathParameters['id']!)),
        GoRoute(path: '/wallet', builder: (_, __) => const WalletPage()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
        GoRoute(path: '/chat/:userId', builder: (_, state) => ChatPage(userId: state.pathParameters['userId']!)),
        // ... more routes
      ],
    ),
  ],
);
```

---

## Firestore Database Schema

### Collections Reference

#### Core User Collections

**`users`** - Customer profiles
```
{
  id: string (auto),
  fullName: string,
  email: string,
  phoneNumber: string,
  countryCode: string,
  profilePic: string (URL),
  gender: string (Male|Female|Other),
  loginType: string (phone|google|apple),
  fcmToken: string,
  walletAmount: double (default 0),
  loyaltyCredits: double (default 0),
  totalRide: int,
  isActive: bool,
  slug: string (lowercase name for search),
  searchKeywords: array<string>,
  referralCode: string,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**`drivers`** - Driver profiles
```
{
  id: string (auto),
  fullName: string,
  email: string,
  phoneNumber: string,
  countryCode: string,
  profilePic: string (URL),
  gender: string,
  dateOfBirth: string,
  loginType: string,
  fcmToken: string,
  walletAmount: double,
  totalEarning: double,
  reviewsCount: int,
  reviewsSum: double,
  isActive: bool,
  isVerified: bool,
  isOnline: bool,
  currentBookingId: string | null,
  location: { latitude: double, longitude: double },
  position: { latitude: double, longitude: double },
  driverVehicleDetails: {
    vehicleTypeName: string,
    vehicleBrandName: string,
    vehicleModelName: string,
    vehicleNumber: string,
    vehicleTypeId: string,
    vehicleBrandId: string,
    vehicleModelId: string
  },
  verifyDocument: array<{
    documentId: string,
    frontImage: string (URL),
    backImage: string (URL),
    isVerify: bool
  }>,
  zoneId: array<string>,
  subscriptionPlanId: string,
  subscriptionExpiryDate: timestamp,
  subscriptionTotalBookings: int,
  searchKeywords: array<string>,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**`admin`** - Admin/employee accounts
```
{
  id: string (auto),
  fullName: string,
  email: string,
  phoneNumber: string,
  profilePic: string (URL),
  role: string (role ID),
  fcmToken: string,
  isActive: bool,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

#### Booking Collections

**`bookings`** - Cab ride bookings
```
{
  id: string (auto),
  customerId: string,
  driverId: string,
  bookingStatus: string (see BookingStatus),
  pickupLocation: { latitude: double, longitude: double, address: string },
  dropLocation: { latitude: double, longitude: double, address: string },
  stops: array<{ latitude: double, longitude: double, address: string }>,
  vehicleType: { id: string, name: string },
  otp: string,
  estimatedFare: double,
  subTotal: double,
  discount: double,
  taxAmount: double,
  totalAmount: double,
  adminCommission: { amount: double, isFixed: bool },
  paymentType: string (cash|wallet|stripe),
  paymentStatus: bool,
  stripePaymentIntentId: string,
  couponId: string,
  couponAmount: double,
  cancellationReason: string,
  cancelledBy: string (customer|driver),
  cancellationCharge: double,
  nightCharge: double,
  holdTimingCharge: double,
  isOnlyForFemale: bool,
  positions: array<{ latitude: double, longitude: double }>,
  distance: { distanceInMeters: double, distanceInKM: double, durationInMinutes: double },
  pickupTime: timestamp,
  dropTime: timestamp,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**`intercity_ride`** - Long-distance rides
```
{
  id: string (auto),
  customerId: string,
  driverId: string,
  bookingStatus: string,
  sourceLocation: { latitude: double, longitude: double, address: string },
  destinationLocation: { latitude: double, longitude: double, address: string },
  stops: array,
  vehicleType: object,
  rideType: string (personal|sharing),
  sharingPersons: array<{ name: string, phone: string }>,
  subTotal: double,
  totalAmount: double,
  paymentType: string,
  paymentStatus: bool,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**`parcel_ride`** - Parcel delivery bookings
```
{
  id: string (auto),
  customerId: string,
  driverId: string,
  bookingStatus: string,
  pickupLocation: object,
  dropLocation: object,
  parcelImage: string (URL),
  parcelWeight: string,
  parcelDimension: string,
  subTotal: double,
  totalAmount: double,
  paymentType: string,
  paymentStatus: bool,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

**`rental_ride`** - Rental bookings
```
{
  id: string (auto),
  customerId: string,
  driverId: string,
  bookingStatus: string,
  pickupLocation: object,
  rentalPackage: { id: string, name: string, hours: int, km: int, price: double },
  currentKM: double,
  completedKM: double,
  extraHourCharge: double,
  extraKMCharge: double,
  subTotal: double,
  totalAmount: double,
  paymentType: string,
  paymentStatus: bool,
  createdAt: timestamp,
  updatedAt: timestamp
}
```

#### Configuration Collections

**`settings/constant`** - App configuration
```
{
  appName: string,
  appColor: string (hex),
  mapAPIKey: string,
  radius: double (km),
  interCityRadius: double,
  distanceType: string (km|mile),
  driverLocationUpdate: int (seconds),
  minimumAmountToDeposit: double,
  minimumAmountToWithdrawal: double,
  minimumAmountToAcceptRide: double,
  referralAmount: double,
  sosAlertNumber: string,
  countryCode: string,
  termsAndConditions: string (HTML),
  privacyPolicy: string (HTML),
  aboutApp: string (HTML),
  isOtpFeatureEnable: bool,
  isSubscriptionEnable: bool,
  isDocumentVerificationEnable: bool,
  isDriverAutoApproved: bool,
  cancellationReason: array<string>,
  nightTimingModel: { startTime: string, endTime: string, charge: double },
  cancellationCharge: { isCancellationChargeApply: bool, amount: double, isFixed: bool }
}
```

**`settings/payment`** - Payment gateway config
```
{
  strip: { clientPublishableKey: string, stripeSecret: string, isActive: bool, name: string, isSandbox: bool },
  wallet: { isActive: bool, name: string },
  cash: { isActive: bool, name: string }
}
```

**`settings/admin_commission`** - Commission settings
```
{ isEnabled: bool, amount: double, isFixed: bool }
```

**`settings/globalValue`** - Global values
```
{ distanceType: string }
```

#### Catalog Collections

**`vehicle_type`**
```
{ id, name, image, isActive, persons, basefare, perKmRate, perMinuteRate, minimumFare }
```

**`vehicle_brand`**
```
{ id, brandName, image, isActive }
```

**`vehicle_model`**
```
{ id, modelName, brandId, isActive }
```

**`zones`**
```
{ id, name, coordinates: array<GeoPoint>, isActive }
```

**`rental_packages`**
```
{ id, name, hours: int, km: int, price: double, isActive: bool }
```

**`documents`**
```
{ id, title, isTwoSide: bool, isEnable: bool }
```

#### Financial Collections

**`wallet_transaction`**
```
{ id, userId, amount: double, type: string (credit|debit), note: string, transactionId: string, createdAt: timestamp }
```

**`withdrawal_history`**
```
{ id, driverId, amount: double, status: string (pending|approved|rejected), bankDetails: object, createdAt: timestamp }
```

**`country_tax`**
```
{ id, country: string, taxPercentage: double, isActive: bool }
```

**`currencies`**
```
{ id, code: string, symbol: string, name: string, decimalDigits: int, symbolAtRight: bool, isActive: bool }
```

**`subscription_plans`**
```
{ id, name, description, price: double, expiryDays: int, totalBookings: int, isActive: bool }
```

**`subscription_history`**
```
{ id, driverId, planId, purchaseDate: timestamp, expiryDate: timestamp, amount: double }
```

#### Communication Collections

**`chat/{userId}/inbox/{otherUserId}`**
```
{ orderId: string, lastMessage: string, timestamp: timestamp, senderId: string }
```

**`chat/{userId}/{otherUserId}/{messageId}`**
```
{ id, senderId, message: string, timestamp: timestamp, type: string (text|image) }
```

**`notification`**
```
{ id, title: string, body: string, type: string, userId: string, bookingId: string, createdAt: timestamp }
```

**`notification_from_admin`**
```
{ id, title, body, sendTo: string (customer|driver|all), createdAt: timestamp }
```

#### Support Collections

**`support_reason`**
```
{ id, title: string, description: string }
```

**`support_ticket`**
```
{ id, userId, subject, description, status: string (pending|active|complete), reason: string, createdAt: timestamp }
```

**`help_support_ticket`**
```
{ id, userId, bookingId, type: string (cab|intercity|parcel|rental), messages: array, status: string, createdAt: timestamp }
```

**`sos_alerts`**
```
{ id, userId, bookingId, location: GeoPoint, contactNumber: string, type: string, createdAt: timestamp }
```

#### Content Collections

**`banner`**
```
{ id, image: string (URL), isActive: bool, createdAt: timestamp }
```

**`coupon`**
```
{ id, code: string, discount: double, isPercentage: bool, minOrderAmount: double, maxDiscount: double, expiryDate: timestamp, isActive: bool, isPublic: bool }
```

**`onboarding_screen`**
```
{ id, title, description, image: string (URL), order: int }
```

**`email_template`**
```
{ id, name, subject, body: string (HTML) }
```

**`languages`**
```
{ id, code: string, name: string, translations: map<string, string> }
```

#### Access Control Collections

**`role_permissions`**
```
{
  id: string,
  roleTitle: string,
  isEdit: bool,
  permissions: array<{
    title: string,
    isView: bool,
    isCreate: bool,
    isUpdate: bool,
    isDelete: bool
  }>
}
```

**`referral`**
```
{ id, userId, referralCode, referralBy: string (userId), role: string, createdAt: timestamp }
```

**`loyalty_point_transaction`**
```
{ id, userId, points: double, action: string, bookingId: string, createdAt: timestamp }
```

**`bank_details`**
```
{ id, driverId, holderName, accountNumber, swiftCode, ifscCode, bankName, branchCity, branchCountry, isDefault: bool }
```

---

## Booking Status State Machine

```
                    ┌──────────────────┐
                    │  booking_placed   │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │ driver_assigned   │───────► booking_rejected
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
                    │ booking_accepted  │
                    └────────┬─────────┘
                             │
                    ┌────────▼─────────┐
              ┌─────│ booking_ongoing   │─────┐
              │     └────────┬─────────┘     │
              │              │               │
     ┌────────▼────────┐    │    ┌──────────▼──────────┐
     │ booking_onHold   │────┘    │ booking_completed    │
     └─────────────────┘         └─────────────────────┘

     Any state (except completed) ──► booking_cancelled
```

### BLoC Event Mapping

| Booking Transition | BLoC Event | Emitted State |
|-------------------|------------|---------------|
| → placed | `BookingCreated` | `BookingPlacedState` |
| placed → assigned | `DriverAssigned` | `BookingDriverAssignedState` |
| assigned → accepted | `BookingAcceptedByDriver` | `BookingAcceptedState` |
| assigned → rejected | `BookingRejectedByDriver` | `BookingRejectedState` |
| accepted → ongoing | `RideStarted` | `BookingOngoingState` |
| ongoing → on_hold | `RidePaused` | `BookingOnHoldState` |
| on_hold → ongoing | `RideResumed` | `BookingOngoingState` |
| ongoing → completed | `RideCompleted` | `BookingCompletedState` |
| any → cancelled | `BookingCancelledBy` | `BookingCancelledState` |

**Status Colors:**
| Status | Color | Hex |
|--------|-------|-----|
| Placed | Grey | #9D9D9D |
| Accepted | Blue | #1EADFF |
| Ongoing | Orange | #D19D00 |
| On Hold | Yellow | #FFC107 |
| Completed | Green | #27C041 |
| Cancelled | Red | #FE7235 |
| Rejected | Red | #FE7235 |

---

## Authentication Flow

```
App Launch
  │
  ├─► AuthBloc: CheckAuthStatus event
  │     ├─► Authenticated state → HomeBloc
  │     └─► Unauthenticated state → LoginPage
  │
  Login Methods:
  ├─► EmailLoginRequested(email, password) → Firebase Email Auth
  ├─► EmailSignupRequested(email, password, profile) → Create account + profile
  ├─► PasswordResetRequested(email) → Send reset email
  ├─► PhoneLoginRequested(phone) → OTP sent → OtpPage
  ├─► OtpVerified → Check profile exists
  ├─► GoogleLoginRequested → Firebase Google Auth
  └─► AppleLoginRequested → Firebase Apple Auth
  │
  Post-Login:
  ├─► ProfileExists → Authenticated state → Home
  └─► ProfileMissing → SignupRequired state → SignupPage
        └─► SignupSubmitted → ProfileCreated → Home
```

---

## Payment Flow

```
PaymentBloc Events & States:

PaymentMethodSelected(method)
  → PaymentMethodReady(method)

PaymentRequested(amount, method)
  ├─► method == cash → PaymentDeferred (pay on completion)
  ├─► method == wallet
  │     ├─► sufficient balance → WalletDeducted → PaymentSuccess
  │     └─► insufficient → PaymentFailed("Insufficient wallet balance")
  └─► method == stripe
        → PaymentProcessing
        → Stripe.createPaymentIntent(amount)
        → Stripe.presentPaymentSheet()
        ├─► success → PaymentSuccess(transactionId)
        └─► failure → PaymentFailed(error)

PaymentSuccess → BookingBloc.add(PaymentCompleted)
```

---

## Real-Time Data Flow

```
Firestore Streams → Repository → BLoC StreamSubscription → State emission → UI rebuild

Examples:
├─► bookings.snapshots() → BookingBloc → BookingUpdated state
├─► drivers/{id}.snapshots() → TrackingBloc → DriverLocationUpdated state
├─► chat/{id}.snapshots() → ChatBloc → NewMessageReceived state
└─► settings.snapshots() → SettingsBloc → SettingsUpdated state
```

---

## Push Notification Architecture

```
FCM Token → stored in user/driver document on app launch

Notification Events:
├─► Foreground: NotificationBloc.add(NotificationReceived)
├─► Background: Handled by onBackgroundMessage
└─► Tap: Deep link via go_router path

Payload:
{
  "type": "cab|intercity|parcel|rental|chat|support",
  "bookingId": "...",
  "customerId": "...",
  "driverId": "..."
}

Topics:
├─► "rwp3-customer" (all customers)
└─► "rwp3-driver" (all drivers)
```

---

## Cloud Functions

**Location:** `/functions/`
**Runtime:** Node.js v24
**Planned Functions:**
- Auto-ride assignment (match drivers to bookings)
- Queue management (booking queue processing)
- Booking state transition validation
- Scheduled cleanup (expired bookings, stale tokens)
- Notification triggers (Firestore-triggered)

---

## Maps Integration

**Dual Map Support:**
- Google Maps (primary) — requires API key
- OpenStreetMap (fallback) — free, no key required

**Features:**
- Polyline route rendering with caching (20-min TTL)
- Deviation detection (120m for cab, 400m for driver)
- ETA calculation with throttling (5-second intervals)
- Geocoding (address ↔ coordinates)
- GeoFlutterFire for proximity queries (nearby drivers)
- Zone geofencing (polygon-based)

---

## File Storage Structure

```
Firebase Storage/
├── profile_pictures/
│   ├── users/{userId}/profile.jpg
│   └── drivers/{driverId}/profile.jpg
├── documents/
│   └── drivers/{driverId}/{documentId}_front.jpg
│   └── drivers/{driverId}/{documentId}_back.jpg
├── parcels/
│   └── {parcelId}/parcel_image.jpg
├── banners/
│   └── {bannerId}/banner.jpg
└── vehicles/
    └── {vehicleTypeId}/image.jpg
```

---

## UI System - Material Design 3

### Design Language
- **Style:** Modern & Clean — rounded corners, generous white space, subtle elevation
- **Framework:** Material Design 3 (Material You) with `useMaterial3: true`
- **Responsive:** Adaptive layouts for mobile, tablet, and web (admin)

### Color Theme

```dart
// Primary: Red | Secondary: Blue | Surface: White
// Seed-based theming with manual overrides

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFFD32F2F),         // Red 700
    onPrimary: Color(0xFFFFFFFF),       // White
    primaryContainer: Color(0xFFFFCDD2), // Red 100
    onPrimaryContainer: Color(0xFFB71C1C), // Red 900
    secondary: Color(0xFF1976D2),       // Blue 700
    onSecondary: Color(0xFFFFFFFF),     // White
    secondaryContainer: Color(0xFFBBDEFB), // Blue 100
    onSecondaryContainer: Color(0xFF0D47A1), // Blue 900
    surface: Color(0xFFFFFFFF),         // White
    onSurface: Color(0xFF1C1B1F),       // Near black
    surfaceContainerHighest: Color(0xFFF5F5F5), // Light grey
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    outline: Color(0xFFE0E0E0),         // Light border
  ),
  fontFamily: 'Inter', // or system default
);

final darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFEF5350),         // Red 400 (lighter for dark)
    onPrimary: Color(0xFF1C1B1F),
    primaryContainer: Color(0xFFB71C1C),
    onPrimaryContainer: Color(0xFFFFCDD2),
    secondary: Color(0xFF42A5F5),       // Blue 400
    onSecondary: Color(0xFF1C1B1F),
    secondaryContainer: Color(0xFF0D47A1),
    onSecondaryContainer: Color(0xFFBBDEFB),
    surface: Color(0xFF1C1B1F),
    onSurface: Color(0xFFE6E1E5),
    surfaceContainerHighest: Color(0xFF2B2B2F),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    outline: Color(0xFF424242),
  ),
  fontFamily: 'Inter',
);
```

### Color Usage

| Element | Color | Token |
|---------|-------|-------|
| App bar, primary buttons, FAB | Red | `colorScheme.primary` |
| Links, secondary actions, icons | Blue | `colorScheme.secondary` |
| Backgrounds, cards | White | `colorScheme.surface` |
| Body text | Near black | `colorScheme.onSurface` |
| Active ride status, online badge | Green | Custom `Color(0xFF27C041)` |
| Errors, cancelled status | Red (error) | `colorScheme.error` |
| Booking status colors | Per status | See Booking Status section |

### Key M3 Components Used

| Component | Usage |
|-----------|-------|
| `FilledButton` | Primary actions (Book Ride, Pay, Confirm) |
| `OutlinedButton` | Secondary actions (Cancel, Skip) |
| `TextButton` | Tertiary actions (links, "Forgot password?") |
| `Card.filled()` | Ride cards, vehicle selection, history items |
| `Card.outlined()` | Settings items, info cards |
| `NavigationBar` | Bottom nav (Customer & Driver apps) |
| `NavigationRail` | Admin sidebar (desktop) |
| `NavigationDrawer` | Admin sidebar (mobile), Customer drawer |
| `SearchBar` | Location search, admin search |
| `SegmentedButton` | Ride type tabs, status filters |
| `Chip` / `FilterChip` | Tags, status badges, categories |
| `BottomSheet` | Vehicle selection, payment method picker |
| `Dialog` | Confirmations, OTP input, add money |
| `SnackBar` | Success/error feedback |
| `FloatingActionButton` | Primary action per screen |
| `ListTile` | Settings, history items, chat messages |
| `CircularProgressIndicator` | Loading states |

### Typography (Inter / System Default)

| Style | Usage |
|-------|-------|
| `headlineLarge` | Page titles ("Book a Ride") |
| `headlineMedium` | Section headers ("Payment Method") |
| `titleLarge` | Card titles, dialog titles |
| `titleMedium` | List item titles, bold labels |
| `bodyLarge` | Primary body text |
| `bodyMedium` | Secondary body text |
| `labelLarge` | Button text |
| `labelSmall` | Captions, timestamps, badges |

### Spacing & Sizing

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4dp | Tight spacing between related elements |
| `sm` | 8dp | Default inner padding |
| `md` | 16dp | Standard padding, card padding |
| `lg` | 24dp | Section spacing |
| `xl` | 32dp | Screen padding top/bottom |
| `borderRadius` | 12dp | Cards, buttons, inputs |
| `borderRadiusLg` | 16dp | Bottom sheets, dialogs |
| `borderRadiusXl` | 24dp | Full-screen modals |

---

## Security Architecture

- Firebase Auth for all apps (Phone, Google, Apple)
- Firestore Security Rules (per-collection read/write)
- Admin role-based access control (RBAC) enforced in BLoC layer
- API keys loaded at runtime from Firestore (not hardcoded)
- Firebase App Check for mobile apps
- FCM token refresh on every app launch
- OTP verification for ride start (driver verifies customer)
- All sensitive operations go through UseCase validation

---

## Cloud Functions (Server-Side Logic)

**Location:** `/functions/`
**Runtime:** Node.js v24

### Function Catalog

| Function | Trigger | Purpose |
|----------|---------|---------|
| `createPaymentIntent` | HTTPS Callable | Create Stripe PaymentIntent server-side (secret key never on client) |
| `confirmPayment` | HTTPS Callable | Verify payment and update booking |
| `assignDriver` | Firestore onCreate (`bookings`) | Find nearest online driver in zone, assign to booking |
| `onBookingStatusChange` | Firestore onUpdate (`bookings`) | Send push notifications on status transitions |
| `calculateFare` | HTTPS Callable | Server-side fare calculation (prevents client tampering) |
| `processWalletTopup` | HTTPS Callable | Verify Stripe payment, credit wallet |
| `processWithdrawal` | HTTPS Callable | Admin approves, deduct wallet, log transaction |
| `cleanupStaleBookings` | Scheduled (every 5 min) | Cancel bookings stuck in `placed` for > 10 min with no driver |
| `expireSubscriptions` | Scheduled (daily) | Deactivate expired driver subscriptions |
| `revokeStaleTokens` | Scheduled (weekly) | Remove FCM tokens older than 30 days |
| `onUserDelete` | Auth onDelete | Clean up user data across collections |
| `deleteUserAccount` | HTTPS Callable | Re-authenticate, anonymize records, delete personal data, delete auth (App Store/Play Store mandatory) |
| `deleteAccountWeb` | HTTPS | Web-based account deletion endpoint (Google Play requirement) |
| `checkAppVersion` | HTTPS Callable | Return min required app version for force-update |

### Stripe Security (Server-Side Only)

```
CLIENT (Flutter)                         SERVER (Cloud Functions)
─────────────────                        ──────────────────────
1. User taps "Pay"
2. Call createPaymentIntent({amount}) ──► 3. Validate amount
                                          4. Stripe.paymentIntents.create()
                                             using SECRET key
5. Receive {clientSecret} ◄────────────── 6. Return clientSecret
7. Stripe.instance.presentPaymentSheet()
   (uses PUBLISHABLE key only)
8. User completes payment
9. Call confirmPayment({intentId}) ─────► 10. Stripe.paymentIntents.retrieve()
                                           11. Verify status == 'succeeded'
                                           12. Update booking.paymentStatus
13. Receive success ◄──────────────────── 14. Return confirmation
```

**Rules:**
- Stripe **secret key** stored in Cloud Functions environment config (`functions:config:set`)
- Stripe **publishable key** stored in Firestore `settings/payment` (safe for client)
- Client **NEVER** calls `api.stripe.com` directly
- All payment verification happens server-side

---

## Offline & Caching Strategy

### Firestore Offline Persistence
```dart
// Enable in main.dart (enabled by default on mobile, explicit on web)
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```

### Caching Layers

| Data | Strategy | TTL |
|------|----------|-----|
| Map routes (polylines) | In-memory LRU cache | 20 minutes |
| Vehicle types | Firestore cache + in-memory | Until app restart |
| User profile | Firestore offline persistence | Real-time sync |
| Booking data | Firestore offline persistence | Real-time sync |
| Settings/config | Firestore cache | Until app restart |
| Map tiles | Google Maps SDK cache | Managed by SDK |
| Profile images | `cached_network_image` disk cache | 7 days |

### Offline Behavior

| Action | Offline Behavior |
|--------|-----------------|
| View booking history | Works (cached data) |
| View profile | Works (cached data) |
| Create new booking | Queued, synced when online |
| Send chat message | Queued, synced when online |
| Make payment | Blocked — requires network (show error) |
| Track ride | Blocked — requires real-time data (show last known) |
| Upload document | Queued, synced when online |

### Network Connectivity
```dart
// Use connectivity_plus to monitor network state
// Show offline banner when disconnected
// Disable payment and tracking buttons when offline
```

---

## App Versioning & Force Update

### Firestore Collection: `app_version/{platform}`
```
{
  platform: string (android|ios|web),
  minVersion: string (e.g., "1.2.0"),
  latestVersion: string (e.g., "1.5.0"),
  updateUrl: string (Play Store / App Store URL),
  forceUpdate: bool,
  releaseNotes: string,
  updatedAt: timestamp
}
```

### Flow
```
App Launch
  │
  ├─► Fetch app_version/{platform} from Firestore
  ├─► Compare local version vs minVersion
  │     ├─► local >= minVersion → Continue normally
  │     └─► local < minVersion && forceUpdate == true
  │           → Show blocking dialog: "Update Required"
  │           → "Update" button opens store URL
  │           → Cannot dismiss
  │
  └─► Compare local version vs latestVersion
        ├─► local == latestVersion → No action
        └─► local < latestVersion && forceUpdate == false
              → Show dismissible banner: "New version available"
```

### Versioning Standard
- Use **semantic versioning**: `MAJOR.MINOR.PATCH`
- `MAJOR` = breaking changes (force update)
- `MINOR` = new features (optional update)
- `PATCH` = bug fixes (optional update)

---

## Analytics & Crash Reporting

### Firebase Analytics
```yaml
# Add to each app's pubspec.yaml
firebase_analytics: latest
firebase_crashlytics: latest
firebase_performance: latest
```

### Key Events to Track

| Event | Parameters | When |
|-------|-----------|------|
| `sign_up` | method (email/phone/google/apple) | User creates account |
| `login` | method | User signs in |
| `booking_created` | ride_type, vehicle_type, payment_type | Booking placed |
| `booking_completed` | ride_type, fare_amount, distance | Ride finished |
| `booking_cancelled` | ride_type, cancelled_by, reason | Booking cancelled |
| `payment_completed` | method, amount | Payment successful |
| `payment_failed` | method, error | Payment failed |
| `wallet_topup` | amount, method | Money added to wallet |
| `driver_online` | zone_id | Driver goes online |
| `sos_triggered` | booking_id | Emergency alert |
| `coupon_applied` | coupon_code, discount | Coupon used |
| `referral_shared` | - | User shares referral code |
| `screen_view` | screen_name | Auto-tracked per page |

### Crashlytics
- Auto-captures uncaught exceptions
- Custom keys: `userId`, `role` (customer/driver/admin), `bookingId`
- Non-fatal error logging for API failures
- Breadcrumbs for user journey before crash

### Performance Monitoring
- Auto HTTP request tracing
- Custom traces for: booking creation, payment flow, map loading
- Screen rendering performance

---

## Rate Limiting & Abuse Prevention

### Client-Side Limits (enforced in BLoC/UseCase layer)

| Action | Limit | Enforcement |
|--------|-------|-------------|
| Create booking | Max 3 active bookings per user | Check in `CreateBooking` UseCase |
| Cancel booking | Max 5 cancellations per day | Check before allowing cancel |
| Failed payment attempts | Max 3 per booking | Lock payment after 3 failures |
| OTP requests | Max 3 per 10 minutes | Cooldown timer in AuthBloc |
| Chat messages | Max 60 per minute | Throttle in ChatBloc |
| Wallet topup | Max 10 per day | Check in WalletBloc |
| Support tickets | Max 5 open tickets | Check before creating |

### Server-Side Limits (enforced in Cloud Functions)

| Action | Limit | Response |
|--------|-------|----------|
| Payment intent creation | Max 10 per user per hour | 429 Too Many Requests |
| Driver assignment retries | Max 5 attempts per booking | Auto-cancel booking |
| Withdrawal requests | Max 1 per day | Reject with message |

### Penalty System
- **Cancellation penalty:** After 3 cancellations in 24 hours, cancellation charge increases by 50%
- **Driver rejection penalty:** After 5 rejections in 1 hour, driver goes offline for 30 minutes
- **Rating threshold:** Drivers below 3.0 average get flagged for review

### Firestore Rate Tracking
```
// Track in user/driver document
{
  cancellationCount24h: int,
  lastCancellationReset: timestamp,
  rejectionCount1h: int,
  lastRejectionReset: timestamp,
  failedPaymentCount: int
}
```

---

## Image & Asset Guidelines

### Image Compression Standards

| Type | Max Dimensions | Quality | Format |
|------|---------------|---------|--------|
| Profile picture | 512x512 px | 80% | JPEG |
| Driver document | 1024x1024 px | 85% | JPEG |
| Parcel image | 1024x1024 px | 80% | JPEG |
| Banner image | 1280x720 px | 85% | JPEG/PNG |
| Vehicle type icon | 256x256 px | 90% | PNG (transparent) |

### Compression Flow
```dart
// Use flutter_image_compress before upload
final compressed = await FlutterImageCompress.compressWithFile(
  file.path,
  minWidth: 512,
  minHeight: 512,
  quality: 80,
  format: CompressFormat.jpeg,
);
```

### Asset Organization
```
assets/
├── icons/
│   ├── ic_cash.svg
│   ├── ic_wallet.svg
│   ├── ic_stripe.svg
│   ├── ic_car.svg
│   ├── ic_parcel.svg
│   ├── ic_rental.svg
│   └── ic_intercity.svg
├── images/
│   ├── logo.png
│   ├── logo_dark.png
│   ├── onboarding_1.png
│   ├── onboarding_2.png
│   ├── onboarding_3.png
│   ├── empty_state.svg
│   └── map_marker_driver.png
├── animations/
│   └── loading.json (Lottie)
└── fonts/
    ├── Inter-Regular.ttf
    ├── Inter-Medium.ttf
    ├── Inter-SemiBold.ttf
    └── Inter-Bold.ttf
```

### Rules
- **SVG** for icons and illustrations (scalable, small file size)
- **PNG** only when transparency is required and SVG is not practical
- **JPEG** for photos (profile pics, documents, banners)
- **Lottie JSON** for animations (loading, success, empty state)
- **NEVER** commit large uncompressed images to git

---

## Accessibility

### Requirements

| Standard | Implementation |
|----------|---------------|
| **Semantic labels** | All `Icon`, `Image`, `IconButton` must have `semanticLabel` or `tooltip` |
| **Contrast ratio** | Minimum 4.5:1 for body text, 3:1 for large text (WCAG AA) |
| **Touch targets** | Minimum 48x48 dp for all interactive elements |
| **Screen reader** | All screens navigable via TalkBack (Android) / VoiceOver (iOS) |
| **Font scaling** | Support system font size up to 200% |
| **Color independence** | Never use color alone to convey meaning — add icons/text |

### Implementation

```dart
// Good: Semantic label on icon button
IconButton(
  icon: const Icon(Icons.phone),
  tooltip: 'Call driver',
  onPressed: () => ...,
)

// Good: Accessible image
Image.network(
  url,
  semanticLabel: 'Driver profile picture',
)

// Good: Form field with label
TextFormField(
  decoration: InputDecoration(
    labelText: 'Email address',
    hintText: 'you@example.com',
  ),
)

// Good: Status with icon + text (not just color)
Row(children: [
  Icon(Icons.circle, color: Colors.green, size: 8),
  SizedBox(width: 4),
  Text('Online'),
])
```

### Testing
- Enable TalkBack/VoiceOver and navigate full booking flow
- Test with system font size set to largest
- Run `flutter test --accessibility` for basic checks
- Verify all form fields have labels
- Verify all buttons have tooltip/semanticLabel

---

## CI/CD Pipeline

### GitHub Actions Workflow

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.2.6'
      - run: cd core && flutter pub get
      - run: cd customer && flutter pub get && flutter analyze
      - run: cd driver && flutter pub get && flutter analyze
      - run: cd admin && flutter pub get && flutter analyze

  test:
    runs-on: ubuntu-latest
    needs: analyze
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: cd core && flutter pub get && flutter test
      - run: cd customer && flutter pub get && flutter test
      - run: cd driver && flutter pub get && flutter test
      - run: cd admin && flutter pub get && flutter test

  build-android:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: cd customer && flutter build apk --release
      - run: cd driver && flutter build apk --release
      - uses: actions/upload-artifact@v4
        with:
          name: android-builds
          path: |
            customer/build/app/outputs/flutter-apk/
            driver/build/app/outputs/flutter-apk/

  build-web:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: cd admin && flutter build web --release
      - uses: actions/upload-artifact@v4
        with:
          name: admin-web
          path: admin/build/web/

  deploy-functions:
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '24'
      - run: cd functions && npm ci
      - uses: w9jds/firebase-action@master
        with:
          args: deploy --only functions
        env:
          FIREBASE_TOKEN: ${{ secrets.FIREBASE_TOKEN }}
```

### Branch Strategy
```
main        → Production (auto-deploy admin web + functions)
develop     → Integration branch (CI runs, no deploy)
feature/*   → Feature branches (CI runs on PR)
fix/*       → Bug fix branches (CI runs on PR)
release/*   → Release candidates (manual deploy to staging)
```

### Deployment Targets

| Branch | Customer | Driver | Admin | Functions |
|--------|----------|--------|-------|-----------|
| `main` | Manual (store upload) | Manual (store upload) | Auto-deploy Firebase Hosting | Auto-deploy |
| `develop` | CI only | CI only | CI only | CI only |
| `feature/*` | CI on PR | CI on PR | CI on PR | CI on PR |

---

## Search Implementation

### Keyword Generation Strategy
```dart
// Generate search keywords for a user document
List<String> generateSearchKeywords(String fullName, String email, String phone) {
  final keywords = <String>{};
  final nameLower = fullName.toLowerCase();

  // Full name
  keywords.add(nameLower);

  // Individual words
  for (final word in nameLower.split(' ')) {
    keywords.add(word);
  }

  // Progressive prefixes (for typeahead search)
  for (int i = 1; i <= nameLower.length && i <= 10; i++) {
    keywords.add(nameLower.substring(0, i));
  }

  // Email
  keywords.add(email.toLowerCase());
  keywords.add(email.split('@').first.toLowerCase());

  // Phone (last 4 digits for search)
  if (phone.length >= 4) {
    keywords.add(phone.substring(phone.length - 4));
  }
  keywords.add(phone);

  return keywords.toList();
}
```

### Firestore Query
```dart
// Search users by keyword
firestore.collection('users')
  .where('searchKeywords', arrayContains: query.toLowerCase())
  .orderBy('fullName')
  .limit(20)
  .get();
```

### Pagination Strategy (Cursor-Based)
```dart
// First page
final firstPage = await firestore.collection('users')
  .orderBy('createdAt', descending: true)
  .limit(20)
  .get();

// Next page (cursor = last document)
final nextPage = await firestore.collection('users')
  .orderBy('createdAt', descending: true)
  .startAfterDocument(firstPage.docs.last)
  .limit(20)
  .get();
```

### Admin Pagination
- Page sizes: 10, 20, 50, 100 (user selectable)
- Cursor-based (not offset) for Firestore efficiency
- Total count cached and refreshed periodically (not on every page)

---

## Audit Log

### Collection: `audit_log`
```
{
  id: string (auto),
  actorId: string (userId/driverId/adminId),
  actorRole: string (customer|driver|admin),
  action: string (see actions below),
  targetCollection: string,
  targetId: string,
  before: map (previous state, optional),
  after: map (new state, optional),
  metadata: map (extra context),
  ipAddress: string (from Cloud Function),
  createdAt: timestamp
}
```

### Tracked Actions

| Action | Trigger |
|--------|---------|
| `user.created` | New user signup |
| `user.updated` | Profile change |
| `driver.verified` | Admin approves driver |
| `driver.rejected` | Admin rejects driver |
| `booking.created` | New booking |
| `booking.status_changed` | Any status transition |
| `payment.intent_created` | Stripe payment initiated |
| `payment.completed` | Payment confirmed |
| `payment.failed` | Payment failed |
| `wallet.credited` | Money added to wallet |
| `wallet.debited` | Money deducted |
| `withdrawal.requested` | Driver requests payout |
| `withdrawal.approved` | Admin approves payout |
| `withdrawal.rejected` | Admin rejects payout |
| `settings.updated` | Admin changes config |
| `role.created` | Admin creates role |
| `employee.created` | Admin adds employee |
| `sos.triggered` | Emergency alert |

### Rules
- Audit log is **immutable** — no updates, no deletes
- Written by Cloud Functions (server-side) for tamper resistance
- Client can create entries for user-initiated actions
- Retained for minimum 1 year

---

## Database Migration Strategy

### Schema Changes After Launch

Firestore is schemaless, but our app code expects specific fields. Migration strategy:

### Adding a New Field
```
1. Add field with default value in Model.fromJson():
   newField: json['newField'] ?? defaultValue

2. Update toJson() to include the new field

3. Do NOT backfill existing documents immediately
   - Reads handle missing field via default
   - Writes include the new field going forward
   - Optional: Run a one-time Cloud Function to backfill if needed
```

### Renaming a Field
```
1. Read BOTH old and new field names in fromJson():
   name: json['newName'] ?? json['oldName'] ?? ''

2. Write ONLY the new field name in toJson()

3. Run backfill Cloud Function:
   - Read all docs with oldName
   - Write newName, delete oldName
   - Deploy in phases (100 docs per batch)

4. After backfill complete, remove old field from fromJson()
```

### Adding a New Collection
```
1. Document in ARCHITECTURE.md (schema section)
2. Add to CollectionName constants
3. Add security rules in firestore.rules
4. Add composite indexes if needed
5. Deploy security rules: firebase deploy --only firestore:rules
6. Deploy indexes: firebase deploy --only firestore:indexes
```

### Removing a Collection
```
1. Remove all code references first
2. Keep security rules (read-only) for 30 days
3. Export data for backup: node database/export.js
4. After 30 days, remove rules and delete data
```

### Migration Tracking
```
// Firestore: settings/migrations
{
  "v1_to_v2": {
    "status": "completed",
    "startedAt": timestamp,
    "completedAt": timestamp,
    "documentsProcessed": 15420,
    "description": "Added estimatedFare to bookings"
  }
}
```

---

## Environment Variable Management

### Firebase Project Environments

| Environment | Firebase Project | Purpose |
|-------------|-----------------|---------|
| Development | `rwp3-dev` | Local development, testing |
| Staging | `rwp3-staging` | QA, demo, Apple/Google review |
| Production | `rwp3-prod` | Live users |

### Switching Environments
```bash
# Generate firebase_options.dart per environment
flutterfire configure --project=rwp3-dev --out=lib/firebase_options_dev.dart
flutterfire configure --project=rwp3-staging --out=lib/firebase_options_staging.dart
flutterfire configure --project=rwp3-prod --out=lib/firebase_options_prod.dart

# Build with environment flag
flutter run --dart-define=ENV=dev
flutter run --dart-define=ENV=staging
flutter build apk --dart-define=ENV=prod
```

### main.dart Environment Selection
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const env = String.fromEnvironment('ENV', defaultValue: 'dev');

  switch (env) {
    case 'prod':
      await Firebase.initializeApp(options: DefaultFirebaseOptionsProd.currentPlatform);
    case 'staging':
      await Firebase.initializeApp(options: DefaultFirebaseOptionsStaging.currentPlatform);
    default:
      await Firebase.initializeApp(options: DefaultFirebaseOptionsDev.currentPlatform);
  }

  runApp(const App());
}
```

### CI/CD Secrets (GitHub Actions)
```yaml
# Store in GitHub Repository Secrets:
FIREBASE_TOKEN            # firebase login:ci token
FIREBASE_PROJECT_PROD     # rwp3-prod
FIREBASE_PROJECT_STAGING  # rwp3-staging
STRIPE_PUBLISHABLE_KEY    # pk_live_xxx (never sk_)
KEYSTORE_BASE64           # Base64-encoded upload-keystore.jks
KEYSTORE_PASSWORD         # Keystore password
KEY_ALIAS                 # Key alias
KEY_PASSWORD              # Key password

# Access in workflow:
- run: echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/keystore.jks
```

### .gitignore (CRITICAL)
```
# Never commit these:
**/firebase_options*.dart
**/*.jks
**/*.keystore
.env
.env.*
**/google-services.json
**/GoogleService-Info.plist
```

---

## Localization Implementation

### Architecture
```
Firestore: languages/{langCode}
  → { code: "en", name: "English", translations: { "book_ride": "Book a Ride", ... } }

App Launch:
  → SettingsBloc loads active language from SharedPreferences
  → Fetches translations from Firestore (cached offline)
  → Injects into MaterialApp localizationsDelegates
```

### Implementation
```dart
// core/lib/localization/app_localizations.dart
class AppLocalizations {
  final Map<String, String> _translations;
  AppLocalizations(this._translations);

  String translate(String key) => _translations[key] ?? key;

  // Shorthand
  String tr(String key) => translate(key);
}

// Usage in widgets:
Text(context.tr('book_ride'))  // "Book a Ride"
```

### Adding New Translation Keys
```
1. Add key to English translations in Firestore: languages/en
2. Add translations for all active languages
3. Use in code: context.tr('new_key')
4. If key is missing for a language, falls back to key name
```

### Language Switching
```
LanguageBloc Events:
  LanguageChanged(langCode) → LanguageLoaded(translations)
    → Save to SharedPreferences
    → Rebuild MaterialApp with new locale
```

### Supported Languages (Admin-Configurable)
Admin can add any language via admin panel → Languages section. No code change needed.

---

## Deep Linking & Universal Links

### URL Scheme
```
rwp3://                          # Custom URL scheme
https://rwp3app.com/             # Universal/App links
```

### Route Mapping

| Deep Link | Screen | Parameters |
|-----------|--------|-----------|
| `rwp3://booking/{id}` | Booking details | bookingId |
| `rwp3://tracking/{id}` | Ride tracking | bookingId |
| `rwp3://chat/{userId}` | Chat screen | otherUserId |
| `rwp3://wallet` | Wallet page | - |
| `rwp3://referral/{code}` | Signup with referral | referralCode |
| `rwp3://support/{ticketId}` | Ticket details | ticketId |

### FCM Deep Linking
```dart
// Notification payload includes route
{
  "data": {
    "type": "cab",
    "route": "/tracking/abc123",
    "bookingId": "abc123"
  }
}

// On notification tap:
GoRouter.of(context).go(payload['route']);
```

### iOS Setup (Info.plist)
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array><string>rwp3</string></array>
  </dict>
</array>
```

### Android Setup (AndroidManifest.xml)
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="rwp3" />
</intent-filter>
```

### go_router Deep Link Handling
```dart
// go_router automatically handles deep links matching defined routes
// No extra config needed — just ensure routes match URL patterns
```

---

## Error Message Standards

### Failure → User Message Mapping

| Failure Type | User Message |
|-------------|-------------|
| `ServerFailure` | "Something went wrong. Please try again." |
| `AuthFailure("wrong-password")` | "Incorrect password. Please try again." |
| `AuthFailure("user-not-found")` | "No account found with this email." |
| `AuthFailure("email-already-in-use")` | "An account with this email already exists." |
| `AuthFailure("too-many-requests")` | "Too many attempts. Please try again later." |
| `AuthFailure("invalid-otp")` | "Invalid verification code. Please try again." |
| `ValidationFailure("min-amount")` | "Minimum amount is {currency}{amount}." |
| `ValidationFailure("max-bookings")` | "You can only have {limit} active bookings." |
| `PaymentFailure("card-declined")` | "Your card was declined. Please try another payment method." |
| `PaymentFailure("insufficient-funds")` | "Insufficient wallet balance. Please add funds." |
| `PaymentFailure("network")` | "Payment failed due to network error. You were not charged." |
| `CacheFailure` | "Unable to load data. Check your connection." |
| `NetworkFailure` | "No internet connection. Some features may be unavailable." |

### Implementation
```dart
// core/lib/errors/failure_mapper.dart
String mapFailureToMessage(Failure failure) {
  return switch (failure) {
    ServerFailure() => 'Something went wrong. Please try again.',
    AuthFailure(:final message) => _mapAuthMessage(message),
    PaymentFailure(:final message) => _mapPaymentMessage(message),
    ValidationFailure(:final message) => message, // Already user-friendly
    CacheFailure() => 'Unable to load data. Check your connection.',
    NetworkFailure() => 'No internet connection.',
  };
}
```

### Rules
- **NEVER** show Firebase error codes to users (e.g., `PERMISSION_DENIED`)
- **NEVER** show stack traces
- **ALWAYS** provide actionable message (what to do next)
- **ALWAYS** use translatable keys (not hardcoded English)

---

## Loading / Empty / Error UI State Patterns

### Standard State Widget
```dart
// core/lib/widgets/async_state_widget.dart
class AsyncStateWidget<T> extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final T? data;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final String emptyMessage;
  final String emptyIcon; // SVG asset path

  // Loading: Shimmer skeleton
  // Error: Icon + message + "Try Again" button
  // Empty: Illustration + message
  // Data: builder(data)
}
```

### Loading State (Shimmer Skeleton)
```
┌─────────────────────────────┐
│ ████████████  ██████        │  ← Shimmer placeholder
│ ████████████████████████    │
│ ██████████                  │
├─────────────────────────────┤
│ ████████████  ██████        │
│ ████████████████████████    │
│ ██████████                  │
└─────────────────────────────┘
```
Use `shimmer` package with theme colors.

### Empty State
```
┌─────────────────────────────┐
│                             │
│      [illustration.svg]     │
│                             │
│     No rides yet            │  ← headlineMedium
│  Book your first ride to    │  ← bodyMedium, onSurfaceVariant
│  see it here                │
│                             │
│    [ Book a Ride ]          │  ← FilledButton (primary)
│                             │
└─────────────────────────────┘
```

### Error State
```
┌─────────────────────────────┐
│                             │
│      [error_icon.svg]       │
│                             │
│   Something went wrong      │  ← headlineMedium
│   Please try again          │  ← bodyMedium
│                             │
│    [ Try Again ]            │  ← OutlinedButton
│                             │
└─────────────────────────────┘
```

### Per-Screen Empty Messages

| Screen | Empty Message | Action |
|--------|-------------|--------|
| Ride History | "No rides yet" | "Book a Ride" |
| Wallet | "No transactions yet" | "Add Money" |
| Chat Inbox | "No conversations" | None |
| Notifications | "All caught up!" | None |
| Support Tickets | "No tickets" | "Create Ticket" |
| Coupons | "No coupons available" | None |
| Emergency Contacts | "No contacts added" | "Add Contact" |

---

## Notification Channels & Sounds

### Android Notification Channels

| Channel ID | Name | Priority | Sound | Vibrate |
|-----------|------|----------|-------|---------|
| `booking_updates` | Ride Updates | High | Default | Yes |
| `new_booking` | New Ride Request (driver) | Max | Custom `ride_alert.mp3` | Yes |
| `chat_messages` | Chat | Default | Default | Yes |
| `payments` | Payments | High | Default | No |
| `promotions` | Promotions | Low | None | No |
| `support` | Support | Default | Default | Yes |
| `sos` | Emergency | Max | Alarm | Yes |

### Implementation
```dart
// Create channels on app launch (Android only)
const bookingChannel = AndroidNotificationChannel(
  'booking_updates',
  'Ride Updates',
  description: 'Updates about your ride status',
  importance: Importance.high,
);

const newBookingChannel = AndroidNotificationChannel(
  'new_booking',
  'New Ride Request',
  description: 'Alerts when a new ride is available',
  importance: Importance.max,
  sound: RawResourceAndroidNotificationSound('ride_alert'),
);
```

### iOS Categories
```dart
// iOS notification categories for action buttons
DarwinNotificationCategory(
  'BOOKING_UPDATE',
  actions: [
    DarwinNotificationAction.plain('VIEW', 'View Ride'),
    DarwinNotificationAction.plain('CANCEL', 'Cancel', options: {DarwinNotificationActionOption.destructive}),
  ],
)
```

### Custom Sound
- File: `android/app/src/main/res/raw/ride_alert.mp3`
- Duration: Max 30 seconds (iOS limit)
- Format: MP3 (Android), CAF/AIFF (iOS)

---

## Driver Matching Algorithm

### `assignDriver` Cloud Function Logic

```
Input: booking document (pickup location, vehicle type, zone)
Output: assigned driverId or null (retry/cancel)

Algorithm:
1. Query eligible drivers:
   WHERE isOnline == true
   AND isVerified == true
   AND isActive == true
   AND currentBookingId == null (not on another ride)
   AND vehicleType matches requested type
   AND zoneId contains booking zone

2. Filter by proximity:
   - Calculate distance from each driver.location to booking.pickupLocation
   - Using Haversine formula (great-circle distance)
   - Filter: distance <= settings.radius (default 10km)

3. Sort by:
   - Distance (ascending) — nearest first
   - Rating (descending) — higher rated preferred (tiebreaker)

4. Assignment attempt (round-robin):
   - Pick top driver
   - Set booking.driverId = driver.id
   - Set booking.bookingStatus = "driver_assigned"
   - Set driver.currentBookingId = booking.id
   - Send push notification to driver
   - Start 30-second acceptance timer

5. If driver doesn't accept in 30 seconds:
   - Reset booking.driverId = null
   - Reset driver.currentBookingId = null
   - Set booking.bookingStatus = "booking_placed"
   - Move to next driver in sorted list
   - Repeat up to 5 attempts

6. If no driver found after 5 attempts:
   - Set booking.bookingStatus = "booking_cancelled"
   - Reason: "No drivers available"
   - Notify customer
   - Refund if prepaid

7. Female-only rides:
   - Additional filter: driver.gender == "Female"
```

### Proximity Calculation (Haversine)
```javascript
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Earth radius in km
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
            Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
            Math.sin(dLon/2) * Math.sin(dLon/2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
  return R * c; // Distance in km
}
```

---

## Fare Calculation Formulas

### Cab Ride
```
baseFare = vehicleType.baseFare
distanceCharge = distance_km * vehicleType.perKmRate
timeCharge = duration_minutes * vehicleType.perMinuteRate

subtotal = MAX(baseFare + distanceCharge + timeCharge, vehicleType.minimumFare)

// Night charge (if pickup time within night window)
if (pickupTime >= nightStart && pickupTime <= nightEnd):
  nightCharge = subtotal * nightChargePercentage

// Hold charges
holdCharge = holdMinutes * holdChargePerMinute

// Gross total
grossTotal = subtotal + nightCharge + holdCharge

// Coupon discount
if (coupon applied && grossTotal >= coupon.minOrderAmount):
  if (coupon.isPercentage):
    discount = MIN(grossTotal * coupon.discount / 100, coupon.maxDiscount)
  else:
    discount = coupon.discount

// Tax
taxableAmount = grossTotal - discount
taxAmount = taxableAmount * taxPercentage / 100

// Final
totalAmount = taxableAmount + taxAmount
estimatedFare = totalAmount (shown before booking)
actualFare = recalculated at ride end with real distance/time

// Commission
if (adminCommission.isFixed):
  commission = adminCommission.amount
else:
  commission = totalAmount * adminCommission.amount / 100
driverEarning = totalAmount - commission
```

### Intercity Ride
```
// Fixed price set by admin per route, or bid-based
if (bidding enabled):
  totalAmount = accepted bid amount
else:
  totalAmount = route fixed price

// Same tax and commission logic as cab
```

### Parcel Delivery
```
// Same as cab ride formula, OR bid-based
if (bidding enabled):
  totalAmount = accepted bid amount
else:
  // Same distance-based calculation as cab
```

### Rental
```
packagePrice = rentalPackage.price (for X hours, Y km)

// Extra charges at ride end
if (actualKM > package.km):
  extraKMCharge = (actualKM - package.km) * extraPerKmRate
if (actualHours > package.hours):
  extraHourCharge = (actualHours - package.hours) * extraPerHourRate

totalAmount = packagePrice + extraKMCharge + extraHourCharge + tax
```

### Cancellation Charge
```
if (cancellationCharge.isCancellationChargeApply):
  if (cancellationCharge.isFixed):
    charge = cancellationCharge.amount
  else:
    charge = estimatedFare * cancellationCharge.amount / 100

  // Penalty multiplier (rate limiting)
  if (userCancellations24h > 3):
    charge = charge * 1.5
```

---

## Firestore Cost Optimization

### Read/Write Cost Awareness

| Operation | Cost | Frequency |
|-----------|------|-----------|
| Document read | 1 read | Every screen load |
| Document write | 1 write | Every booking update |
| Document delete | 1 delete | Rare |
| Snapshot listener | 1 read per change | Real-time screens |
| Query (N results) | N reads | List screens |

### Cost Reduction Strategies

**1. Minimize Listeners**
```dart
// BAD: Listener on all bookings
firestore.collection('bookings').snapshots() // Reads EVERY doc on EVERY change

// GOOD: Listener on single booking
firestore.collection('bookings').doc(bookingId).snapshots() // 1 read per change
```

**2. Paginate Everything**
- Never load all documents at once
- Use cursor-based pagination (limit 20)
- Admin lists: user-selectable page size (10/20/50)

**3. Cache Aggressively**
- Vehicle types: Load once, cache in memory
- Settings: Load once per app session
- User profile: Firestore offline cache handles this

**4. Denormalize Strategically**
```
// Instead of joining bookings + users + drivers:
// Store driver name/phone in booking document
bookings/{id}: {
  driverName: "John",      // Denormalized from drivers collection
  driverPhone: "+1234",    // Avoid extra read
  customerName: "Jane",    // Denormalized from users collection
}
```

**5. Use Collection Group Queries Sparingly**
- Collection group queries read ALL matching docs across subcollections
- Prefer flat collections over deeply nested subcollections

**6. Estimated Monthly Costs (Scale Reference)**

| Scale | Daily Bookings | Est. Reads/Day | Est. Writes/Day | Est. Cost/Month |
|-------|---------------|----------------|-----------------|-----------------|
| Small | 100 | 50,000 | 5,000 | $5-15 |
| Medium | 1,000 | 500,000 | 50,000 | $50-100 |
| Large | 10,000 | 5,000,000 | 500,000 | $300-600 |

**Free tier:** 50K reads, 20K writes, 20K deletes per day.

**7. Monitor in Firebase Console**
- Usage tab → Reads, Writes, Deletes per day
- Set budget alerts at $50, $100, $500
- Review slow queries in Firestore Profiler

---

## Changelog

| Date | Change | Author |
|------|--------|--------|
| 2026-04-01 | Initial architecture — BLoC + Clean Architecture | - |
| 2026-04-01 | Added: Cloud Functions, Stripe security, offline strategy, versioning, analytics, rate limiting, assets, accessibility, CI/CD, search, audit log | - |
| 2026-04-01 | Added: Migration strategy, env management, localization, deep linking, error messages, UI state patterns, notification channels, driver matching algorithm, fare formulas, Firestore cost optimization | - |
