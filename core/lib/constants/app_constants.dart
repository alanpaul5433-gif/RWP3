class AppConstants {
  AppConstants._();

  static const String appName = 'RWP';
  static const String appFullName = 'Ride with Purpose';

  // Payment types
  static const String paymentCash = 'cash';
  static const String paymentWallet = 'wallet';
  static const String paymentStripe = 'stripe';

  // Login types
  static const String loginEmail = 'email';
  static const String loginPhone = 'phone';
  static const String loginGoogle = 'google';
  static const String loginApple = 'apple';

  // Gender
  static const String genderMale = 'Male';
  static const String genderFemale = 'Female';
  static const String genderOther = 'Other';

  // Ride types
  static const String rideTypeCab = 'cab';
  static const String rideTypeIntercity = 'intercity';
  static const String rideTypeParcel = 'parcel';
  static const String rideTypeRental = 'rental';

  // User roles
  static const String roleCustomer = 'customer';
  static const String roleDriver = 'driver';
  static const String roleAdmin = 'admin';

  // Wallet transaction types
  static const String transactionCredit = 'credit';
  static const String transactionDebit = 'debit';

  // Support ticket status
  static const String ticketPending = 'pending';
  static const String ticketActive = 'active';
  static const String ticketComplete = 'complete';

  // Withdrawal status
  static const String withdrawalPending = 'pending';
  static const String withdrawalApproved = 'approved';
  static const String withdrawalRejected = 'rejected';
}
