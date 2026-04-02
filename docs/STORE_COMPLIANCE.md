# STORE_COMPLIANCE.md - Apple App Store & Google Play Store Compliance

## Overview

This document covers everything needed to pass **Apple App Store Review** and **Google Play Store Review** on the first submission attempt. Both stores have strict guidelines — ride-sharing apps get extra scrutiny due to location, payment, and safety features.

---

# PART 1: APPLE APP STORE

## 1.1 Account Deletion (Guideline 5.1.1(v)) — MANDATORY

**Requirement:** Users must be able to delete their account and all associated data from within the app.

### Implementation

**Customer & Driver apps must have:**
- "Delete Account" button in Settings/Profile page
- Confirmation dialog: "This will permanently delete your account and all data. This cannot be undone."
- Second confirmation: Re-enter password or re-authenticate

**DeleteAccountBloc Events/States:**
```
DeleteAccountRequested → DeleteAccountConfirming (show dialog)
DeleteAccountConfirmed(password) → DeleteAccountProcessing → AccountDeleted
```

**What must be deleted:**
- Firebase Auth account
- User/Driver Firestore document
- All wallet transactions (anonymize, don't delete — financial records)
- Chat messages (remove user's messages or anonymize)
- Profile picture from Storage
- Driver documents from Storage
- FCM token
- Referral records (anonymize referrer)
- Support tickets (keep for legal, anonymize user info)

**What must be retained (legal/financial):**
- Completed booking records (anonymize user fields: "Deleted User")
- Financial transaction logs (anonymize, retain amounts)
- Audit log entries (anonymize actor)

**Cloud Function: `deleteUserAccount`**
```
1. Re-authenticate user (verify password/token)
2. Anonymize all linked records (bookings, transactions)
3. Delete personal data (profile, documents, chat)
4. Delete Firebase Storage files
5. Delete Firebase Auth account
6. Send confirmation email (if email exists)
7. Log to audit_log
```

**Timeline:** Must complete within 14 days (Apple requirement). Recommend immediate deletion with background cleanup.

---

## 1.2 Permission Request Flow (Guidelines 5.1.1, 5.1.2)

**Rule:** NEVER request permissions on first launch. Always explain WHY before the system dialog.

### Location Permission

**Customer App:**
```
Home Screen → User taps "Book a Ride"
  → Pre-permission screen:
    Icon: Map pin
    Title: "Enable Location"
    Body: "We need your location to find nearby drivers
           and show your pickup point on the map."
    Button: "Allow Location Access"
  → System dialog: "Allow while using the app" (When In Use ONLY)
  → Never request "Always" for customer
```

**Driver App:**
```
Home Screen → Driver taps "Go Online"
  → Pre-permission screen:
    Icon: Navigation
    Title: "Location Access Required"
    Body: "To receive ride requests and share your location
           with passengers, we need location access even
           when the app is in the background."
    Button: "Enable Location"
  → System dialog: "Allow While Using" first
  → Later prompt for "Always Allow" with explanation:
    "For accurate tracking during rides, please select
     'Always' in Settings > Location"
```

**Background Location Justification (Info.plist):**
```
NSLocationAlwaysAndWhenInUseUsageDescription:
"RWP3 uses your location in the background to share real-time
position with passengers during active rides and to receive
nearby ride requests while you're online."

NSLocationWhenInUseUsageDescription:
"RWP3 uses your location to find nearby drivers, calculate
routes, and show your position on the map."
```

### Camera Permission
```
Trigger: Only when user taps "Upload Document" or "Change Profile Photo"
Pre-permission: "We need camera access to take photos of your documents"
System dialog appears
```

### Contacts Permission
```
Trigger: Only when user taps "Add Emergency Contact" → "Import from Contacts"
Pre-permission: "We'll access your contacts to quickly add emergency numbers"
System dialog appears
```

### Push Notification Permission
```
Trigger: AFTER first successful booking (not on app launch)
Pre-permission screen:
  Icon: Bell
  Title: "Stay Updated"
  Body: "Get notified when your driver arrives,
         ride status changes, and important updates."
  Button: "Enable Notifications"
  Skip: "Not Now" (allow skip!)
System dialog appears
```

---

## 1.3 App Tracking Transparency (Guideline 5.1.2)

**Required if:** Using Firebase Analytics with IDFA collection.

### Implementation
```dart
// Add to pubspec.yaml
app_tracking_transparency: latest

// Show ATT dialog BEFORE Firebase Analytics init
final status = await AppTrackingTransparency.requestTrackingAuthorization();
if (status == TrackingStatus.authorized) {
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
} else {
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);
}
```

**Info.plist:**
```
NSUserTrackingUsageDescription:
"We use analytics to improve ride matching, reduce wait times,
and enhance your experience. Your data is never sold."
```

**Rules:**
- Must show ATT dialog BEFORE any tracking
- App must work fully if user declines
- Don't repeatedly ask — one chance only

---

## 1.4 Apple Sign-In Requirements (Guideline 4.8)

**Rules:**
- Apple Sign-In button must be **same size and prominence** as Google Sign-In
- Must support "Hide My Email" — don't require real email for core functionality
- Must handle Apple's relay email: `user@privaterelay.appleid.com`
- If user hides email, use their Apple User ID as unique identifier
- Must work with "Anonymous" Apple accounts (no name shared)

**UI Layout (Login Page):**
```
[Email field                    ]
[Password field                 ]
[        Sign In (FilledButton) ]
[   Forgot Password? (TextButton)]

──────────── OR ────────────────

[🍎 Sign in with Apple  ] ← Black, full width, same height
[G  Sign in with Google ] ← Same height, same width
[📱 Sign in with Phone  ] ← Same height, same width
```

---

## 1.5 In-App Purchase Compliance (Guideline 3.1)

### What's Allowed via Stripe (No Apple Cut):
- **Ride fares** — physical service, 100% allowed
- **Parcel delivery fees** — physical service, allowed
- **Cancellation charges** — tied to physical service, allowed
- **Driver payouts** — not a purchase, allowed

### Grey Areas (May Require IAP):
- **Wallet top-up** — Apple may consider this a "digital currency"
  - **Mitigation:** Frame wallet as "prepaid ride credit" tied to physical services
  - Include in App Review notes: "Wallet balance is used exclusively for purchasing physical transportation services"
- **Driver subscriptions** — could be flagged as digital subscription
  - **Mitigation:** Frame as "service fee" not "subscription to digital content"
  - Include in App Review notes: "Driver plans are business operating licenses for physical transportation services, not digital content subscriptions"

### App Review Notes (Submit with Review):
```
"RWP3 is a ride-sharing platform connecting passengers with drivers
for physical transportation services. All payments processed through
Stripe are for physical services (rides, deliveries) as permitted
under App Store Review Guideline 3.1.3(e). The wallet feature stores
prepaid credit exclusively for purchasing physical transportation.
Driver subscription plans are operating fees for providing physical
transportation services, not digital content subscriptions."
```

---

## 1.6 Demo/Test Account for Apple Review (Guideline 2.1)

**CRITICAL:** Apple reviewers will try to use the app. If they can't complete a flow, it's rejected.

### Provide in App Store Connect:
```
Demo Account:
  Email: review@rwp3app.com
  Password: AppleReview2026!

Demo Instructions:
  1. Sign in with the credentials above
  2. The account has $50 wallet balance for testing
  3. A test driver is always "online" in San Francisco area
  4. To test a ride: Tap "Book a Ride" → Select any pickup/drop
     → Choose any vehicle → Pay with Wallet → A driver will be
     auto-assigned within 10 seconds
  5. The ride will auto-complete after 30 seconds for review purposes
```

### Implementation:
- Create a `demo_mode` flag in Firestore settings
- When demo account is detected, auto-assign a simulated driver
- Simulated driver follows a predefined route
- Ride auto-completes after 30 seconds
- All payment succeeds with mock data

---

## 1.7 Background Modes (Guideline 2.5.4)

### Customer App — Info.plist UIBackgroundModes:
```
- remote-notification (push notifications)
```
**NO** background location for customer app.

### Driver App — Info.plist UIBackgroundModes:
```
- location (background GPS tracking during active rides)
- remote-notification (push notifications)
- fetch (periodic location updates when online)
```

**Apple will verify:**
- Background location is actually used (not just declared)
- Location indicator appears in status bar during active rides
- Battery usage is reasonable
- Location updates stop when driver goes offline

---

## 1.8 Privacy Nutrition Labels (App Store Connect)

### Data Collected — Customer App:

| Data Type | Collection Purpose | Linked to Identity |
|-----------|-------------------|-------------------|
| Name | App Functionality | Yes |
| Email | App Functionality, Account | Yes |
| Phone Number | App Functionality, Account | Yes |
| Precise Location | App Functionality | Yes |
| Payment Info | App Functionality | Yes (via Stripe) |
| Contacts | App Functionality (Emergency) | No |
| Photos | App Functionality (Profile) | Yes |
| Identifiers (User ID) | App Functionality | Yes |
| Crash Data | Analytics | No |
| Performance Data | Analytics | No |
| Usage Data | Analytics | No |

### Data Collected — Driver App:
Same as customer, plus:
| Data Type | Collection Purpose | Linked to Identity |
|-----------|-------------------|-------------------|
| Coarse Location | App Functionality | Yes |
| Financial Info (Bank) | App Functionality | Yes |
| Government ID (Documents) | App Functionality | Yes |

---

## 1.9 SOS Feature Compliance

**Rules:**
- SOS must NOT directly dial emergency services (911/112) without clear user action
- SOS should: Alert pre-configured emergency contacts via SMS/notification
- SOS should: Share live location with emergency contacts
- SOS should: Log alert for admin dashboard review
- Include disclaimer: "For immediate danger, call your local emergency number"
- Show emergency number prominently (configurable per country)

---

## 1.10 Additional Apple Requirements

| Requirement | Implementation |
|-------------|---------------|
| **IPv6 support** | Firebase SDK handles this — verify with Apple's test tool |
| **64-bit support** | Flutter default — no action needed |
| **Launch screen** | Use Flutter's default splash, no ads or heavy loading |
| **No private APIs** | Flutter SDK is compliant — verify with `flutter build ios` |
| **HTTPS only** | All Firebase/Stripe calls are HTTPS — verify no HTTP calls |
| **No web view login** | Apple Sign-In uses native SDK, Google uses SDK, Phone is native |
| **Minimum iOS version** | iOS 15.0+ (covers 95%+ of devices) |
| **App thinning** | Enable bitcode and app thinning in Xcode |
| **Screenshot sizes** | 6.7", 6.5", 5.5" (iPhone), 12.9" (iPad if supported) |

---

# PART 2: GOOGLE PLAY STORE

## 2.1 Target API Level (Policy)

**Requirement:** Must target Android API level 34+ (Android 14) as of 2025.

```groovy
// android/app/build.gradle
android {
    compileSdkVersion 34
    defaultConfig {
        targetSdkVersion 34
        minSdkVersion 23  // Android 6.0 (covers 95%+ devices)
    }
}
```

---

## 2.2 Permissions Declaration

### AndroidManifest.xml
```xml
<!-- Location -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<!-- Driver app ONLY: -->
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />

<!-- Camera (document upload, profile photo) -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- Storage (image picker fallback) -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

<!-- Notifications (Android 13+) -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />

<!-- Phone state (call interruption) -->
<uses-permission android:name="android.permission.READ_PHONE_STATE" />

<!-- Internet -->
<uses-permission android:name="android.permission.INTERNET" />

<!-- Foreground service for driver location -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
```

### Background Location — Google Play Extra Steps
- Must submit a **video demonstrating** why background location is needed
- Must fill out the **Location Permissions Declaration Form** in Play Console
- Explanation: "Background location is required for drivers to share real-time position with passengers during active rides, even when the app is minimized"

---

## 2.3 Data Safety Section (Play Console)

### Customer App:

| Data Type | Collected | Shared | Purpose |
|-----------|-----------|--------|---------|
| Name | Yes | No | Account |
| Email | Yes | No | Account |
| Phone | Yes | No | Account, Communication |
| Location (precise) | Yes | Yes (with driver) | App functionality |
| Payment info | Yes | Yes (Stripe) | Payments |
| Contacts | Yes | No | Emergency contacts |
| Photos | Yes | No | Profile, documents |
| App interactions | Yes | No | Analytics |
| Crash logs | Yes | No | Stability |
| Device identifiers | Yes | No | Analytics |

**Data Handling Declarations:**
- Data encrypted in transit: Yes (HTTPS/TLS)
- Data encrypted at rest: Yes (Firebase encryption)
- Users can request data deletion: Yes
- Data deletion mechanism: In-app "Delete Account" feature

### Driver App:
Same as customer, plus:
| Data Type | Collected | Shared | Purpose |
|-----------|-----------|--------|---------|
| Location (background) | Yes | Yes (with passengers) | Core functionality |
| Government ID | Yes | No | Identity verification |
| Bank details | Yes | No | Payouts |

---

## 2.4 Account Deletion (Google Play Policy — Effective 2024)

**Same requirement as Apple.** Must provide in-app account deletion.

Additional Google requirements:
- Must also provide a **web-based deletion option** (link in Play Store listing)
- Must clearly state data retention policies
- Must complete deletion within **reasonable timeframe** (recommend < 7 days)

### Web Deletion Page
Create a simple web page at `https://rwp3app.com/delete-account`:
- User enters email
- Receives confirmation email with deletion link
- Clicking link triggers Cloud Function to process deletion
- Include in Play Store listing under "Data safety" → "Deletion request URL"

---

## 2.5 Google Play Billing (Policy)

**Good news:** Google Play is clearer than Apple on this.

### What's Allowed via Stripe:
- **Ride fares** — physical service, allowed
- **Parcel delivery** — physical service, allowed
- **Wallet top-up** — allowed if used for physical services
- **Driver subscriptions** — allowed if for physical service access

Google explicitly allows third-party payment for "physical goods and services" — ride-sharing is clearly physical.

**No Google Play Billing required for any feature.**

---

## 2.6 Families Policy Compliance

**Requirement:** If your app is NOT for children, declare it.

```
Target audience: 18+ (ride-sharing requires payment and location)
Content rating: IARC questionnaire → likely "Everyone" or "Teen"
Not a "family" app — do not enroll in Designed for Families program
```

---

## 2.7 App Signing & Security

```bash
# Generate upload key
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA \
  -keysize 2048 -validity 10000 -alias upload

# Use Google Play App Signing (recommended)
# Upload key signs the upload, Google re-signs for distribution
```

**Store keystore securely:**
- Never commit to git
- Store in CI/CD secrets (GitHub Actions)
- Keep backup in secure location

---

## 2.8 Foreground Service (Android 14+)

**Driver app uses foreground service for location tracking.**

```xml
<!-- AndroidManifest.xml -->
<service
    android:name=".LocationTrackingService"
    android:foregroundServiceType="location"
    android:exported="false" />
```

**Requirements:**
- Must show persistent notification while tracking: "RWP3 is tracking your location for an active ride"
- Must stop service when driver goes offline or ride completes
- Must declare `foregroundServiceType="location"` (Android 14 requirement)

---

## 2.9 Google Play Review Notes

```
App Description for Review:
"RWP3 is a ride-sharing platform. To test:

Test Customer Account:
  Email: review@rwp3app.com
  Password: PlayReview2026!
  Wallet: Pre-loaded with $50

Test Driver Account:
  Email: driver-review@rwp3app.com
  Password: PlayReview2026!

A simulated driver is always available in the San Francisco area.
Book a ride from any location in SF to test the full flow.
Rides auto-complete after 30 seconds in review mode.

Background location (driver app) is required to share real-time
position with passengers during active rides."
```

---

## 2.10 Additional Google Play Requirements

| Requirement | Implementation |
|-------------|---------------|
| **64-bit APK** | Flutter default — build with `flutter build appbundle` |
| **App Bundle (AAB)** | Required for new apps — don't upload APK |
| **Deobfuscation mapping** | Upload ProGuard mapping with each release |
| **Content rating** | Complete IARC questionnaire in Play Console |
| **Store listing** | Screenshots: phone + 7" tablet + 10" tablet |
| **Privacy policy URL** | Required — link to hosted privacy policy |
| **Ads declaration** | No ads — declare "No" in Play Console |
| **COVID-19 contact tracing** | Not applicable — declare "No" |
| **News publisher** | Not applicable — declare "No" |
| **Government apps** | Not applicable — declare "No" |

---

# PART 3: SHARED COMPLIANCE CHECKLIST

## Pre-Submission Checklist

### Account & Data
- [ ] Account deletion works (in-app, both apps)
- [ ] Web-based deletion page (Google Play requirement)
- [ ] Privacy policy URL is live and accurate
- [ ] Terms of service URL is live
- [ ] Data is encrypted in transit (HTTPS only)
- [ ] No hardcoded API keys in source code

### Permissions
- [ ] Pre-permission screens for: Location, Camera, Contacts, Notifications
- [ ] Customer app: "When In Use" location only — never "Always"
- [ ] Driver app: Background location with clear justification
- [ ] All permissions work if denied (graceful degradation)
- [ ] Push notification requested AFTER first booking, not on launch

### Authentication
- [ ] Apple Sign-In button same size as Google Sign-In
- [ ] "Hide My Email" relay emails handled correctly
- [ ] Forgot password flow works
- [ ] Email verification sent on signup
- [ ] Login/signup errors are user-friendly (not Firebase error codes)

### Payment
- [ ] Stripe publishable key only on client
- [ ] Stripe secret key only on server (Cloud Functions)
- [ ] Wallet framed as "ride credit" in store descriptions
- [ ] App Review notes explain physical service payments

### Demo/Review Mode
- [ ] Test accounts created for Apple and Google reviewers
- [ ] Demo driver always online in test region
- [ ] Rides auto-complete in review mode
- [ ] Test wallet pre-loaded with credits
- [ ] Demo mode flag in Firestore (not hardcoded)

### Safety
- [ ] SOS alerts emergency contacts, does NOT auto-dial 911
- [ ] Emergency number displayed prominently
- [ ] SOS disclaimer: "For immediate danger, call local emergency number"

### UI & UX
- [ ] No empty/placeholder screens (remove unfinished features)
- [ ] No "Coming Soon" sections
- [ ] Loading states for all async operations
- [ ] Error states for all failure scenarios
- [ ] Works on smallest supported screen (320dp width)
- [ ] Works on largest screen (tablet if supported)
- [ ] Dark mode fully styled (no white-on-white or black-on-black)

### iOS Specific
- [ ] App Tracking Transparency dialog (before analytics)
- [ ] Info.plist permission descriptions (all human-readable, not generic)
- [ ] Privacy Nutrition Labels filled in App Store Connect
- [ ] Launch screen configured (no ads, no heavy loading)
- [ ] Minimum iOS 15.0
- [ ] Background modes justified in review notes

### Android Specific
- [ ] Target API 34+
- [ ] AAB format (not APK)
- [ ] Background Location video uploaded to Play Console
- [ ] Location Permission Declaration Form completed
- [ ] Data Safety section filled accurately
- [ ] Foreground service notification for driver tracking
- [ ] POST_NOTIFICATIONS permission requested at runtime (Android 13+)
- [ ] ProGuard mapping uploaded with release
- [ ] Content rating (IARC) completed

### Store Listings
- [ ] App name: short, descriptive (max 30 chars)
- [ ] Short description (80 chars)
- [ ] Full description (4000 chars, no keyword stuffing)
- [ ] Screenshots: all required sizes for both stores
- [ ] App icon: 1024x1024 (Apple), 512x512 (Google)
- [ ] Feature graphic: 1024x500 (Google Play)
- [ ] Category: Travel & Transportation
- [ ] Privacy policy URL in listing
- [ ] Support email in listing

---

## App Store Review Notes Template

### Apple:
```
Thank you for reviewing RWP3.

DEMO CREDENTIALS:
Email: review@rwp3app.com
Password: AppleReview2026!

TESTING INSTRUCTIONS:
1. Sign in with credentials above
2. Account has $50 wallet balance
3. A test driver is available in San Francisco
4. Book any ride type → driver auto-assigns in 10s → ride completes in 30s

PAYMENT CLARIFICATION:
All payments are for physical transportation services (rides, deliveries)
as permitted under Guideline 3.1.3(e). Wallet stores prepaid credit for
physical services only. Driver plans are operating fees for providing
physical transportation.

BACKGROUND LOCATION (Driver App):
Background location is used to share driver's real-time position with
passengers during active rides. Tracking stops when driver goes offline.

ACCOUNT DELETION:
Available in Profile > Settings > Delete Account. Processes immediately.
```

### Google:
```
DEMO CREDENTIALS:
Customer: review@rwp3app.com / PlayReview2026!
Driver: driver-review@rwp3app.com / PlayReview2026!

Test driver always available in San Francisco area.
Rides auto-complete after 30 seconds in review mode.

BACKGROUND LOCATION:
Required for drivers to share real-time position during active rides.
Foreground notification shown: "RWP3 is tracking your location."
```
