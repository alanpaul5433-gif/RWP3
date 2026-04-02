# PROJECT.md - RWP3 (Ride With Purpose) Project Overview

## About

RWP3 is a multi-app ride-sharing platform that connects passengers with drivers for transportation and delivery services. Built from scratch with Flutter and Firebase.

**Project Name:** Ride With Purpose (RWP3)
**Type:** Multi-app ride-sharing platform
**Platform:** iOS, Android, Web
**Tech Stack:** Flutter + Firebase
**Architecture:** BLoC + Clean Architecture
**State Management:** flutter_bloc
**UI:** Material Design 3 (Modern & Clean)
**Color Theme:** Red (primary), Blue (secondary), White (surface)
**Auth:** Email/Password, Phone OTP, Google, Apple
**Payment:** Stripe only

---

## Apps

| App | Platform | Target User | Purpose |
|-----|----------|-------------|---------|
| Customer | iOS / Android | Passengers | Book and track rides |
| Driver | iOS / Android | Drivers | Accept and complete rides |
| Admin | Web (Flutter) | Platform admins | Manage entire platform |

---

## Services Offered

| Service | Description |
|---------|-------------|
| **Cab Ride** | Local point-to-point transportation with multiple stops |
| **Intercity Ride** | Long-distance travel (personal or shared) |
| **Parcel Delivery** | Package pickup and delivery |
| **Rental** | Vehicle rental by time/distance packages |

---

## Documentation Index

| Document | Description |
|----------|-------------|
| [CLAUDE.md](CLAUDE.md) | AI agent rules, coding standards, mandatory guidelines |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Technical architecture, Firestore schema, system design, state machines |
| [DESIGN.md](DESIGN.md) | Feature specification, roles, user journeys, data models, notification matrix |
| [DEVELOPMENT.md](DEVELOPMENT.md) | Setup guide, coding conventions, module creation, build & deploy |
| [PROJECT.md](PROJECT.md) | This file - project overview and index |
| [firestore.rules](firestore.rules) | Firestore security rules for all collections |
| [firestore_indexes/firestore.indexes.json](firestore_indexes/firestore.indexes.json) | Composite indexes for all complex queries |
| [storage.rules](storage.rules) | Firebase Storage security rules (images, documents) |
| [docs/STORE_COMPLIANCE.md](docs/STORE_COMPLIANCE.md) | Apple App Store & Google Play compliance, review checklists |
| [docs/PLATFORM_SETUP.md](docs/PLATFORM_SETUP.md) | Step-by-step setup for Firebase, Stripe, Google OAuth, Apple Sign-In, APNs, Maps |
| [docs/LEGAL_TEMPLATES.md](docs/LEGAL_TEMPLATES.md) | Privacy Policy, Terms of Service, Account Deletion page templates |
| [docs/DESIGN_ASSETS.md](docs/DESIGN_ASSETS.md) | App icons, screenshots, in-app assets, illustrations, color reference |
| [docs/LAUNCH_CHECKLIST.md](docs/LAUNCH_CHECKLIST.md) | 7-phase checklist: accounts → development → testing → assets → legal → submission → post-launch |
| [docs/SYSTEM_DESIGN.md](docs/SYSTEM_DESIGN.md) | System architecture diagrams: high-level, clean arch, booking flow, payment, driver matching, auth, tracking, notifications, fare calc, DI graph, navigation map |

---

## Quick Reference

### Roles
- **Customer:** Books rides, manages wallet, tracks in real-time
- **Driver:** Accepts rides, navigates, earns money, manages documents
- **Admin:** Manages users, bookings, finances, settings, support

### Architecture
- **Pattern:** BLoC + Clean Architecture (3 layers: Data → Domain ← Presentation)
- **State:** flutter_bloc with sealed Events & States
- **DI:** get_it + injectable
- **Navigation:** go_router
- **Error Handling:** Either<Failure, T> (dartz)
- **Shared Code:** `core/` package used by all 3 apps

### Key Numbers
- 4 ride types (cab, intercity, parcel, rental)
- 3 payment methods (cash, wallet, Stripe)
- 4 auth methods (email/password, phone OTP, Google, Apple)
- 35+ Firestore collections
- 40+ data entities
- 17+ BLoCs with mapped events/states
- 8 booking statuses
- 50+ screens per app
- Multi-language, dark/light theme

### Booking Status Flow
```
placed → assigned → accepted → ongoing → completed
                                  ↕
                               on_hold
Any (except completed) → cancelled
assigned → rejected
```

### Payment Flow
```
Cash    → Pay driver directly → Mark complete
Wallet  → Auto-deduct balance → Update transaction log
Stripe  → PaymentIntent → PaymentSheet → Confirm → Update booking
```

---

## Getting Started

1. Read [DEVELOPMENT.md](DEVELOPMENT.md) for setup instructions
2. Read [ARCHITECTURE.md](ARCHITECTURE.md) for technical understanding
3. Read [DESIGN.md](DESIGN.md) for feature requirements
4. Read [CLAUDE.md](CLAUDE.md) for coding rules and standards
5. Start building!

---

## Implementation Priority (Suggested)

### Phase 1: Foundation
- [ ] Firebase project setup
- [ ] Create `core/` shared package (entities, models, errors, constants, base UseCase)
- [ ] Set up get_it dependency injection in each app
- [ ] Set up go_router navigation in each app
- [ ] Implement AuthBloc + Auth feature (Email/Password + Phone OTP + Google + Apple + Forgot Password)
- [ ] User/Driver profile entities, models, repository, CRUD usecases

### Phase 2: Core Booking (Cab)
- [ ] LocationBloc (pickup, drop, stops, route calculation)
- [ ] Vehicle type entity, model, repository, BLoC
- [ ] BookingBloc (create, status stream, cancel) with full event/state mapping
- [ ] Driver assignment flow (DriverBookingBloc)
- [ ] OTP verification BLoC
- [ ] TrackingBloc (real-time location, polyline, ETA)
- [ ] PaymentBloc (Stripe, wallet, cash) with audit trail events
- [ ] ReviewBloc (rate driver/customer)

### Phase 3: Admin Panel
- [ ] Dashboard with stats
- [ ] Customer and driver management
- [ ] Booking management
- [ ] Settings configuration
- [ ] Payment gateway setup

### Phase 4: Financial
- [ ] Wallet system (add money, deductions)
- [ ] Stripe payment integration
- [ ] Commission calculation
- [ ] Driver payouts and bank management
- [ ] Tax configuration

### Phase 5: Extended Services
- [ ] Intercity rides
- [ ] Parcel delivery
- [ ] Rental bookings

### Phase 6: Engagement
- [ ] Push notifications (FCM)
- [ ] In-ride chat
- [ ] Coupon system
- [ ] Loyalty points
- [ ] Referral program
- [ ] Reviews and ratings

### Phase 7: Safety & Support
- [ ] Emergency contacts
- [ ] SOS alerts
- [ ] Support ticket system
- [ ] Help chat

### Phase 8: Admin Advanced
- [ ] Role-based access control
- [ ] Employee management
- [ ] Zone management
- [ ] Banner and content management
- [ ] Subscription plans
- [ ] Email templates
- [ ] Data export (PDF/Excel)

### Phase 9: Polish
- [ ] Multi-language support
- [ ] Dark/Light theme
- [ ] Onboarding screens
- [ ] Night charges
- [ ] Cancellation system
- [ ] Statement generation
