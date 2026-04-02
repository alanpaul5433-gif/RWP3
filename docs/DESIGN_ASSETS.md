# DESIGN_ASSETS.md - Required Design Assets & Specifications

## App Icons

### Android
| Size | File | Usage |
|------|------|-------|
| 512x512 px | `ic_launcher.png` | Play Store listing |
| 192x192 px | `ic_launcher.png` | xxxhdpi |
| 144x144 px | `ic_launcher.png` | xxhdpi |
| 96x96 px | `ic_launcher.png` | xhdpi |
| 72x72 px | `ic_launcher.png` | hdpi |
| 48x48 px | `ic_launcher.png` | mdpi |

Use `flutter_launcher_icons` package to auto-generate all sizes.

### iOS
| Size | Usage |
|------|-------|
| 1024x1024 px | App Store listing |
| 180x180 px | iPhone @3x |
| 120x120 px | iPhone @2x |
| 167x167 px | iPad Pro |
| 152x152 px | iPad |

### Design Rules
- No transparency (iOS rejects transparent icons)
- No text in the icon (too small to read)
- Rounded corners: added automatically by OS (don't bake them in)
- Distinct for each app: Customer (rider icon), Driver (steering wheel icon)
- Use primary red (#D32F2F) as dominant color with white symbol
- Simple, recognizable at 48px

---

## Splash Screen

### Specifications
- White background with centered logo
- Logo: 200x200 dp (centered)
- No text below logo (appears for < 2 seconds)
- Match `colorScheme.surface` for seamless transition

### Implementation
```yaml
# pubspec.yaml
flutter_native_splash:
  color: "#FFFFFF"
  image: assets/images/logo.png
  android_12:
    color: "#FFFFFF"
    image: assets/images/logo.png
```

---

## Store Screenshots

### Apple App Store

| Device | Size (px) | Required |
|--------|-----------|----------|
| iPhone 6.7" (15 Pro Max) | 1290 x 2796 | Yes |
| iPhone 6.5" (11 Pro Max) | 1242 x 2688 | Yes |
| iPhone 5.5" (8 Plus) | 1242 x 2208 | Yes |
| iPad 12.9" (Pro) | 2048 x 2732 | If supporting iPad |

**Minimum 3 screenshots, maximum 10 per device size.**

### Google Play Store

| Device | Size (px) | Required |
|--------|-----------|----------|
| Phone | 1080 x 1920 (min) | Yes (min 2, max 8) |
| 7" Tablet | 1200 x 1920 | Recommended |
| 10" Tablet | 1600 x 2560 | Recommended |

**Feature Graphic:** 1024 x 500 px (required for Play Store listing)

### Recommended Screenshot Screens (Customer App)
1. **Home screen** — "Book rides in seconds"
2. **Map/booking screen** — "Choose your pickup & drop"
3. **Vehicle selection** — "Multiple vehicle options"
4. **Live tracking** — "Track your ride in real-time"
5. **Payment** — "Pay your way — Card, Wallet, or Cash"
6. **Ride history** — "Your complete ride history"

### Recommended Screenshot Screens (Driver App)
1. **Home/dashboard** — "Your earnings at a glance"
2. **Ride request** — "Accept rides instantly"
3. **Navigation** — "Turn-by-turn navigation"
4. **Earnings** — "Track every rupee earned"
5. **Wallet** — "Easy payouts to your bank"

### Screenshot Style Guide
- Device frame: Use device mockup frame (optional but professional)
- Background: White or light gradient
- Caption text above/below: 24-32pt, bold, 1-line description
- Use app's primary red (#D32F2F) for caption text or accents
- No personal data visible in screenshots (use demo data)

---

## In-App Assets

### Icons (SVG)
| Icon | File | Usage |
|------|------|-------|
| Cash | `ic_cash.svg` | Payment method |
| Wallet | `ic_wallet.svg` | Payment method, wallet screen |
| Stripe/Card | `ic_card.svg` | Payment method |
| Car/Cab | `ic_cab.svg` | Cab ride type |
| Highway | `ic_intercity.svg` | Intercity ride type |
| Package | `ic_parcel.svg` | Parcel delivery type |
| Clock/Rental | `ic_rental.svg` | Rental ride type |
| Location pin | `ic_pickup.svg` | Pickup marker |
| Destination flag | `ic_drop.svg` | Drop marker |
| Navigation | `ic_navigate.svg` | Route/directions |
| Star | `ic_star.svg` | Ratings |
| Chat | `ic_chat.svg` | Messaging |
| Bell | `ic_notification.svg` | Notifications |
| SOS | `ic_sos.svg` | Emergency |
| Phone | `ic_phone.svg` | Call |
| Profile | `ic_profile.svg` | User avatar placeholder |
| Settings | `ic_settings.svg` | Settings |
| Coupon | `ic_coupon.svg` | Discount codes |
| Gift | `ic_referral.svg` | Referral program |
| Document | `ic_document.svg` | Driver documents |

### Illustrations (SVG)
| Illustration | File | Usage |
|-------------|------|-------|
| Empty rides | `il_empty_rides.svg` | No ride history |
| Empty wallet | `il_empty_wallet.svg` | No transactions |
| Empty chat | `il_empty_chat.svg` | No messages |
| Empty notifications | `il_empty_notif.svg` | No notifications |
| Error state | `il_error.svg` | Something went wrong |
| No connection | `il_offline.svg` | No internet |
| Success | `il_success.svg` | Payment/booking success |
| Onboarding 1 | `il_onboarding_1.svg` | Book a ride |
| Onboarding 2 | `il_onboarding_2.svg` | Track in real-time |
| Onboarding 3 | `il_onboarding_3.svg` | Pay easily |

### Map Markers (PNG — required for Google Maps)
| Marker | File | Size |
|--------|------|------|
| Driver car | `marker_driver.png` | 64x64 px @2x, 96x96 @3x |
| Pickup | `marker_pickup.png` | 48x48 px @2x |
| Drop | `marker_drop.png` | 48x48 px @2x |
| Stop | `marker_stop.png` | 36x36 px @2x |

### Animations (Lottie JSON)
| Animation | File | Usage |
|-----------|------|-------|
| Loading | `anim_loading.json` | General loading |
| Searching driver | `anim_searching.json` | Finding nearby drivers |
| Success | `anim_success.json` | Payment/booking confirmed |
| Location pulse | `anim_pulse.json` | Current location indicator |

### Fonts
```
fonts/
├── Inter-Regular.ttf      (400)
├── Inter-Medium.ttf       (500)
├── Inter-SemiBold.ttf     (600)
└── Inter-Bold.ttf         (700)
```

Or use Google Fonts package: `google_fonts: latest` (downloads at runtime).

---

## Color Asset Reference

| Name | Hex | Usage |
|------|-----|-------|
| Primary Red | #D32F2F | Buttons, app bar, FAB |
| Primary Light | #EF5350 | Dark mode primary |
| Primary Container | #FFCDD2 | Light backgrounds |
| Secondary Blue | #1976D2 | Links, secondary actions |
| Secondary Light | #42A5F5 | Dark mode secondary |
| Secondary Container | #BBDEFB | Light backgrounds |
| Surface White | #FFFFFF | Backgrounds, cards |
| On Surface | #1C1B1F | Body text |
| Success Green | #27C041 | Completed, online |
| Warning Yellow | #FFC107 | On hold, caution |
| Error Red | #BA1A1A | Errors, cancelled |
| Orange Status | #D19D00 | Ongoing ride |
| Grey Inactive | #9D9D9D | Placed, disabled |
