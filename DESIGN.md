# DESIGN.md - RWP3 Design & Feature Specification

## 1. Roles & Personas

### 1.1 Customer (Passenger)
- Books rides across 4 service types
- Tracks rides in real-time
- Manages wallet, payments, and profile
- Communicates with drivers and support
- Earns loyalty points and referral rewards

### 1.2 Driver
- Receives and fulfills ride requests
- Manages documents, vehicle, and bank details
- Tracks earnings and requests payouts
- Subscribes to platform plans
- Communicates with customers and support

### 1.3 Admin
- Full platform management (users, drivers, bookings, finances)
- Configures services, pricing, zones, and payment gateways
- Manages roles, employees, and access control
- Monitors SOS alerts and support tickets
- Sends push notifications and manages content

---

## 2. Service Types

### 2.1 Cab Ride (Daily/Local)
- Point-to-point local transportation
- Multiple stops support
- Per-km and per-minute pricing
- Night charge surcharge
- Hold/pause with per-minute charges
- OTP verification before ride start
- Female-only ride option
- Real-time tracking with ETA

### 2.2 Intercity Ride
- Long-distance transportation
- Personal or sharing ride types
- Sharing persons management (add co-passengers)
- Fixed or bid-based pricing
- Driver bidding system (optional, configurable)
- Multi-stop route support

### 2.3 Parcel Delivery
- Package pickup and delivery
- Parcel metadata (image, weight, dimensions)
- Bid-based pricing (optional)
- Proof of delivery via OTP

### 2.4 Rental
- Vehicle rental by time/distance packages
- Pre-defined packages (hours + km)
- Real-time KM tracking
- Extra hour and extra KM charges
- Package-based pricing

---

## 3. Feature Specification

### 3.1 Authentication & Onboarding

| Feature | Customer | Driver | Admin |
|---------|----------|--------|-------|
| Email/Password login | Yes | Yes | Yes |
| Phone + OTP login | Yes | Yes | No |
| Google Sign-In | Yes | Yes | No |
| Apple Sign-In | Yes | Yes | No |
| Onboarding slides | Yes | Yes | No |
| Document upload | No | Yes | No |
| Vehicle registration | No | Yes | No |
| Admin approval | No | Required | N/A |
| Referral code (signup) | Yes | Yes | No |

### 3.2 Customer App Features

#### Home Screen
- Profile card (name, phone, avatar)
- Active ride banner (if ongoing ride exists)
- Promotional banner carousel
- Quick access: Cab, Intercity, Parcel, Rental
- Drawer navigation to all sections

#### Authentication Screens
- **Login Page:** Email + password fields, "Forgot password?" link, OR divider, social buttons (Google, Apple), "Login with Phone" link, "Sign up" link
- **Signup Page:** Full name, email, password, confirm password, gender, referral code (optional), "Sign up" button, social signup options
- **Forgot Password Page:** Email input, "Send reset link" button, back to login
- **OTP Page:** 6-digit pin input, countdown timer, "Resend OTP" button
- **Phone Login Page:** Country code picker + phone number, "Send OTP" button

#### Booking Flow (All Ride Types)
1. Select ride type
2. Pick source location (map + search)
3. Pick destination location
4. Add intermediate stops (optional)
5. Select vehicle type
6. View fare estimate
7. Apply coupon (optional)
8. Select payment method (Cash / Wallet / Stripe)
9. Confirm booking
10. Wait for driver assignment
11. OTP exchange with driver
12. Real-time tracking
13. Ride completion
14. Payment processing
15. Rate and review driver

#### Wallet Management
- View balance
- Add money via Stripe
- Transaction history (credits and debits)
- Auto-deduct for wallet payments

#### Payment Methods
- Cash on delivery/completion
- Wallet balance
- Stripe (credit/debit card, Google Pay, Apple Pay)

