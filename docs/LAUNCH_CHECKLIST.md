# LAUNCH_CHECKLIST.md - Complete Pre-Launch Checklist

## Phase 1: Accounts & Services Setup

### Accounts
- [ ] Google Play Developer account ($25) — play.google.com/console
- [ ] Apple Developer Program ($99/year) — developer.apple.com
- [ ] Firebase project created (Blaze plan for Cloud Functions)
- [ ] Stripe account created and business verified
- [ ] Domain registered (e.g., rwp3app.com)
- [ ] Email set up (support@rwp3app.com)

### Firebase Configuration
- [ ] Authentication providers enabled (Email, Phone, Google, Apple)
- [ ] Cloud Firestore created with security rules deployed
- [ ] Firebase Storage created with security rules deployed
- [ ] Cloud Functions deployed
- [ ] Firestore composite indexes deployed
- [ ] Firebase Hosting configured (admin panel + legal pages)

### Google Cloud
- [ ] Google Maps APIs enabled (Maps, Directions, Geocoding, Places, Distance Matrix)
- [ ] API key created with app restrictions
- [ ] Billing account linked (for Maps — $200 free credit)
- [ ] Budget alerts set ($50, $100)

### Platform Config
- [ ] Android SHA-1/SHA-256 registered in Firebase (debug + release)
- [ ] Google OAuth consent screen configured and published
- [ ] Google Sign-In OAuth client IDs created (Android, iOS, Web)
- [ ] Apple Sign-In: App ID capability enabled
- [ ] Apple Sign-In: Services ID created and configured in Firebase
- [ ] Apple Sign-In: Key (.p8) created and uploaded to Firebase
- [ ] APNs Key (.p8) created and uploaded to Firebase for push notifications
- [ ] Stripe publishable key in Firestore, secret key in Cloud Functions config
- [ ] Apple Merchant ID created (for Apple Pay via Stripe)
- [ ] Universal links file hosted (.well-known/apple-app-site-association)
- [ ] App links file hosted (.well-known/assetlinks.json)

---

## Phase 2: Development Complete

### Core Features
- [ ] Email/Password login, signup, forgot password
- [ ] Phone OTP login
- [ ] Google Sign-In
- [ ] Apple Sign-In
- [ ] User profile CRUD (create, read, update, delete account)
- [ ] Driver onboarding (documents, vehicle, zone selection)

### Booking (All 4 Types)
- [ ] Cab ride: full flow (book → assign → track → complete → pay → review)
- [ ] Intercity ride: full flow
- [ ] Parcel delivery: full flow
- [ ] Rental: full flow
- [ ] Booking cancellation with charges
- [ ] OTP verification before ride start

### Payment
- [ ] Cash payment flow
- [ ] Wallet payment flow (deduction + transaction log)
- [ ] Stripe payment (via Cloud Functions — server-side intent creation)
- [ ] Wallet top-up via Stripe
- [ ] Fare calculation (server-side via Cloud Functions)

### Real-Time
- [ ] Live driver tracking on map
- [ ] Booking status real-time updates
- [ ] Chat messaging (rider ↔ driver)
- [ ] Push notifications (booking updates, chat, SOS)

### Driver Features
- [ ] Online/offline toggle
- [ ] Ride acceptance/rejection
- [ ] Navigation with polyline routing
- [ ] Earnings dashboard
- [ ] Bank details management
- [ ] Withdrawal requests
- [ ] Subscription plan purchase
- [ ] Financial statement export (Excel)

### Admin Panel
- [ ] Dashboard with live stats
- [ ] Customer management (list, search, detail)
- [ ] Driver management (list, verify documents, approve/reject)
- [ ] Booking management (all 4 types, status filters)
- [ ] Payment gateway configuration
- [ ] Vehicle types/brands/models management
- [ ] Zone management
- [ ] Coupon management
- [ ] Tax and currency configuration
- [ ] Commission settings
- [ ] Subscription plans
- [ ] Payout request approval
- [ ] Push notification broadcasting
- [ ] Support ticket management
- [ ] SOS alert monitoring
- [ ] Role-based access control
- [ ] Employee management
- [ ] Banner management
- [ ] Email template management
- [ ] Settings (general, map, legal pages)

### Engagement
- [ ] Coupon system
- [ ] Loyalty points
- [ ] Referral program
- [ ] Reviews and ratings
- [ ] Notification center

### Safety
- [ ] Emergency contacts
- [ ] SOS alerts (alerts contacts, not auto-dial 911)
- [ ] Support ticket system
- [ ] Help chat by ride type

---

## Phase 3: Quality & Compliance

### Testing
- [ ] Unit tests for all BLoCs (event → state transitions)
- [ ] Unit tests for all UseCases
- [ ] Model serialization tests (toJson/fromJson roundtrip)
- [ ] Full booking flow tested end-to-end (all 4 ride types)
- [ ] Payment tested with Stripe test cards
- [ ] Tested on physical Android device
- [ ] Tested on physical iOS device
- [ ] Tested offline behavior (cached data, blocked payments)
- [ ] Tested force update flow
- [ ] Tested account deletion
- [ ] Tested with TalkBack (Android accessibility)
- [ ] Tested with VoiceOver (iOS accessibility)

### Permissions
- [ ] Pre-permission screens implemented for: Location, Camera, Contacts, Notifications
- [ ] Customer app: "When In Use" location only
- [ ] Driver app: background location with justification
- [ ] All features work if permissions denied (graceful degradation)
- [ ] Push notifications requested after first booking (not on launch)
- [ ] App Tracking Transparency dialog shown before analytics (iOS)

