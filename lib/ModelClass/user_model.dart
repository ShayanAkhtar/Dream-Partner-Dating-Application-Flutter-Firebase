class UserModel{
  final String? id;
  final String fullname;
  final String email;
  final String pass;


  const UserModel({
    this.id,
    required this.fullname,
    required this.email,
    required this.pass,

});

  toJson(){
    return{
      'FullName': fullname,
      'Email': email,
      'Password': pass,
    };
  }
}