#### Coupon System
- Browse available coupons
- Apply to booking (validates min order, expiry, usage)
- Fixed amount or percentage discount
- Max discount cap

#### Loyalty Points
- Earn points per completed ride
- View points balance and history
- Redemption rules (configured by admin)

#### Referral Program
- Unique referral code per user (format: 2 letters + 4 digits)
- Share code via native share
- Bonus credited to both referrer and referee
- Referral history tracking

#### Communication
- In-ride chat with driver (text messages)
- Chat inbox with conversation history
- Help/support chat by ride type
- Support ticket creation and tracking

#### Safety & Emergency
- Add emergency contacts
- SOS alert during active ride (sends location + booking info)
- Configurable SOS number

#### Profile & Settings
- Edit name, email, phone, gender, avatar
- Language selection (multi-language)
- Dark/Light theme toggle
- Notification preferences
- View terms, privacy policy, about
- **Delete Account** (mandatory for App Store & Play Store)
  - Re-authenticate before deletion
  - Anonymize linked records (bookings, transactions)
  - Delete personal data, images, auth account
  - Confirmation email sent

#### Ride History
- Separate tabs: Ongoing, Completed, Cancelled, Rejected
- View full ride details with map
- Export booking data

#### Cancellation
- Cancel before ride starts or during ride
- Select predefined cancellation reason
- Cancellation charge applied (configurable)
- Refund to wallet if prepaid

### 3.3 Driver App Features

#### Home Screen
- Online/Offline toggle
- Booking stats pie chart (new, ongoing, completed, rejected, cancelled)
- Earnings summary
- Tab-based ride type views

#### Ride Management
- Receive ride requests via push notification
- Accept or reject rides
- Request OTP from customer before starting
- Real-time navigation with polyline routing
- Route deviation detection
- Complete ride and trigger payment
- Cancel with reason

#### Document Management
- Upload required documents (license, ID, insurance, etc.)
- Two-sided document support (front + back)
- Image compression before upload
- Verification status tracking
- Re-upload on rejection

#### Vehicle Management
- Select vehicle type, brand, model
- Enter registration number
- Select service zones (multi-zone)
- Update vehicle details

#### Financial Management
- Wallet balance display
- Add money via Stripe
- Withdrawal to bank account
- Bank account management (add/edit/delete)
- Minimum withdrawal amount enforcement
- Transaction history
- Financial statement export (Excel format)
  - Cab, Intercity, Parcel ride data
  - Date range filtering
  - Columns: ID, pickup, dropoff, distance, status, price, payment type

#### Subscription Plans
- View available plans (name, price, duration, booking limit)
- Purchase via Stripe / Wallet
- Track active subscription
- Renewal reminders
- Subscription history

#### Communication
- Chat with customer during active ride
- Chat inbox
- Help/support chat
- Support ticket system

#### Safety
- Emergency contacts management
- SOS alert history
- Access to customer emergency info during ride

#### Profile & Settings
- Same as customer (edit profile, language, theme)
- Notification management

### 3.4 Admin Panel Features

#### Dashboard
- Live stats: total bookings, customers, drivers, vehicle types
- Booking breakdown: placed, active, completed, cancelled
- Today's and monthly earnings
- Real-time stream updates
- Recent bookings and users

#### Customer Management
- List all customers with pagination (10/20/50/100 per page)
- Search by name, email, phone
- View customer details (profile, wallet, ride history)

#### Driver Management
- List all drivers with search/filter
- Separate views: verified, unverified, online
- Document verification workflow (approve/reject per document)
- Driver detail view (profile, vehicle, earnings, documents)

#### Booking Management (All 4 Types)
- List bookings with status filters
- View booking details with map
- Customer and driver info per booking
- Payment and commission breakdown
- Export to PDF with date range

#### Fleet Management
- **Vehicle Types:** Create/edit (name, image, pricing: base fare, per-km, per-minute, minimum fare, capacity)
- **Vehicle Brands:** Create/edit (name, image)
- **Vehicle Models:** Create/edit (name, linked to brand)
- **Online Drivers:** Real-time view of online drivers

