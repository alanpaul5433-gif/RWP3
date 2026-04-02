# CLAUDE.md - AI Agent Rules for RWP3 (Ride With Purpose)

## Project Overview

RWP3 is a multi-app ride-sharing platform built with Flutter and Firebase. It consists of three applications:
- **Customer App** (iOS/Android) - Passengers book and track rides
- **Driver App** (iOS/Android) - Drivers accept and complete rides
- **Admin Panel** (Flutter Web) - Administrators manage the platform

## Architecture: BLoC + Clean Architecture

This project uses **BLoC (Business Logic Component)** pattern with **Clean Architecture** layers. Every feature is organized into three layers with strict dependency rules.

### Dependency Rule
```
Presentation → Domain ← Data
```
- **Domain** layer has ZERO dependencies on other layers
- **Presentation** depends on Domain only
- **Data** implements Domain interfaces
- **NEVER** import data layer from presentation or domain from data

## Mandatory Rules

### 1. Architecture Consistency
- **ALWAYS** read ARCHITECTURE.md before making structural changes
- **ALWAYS** update ARCHITECTURE.md when adding/removing/modifying:
  - Firestore collections or document schemas
  - Routes or screens
  - Entities or models
  - BLoC events or states
  - Cloud Functions
  - Payment flows
- **NEVER** add a new Firestore collection without documenting it in ARCHITECTURE.md

### 2. Clean Architecture Layers

Every feature follows three layers:

```
features/<feature_name>/
  data/
    datasources/<feature_name>_remote_datasource.dart   # Firestore operations
    models/<feature_name>_model.dart                     # JSON serialization (extends Entity)
    repositories/<feature_name>_repository_impl.dart     # Implements domain interface
  domain/
    entities/<feature_name>_entity.dart                  # Pure business objects (no deps)
    repositories/<feature_name>_repository.dart          # Abstract interface
    usecases/<use_case_name>.dart                        # Single-responsibility business logic
  presentation/
    bloc/<feature_name>_bloc.dart                        # Events + States + BLoC
    bloc/<feature_name>_event.dart                       # All events (sealed class)
    bloc/<feature_name>_state.dart                       # All states (sealed class)
    pages/<feature_name>_page.dart                       # Screen UI
    widgets/                                             # Feature-specific widgets
```

**Rules:**
- **NEVER** put business logic in pages/widgets — use BLoCs
- **NEVER** access Firestore directly from BLoCs — use UseCases
- **NEVER** access Firestore directly from UseCases — use Repositories
- **NEVER** import Flutter/UI code in domain layer
- **ALWAYS** define repository interfaces in domain, implement in data
- **ALWAYS** use UseCases to encapsulate single business operations
- **ALWAYS** use sealed classes for Events and States (exhaustive pattern matching)

### 3. BLoC Rules
- Every BLoC event **MUST** be a discrete, named action (e.g., `BookingPlaced`, `PaymentRequested`)
- Every BLoC state **MUST** represent a distinct UI state (e.g., `BookingLoading`, `BookingLoaded`, `BookingError`)
- **NEVER** use generic states like `Loading` or `Error` — prefix with feature name
- **ALWAYS** handle every event in the BLoC — no ignored events
- **ALWAYS** emit a new state for every event — no silent processing
- BLoCs must be **pure Dart** — no Flutter imports, no BuildContext
- Use `Emitter<State>` async pattern, not `mapEventToState` (deprecated)

### 4. Dependency Injection
- Use **get_it** + **injectable** for service locator pattern
- Register all dependencies in `injection_container.dart`
- **NEVER** manually instantiate repositories or datasources in BLoCs
- **ALWAYS** inject dependencies through constructor

### 5. Shared Code Across Apps
- **Core package** (`core/`) contains shared code used by all 3 apps
- Collection names **MUST** use `CollectionName` constants — never hardcode strings
- Booking statuses **MUST** use `BookingStatus` sealed class with valid transitions
- Shared entities, repositories, and datasources live in `core/`
- App-specific features live in their respective app's `features/` directory

### 6. Firestore Schema Rules
- Every document **MUST** have `createdAt` and `updatedAt` timestamps
- User documents **MUST** include `searchKeywords` for search functionality
- Location fields use `LocationLatLng` entity (latitude, longitude, address)
- All monetary values stored as `double` (not int)
- IDs are auto-generated Firestore document IDs unless specified

### 7. Booking Status State Machine
Valid transitions only (enforced in `BookingStatusEntity`):
```
booking_placed    -> driver_assigned | booking_cancelled
driver_assigned   -> booking_accepted | booking_rejected | booking_cancelled
booking_accepted  -> booking_ongoing | booking_cancelled
booking_ongoing   -> booking_completed | booking_onHold | booking_cancelled
booking_onHold    -> booking_ongoing | booking_cancelled
```
**NEVER** skip states or create invalid transitions.
**ALWAYS** validate transitions in the domain layer before persisting.

### 8. UI System (Material Design 3)
- Use **Material Design 3** (Material You) exclusively — no Cupertino widgets
- Use `ThemeData` with `useMaterial3: true` and `ColorScheme.fromSeed()`
- **Modern & Clean** style: rounded corners, generous white space, subtle elevation
- **ALWAYS** use theme tokens (`Theme.of(context).colorScheme`, `Theme.of(context).textTheme`)
- **NEVER** hardcode colors, font sizes, or spacing — use theme and constants
- Use `FilledButton`, `OutlinedButton`, `TextButton` (M3 variants, not deprecated `RaisedButton`)
- Use `SearchBar`, `NavigationBar`, `NavigationDrawer`, `SegmentedButton` (M3 components)
- Cards use `Card.filled()` or `Card.outlined()` — not old `Card()` with manual elevation
- Responsive: Use `LayoutBuilder` and `MediaQuery` for adaptive layouts
- Admin panel: Use `NavigationRail` on desktop, `NavigationDrawer` on mobile