### Security
- [ ] Stripe secret key only in Cloud Functions (not client)
- [ ] firebase_options.dart in .gitignore
- [ ] No hardcoded API keys in source code
- [ ] Firestore security rules tested (try unauthorized access)
- [ ] Storage security rules tested
- [ ] Custom Claims set for admin users (for Storage rules)

### Store Compliance
- [ ] Account deletion works (in-app)
- [ ] Web account deletion page live (Google requirement)
- [ ] Apple Sign-In same size/prominence as Google Sign-In
- [ ] "Hide My Email" handled correctly
- [ ] SOS disclaimer: "For immediate danger, call local emergency number"
- [ ] No empty/placeholder screens
- [ ] No "Coming Soon" sections
- [ ] Demo mode works (simulated driver for reviewers)

---

## Phase 4: Design Assets

### App Icons
- [ ] Customer app icon (1024x1024, no transparency)
- [ ] Driver app icon (1024x1024, no transparency)
- [ ] Admin panel favicon
- [ ] Icons generated for all Android/iOS sizes (flutter_launcher_icons)

### Splash Screen
- [ ] Splash screen configured (flutter_native_splash)
- [ ] Android 12+ splash screen configured

### In-App Assets
- [ ] All SVG icons created (20+ icons)
- [ ] All SVG illustrations created (10+ empty states)
- [ ] Map markers (PNG, driver/pickup/drop/stop)
- [ ] Lottie animations (loading, searching, success)
- [ ] Onboarding illustration screens (3 screens)

### Store Listings
- [ ] Customer app screenshots (6 screens, all required sizes)
- [ ] Driver app screenshots (5 screens, all required sizes)
- [ ] Google Play feature graphic (1024x500)
- [ ] App descriptions written (short + full)
- [ ] App category selected: Travel & Transportation
- [ ] Keywords/tags researched

---

## Phase 5: Legal & Content

### Legal Pages (Hosted on Domain)
- [ ] Privacy Policy live at rwp3app.com/privacy
- [ ] Terms of Service live at rwp3app.com/terms
- [ ] Account deletion page live at rwp3app.com/delete-account
- [ ] Support page live at rwp3app.com/support
- [ ] Reviewed by lawyer (recommended)

### Firebase Seed Data
- [ ] Default admin account created
- [ ] Vehicle types seeded (sedan, SUV, hatchback, premium, etc.)
- [ ] Vehicle brands seeded (Toyota, Honda, etc.)
- [ ] At least one zone created
- [ ] Payment settings configured (Stripe keys)
- [ ] App settings configured (app name, color, radius, etc.)
- [ ] At least one subscription plan created
- [ ] Onboarding screens configured
- [ ] Default support reasons created
- [ ] Default driver document requirements created
- [ ] Default currency configured
- [ ] Default tax rate configured
- [ ] Commission settings configured

---

## Phase 6: Store Submission

### Google Play Store
- [ ] AAB built: `flutter build appbundle --release`
- [ ] AAB signed with upload key
- [ ] Play Console: App created
- [ ] Play Console: Store listing completed (description, screenshots, icon, feature graphic)
- [ ] Play Console: Content rating (IARC) completed
- [ ] Play Console: Pricing: Free
- [ ] Play Console: Target audience: 18+
- [ ] Play Console: Data Safety section filled accurately
- [ ] Play Console: Privacy Policy URL added
- [ ] Play Console: Background Location Declaration Form completed (driver app)
- [ ] Play Console: Background Location video uploaded (driver app)
- [ ] Review notes added with test credentials
- [ ] App submitted → Internal Testing → Closed Testing → Production

### Apple App Store
- [ ] IPA built: `flutter build ios --release`
- [ ] Archive created in Xcode → Uploaded to App Store Connect
- [ ] App Store Connect: App created (customer + driver)
- [ ] App Store Connect: App Information (category, age rating, pricing)
- [ ] App Store Connect: Privacy Nutrition Labels filled
- [ ] App Store Connect: App Privacy section completed
- [ ] App Store Connect: Screenshots uploaded (all required sizes)
- [ ] App Store Connect: App description, keywords, support URL
- [ ] App Store Connect: Privacy Policy URL
- [ ] App Store Connect: Review notes with test credentials + payment explanation
- [ ] App submitted for review

### Post-Submission
- [ ] Monitor review status daily
- [ ] Be ready to respond to rejection notes within 24 hours
- [ ] Have demo account credentials ready to share if requested
- [ ] Have additional screenshots ready if requested

---

## Phase 7: Post-Launch

### Monitoring
- [ ] Firebase Crashlytics: monitoring for crashes
- [ ] Firebase Analytics: tracking key events
- [ ] Firebase Performance: monitoring API latency
- [ ] Firestore Usage: monitoring reads/writes/cost
- [ ] Cloud Functions logs: monitoring errors
- [ ] Stripe Dashboard: monitoring payments
- [ ] Set up email alerts for: crashes > 1%, payment failures > 5%

### Operations
- [ ] Customer support email monitored daily
- [ ] Support tickets reviewed daily
- [ ] SOS alerts reviewed immediately
- [ ] Payout requests processed within 3 business days
- [ ] Driver verifications processed within 24 hours

### Iteration
- [ ] Collect user feedback (in-app, store reviews)
- [ ] Plan version 1.1 based on feedback
- [ ] A/B test new features via feature flags
- [ ] Monitor app store ratings → respond to reviews