#### Financial Management
- **Payment Config:** Enable/disable Stripe, Cash, Wallet with API keys
- **Tax Management:** Create/edit tax rates per country (percentage)
- **Currency:** Set active currency (code, symbol, decimals, position)
- **Admin Commission:** Fixed amount or percentage per ride
- **Payout Requests:** Approve/reject driver withdrawals
- **Subscription Plans:** Create/edit plans (name, price, duration, booking limit)
- **Subscription History:** Track all plan purchases

#### Zone Management
- Create service zones with polygon coordinates on map
- Activate/deactivate zones
- Zone-specific settings

#### Content Management
- **Banners:** Create/edit promotional banners (image upload)
- **Coupons:** Create/edit (code, discount, type, min order, max discount, expiry, public/private)
- **Onboarding:** Manage first-time user guidance screens
- **Email Templates:** HTML-based transactional email templates
- **Documents:** Define required driver documents (title, two-sided, enable/disable)

#### Notifications
- Send push notifications to customers/drivers
- Topic-based (all customers, all drivers) or individual
- Notification history

#### Support Management
- View all support tickets (pending, active, complete)
- Reply to tickets
- Manage support reasons/categories
- Help chat monitoring

#### SOS Alert Monitoring
- View all emergency alerts
- Location on map
- Contact information
- Alert history

#### Settings
- **General:** App name, color, country code, distance type
- **Map:** Google Maps API key
- **Deposit/Withdrawal:** Minimum amounts
- **SOS:** Emergency number
- **Ride Cancellation:** Charge amount, fixed/percentage
- **Night Charges:** Start/end time, charge amount
- **Feature Flags:** OTP, subscription, document verification, auto-approval
- **Legal:** Terms, privacy policy, about (HTML editors)
- **Contact:** Support email and phone
- **SMTP:** Email server configuration
- **Demo Mode:** Toggle for data masking

#### Role-Based Access Control
- Create custom roles with granular permissions
- Per-module permissions: View, Create, Update, Delete
- Default roles: Admin (full access), Support (limited)
- Assign roles to employees
- Employee management (create, edit, deactivate)

---

## 4. Data Models Summary

### Core Models (shared across apps)

