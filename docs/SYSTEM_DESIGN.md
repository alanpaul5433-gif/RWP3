# SYSTEM_DESIGN.md - System Design Diagrams

## 1. High-Level System Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                        CLIENT LAYER                                  │
│                                                                      │
│  ┌──────────────┐   ┌──────────────┐   ┌──────────────────────┐    │
│  │ Customer App  │   │  Driver App   │   │    Admin Panel        │    │
│  │  iOS/Android  │   │  iOS/Android  │   │    Flutter Web        │    │
│  │              │   │              │   │                      │    │
│  │ ┌──────────┐│   │ ┌──────────┐│   │ ┌──────────────────┐│    │
│  │ │  BLoCs   ││   │ │  BLoCs   ││   │ │     BLoCs        ││    │
│  │ └────┬─────┘│   │ └────┬─────┘│   │ └────────┬─────────┘│    │
│  │      │      │   │      │      │   │          │          │    │
│  │ ┌────▼─────┐│   │ ┌────▼─────┐│   │ ┌────────▼─────────┐│    │
│  │ │ UseCases ││   │ │ UseCases ││   │ │    UseCases      ││    │
│  │ └────┬─────┘│   │ └────┬─────┘│   │ └────────┬─────────┘│    │
│  │      │      │   │      │      │   │          │          │    │
│  │ ┌────▼─────┐│   │ ┌────▼─────┐│   │ ┌────────▼─────────┐│    │
│  │ │  Repos   ││   │ │  Repos   ││   │ │     Repos        ││    │
│  │ └────┬─────┘│   │ └────┬─────┘│   │ └────────┬─────────┘│    │
│  └──────┼──────┘   └──────┼──────┘   └──────────┼──────────┘    │
│         └──────────────────┼──────────────────────┘                │
│                            │                                        │
│                   ┌────────▼────────┐                               │
│                   │  core/ package   │                               │
│                   │ Shared Entities  │                               │
│                   │ Models, Errors   │                               │
│                   │ Constants, Utils │                               │
│                   └────────┬────────┘                               │
└────────────────────────────┼────────────────────────────────────────┘
                             │
                    ─ ─ ─ ─ ─│─ ─ ─ ─ ─  NETWORK BOUNDARY
                             │
┌────────────────────────────┼────────────────────────────────────────┐
│                     FIREBASE BACKEND                                 │
│                            │                                        │
│  ┌─────────────────────────▼──────────────────────────────────┐    │
│  │                  Cloud Firestore                            │    │
│  │                                                             │    │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐  │    │
│  │  │  users   │ │ drivers  │ │ bookings │ │intercity_ride│  │    │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────┘  │    │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐  │    │
│  │  │parcel_   │ │rental_   │ │ wallet_  │ │   settings   │  │    │
│  │  │ride      │ │ride      │ │ trans.   │ │              │  │    │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────────┘  │    │
│  │  + 30 more collections (see ARCHITECTURE.md)               │    │
│  └────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────────────────┐    │
│  │  Firebase     │  │   Firebase    │  │   Firebase Cloud       │    │
│  │  Auth         │  │   Storage     │  │   Messaging (FCM)      │    │
│  │              │  │              │  │                        │    │
│  │ • Email/Pass │  │ • Profiles   │  │ • Push Notifications   │    │
│  │ • Phone OTP  │  │ • Documents  │  │ • Topic Messaging      │    │
│  │ • Google     │  │ • Parcels    │  │ • Deep Linking         │    │
│  │ • Apple      │  │ • Banners    │  │                        │    │
│  └──────────────┘  └──────────────┘  └────────────────────────┘    │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │              Cloud Functions (Node.js v24)                   │    │
│  │                                                              │    │
│  │  ┌───────────────┐  ┌───────────────┐  ┌────────────────┐  │    │
│  │  │ createPayment │  │ assignDriver  │  │ calculateFare  │  │    │
│  │  │ Intent        │  │               │  │                │  │    │
│  │  └───────────────┘  └───────────────┘  └────────────────┘  │    │
│  │  ┌───────────────┐  ┌───────────────┐  ┌────────────────┐  │    │
│  │  │ onBooking     │  │ processWallet │  │ deleteUser     │  │    │
│  │  │ StatusChange  │  │ Topup         │  │ Account        │  │    │
│  │  └───────────────┘  └───────────────┘  └────────────────┘  │    │
│  │  ┌───────────────┐  ┌───────────────┐  ┌────────────────┐  │    │
│  │  │ cleanup       │  │ expireSubs    │  │ checkApp       │  │    │
│  │  │ StaleBookings │  │ criptions     │  │ Version        │  │    │
│  │  └───────────────┘  └───────────────┘  └────────────────┘  │    │
│  └────────────────────────────────────────────────────────────┘    │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────┐    │
│  │              Firebase Hosting                                │    │
│  │  • Admin Panel (Flutter Web build)                           │    │
│  │  • Privacy Policy / Terms of Service pages                   │    │
│  │  • .well-known/ (Universal Links, App Links)                 │    │
│  │  • Account Deletion web page                                 │    │
│  └────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
                             │
                    ─ ─ ─ ─ ─│─ ─ ─ ─ ─  EXTERNAL SERVICES
                             │
