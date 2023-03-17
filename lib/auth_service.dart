import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:garden_app/pages/login_register_page.dart';
import 'package:garden_app/pages/main_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class AuthService {

  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {

            print("TOKEN USER: ${UserCredential}");
            return const MainPage();
          } else {
            return const LoginPage() ;
          }
        });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    print("TokenUS: ${googleAuth.idToken}");
    makeAuthServer(googleAuth.idToken.toString());
    makeAuthenticatedRequest(googleAuth.idToken.toString());
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> saveAccessToken(String token,String refreshToken) async {
    // Save the token to storage using your preferred storage mechanism
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
    await prefs.setString('refresh_token', refreshToken);
  }

  Future<String?> getAccessToken() async {
    final GoogleSignInAccount? googleUser =
    await GoogleSignIn(scopes: <String>["email"]).signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return googleAuth.idToken;
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // return prefs.getString('access_token');
  }
  Future<Map<String, String>> readTokens() async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('access_token') ?? '';
    final refreshToken = prefs.getString('refresh_token') ?? '';

    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }
  //Sign out
  signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
  Future<String> makeAuthServer(String idToken) async{
    final String? idToken =await getAccessToken();
    if(idToken!=null){
      final response= await http.post(
        Uri.parse("https://lacha.s2tek.net/api/CustomToken?token=$idToken"),
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );
      if(response.statusCode == 200){
        print("success");
        print("${response.body}");
        return response.body;
      } else {
        throw Exception('Failed to fetch data');
      }
    } else {
      throw Exception('Access token not found');
    }
  }
  // Make an authenticated API request
  Future<String> makeAuthenticatedRequest(String idToken) async {
    final String? idToken = await getAccessToken();
    if (idToken != null) {
      final response = await http.get(
        Uri.parse('https://lacha.s2tek.net/swagger/index.html'),
        headers: {
          'Authorization': 'Bearer $idToken',
        },
      );
      if (response.statusCode == 200) {
        print('Success!!!');
        return response.body;
      } else {
        throw Exception('Failed to fetch data');
      }
    } else {
      throw Exception('Access token not found');
    }
  }
}
