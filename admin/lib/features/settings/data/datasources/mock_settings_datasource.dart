class MockSettingsDataSource {
  final Map<String, dynamic> _settings = {
    // General
    'appName': 'RWP',
    'appFullName': 'Ride with Purpose',
    'appColor': '#C41E24',
    'countryCode': '+1',
    'currency': 'USD',
    'currencySymbol': '\$',
    'defaultDistanceType': 'km', // global default
    'searchRadius': 10.0,

    // Distance Pricing (per distance type)
    'pricePerKm': 2.00,
    'pricePerMile': 1.50,

    // Financial
    'commissionPercent': 20.0,
    'commissionIsFixed': false,
    'commissionFixedAmount': 0.0,
    'taxPercent': 8.0,
    'minimumAmountToDeposit': 10.0,
    'minimumAmountToWithdrawal': 20.0,
    'referralAmount': 5.0,
    'loyaltyPointsPerRide': 10,
    'loyaltyPointValue': 0.01, // 1 point = $0.01

    // Charges
    'nightChargePercent': 15.0,
    'nightChargeStartHour': 22,
    'nightChargeEndHour': 6,
    'cancellationChargeIsFixed': true,
    'cancellationChargeAmount': 5.0,
    'holdChargePerMinute': 0.50,

    // Safety
    'sosAlertNumber': '911',
    'maxEmergencyContacts': 3,

    // Feature Flags
    'isOtpFeatureEnable': true,
    'isSubscriptionEnable': true,
    'isDocumentVerificationEnable': true,
    'isDriverAutoApproved': false,
    'isFemaleOnlyRideEnable': true,
    'isBiddingEnable': false,
    'isCashPaymentEnable': true,
    'isWalletPaymentEnable': true,
    'isCardPaymentEnable': true,
    'isDemoMode': false,

    // SMTP
    'smtpHost': '',
    'smtpPort': 587,
    'smtpEmail': '',

    // App Version
    'minAppVersion': '1.0.0',
    'latestAppVersion': '1.0.0',
    'forceUpdate': false,
  };

  Future<Map<String, dynamic>> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Map.from(_settings);
  }

  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _settings.addAll(updates);
    return Map.from(_settings);
  }
}