┌────────────────────────────┼────────────────────────────────────────┐
│                             │                                        │
│  ┌──────────────┐  ┌───────▼──────┐  ┌────────────────────────┐    │
│  │ Google Maps   │  │   Stripe     │  │   Apple / Google       │    │
│  │ Platform      │  │              │  │   Sign-In (OAuth)      │    │
│  │              │  │ • Payments   │  │                        │    │
│  │ • Maps SDK   │  │ • Google Pay │  └────────────────────────┘    │
│  │ • Directions │  │ • Apple Pay  │                                │
│  │ • Geocoding  │  │              │  ┌────────────────────────┐    │
│  │ • Places     │  └──────────────┘  │   SMTP (Email)         │    │
│  │ • Distance   │                    │ • Password reset       │    │
│  │   Matrix     │                    │ • Booking confirmations│    │
│  └──────────────┘                    └────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Clean Architecture — Per Feature

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                     │
│                                                          │
│   ┌────────────┐      ┌──────────────────────────────┐  │
│   │            │      │           BLoC               │  │
│   │   Page     │─────▶│                              │  │
│   │  (Widget)  │      │  Event ──▶ Handler ──▶ State │  │
│   │            │◀─────│                              │  │
│   │ BlocBuilder│      │  Uses: UseCases only         │  │
│   │ BlocListener     │  No Firebase imports         │  │
│   └────────────┘      └──────────┬───────────────────┘  │
│                                  │                       │
├──────────────────────────────────┼───────────────────────┤
│                    DOMAIN LAYER  │  (Pure Dart)           │
│                                  │                       │
│   ┌──────────────────────────────▼───────────────────┐  │
│   │                  UseCase                          │  │
│   │                                                   │  │
│   │  Input: Params ──▶ Logic ──▶ Output: Either<F,T> │  │
│   │  Calls: Repository (interface)                    │  │
│   └──────────────────────────────┬───────────────────┘  │
│                                  │                       │
│   ┌──────────────┐    ┌─────────▼────────────────┐     │
│   │   Entity     │    │   Repository (abstract)   │     │
│   │              │    │                           │     │
│   │ Pure Dart    │    │  Future<Either<Failure,T>>│     │
│   │ Equatable    │    │  Stream<Either<Failure,T>>│     │
│   │ No Firebase  │    │                           │     │
│   └──────────────┘    └─────────┬────────────────┘     │
│                                  │                       │
├──────────────────────────────────┼───────────────────────┤
│                    DATA LAYER    │                        │
│                                  │                       │
│   ┌──────────────────────────────▼───────────────────┐  │
│   │            RepositoryImpl                         │  │
│   │                                                   │  │
│   │  Implements domain Repository interface           │  │
│   │  Catches exceptions → returns Left(Failure)       │  │
│   │  Converts Model → Entity                          │  │
│   └──────────────────────────────┬───────────────────┘  │
│                                  │                       │
│   ┌──────────────┐    ┌─────────▼────────────────┐     │
│   │    Model     │    │   RemoteDataSource        │     │
│   │              │    │                           │     │
│   │ extends      │    │  Firestore CRUD           │     │
│   │ Entity       │    │  Firebase Auth            │     │
│   │ toJson()     │    │  Firebase Storage         │     │
│   │ fromJson()   │    │  HTTP calls               │     │
│   └──────────────┘    └───────────────────────────┘     │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 3. Booking Flow — Sequence Diagram

