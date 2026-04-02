import 'dart:math';

class MockReferralDataSource {
  String? _referralCode;

  Future<String> getReferralCode(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _referralCode ??= _generateCode();
    return _referralCode!;
  }

  Future<bool> validateReferralCode(String code) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return code.length == 6; // simple mock validation
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    final letters = String.fromCharCodes(
      Iterable.generate(2, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
    final digits = (random.nextInt(9000) + 1000).toString();
    return '$letters$digits';
  }
}
