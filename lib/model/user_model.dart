class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
  });

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(
      uid: user?.uid,
      email: user?.email,
      displayName: user?.displayName,
    );
  }

  bool get isAuthenticated => uid != null;
}