```
Customer App          Cloud Functions        Firestore           Driver App
    │                      │                     │                    │
    │  1. Create Booking   │                     │                    │
    ├─────────────────────────────────────────▶  │                    │
    │                      │   booking_placed     │                    │
    │                      │                     │                    │
    │                      │  2. assignDriver     │                    │
    │                      │◀──── (onCreate) ────│                    │
    │                      │                     │                    │
    │                      │  3. Query nearby     │                    │
    │                      │     online drivers   │                    │
    │                      ├────────────────────▶│                    │
    │                      │◀────────────────────│                    │
    │                      │                     │                    │
    │                      │  4. Update booking   │                    │
    │                      │     driver_assigned  │                    │
    │                      ├────────────────────▶│                    │
    │                      │                     │                    │
    │                      │  5. Send FCM         │   6. Notification │
    │                      ├─────────────────────────────────────────▶│
    │                      │                     │                    │
    │  7. Status stream    │                     │   8. Accept ride   │
    │◀─────────────────────────────────────────  │◀───────────────────│
    │   driver_assigned    │                     │  booking_accepted  │
    │                      │                     │                    │
    │  9. Show driver info │                     │  10. Navigate to   │
    │     on map           │                     │      pickup        │
    │                      │                     │                    │
    │                      │                     │  11. Request OTP   │
    │  12. Show OTP  ◀───────────────────────────────────────────────│
    │                      │                     │                    │
    │  13. Share OTP ─────────────────────────────────────────────▶  │
    │                      │                     │                    │
    │                      │                     │  14. Verify OTP    │
    │                      │                     │  15. Start ride    │
    │                      │                     │◀───────────────────│
    │                      │                     │  booking_ongoing   │
    │                      │                     │                    │
    │  16. Track driver    │                     │  17. Update        │
    │      in real-time    │                     │      location      │
    │◀─────────────────────────────────────────  │◀───────────────────│
    │                      │                     │                    │
    │                      │                     │  18. Complete ride │
    │                      │                     │◀───────────────────│
    │                      │                     │  booking_completed │
    │                      │                     │                    │
    │  19. Payment         │                     │                    │
    │      ┌───────────────┴──────────────┐      │                    │
    │      │ Cash: mark complete          │      │                    │
    │      │ Wallet: deduct balance       │      │                    │
    │      │ Stripe:                      │      │                    │
    │      │  a. createPaymentIntent ────▶│      │                    │
    │      │  b. ◀── clientSecret         │      │                    │
    │      │  c. presentPaymentSheet      │      │                    │
    │      │  d. confirmPayment ─────────▶│      │                    │
    │      │  e. ◀── verified             │      │                    │
    │      └──────────────────────────────┘      │                    │
    │                      │                     │                    │
    │  20. Rate driver     │                     │  21. Rate customer │
    │├────────────────────────────────────────▶  │◀───────────────────│
    │                      │                     │                    │
    ▼                      ▼                     ▼                    ▼
```

---

## 4. Payment Flow — Detailed

