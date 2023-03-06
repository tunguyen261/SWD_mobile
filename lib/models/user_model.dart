class UserProfile {
  final String uid;
  late final String displayName;
  final String email;
  final String photoUrl;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
  });
}