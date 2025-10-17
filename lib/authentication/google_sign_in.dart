import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  static final GoogleSignInService _instance = GoogleSignInService._internal();
  
  late StreamSubscription<GoogleSignInAuthenticationEvent> _authenticationEventSubscription;
  
  GoogleSignInService._internal();
  
  factory GoogleSignInService() {
    return _instance;
  }
  
  Future<void> initialize({
    required Function(GoogleSignInAccount) onSignIn,
    required Function(Object) onError,
  }) async {
    final GoogleSignIn signIn = GoogleSignIn.instance;
    await signIn.initialize();
    
    _authenticationEventSubscription = signIn.authenticationEvents.listen(
      (event) async {
        final GoogleSignInAccount? user = switch (event) {
          GoogleSignInAuthenticationEventSignIn() => event.user,
          GoogleSignInAuthenticationEventSignOut() => null,
        };
        
        if (user != null) {
          await onSignIn(user);
        }
      },
      onError: (error) {
        onError(error);
      },
    );
    
    await signIn.attemptLightweightAuthentication();
  }
  
  Future<void> signIn() async {
    try {
      if (GoogleSignIn.instance.supportsAuthenticate()) {
        await GoogleSignIn.instance.authenticate();
      }
    } catch (e) {
      if (e is GoogleSignInException && 
          e.code == GoogleSignInExceptionCode.canceled) {
        return;
      }
      rethrow;
    }
  }
  
  Future<AuthCredential> getFirebaseCredential(
      GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    
    return credential;
  }
  
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
  }
  
  Future<void> disconnect() async {
    await GoogleSignIn.instance.disconnect();
  }
  
  void dispose() {
    _authenticationEventSubscription.cancel();
  }
}