```
┌──────────────────────────────────────────────────────────────────┐
│                     PAYMENT METHOD SELECTION                      │
│                                                                   │
│  ┌─────────┐    ┌──────────┐    ┌──────────────────────────┐    │
│  │  Cash    │    │  Wallet   │    │  Stripe (Card/GPay/APay) │    │
│  └────┬────┘    └─────┬────┘    └────────────┬─────────────┘    │
│       │               │                       │                   │
└───────┼───────────────┼───────────────────────┼───────────────────┘
        │               │                       │
        ▼               ▼                       ▼
  ┌───────────┐  ┌────────────┐         ┌─────────────┐
  │ Mark as   │  │ Check      │         │ Client:     │
  │ "cash"    │  │ balance    │         │ Request     │
  │ payment   │  │ >= amount? │         │ payment     │
  │ deferred  │  └─────┬──┬──┘         └──────┬──────┘
  └─────┬─────┘        │  │                    │
        │         Yes──┘  └──No                │
        │         │          │                  ▼
        │         ▼          ▼          ┌──────────────┐
        │  ┌───────────┐ ┌────────┐    │Cloud Function:│
        │  │ Deduct    │ │ Error: │    │createPayment │
        │  │ wallet    │ │ "Add   │    │Intent        │
        │  │ balance   │ │ funds" │    │(secret key)  │
        │  └─────┬─────┘ └────────┘    └──────┬───────┘
        │        │                             │
        │        ▼                             ▼
        │  ┌───────────┐              ┌──────────────┐
        │  │ Create    │              │ Return       │
        │  │ wallet_   │              │ clientSecret │
        │  │ transaction│              └──────┬───────┘
        │  └─────┬─────┘                      │
        │        │                             ▼
        │        │                    ┌──────────────┐
        │        │                    │ Client:      │
        │        │                    │ Present      │
        │        │                    │ PaymentSheet │
        │        │                    │ (Stripe SDK) │
        │        │                    └──────┬───────┘
        │        │                           │
        │        │                    Success│  Failure
        │        │                      │    │    │
        │        │                      ▼    │    ▼
        │        │              ┌────────────┐│ ┌────────┐
        │        │              │Cloud Func: ││ │ Show   │
        │        │              │confirmPay- ││ │ error  │
        │        │              │ment        ││ │ retry  │
        │        │              └──────┬─────┘│ └────────┘
        │        │                     │      │
        ▼        ▼                     ▼      │
  ┌────────────────────────────────────────┐  │
  │         UPDATE BOOKING                  │  │
  │  paymentStatus: true                    │  │
  │  paymentType: cash|wallet|stripe        │  │
  │  stripePaymentIntentId: pi_xxx          │  │
  └───────────────────┬────────────────────┘  │
                      │                        │
                      ▼                        │
  ┌────────────────────────────────────────┐  │
  │         CALCULATE COMMISSION            │  │
  │  adminCommission = total * rate         │  │
  │  driverEarning = total - commission     │  │
  │  Credit driver wallet                   │  │
  │  Log to audit_log                       │  │
  └────────────────────────────────────────┘  │
```

---

## 5. Driver Matching Algorithm

```
                    New Booking Created
                    (booking_placed)
                           │
                           ▼
                ┌─────────────────────┐
                │  Query Firestore:    │
                │  drivers WHERE       │
                │    isOnline = true   │
                │    isVerified = true │
                │    isActive = true   │
                │    currentBookingId  │
                │      = null          │
                │    vehicleType match │
                │    zoneId contains   │
                │      booking zone    │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │  Calculate distance  │
                │  (Haversine) from    │
                │  each driver to      │    isOnlyForFemale?
                │  pickup location     │───── Yes ──▶ Filter: gender=Female
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │  Filter: distance    │
                │  <= search radius    │
                │  (default 10km)      │
                └──────────┬──────────┘
                           │
                           ▼
                ┌─────────────────────┐
                │  Sort by:            │
                │  1. Distance (ASC)   │
                │  2. Rating (DESC)    │
                └──────────┬──────────┘
                           │
                           ▼
               ┌──────────────────────┐
        ┌─────│  Attempt = 1          │
        │     │  Max attempts = 5     │
        │     └──────────┬────────────┘
        │                │
        │                ▼
        │     ┌─────────────────────┐
        │     │  Pick driver[attempt]│
        │     │  Set booking:        │
        │     │   driverId = driver  │
        │     │   status = assigned  │
        │     │  Set driver:         │
        │     │   currentBookingId   │
        │     │  Send FCM push       │
        │     └──────────┬──────────┘
        │                │
        │                ▼
        │     ┌─────────────────────┐
        │     │  Wait 30 seconds     │
        │     └──────────┬──────────┘
        │                │
        │          ┌─────┴─────┐
        │          │           │
        │       Accepted    Timeout/Rejected
        │          │           │
        │          ▼           ▼
        │     ┌─────────┐  ┌────────────────┐
        │     │ DONE!    │  │ Reset booking: │
        │     │ status=  │  │  driverId=null │
        │     │ accepted │  │  status=placed │
        │     └─────────┘  │ Reset driver:  │
        │                  │  currentBooking │
        │                  │  Id = null      │
        │                  │ attempt += 1    │
        │                  └───────┬────────┘
        │                          │
        │                    attempt > 5?
        │                     │         │
        │                    Yes        No
        │                     │         │
        │                     ▼         └──── (loop back) ───▶
        │           ┌──────────────────┐
        │           │ CANCEL BOOKING   │
        │           │ status=cancelled │
        │           │ reason="No       │
        │           │  drivers found"  │
        │           │ Notify customer  │
        │           │ Refund if prepaid│
        └───────▶   └──────────────────┘
```

