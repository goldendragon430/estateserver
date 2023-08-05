class User {
  final String id;
  final String email;
  final String username;
  String landline;
  int role;
  int state;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.landline = '',
    this.role = 2,
    this.state = 1,
  });
}