| Model | Purpose | Key Fields |
|-------|---------|------------|
| UserModel | Customer profile | fullName, email, phone, wallet, loyalty, referralCode |
| DriverUserModel | Driver profile | fullName, vehicle, documents, wallet, earnings, zones, subscription |
| BookingModel | Cab ride | customer, driver, status, locations, payment, timestamps |
| IntercityModel | Long-distance ride | source, destination, rideType, sharingPersons |
| ParcelModel | Delivery | pickup, drop, parcelImage, weight, dimensions |
| RentalBookingModel | Rental | pickup, package, currentKM, extraCharges |
| VehicleTypeModel | Vehicle category | name, image, baseFare, perKmRate, perMinuteRate |
| VehicleBrandModel | Vehicle make | brandName, image |
| VehicleModelModel | Vehicle model | modelName, brandId |
| ZoneModel | Service area | name, coordinates (polygon), isActive |
| PaymentModel | Payment config | strip (keys), wallet, cash |
| CouponModel | Discount code | code, discount, isPercentage, minOrder, expiry |
| TaxModel | Tax rate | country, taxPercentage |
| CurrencyModel | Currency config | code, symbol, decimalDigits, symbolAtRight |
| WalletTransactionModel | Wallet log | userId, amount, type, note, transactionId |
| BankDetailsModel | Driver bank | holderName, accountNumber, swift, ifsc, bankName |
| WithdrawModel | Payout request | driverId, amount, status, bankDetails |
| SubscriptionModel | Plan definition | name, price, expiryDays, totalBookings |
| ReferralModel | Referral record | userId, referralCode, referralBy |
| LoyaltyPointTransactionModel | Points log | userId, points, action, bookingId |
| ReviewModel | Ride review | rating, comment, reviewerId, bookingId |
| ChatModel | Chat message | senderId, message, timestamp, type |
| InboxModel | Chat thread | lastMessage, timestamp, senderId |
| NotificationModel | Push notification | title, body, type, userId, bookingId |
| SupportTicketModel | Support request | userId, subject, description, status |
| HelpSupportModel | Help chat | userId, bookingId, type, messages |
| SOSAlertsModel | Emergency alert | userId, bookingId, location, contactNumber |
| BannerModel | Promo banner | image, isActive |
| DocumentsModel | Driver doc type | title, isTwoSide, isEnable |
| VerifyDocument | Uploaded doc | documentId, frontImage, backImage, isVerify |
| RolePermissionModel | Admin role | roleTitle, permissions[] |
| EmployeeModel | Admin staff | fullName, email, role, fcmToken |
| OnboardingModel | Onboarding screen | title, description, image, order |
| EmailTemplateModel | Email template | name, subject, body (HTML) |
| LanguageModel | Translation set | code, name, translations |
| LocationLatLng | GPS coordinate | latitude, longitude, address |
| DistanceModel | Distance calc | distanceInMeters, distanceInKM, durationInMinutes |
| AdminCommission | Commission config | amount, isFixed, isEnabled |
| NightTimingModel | Night charge config | startTime, endTime, charge |
| CancellationChargeModel | Cancel fee | isCancellationChargeApply, amount, isFixed |
| RentalPackageModel | Rental option | name, hours, km, price |
| SubscriptionHistoryModel | Purchase log | driverId, planId, purchaseDate, expiryDate, amount |

---

## 5. User Journey Maps

### 5.1 Customer - First Time
```
Install App → Splash → Onboarding Slides → Login (Phone/Google/Apple)
→ OTP Verify → Signup (name, email, gender, referral code)
→ Home Screen → Browse Services → Book First Ride
```

### 5.2 Customer - Book a Cab Ride
```
Home → Tap "Daily Ride" → Select Pickup (map) → Select Drop → Add Stops?
→ Choose Vehicle Type → View Fare → Apply Coupon? → Select Payment
→ Confirm → Waiting (booking_placed) → Driver Assigned → Driver Arrives
→ Share OTP → Ride Starts (ongoing) → Track on Map → Drop Off
→ Payment Processed → Rate Driver → Done
```

### 5.3 Driver - Onboarding
```
Install App → Splash → Onboarding → Login → Signup
→ Upload Documents (license, ID, etc.) → Select Vehicle (type/brand/model)
→ Enter Registration # → Select Zones → Submit for Verification
→ Wait for Admin Approval → Approved → Home Screen → Go Online
```

### 5.4 Driver - Complete a Ride
```
Go Online → Receive Booking Notification → View Details → Accept/Reject
→ Navigate to Pickup → Request Customer OTP → Verify OTP → Start Ride
→ Navigate to Destination (real-time tracking) → Arrive → Complete Ride
→ Payment Received → View Earnings → Rate Customer
```

### 5.5 Admin - Verify a Driver
```
Dashboard → Drivers → Unverified Tab → Select Driver
→ Review Documents (front/back images) → Approve/Reject Each Document
→ All Approved → Driver Status: Verified → Driver Notified
```

### 5.6 Admin - Handle Payout
```
Dashboard → Payout Requests → View Pending Requests
→ Select Request → View Amount, Bank Details → Approve/Reject
→ Driver Wallet Updated → Driver Notified
```

---

## 6. Notification Matrix