---

## 6. Authentication Flow

```
                         App Launch
                            │
                            ▼
                  ┌───────────────────┐
                  │ Check Firebase     │
                  │ Auth state         │
                  └────────┬──────────┘
                           │
                    ┌──────┴──────┐
                    │             │
                 Logged In    Not Logged In
                    │             │
                    ▼             ▼
            ┌──────────┐  ┌──────────────┐
            │ Check     │  │  Login Page   │
            │ Firestore │  │              │
            │ profile   │  │ ┌──────────┐│
            └─────┬────┘  │ │Email+Pass ││──▶ Firebase Auth
                  │       │ └──────────┘│     signInWithEmail
            ┌─────┴────┐  │ ┌──────────┐│
            │          │  │ │Phone+OTP ││──▶ Firebase Auth
         Exists    Missing│ └──────────┘│     verifyPhoneNumber
            │          │  │ ┌──────────┐│         │
            ▼          │  │ │ Google   ││──▶ Google OAuth
       ┌────────┐      │  │ └──────────┘│     signInWithCredential
       │  Home   │      │  │ ┌──────────┐│         │
       │  Page   │      │  │ │  Apple   ││──▶ Apple OAuth
       └────────┘      │  │ └──────────┘│     signInWithCredential
                       │  └──────┬───────┘         │
                       │         │                  │
                       │         └──────┬───────────┘
                       │                │
                       ▼                ▼
                 ┌──────────┐   ┌──────────────┐
                 │ Signup    │   │ Auth Success  │
                 │ Page      │   │ Check profile │
                 │           │   └──────┬───────┘
                 │ Name      │          │
                 │ Email     │    ┌─────┴─────┐
                 │ Password  │    │           │
                 │ Gender    │  Exists     Missing ──▶ Signup Page
                 │ Referral  │    │
                 └─────┬────┘    ▼
                       │    ┌────────┐
                       └──▶│  Home   │
                            │  Page   │
                            └────────┘
```

---

## 7. Real-Time Tracking Architecture

