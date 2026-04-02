# PLATFORM_SETUP.md - Third-Party Service Configuration

## All Accounts & Services Required

| Service | Purpose | Cost | URL |
|---------|---------|------|-----|
| Google Play Developer | Publish Android apps | $25 one-time | play.google.com/console |
| Apple Developer Program | Publish iOS apps | $99/year | developer.apple.com |
| Firebase (Google Cloud) | Backend (Firestore, Auth, Functions, Storage, FCM) | Free tier → Blaze plan (pay-as-you-go) | firebase.google.com |
| Google Maps Platform | Maps SDK, Directions, Geocoding, Places | $200/month free credit | cloud.google.com/maps-platform |
| Stripe | Payment processing | 2.9% + 30¢ per transaction | stripe.com |
| Domain registrar | rwp3app.com (or similar) | ~$12/year | namecheap.com, cloudflare.com |
| Email hosting | support@rwp3app.com | Free with domain (Cloudflare Email Routing) or Google Workspace ($6/month) | - |

---

## 1. Firebase Configuration

### 1.1 Create Firebase Project
```
1. Go to console.firebase.google.com
2. "Add Project" → name: "rwp3-prod"
3. Enable Google Analytics → select default account
4. Wait for project creation
```

### 1.2 Enable Authentication Providers
```
Firebase Console → Authentication → Sign-in method → Enable:

✅ Email/Password
   - Toggle ON
   - Enable "Email link (passwordless sign-in)": OFF (we use password)

✅ Phone
   - Toggle ON
   - Add test phone numbers for development:
     +1 555-555-0100 → OTP: 123456
     +1 555-555-0101 → OTP: 123456

✅ Google
   - Toggle ON
   - Configure OAuth consent screen (see section 3)

✅ Apple
   - Toggle ON
   - Requires: Services ID, Team ID, Key ID, Private Key (see section 4)
```

### 1.3 Enable Firestore
```
Firebase Console → Firestore Database → Create Database
  - Mode: Production
  - Location: nam5 (US multi-region) or your closest region
  - Deploy security rules from: firestore.rules
```

### 1.4 Enable Storage
```
Firebase Console → Storage → Get Started
  - Location: Same as Firestore
  - Deploy security rules from: storage.rules
```

### 1.5 Enable Cloud Functions
```
- Requires Blaze (pay-as-you-go) plan
- Firebase Console → Functions → Get Started
- Deploy via CLI: firebase deploy --only functions
```

### 1.6 Enable Cloud Messaging (FCM)
```
Firebase Console → Cloud Messaging
  - Auto-enabled with project
  - For iOS: Upload APNs key (see section 5)
  - For web admin: No extra config needed
```

### 1.7 Firebase App Registration
```
Firebase Console → Project Settings → Add App:

1. Android (Customer):
   Package: com.rwp3.customer
   SHA-1: (see section 2)
   Download: google-services.json → customer/android/app/

2. Android (Driver):
   Package: com.rwp3.driver
   SHA-1: (see section 2)
   Download: google-services.json → driver/android/app/

3. iOS (Customer):
   Bundle ID: com.rwp3.customer
   Download: GoogleService-Info.plist → customer/ios/Runner/

4. iOS (Driver):
   Bundle ID: com.rwp3.driver
   Download: GoogleService-Info.plist → driver/ios/Runner/

5. Web (Admin):
   Auto-configured via FlutterFire CLI
```

---

## 2. Android SHA Certificates

### Why Needed
Google Sign-In and some Firebase features require SHA-1 and SHA-256 fingerprints.

### Get Debug SHA-1 (Development)
```bash
# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Windows
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### Get Release SHA-1 (Production)
```bash
keytool -list -v -keystore upload-keystore.jks -alias upload
# Enter your keystore password
```

### Register in Firebase
```
Firebase Console → Project Settings → Your Apps → Android app
  → Add Fingerprint → paste SHA-1
  → Add Fingerprint → paste SHA-256

Add BOTH debug and release fingerprints.
```

### Register in Google Cloud Console
```
Google Cloud Console → APIs & Services → Credentials
  → OAuth 2.0 Client IDs → Android
  → Add SHA-1 fingerprint
```

---

## 3. Google Sign-In (OAuth)

### 3.1 Configure OAuth Consent Screen
```
Google Cloud Console → APIs & Services → OAuth consent screen
  - User type: External
  - App name: RWP3
  - User support email: support@rwp3app.com
  - App logo: Upload your logo
  - App domain: rwp3app.com
  - Developer contact: your-email@domain.com
  - Scopes: email, profile, openid
  - Test users: Add your test emails (while in "Testing" status)
  - Publish app → move to "Production" before store submission
```

### 3.2 Create OAuth Client IDs
```
Google Cloud Console → APIs & Services → Credentials → Create Credentials → OAuth Client ID

1. Android (Customer):
   - Application type: Android
   - Package name: com.rwp3.customer
   - SHA-1: (your release fingerprint)