| Event | Customer | Driver | Admin |
|-------|----------|--------|-------|
| Booking placed | - | Push | Dashboard |
| Driver assigned | Push | - | - |
| Booking accepted | Push | - | - |
| Ride started | Push | - | - |
| Ride completed | Push | Push | - |
| Booking cancelled | Push | Push | - |
| New chat message | Push | Push | - |
| Support ticket update | Push | Push | - |
| Document verified | - | Push | - |
| Payout approved | - | Push | - |
| SOS alert | - | - | Push + Dashboard |
| Admin broadcast | Push (topic) | Push (topic) | - |
| Wallet credit | Push | Push | - |
| Subscription expiry | - | Push | - |

---

## 7. Commission & Pricing Model

```
Ride Total = Base Fare + (Distance * PerKmRate) + (Duration * PerMinuteRate)
           + Night Charge (if applicable)
           + Hold Charges (if applicable)
           - Coupon Discount
           + Tax

Admin Commission = Ride Total * Commission% (or fixed amount)
Driver Earning = Ride Total - Admin Commission
```

**Configurable Parameters (Admin Panel):**
- Base fare per vehicle type
- Per-km rate per vehicle type
- Per-minute rate per vehicle type
- Minimum fare per vehicle type
- Night charge (time window + surcharge)
- Hold/waiting charge per minute
- Admin commission (fixed or %)
- Tax percentage per country
- Cancellation charge (fixed or %)

---

## 8. Feature Flags (Admin-Configurable)

| Flag | Description | Default |
|------|-------------|---------|
| isOtpFeatureEnable | Require OTP before ride start | true |
| isSubscriptionEnable | Driver subscription plans active | true |
| isDocumentVerificationEnable | Require document upload | true |
| isDriverAutoApproved | Skip admin approval for drivers | false |
| isInterCityBid | Enable bidding on intercity rides | false |
| isParcelBid | Enable bidding on parcel deliveries | false |
| isCancellationChargeApply | Charge for cancellations | true |
| demoMode | Mask sensitive data in admin | false |

---

## 9. New Collections (Added)

| Collection | Purpose |
|------------|---------|
| `app_version/{platform}` | Force update: minVersion, latestVersion, forceUpdate flag |
| `audit_log` | Immutable log of all admin/payment/booking actions |

## 10. Rate Limits

| Action | Limit |
|--------|-------|
| Active bookings per user | Max 3 |
| Cancellations per day | Max 5 (then charge increases 50%) |
| Failed payments per booking | Max 3 |
| OTP requests per 10 min | Max 3 |
| Driver rejections per hour | Max 5 (then forced offline 30 min) |
| Support tickets (open) | Max 5 |
| Wallet topups per day | Max 10 |
| Withdrawals per day | Max 1 |

---

## 9. BLoC Event & State Mapping Per Feature

### 9.1 Auth BLoC

| Event | State | Description |
|-------|-------|-------------|
| `CheckAuthStatus` | `Authenticated` / `Unauthenticated` | App launch auth check |
| `EmailLoginRequested(email, password)` | `AuthSuccess(user)` / `AuthError` | Email + password sign in |
| `EmailSignupRequested(email, password, profile)` | `AuthSuccess(user)` / `AuthError` | Register with email |
| `PasswordResetRequested(email)` | `PasswordResetSent` / `AuthError` | Forgot password flow |
| `PhoneLoginRequested(phone)` | `OtpSent(verificationId)` | Firebase sends OTP |
| `OtpVerified(otp, verificationId)` | `AuthSuccess(user)` / `AuthError` | Verify OTP code |
| `GoogleLoginRequested` | `AuthSuccess(user)` / `AuthError` | Google OAuth |
| `AppleLoginRequested` | `AuthSuccess(user)` / `AuthError` | Apple OAuth |
| `SignupSubmitted(profile)` | `SignupSuccess` / `SignupError` | Create profile |
| `LogoutRequested` | `Unauthenticated` | Sign out |

### 9.2 Booking BLoC (Customer)