```
┌─────────────────┐                              ┌─────────────────┐
│   Driver App     │                              │  Customer App    │
│                  │                              │                  │
│ ┌──────────────┐│    ┌──────────────────┐      │┌──────────────┐ │
│ │ GPS          ││    │    Firestore      │      ││ TrackingBloc │ │
│ │ Geolocator   ││    │                  │      ││              │ │
│ │              ││    │  drivers/{id}     │      ││ Subscribes   │ │
│ │ Every 10s:   ││    │  ┌────────────┐  │      ││ to driver    │ │
│ │ update       │├───▶│  │ location:  │  │──────▶│ location     │ │
│ │ driver.      ││    │  │  lat: 37.7 │  │      ││ stream       │ │
│ │ location     ││    │  │  lng:-122.4│  │      ││              │ │
│ │              ││    │  └────────────┘  │      ││ Updates:     │ │
│ └──────────────┘│    │                  │      ││ • Map marker │ │
│                  │    │  bookings/{id}   │      ││ • Polyline   │ │
│ ┌──────────────┐│    │  ┌────────────┐  │      ││ • ETA        │ │
│ │ Position     ││    │  │ positions: │  │      │└──────────────┘ │
│ │ history      │├───▶│  │ [{lat,lng}]│  │      │                  │
│ │ (breadcrumb) ││    │  └────────────┘  │      │┌──────────────┐ │
│ └──────────────┘│    │                  │      ││ Google Maps  │ │
│                  │    │  bookings/{id}   │      ││              │ │
│ ┌──────────────┐│    │  ┌────────────┐  │      ││ • Driver     │ │
│ │ Status       ││    │  │ status:    │  │      ││   marker     │ │
│ │ updates      │├───▶│  │ "ongoing"  │  │──────▶│ • Pickup pin │ │
│ │              ││    │  └────────────┘  │      ││ • Drop pin   │ │
│ └──────────────┘│    └──────────────────┘      ││ • Route line │ │
│                  │                              ││ • ETA text   │ │
└─────────────────┘                              │└──────────────┘ │
                                                  └─────────────────┘

    Route Caching:
    ┌─────────────────────────────────┐
    │  LRU Cache (in-memory)          │
    │  Key: "{origin}_{destination}"  │
    │  Value: polyline points         │
    │  TTL: 20 minutes                │
    │  Eviction: LRU when > 50 routes │
    └─────────────────────────────────┘

    Deviation Detection:
    ┌─────────────────────────────────┐
    │  Every location update:          │
    │  distance = haversine(           │
    │    driver.location,              │
    │    nearestPointOnRoute           │
    │  )                               │
    │  if distance > 120m:             │
    │    → recalculate route           │
    │    → update polyline             │
    │    → update ETA                  │
    └─────────────────────────────────┘
```

---

## 8. Notification System

```
┌──────────────────────────────────────────────────────────────┐
│                    NOTIFICATION TRIGGERS                       │
│                                                               │
│  Firestore Triggers (Cloud Functions):                        │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ onBookingStatusChange:                                  │  │
│  │   placed     → notify driver (new ride available)       │  │
│  │   assigned   → notify customer (driver found)           │  │
│  │   accepted   → notify customer (driver is coming)       │  │
│  │   ongoing    → notify customer (ride started)           │  │
│  │   completed  → notify both (ride complete, payment)     │  │
│  │   cancelled  → notify other party                       │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
│  Direct Triggers (from app):                                  │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ Chat message    → notify recipient                      │  │
│  │ SOS alert       → notify admin + emergency contacts     │  │
│  │ Support reply   → notify ticket creator                 │  │
│  │ Admin broadcast → notify topic (all customers/drivers)  │  │
│  │ Wallet credit   → notify user                           │  │
│  │ Payout approved → notify driver                         │  │
│  │ Document status → notify driver                         │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────┬───────────────────────────────────────┘
                       │
                       ▼
         ┌─────────────────────────┐
         │   Firebase Cloud         │
         │   Messaging (FCM)        │
         │                          │
         │  ┌────────────────────┐ │
         │  │ Token-based        │ │ ──▶ Single device
         │  │ (user.fcmToken)    │ │
         │  └────────────────────┘ │
         │  ┌────────────────────┐ │
         │  │ Topic-based        │ │ ──▶ All customers / all drivers
         │  │ (rwp3-customer)    │ │
         │  │ (rwp3-driver)      │ │
         │  └────────────────────┘ │
         └────────────┬────────────┘
                      │
            ┌─────────┴─────────┐
            │                   │
         Android              iOS
            │                   │
            ▼                   ▼
   ┌────────────────┐  ┌────────────────┐
   │ Channels:      │  │ Categories:    │
   │ • booking_     │  │ • BOOKING_     │
   │   updates      │  │   UPDATE       │
   │ • new_booking  │  │ • NEW_BOOKING  │
   │ • chat_        │  │ • CHAT         │
   │   messages     │  │                │
   │ • payments     │  │ Actions:       │
   │ • promotions   │  │ • View Ride    │
   │ • support      │  │ • Cancel       │
   │ • sos (alarm)  │  │ • Reply        │
   └────────────────┘  └────────────────┘
            │                   │
            └─────────┬─────────┘
                      │
                      ▼
            ┌───────────────────┐
            │  On Tap:           │
            │  Parse payload     │
            │  Extract route     │
            │  GoRouter.go()     │
            │  → Deep link to    │
            │    relevant screen │
            └───────────────────┘
```