2. Android (Driver):
   - Application type: Android
   - Package name: com.rwp3.driver
   - SHA-1: (your release fingerprint)

3. iOS (Customer):
   - Application type: iOS
   - Bundle ID: com.rwp3.customer

4. iOS (Driver):
   - Application type: iOS
   - Bundle ID: com.rwp3.driver

5. Web (Admin):
   - Application type: Web application
   - Authorized redirect URIs: https://rwp3-prod.firebaseapp.com/__/auth/handler
```

### 3.3 Flutter Implementation
```dart
// google_sign_in package reads client IDs from:
// Android: google-services.json (auto)
// iOS: GoogleService-Info.plist + Info.plist URL scheme
// Web: firebase_options.dart (auto)
```

### 3.4 iOS Info.plist Addition
```xml
<!-- Add reversed client ID as URL scheme -->
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
    </array>
  </dict>
</array>
```

---

## 4. Apple Sign-In

### 4.1 App ID Configuration
```
Apple Developer → Certificates, Identifiers & Profiles → Identifiers
  → Select your App ID (com.rwp3.customer)
  → Capabilities → Enable "Sign In with Apple"
  → Save

Repeat for com.rwp3.driver
```

### 4.2 Create Services ID (for Firebase)
```
Apple Developer → Identifiers → + → Services IDs
  - Description: RWP3 Sign In
  - Identifier: com.rwp3.signin
  - Enable "Sign In with Apple"
  - Configure:
    - Primary App ID: com.rwp3.customer
    - Domains: rwp3-prod.firebaseapp.com
    - Return URLs: https://rwp3-prod.firebaseapp.com/__/auth/handler
```

### 4.3 Create Key (for Firebase)
```
Apple Developer → Keys → + → Create New Key
  - Key Name: RWP3 Firebase
  - Enable "Sign In with Apple"
  - Configure → Select Primary App ID
  - Register → Download .p8 file (SAVE THIS - can only download once!)
  - Note the Key ID
```

### 4.4 Configure in Firebase
```
Firebase Console → Authentication → Sign-in method → Apple
  - Services ID: com.rwp3.signin
  - Team ID: (from Apple Developer membership page)
  - Key ID: (from step 4.3)
  - Private Key: (paste contents of .p8 file)
```

### 4.5 Xcode Configuration
```
Xcode → Target → Signing & Capabilities → + Capability → Sign In with Apple
```

---

## 5. Apple Push Notifications (APNs)

### 5.1 Create APNs Key
```
Apple Developer → Keys → + → Create New Key
  - Key Name: RWP3 Push
  - Enable "Apple Push Notifications service (APNs)"
  - Register → Download .p8 file (SAVE THIS!)
  - Note the Key ID
```

### 5.2 Upload to Firebase
```
Firebase Console → Project Settings → Cloud Messaging → iOS app
  - APNs Authentication Key: Upload .p8 file
  - Key ID: (from step 5.1)
  - Team ID: (from Apple Developer membership)
```

### 5.3 Xcode Configuration
```
Xcode → Target → Signing & Capabilities → + Capability → Push Notifications
Xcode → Target → Signing & Capabilities → + Capability → Background Modes
  → Check: Remote notifications
  → Check: Background fetch (driver app only)
  → Check: Location updates (driver app only)
```

---

## 6. Stripe Configuration

### 6.1 Create Account
```
1. Go to stripe.com → Create account
2. Complete business verification (required for live payments)
3. Get API keys:
   - Dashboard → Developers → API Keys
   - Publishable key: pk_live_xxx (safe for client)
   - Secret key: sk_live_xxx (server only!)
```

### 6.2 Store Keys
```
Publishable key → Firestore: settings/payment.strip.clientPublishableKey
Secret key → Cloud Functions environment:
  firebase functions:config:set stripe.secret="sk_live_xxx"

NEVER store secret key in Firestore or client code.
```

### 6.3 Apple Pay Setup (via Stripe)
```
Stripe Dashboard → Settings → Payment Methods → Apple Pay
  - Register domains: rwp3app.com
  - Download domain verification file
  - Upload to: https://rwp3app.com/.well-known/apple-developer-merchantid-domain-association

Apple Developer → Identifiers → Merchant IDs → +
  - Description: RWP3 Payments
  - Identifier: merchant.com.rwp3

Xcode → Target → Signing & Capabilities → + Capability → Apple Pay
  - Select: merchant.com.rwp3
```

### 6.4 Google Pay Setup (via Stripe)
```
- Google Pay works automatically through Stripe SDK
- No extra configuration needed
- Must test on real Android device (not emulator)
- Enable in Stripe Dashboard → Settings → Payment Methods → Google Pay
```

### 6.5 Test Mode
```
Test keys (use during development):
  pk_test_xxx → Firestore (dev environment)
  sk_test_xxx → Cloud Functions (dev environment)

