import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:on_stage_app/app/features/login/application/login_state.dart';
import 'package:on_stage_app/app/features/login/data/login_repository.dart';
import 'package:on_stage_app/app/features/login/domain/login_request_model.dart';
import 'package:on_stage_app/app/shared/data/dio_client.dart';
import 'package:on_stage_app/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_notifier.g.dart';

@Riverpod(keepAlive: true)
class LoginNotifier extends _$LoginNotifier {
  late final LoginRepository _loginRepository;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  LoginState build() {
    final dio = ref.read(dioProvider);
    _loginRepository = LoginRepository(dio);
    return const LoginState();
  }

  Future<void> init() async {
    logger.i('init login provider state');
  }

  Future<bool> signUpWithCredentials(
      String name, String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);
        final idToken = await user.getIdToken();
        if (idToken == null) {
          throw Exception('Failed to get ID Token');
        }
        final authToken = await _loginRepository.login(
          LoginRequest(firebaseToken: idToken),
        );
        await _saveAuthToken(authToken as String);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      logger.e('Failed to sign up with credentials: ${e.code}, ${e.message}');
      // state = SignUpState(error: e.message ?? 'Sign up failed');
      return false;
    } catch (e, s) {
      logger.e('Failed to sign up with credentials: $e, $s');
      // state = SignUpState(error: e.toString());
      return false;
    }
  }

  Future<bool> loginWithCredentials(String email, String password) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken == null) {
          throw Exception('Failed to get ID Token');
        }
        final authToken = await _loginRepository.login(
          LoginRequest(firebaseToken: idToken),
        );
        await _saveAuthToken(authToken as String);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      logger.e('Failed to login with credentials: ${e.code}, ${e.message}');
      state = LoginState(error: e.message ?? 'Authentication failed');
      return false;
    } catch (e, s) {
      logger.e('Failed to login with credentials: $e, $s');
      state = LoginState(error: e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return false;
      }

      final googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken == null) {
          throw Exception('Failed to get ID Token');
        }
        final authToken = await _loginRepository.login(
          LoginRequest(firebaseToken: idToken),
        );
        await _saveAuthToken(authToken as String);
        return true;
      }
      return false;
    } catch (e, s) {
      logger.e('Failed to sign in with Google: $e, $s');
      state = LoginState(error: e.toString());
      return false;
    }
  }

  Future<void> _saveAuthToken(String authToken) async {
    try {
      await _secureStorage.write(key: 'token', value: authToken);
      logger.i('Auth token saved successfully');
    } catch (e) {
      logger.e('Failed to save auth token: $e');
    }
  }
}