---

## 9. Data Flow — Fare Calculation

```
┌──────────────────────────────────────────────────────────────────┐
│                     FARE CALCULATION                              │
│                                                                   │
│  INPUT (from booking):                                            │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ distance_km    = 12.5                                       │  │
│  │ duration_min   = 28                                         │  │
│  │ vehicleType    = { baseFare: 50, perKm: 12, perMin: 2 }   │  │
│  │ minimumFare    = 80                                         │  │
│  │ nightWindow    = { start: "22:00", end: "06:00", charge: 15%}│ │
│  │ pickupTime     = 23:30 (within night window)                │  │
│  │ holdMinutes    = 5                                          │  │
│  │ holdChargeRate = 3/min                                      │  │
│  │ coupon         = { discount: 10%, maxDiscount: 50 }         │  │
│  │ taxRate        = 8%                                         │  │
│  │ commission     = { rate: 20%, isFixed: false }              │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                   │
│  CALCULATION:                                                     │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │                                                             │  │
│  │  distanceCharge = 12.5 × 12        = 150.00                │  │
│  │  timeCharge     = 28 × 2           =  56.00                │  │
│  │  baseFare                          =  50.00                │  │
│  │                                    ────────                │  │
│  │  rawTotal                          = 256.00                │  │
│  │  subtotal = MAX(256.00, 80.00)     = 256.00                │  │
│  │                                                             │  │
│  │  nightCharge = 256.00 × 15%        =  38.40                │  │
│  │  holdCharge  = 5 × 3               =  15.00                │  │
│  │                                    ────────                │  │
│  │  grossTotal                        = 309.40                │  │
│  │                                                             │  │
│  │  couponDiscount = MIN(309.40×10%, 50) = 30.94              │  │
│  │                                    ────────                │  │
│  │  afterDiscount                     = 278.46                │  │
│  │                                                             │  │
│  │  tax = 278.46 × 8%                =  22.28                │  │
│  │                                    ════════                │  │
│  │  TOTAL                             = 300.74                │  │
│  │                                                             │  │
│  │  adminCommission = 300.74 × 20%    =  60.15                │  │
│  │  driverEarning   = 300.74 - 60.15  = 240.59                │  │
│  │                                                             │  │
│  └────────────────────────────────────────────────────────────┘  │
│                                                                   │
│  OUTPUT:                                                          │
│  ┌────────────────────────────────────────────────────────────┐  │
│  │ booking.estimatedFare    = 300.74  (shown before booking)   │  │
│  │ booking.subTotal         = 256.00                           │  │
│  │ booking.nightCharge      = 38.40                            │  │
│  │ booking.holdTimingCharge = 15.00                            │  │
│  │ booking.discount         = 30.94                            │  │
│  │ booking.taxAmount        = 22.28                            │  │
│  │ booking.totalAmount      = 300.74                           │  │
│  │ booking.adminCommission  = 60.15                            │  │
│  │ driverWallet            += 240.59                           │  │
│  └────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 10. Dependency Injection Graph

```
┌──────────────────────────────────────────────────────────────┐
│                    DEPENDENCY INJECTION (get_it)               │
│                                                               │
│  EXTERNAL (registered first):                                 │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ FirebaseFirestore.instance                              │  │
│  │ FirebaseAuth.instance                                   │  │
│  │ FirebaseStorage.instance                                │  │
│  │ FirebaseMessaging.instance                              │  │
│  └──────────────────────┬─────────────────────────────────┘  │
│                          │                                    │
│  DATA SOURCES (depend on external):                           │
│  ┌──────────────────────▼─────────────────────────────────┐  │
│  │ AuthRemoteDataSource(firestore, auth)                   │  │
│  │ BookingRemoteDataSource(firestore)                      │  │
│  │ WalletRemoteDataSource(firestore)                       │  │
│  │ ChatRemoteDataSource(firestore)                         │  │
│  │ DriverRemoteDataSource(firestore)                       │  │
│  │ VehicleRemoteDataSource(firestore)                      │  │
│  │ PaymentRemoteDataSource(firestore, functions)           │  │
│  │ ...                                                     │  │
│  └──────────────────────┬─────────────────────────────────┘  │
│                          │                                    │
│  REPOSITORIES (depend on data sources):                       │
│  ┌──────────────────────▼─────────────────────────────────┐  │
│  │ AuthRepositoryImpl(authDataSource)                      │  │
│  │ BookingRepositoryImpl(bookingDataSource)                 │  │
│  │ WalletRepositoryImpl(walletDataSource)                  │  │
│  │ ChatRepositoryImpl(chatDataSource)                      │  │
│  │ ...                                                     │  │
│  └──────────────────────┬─────────────────────────────────┘  │
│                          │                                    │
│  USE CASES (depend on repositories):                          │
│  ┌──────────────────────▼─────────────────────────────────┐  │
│  │ LoginWithEmail(authRepo)                                │  │
│  │ CreateBooking(bookingRepo)                              │  │
│  │ CalculateFare(bookingRepo)                              │  │
│  │ AddMoneyToWallet(walletRepo)                            │  │
│  │ SendMessage(chatRepo)                                   │  │
│  │ ...                                                     │  │
│  └──────────────────────┬─────────────────────────────────┘  │
│                          │                                    │
│  BLOCS (depend on use cases):                                 │
│  ┌──────────────────────▼─────────────────────────────────┐  │
│  │ AuthBloc(loginWithEmail, signupWithEmail, ...)          │  │
│  │ BookingBloc(createBooking, getBooking, cancelBooking)   │  │
│  │ PaymentBloc(createPaymentIntent, confirmPayment)        │  │
│  │ WalletBloc(addMoney, getTransactions)                   │  │
│  │ TrackingBloc(watchDriverLocation, calculateEta)         │  │
│  │ ChatBloc(sendMessage, watchMessages)                    │  │
│  │ ...                                                     │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                               │
│  Registration order: External → DataSources → Repos           │
│                      → UseCases → BLoCs                       │
│  BLoCs registered as Factory (new instance per screen)        │
│  Everything else registered as LazySingleton                  │
└──────────────────────────────────────────────────────────────┘
```

---

## 11. Navigation Map — Customer App

```
                              Splash
                                │
                   ┌────────────┴────────────┐
                   │                         │
               Logged In               Not Logged In
                   │                         │
                   ▼                         ▼
                 Home ◀──────────────── Login ──▶ Signup
                   │                     │
                   │                     ├──▶ OTP Verify
                   │                     └──▶ Forgot Password
                   │
        ┌──────────┼──────────┬──────────────┐
        │          │          │              │
        ▼          ▼          ▼              ▼
    Book Cab   Intercity   Parcel        Rental
        │          │          │              │
        ▼          ▼          ▼              ▼
   Select Location (shared)
        │
        ▼
   Select Vehicle
        │
        ▼
   Apply Coupon? ──▶ Coupon List
        │
        ▼
   Select Payment ──▶ Add Money (Stripe)
        │
        ▼
   Confirm Booking
        │
        ▼
   Waiting for Driver ──▶ Cancel (with reason)
        │
        ▼
   Driver Assigned
        │
        ▼
   Tracking Screen ──▶ Chat with Driver
        │              ──▶ SOS Alert
        │              ──▶ Cancel
        ▼
   Ride Complete
        │
        ▼
   Payment Screen
        │
        ▼
   Rate Driver
        │
        ▼
   Home

   DRAWER MENU:
   ├── Ride History ──▶ Ride Details
   ├── Wallet ──▶ Add Money ──▶ Transactions
   ├── Coupons
   ├── Loyalty Points
   ├── Referral
   ├── Chat Inbox ──▶ Chat Screen
   ├── Notifications
   ├── Emergency Contacts
   ├── Support ──▶ Create Ticket ──▶ Ticket Details
   ├── Profile ──▶ Edit Profile ──▶ Delete Account
   ├── Language
   ├── Theme (Dark/Light)
   ├── About / Terms / Privacy
   └── Logout
```