Test card numbers:
  Success: 4242 4242 4242 4242
  Decline: 4000 0000 0000 0002
  3D Secure: 4000 0025 0000 3155
  Exp: Any future date, CVC: Any 3 digits
```

---

## 7. Google Maps Platform

### 7.1 Enable APIs
```
Google Cloud Console → APIs & Services → Library → Enable:

✅ Maps SDK for Android
✅ Maps SDK for iOS
✅ Maps JavaScript API (admin web panel)
✅ Directions API
✅ Geocoding API
✅ Places API
✅ Distance Matrix API
```

### 7.2 Create API Key
```
Google Cloud Console → APIs & Services → Credentials → Create Credentials → API Key

Restrictions (IMPORTANT for security):
  Android apps:
    - Package: com.rwp3.customer, SHA-1: xxx
    - Package: com.rwp3.driver, SHA-1: xxx
  iOS apps:
    - Bundle ID: com.rwp3.customer
    - Bundle ID: com.rwp3.driver
  API restrictions:
    - Restrict to: Maps SDK Android, Maps SDK iOS, Directions, Geocoding, Places, Distance Matrix
```

### 7.3 Store Key
```
- Store in Firestore: settings/constant.mapAPIKey
- Also add to:
  - customer/android/app/src/main/AndroidManifest.xml
  - driver/android/app/src/main/AndroidManifest.xml
  - customer/ios/Runner/AppDelegate.swift
  - driver/ios/Runner/AppDelegate.swift
```

### 7.4 Billing
```
Google Cloud Console → Billing → Link billing account
- $200 free credit per month
- ~28,000 free map loads/month
- ~40,000 free direction requests/month
- Set budget alert at $50 to monitor
```

---

## 8. Domain & Email Setup

### 8.1 Register Domain
```
Register: rwp3app.com (or your chosen domain)
Recommended registrars: Cloudflare, Namecheap, Google Domains
```

### 8.2 Required Subpages
```
https://rwp3app.com/privacy          ← Privacy Policy
https://rwp3app.com/terms            ← Terms of Service
https://rwp3app.com/delete-account   ← Web account deletion (Google Play requirement)
https://rwp3app.com/support          ← Support page
```

### 8.3 Email Setup
```
Option A: Cloudflare Email Routing (Free)
  - Forward support@rwp3app.com → your Gmail
  - Send from Gmail with "Send as" configured

Option B: Google Workspace ($6/month)
  - Full support@rwp3app.com mailbox
  - Needed if sending transactional emails

SMTP Config (for Firebase email templates):
  Store in Firestore: settings/smtp
  {
    host: "smtp.gmail.com" or your SMTP provider,
    port: 587,
    username: "support@rwp3app.com",
    password: "app-specific-password",
    fromEmail: "support@rwp3app.com",
    fromName: "RWP3 Support"
  }
```

### 8.4 Firebase Hosting (Admin Panel + Web Pages)
```bash
# Initialize hosting
firebase init hosting
  - Public directory: admin/build/web
  - Single-page app: Yes
  - Automatic builds: No

# Deploy admin panel + legal pages
firebase deploy --only hosting
```

---

## 9. FCM Server Configuration

### 9.1 Service Account Key (for Cloud Functions)
```
Firebase Console → Project Settings → Service Accounts
  → Generate New Private Key → Download JSON

Store as: functions/service-account.json
Add to .gitignore (NEVER commit!)

For CI/CD: Store as GitHub Secret → inject during build
```

### 9.2 FCM v1 API (New)
```
Cloud Functions use firebase-admin SDK which auto-authenticates.
No separate FCM server key needed when using firebase-admin.

// In Cloud Functions:
const admin = require('firebase-admin');
admin.initializeApp();

await admin.messaging().send({
  token: userFcmToken,
  notification: { title: 'Ride Update', body: 'Your driver is arriving' },
  data: { type: 'cab', bookingId: '123', route: '/tracking/123' }
});
```

---

## 10. Universal Links / App Links

### 10.1 Apple Universal Links
```
1. Create file: .well-known/apple-app-site-association
   Host at: https://rwp3app.com/.well-known/apple-app-site-association

{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.rwp3.customer",
        "paths": ["/booking/*", "/tracking/*", "/referral/*"]
      },
      {
        "appID": "TEAMID.com.rwp3.driver",
        "paths": ["/driver/*"]
      }
    ]
  }
}

2. Xcode → Target → Signing & Capabilities → Associated Domains
   Add: applinks:rwp3app.com
```

### 10.2 Android App Links
```
1. Create file: .well-known/assetlinks.json
   Host at: https://rwp3app.com/.well-known/assetlinks.json

[{
  "relation": ["delegate_permission/common.handle_all_urls"],
  "target": {
    "namespace": "android_app",
    "package_name": "com.rwp3.customer",
    "sha256_cert_fingerprints": ["YOUR_SHA256"]
  }
}]

2. AndroidManifest.xml:
<intent-filter android:autoVerify="true">
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="https" android:host="rwp3app.com" />
</intent-filter>
```
