class BookingStatus {
  BookingStatus._();

  static const String placed = 'booking_placed';
  static const String driverAssigned = 'driver_assigned';
  static const String accepted = 'booking_accepted';
  static const String ongoing = 'booking_ongoing';
  static const String completed = 'booking_completed';
  static const String cancelled = 'booking_cancelled';
  static const String rejected = 'booking_rejected';
  static const String onHold = 'booking_onHold';

  /// Returns true if transitioning from [current] to [next] is valid.
  static bool isValidTransition(String current, String next) {
    return _validTransitions[current]?.contains(next) ?? false;
  }

  static const Map<String, Set<String>> _validTransitions = {
    placed: {driverAssigned, cancelled},
    driverAssigned: {accepted, rejected, cancelled},
    accepted: {ongoing, cancelled},
    ongoing: {completed, onHold, cancelled},
    onHold: {ongoing, cancelled},
  };

  /// All terminal states (no further transitions).
  static const Set<String> terminalStates = {completed, cancelled, rejected};

  /// All active states (ride is in progress).
  static const Set<String> activeStates = {
    placed,
    driverAssigned,
    accepted,
    ongoing,
    onHold,
  };
}