### 9. Payment Gateway
- Only **Stripe** is used as the external payment gateway
- Cash and Wallet are always available
- Stripe keys are loaded from Firestore `settings/payment` document at runtime
- **NEVER** hardcode API keys in source code
- Payment flow **MUST** use events: `PaymentRequested → PaymentProcessing → PaymentSuccess | PaymentFailed`

### 9. Security Rules
- **NEVER** store secrets in client-side code
- **NEVER** commit firebase_options.dart with real credentials to version control
- **ALWAYS** validate user input in UseCases before Firestore writes
- **ALWAYS** check authentication state before sensitive operations
- FCM tokens must be refreshed on every app launch

### 10. File Naming Conventions
- Dart files: `snake_case.dart`
- Entities: `PascalCase` with `Entity` suffix (e.g., `BookingEntity`)
- Models (data layer): `PascalCase` with `Model` suffix (e.g., `BookingModel`)
- BLoCs: `PascalCase` with `Bloc` suffix (e.g., `BookingBloc`)
- Events: `PascalCase` (e.g., `BookingPlaced`, `BookingAccepted`)
- States: `PascalCase` (e.g., `BookingInitial`, `BookingLoaded`)
- UseCases: `PascalCase` verb phrase (e.g., `CreateBooking`, `GetBookingDetails`)
- Repositories: `PascalCase` with `Repository` suffix (interface) / `RepositoryImpl` (implementation)
- DataSources: `PascalCase` with `RemoteDataSource` suffix
- Pages: `PascalCase` with `Page` suffix
- Constants: `camelCase` for variables, `SCREAMING_SNAKE` for compile-time constants

### 11. Entity & Model Conventions
- **Entities** (domain): Pure Dart classes with `Equatable`, no serialization, no Firebase imports
- **Models** (data): Extend entities, add `toJson()` / `fromJson()` / `toEntity()` / `fromEntity()`
- Nullable fields use `?` suffix
- Default values provided in constructors where sensible

### 12. Error Handling
- Use `Either<Failure, T>` (from dartz) for all repository return types
- Define `Failure` sealed class hierarchy in domain: `ServerFailure`, `CacheFailure`, `ValidationFailure`
- **NEVER** throw exceptions from repositories — return `Left(Failure)`
- BLoCs map failures to error states with user-friendly messages
- Use `kDebugMode` guards for debug logging
- Never expose stack traces to users

### 13. Pre-Implementation Checklist
Before implementing any feature:
- [ ] Read ARCHITECTURE.md and DESIGN.md
- [ ] Check if similar functionality exists in `core/` (reuse, don't duplicate)
- [ ] Define the Entity in domain layer first
- [ ] Define the Repository interface in domain
- [ ] Create UseCases for each operation
- [ ] Define BLoC Events and States (sealed classes)
- [ ] Implement Repository and DataSource in data layer
- [ ] Build the BLoC
- [ ] Build the UI (pages/widgets)
- [ ] Register all new classes in dependency injection
- [ ] Identify all affected apps (customer, driver, admin)
- [ ] Ensure changes work across all 4 ride types (cab, intercity, parcel, rental)

### 14. Accessibility Requirements
- **ALWAYS** add `semanticLabel` or `tooltip` to Icon, Image, IconButton widgets
- **ALWAYS** add `labelText` to TextFormField/TextField
- **NEVER** use color alone to convey meaning — pair with icon or text
- Minimum touch target: 48x48 dp
- Support system font scaling up to 200%

### 15. Analytics
- Log key events via Firebase Analytics (booking_created, payment_completed, etc.)
- Set user properties: userId, role (customer/driver/admin)
- Log non-fatal errors to Crashlytics with context (bookingId, userId)

### 16. Rate Limiting
- Enforce limits in UseCases (not UI): max active bookings, cancellation limits, OTP cooldown
- Track counts in user/driver Firestore document
- Reset counts on schedule (24h for cancellations, 1h for rejections)

### 17. Image Handling
- **ALWAYS** compress images before Firebase Storage upload
- Max 512x512 for profiles, 1024x1024 for documents/parcels
- Quality: 80-85% JPEG
- Use SVG for icons, PNG only when transparency required

### 18. Store Compliance (Apple & Google)
- **ALWAYS** show pre-permission screen before requesting any system permission
- **NEVER** request "Always" location in customer app — "When In Use" only
- **NEVER** request push notification permission on first launch — wait until first booking
- **ALWAYS** provide account deletion in Settings (both apps)
- **NEVER** use Stripe secret key on client — all payment intents via Cloud Functions
- Apple Sign-In button **MUST** be same size/prominence as Google Sign-In
- Support "Hide My Email" (Apple relay emails)
- See `docs/STORE_COMPLIANCE.md` for full checklist

### 19. Testing Requirements
- **Unit tests** for every UseCase
- **Unit tests** for every BLoC (test events → states)
- **Unit tests** for Model serialization (toJson/fromJson roundtrip)
- After route changes, verify navigation in the router config
- After Firestore schema changes, verify all 3 apps still compile
- Run `flutter analyze` before considering work complete

## Project Structure
```
RWP3/
├── core/              # Shared package (entities, repos, utils, constants)
├── customer/          # Customer mobile app
├── driver/            # Driver mobile app
├── admin/             # Admin web panel
├── functions/         # Firebase Cloud Functions
├── database/          # Firestore seed data & scripts
├── CLAUDE.md          # This file
├── ARCHITECTURE.md    # Technical architecture reference
├── DESIGN.md          # Design & feature specification
├── DEVELOPMENT.md     # Development guide & setup
└── PROJECT.md         # Project overview & index
```