| Event | State | Description |
|-------|-------|-------------|
| `BookingCreated(params)` | `BookingPlacedState(booking)` | New booking submitted |
| `BookingStreamStarted(bookingId)` | `BookingUpdated(booking)` | Real-time booking listener |
| `BookingCancelRequested(id, reason)` | `BookingCancelledState` | Customer cancels |
| `PaymentCompleted(bookingId, txn)` | `BookingPaymentDone` | Payment confirmed |

### 9.3 Booking BLoC (Driver)

| Event | State | Description |
|-------|-------|-------------|
| `IncomingBookingsRequested` | `BookingsLoaded(list)` | Fetch available bookings |
| `BookingAccepted(bookingId)` | `BookingAcceptedState` | Driver accepts ride |
| `BookingRejected(bookingId)` | `BookingRejectedState` | Driver rejects ride |
| `OtpVerified(bookingId, otp)` | `RideReadyToStart` | Customer OTP verified |
| `RideStarted(bookingId)` | `RideOngoingState` | Ride begins |
| `RidePaused(bookingId)` | `RideOnHoldState` | Ride on hold |
| `RideResumed(bookingId)` | `RideOngoingState` | Ride resumed |
| `RideCompleted(bookingId)` | `RideCompletedState(fare)` | Ride finished |
| `BookingCancelRequested(id, reason)` | `BookingCancelledState` | Driver cancels |

### 9.4 Tracking BLoC

| Event | State | Description |
|-------|-------|-------------|
| `TrackingStarted(bookingId)` | `TrackingActive(location, route)` | Start tracking |
| `DriverLocationUpdated(latLng)` | `TrackingUpdated(location, eta)` | Driver moved |
| `RouteDeviated` | `TrackingRerouting` | Driver off-route |
| `RouteRecalculated(newRoute)` | `TrackingActive(location, newRoute)` | New route calculated |
| `TrackingStopped` | `TrackingInactive` | Ride ended |

### 9.5 Payment BLoC

| Event | State | Description |
|-------|-------|-------------|
| `PaymentMethodSelected(method)` | `PaymentMethodReady(method)` | User chose method |
| `PaymentRequested(amount, method)` | `PaymentProcessing` | Payment initiated |
| `StripePaymentCompleted(intentId)` | `PaymentSuccess(txnId)` | Stripe confirmed |
| `WalletPaymentRequested(amount)` | `PaymentSuccess` / `PaymentFailed` | Wallet deduction |
| `CashPaymentMarked` | `PaymentDeferred` | Cash on delivery |

### 9.6 Wallet BLoC

| Event | State | Description |
|-------|-------|-------------|
| `WalletLoaded` | `WalletReady(balance, transactions)` | Initial load |
| `AddMoneyRequested(amount, method)` | `WalletTopUpProcessing` → `WalletUpdated` | Top up wallet |
| `WithdrawalRequested(amount, bankId)` | `WithdrawalSubmitted` | Driver requests payout |
| `TransactionHistoryRequested` | `TransactionsLoaded(list)` | View history |

### 9.7 Chat BLoC

| Event | State | Description |
|-------|-------|-------------|
| `ChatStreamStarted(otherUserId)` | `ChatLoaded(messages)` | Open chat |
| `MessageSent(text)` | `MessageDelivered` | Send message |
| `NewMessageReceived(message)` | `ChatUpdated(messages)` | Real-time message |
| `InboxRequested` | `InboxLoaded(conversations)` | View inbox |

### 9.8 Profile BLoC

| Event | State | Description |
|-------|-------|-------------|
| `ProfileLoaded` | `ProfileReady(user)` | Fetch profile |
| `ProfileUpdated(fields)` | `ProfileSaved` / `ProfileError` | Save changes |
| `ProfilePicChanged(image)` | `ProfilePicUploading` → `ProfilePicUpdated` | Upload avatar |
| `DeleteAccountRequested` | `DeleteAccountConfirming` | Show confirmation |
| `DeleteAccountConfirmed(password)` | `AccountDeleting` → `AccountDeleted` | Delete all data |

