import 'package:core/errors/failures.dart';

String mapFailureToMessage(Failure failure) {
  return switch (failure) {
    ServerFailure(:final message) => message.isNotEmpty
        ? message
        : 'Something went wrong. Please try again.',
    CacheFailure() => 'Unable to load data. Check your connection.',
    NetworkFailure() => 'No internet connection. Some features may be unavailable.',
    AuthFailure(:final message) => _mapAuthMessage(message),
    ValidationFailure(:final message) => message,
    PaymentFailure(:final message) => _mapPaymentMessage(message),
  };
}

String _mapAuthMessage(String code) {
  return switch (code) {
    'wrong-password' => 'Incorrect password. Please try again.',
    'user-not-found' => 'No account found with this email.',
    'email-already-in-use' => 'An account with this email already exists.',
    'too-many-requests' => 'Too many attempts. Please try again later.',
    'invalid-otp' => 'Invalid verification code. Please try again.',
    'invalid-email' => 'Please enter a valid email address.',
    'weak-password' => 'Password must be at least 6 characters.',
    'user-disabled' => 'This account has been disabled. Contact support.',
    'operation-not-allowed' => 'This sign-in method is not enabled.',
    'account-exists-with-different-credential' =>
      'An account already exists with a different sign-in method.',
    _ => 'Authentication failed. Please try again.',
  };
}

String _mapPaymentMessage(String code) {
  return switch (code) {
    'card-declined' => 'Your card was declined. Please try another payment method.',
    'insufficient-funds' => 'Insufficient wallet balance. Please add funds.',
    'network' => 'Payment failed due to network error. You were not charged.',
    'cancelled' => 'Payment was cancelled.',
    _ => 'Payment failed. Please try again.',
  };
}
