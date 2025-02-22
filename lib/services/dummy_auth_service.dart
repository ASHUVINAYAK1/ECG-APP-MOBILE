class DummyAuthService {
  // Simulates sign-in with a delay.
  Future<bool> signIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    if (email == 'test@test.com' && password == 'password') {
      return true;
    }
    return false;
  }
}