### 9.9 Location BLoC

| Event | State | Description |
|-------|-------|-------------|
| `CurrentLocationRequested` | `LocationObtained(latLng, address)` | Get GPS position |
| `PickupLocationSet(latLng)` | `PickupReady(location)` | User picks source |
| `DropLocationSet(latLng)` | `DropReady(location)` | User picks destination |
| `StopAdded(latLng)` | `StopsUpdated(stops)` | Intermediate stop |
| `RouteCalculated` | `RouteReady(distance, eta, polyline)` | Get directions |
| `FareEstimated(vehicleType)` | `FareReady(amount)` | Calculate fare |

### 9.10 Driver Home BLoC

| Event | State | Description |
|-------|-------|-------------|
| `DriverStatusToggled(online)` | `DriverOnline` / `DriverOffline` | Go online/offline |
| `DashboardLoaded` | `DashboardReady(stats)` | Fetch stats |
| `LocationUpdateStarted` | `LocationUpdating` | Periodic GPS updates |

### 9.11 Document BLoC (Driver)

| Event | State | Description |
|-------|-------|-------------|
| `DocumentsLoaded` | `DocumentsReady(required, uploaded)` | Fetch requirements |
| `DocumentUploaded(docId, front, back)` | `DocumentSubmitted` | Upload images |
| `VerificationStatusChecked` | `VerificationPending` / `Verified` / `Rejected` | Check status |

### 9.12 Admin Dashboard BLoC

| Event | State | Description |
|-------|-------|-------------|
| `DashboardLoaded` | `DashboardReady(stats)` | All stats |
| `StatsStreamStarted` | `DashboardUpdated(stats)` | Real-time updates |
| `DateRangeChanged(from, to)` | `DashboardFiltered(stats)` | Filter by dates |

### 9.13 Admin Driver Verification BLoC

| Event | State | Description |
|-------|-------|-------------|
| `UnverifiedDriversLoaded` | `DriversReady(list)` | Fetch unverified |
| `DocumentApproved(driverId, docId)` | `DocumentStatusUpdated` | Approve document |
| `DocumentRejected(driverId, docId)` | `DocumentStatusUpdated` | Reject document |
| `DriverApproved(driverId)` | `DriverVerified` | Fully approve driver |

### 9.14 Support BLoC

| Event | State | Description |
|-------|-------|-------------|
| `TicketsLoaded` | `TicketsReady(list)` | Fetch tickets |
| `TicketCreated(subject, desc)` | `TicketSubmitted` | New ticket |
| `TicketReplyAdded(ticketId, msg)` | `TicketUpdated` | Add reply |
| `TicketStatusChanged(id, status)` | `TicketUpdated` | Admin changes status |

### 9.15 SOS BLoC

| Event | State | Description |
|-------|-------|-------------|
| `SosTriggered(bookingId, location)` | `SosAlertSent` | Emergency triggered |
| `SosHistoryLoaded` | `SosHistoryReady(list)` | View alerts |

### 9.16 Notification BLoC

| Event | State | Description |
|-------|-------|-------------|
| `NotificationsLoaded` | `NotificationsReady(list)` | Fetch all |
| `NotificationReceived(payload)` | `NewNotification(data)` | FCM received |
| `NotificationDeleted(id)` | `NotificationRemoved` | Delete |
| `BroadcastSent(title, body, target)` | `BroadcastDelivered` | Admin sends |

### 9.17 Settings BLoC (Admin)

| Event | State | Description |
|-------|-------|-------------|
| `SettingsLoaded` | `SettingsReady(config)` | Fetch all settings |
| `SettingsUpdated(key, value)` | `SettingsSaved` | Update a setting |
| `PaymentConfigUpdated(config)` | `PaymentConfigSaved` | Update payment keys |
