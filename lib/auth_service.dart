import 'package:firebase_auth/firebase_auth.dart';
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

            print(readTokens());
            return const MainPage();
          } else {
            return const LoginPage() ;
          }
        });
  }

  signInWithGoogle() async {
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

    print("tokenUS: ${googleAuth.idToken}");
    // Once signed in, return the UserCredential
    makeAuthenticatedRequest();
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  // Refresh the access token
  // Future<void> refreshAccessToken() async {
  //   User? user = auth.currentUser;
  //
  //   if (user != null) {
  //     try {
  //       final String refreshToken = user.refreshToken.toString();
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         idToken: await user.getIdToken(),
  //         accessToken: await user.getIdToken(),
  //       );
  //
  //       final UserCredential userCredential =
  //       await user.reauthenticateWithCredential(credential);
  //       final String newAccessToken = await user.getIdToken();
  //
  //       // Save the new access token to storage
  //       await saveAccessToken(newAccessToken, refreshToken);
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'user-token-expired') {
  //         try {
  //           await refreshAccessToken();
  //           final String? newAccessToken = await getAccessToken();
  //           // Retry the API request using the new access token
  //           final response = await http.get(
  //             Uri.parse('https://example.com/api'),
  //             headers: {
  //               'Authorization': 'Bearer $newAccessToken',
  //             },
  //           );
  //           if (response.statusCode == 200) {
  //
  //             return null;
  //           } else {
  //             throw Exception('Failed to fetch data');
  //           }
  //         } catch (e) {
  //           // Handle error refreshing the access token or retrying the API request
  //         }
  //       } else {
  //         // Handle other Firebase authentication errors
  //         print('Firebase authentication error: ${e.code}');
  //       }
  //     } catch (e) {
  //       print('Error: $e');
  //     }
  //   }
  // }
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

  // Make an authenticated API request
  Future<String> makeAuthenticatedRequest() async {
    final String? idToken = await getAccessToken();
    if (idToken != null) {
      final response = await http.get(
        Uri.parse('http://s2tek.net:7100/swagger/index.html?fbclid=IwAR2Ynh0yEfhgmyyWwT17NvMlLs37zXkH2CwYv-X7aStZLMQVTORAmVrAEgA'),
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
