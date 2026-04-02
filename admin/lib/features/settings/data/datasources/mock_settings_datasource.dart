class MockSettingsDataSource {
  final Map<String, dynamic> _settings = {
    'appName': 'RWP3',
    'appColor': '#D32F2F',
    'countryCode': '+1',
    'distanceType': 'km',
    'radius': 10.0,
    'minimumAmountToDeposit': 10.0,
    'minimumAmountToWithdrawal': 20.0,
    'referralAmount': 5.0,
    'sosAlertNumber': '112',
    'isOtpFeatureEnable': true,
    'isSubscriptionEnable': true,
    'isDocumentVerificationEnable': true,
    'isDriverAutoApproved': false,
    'commissionPercent': 20.0,
    'commissionIsFixed': false,
    'taxPercent': 8.0,
    'nightChargePercent': 15.0,
    'cancellationChargeAmount': 25.0,
    'cancellationChargeIsFixed': true,
  };

  Future<Map<String, dynamic>> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return Map.unmodifiable(_settings);
  }

  Future<Map<String, dynamic>> updateSettings(Map<String, dynamic> updates) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _settings.addAll(updates);
    return Map.unmodifiable(_settings);
  }
}
