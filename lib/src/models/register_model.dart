class RegisterModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? password;
  String? username;
  String? companyName;
  bool? seller;
  String? shopName;
  String? shopURL;
  RegisterModel({this.firstName, this.lastName, this.email, this.phoneNumber, this.password, this.username,this.companyName,  this.seller = false, this.shopName, this.shopURL});

  Map<String, dynamic> toJson() => {
    "first_name": firstName == null ? '' : firstName,
    "last_name": lastName == null ? '' : lastName,
    "email": email == null ? '' : email,
    "phone": phoneNumber == null ? '' : phoneNumber,
    "password": password == null ? '' : password,
    "username": email == null ? '' : email,
    "company_name":companyName == null ? '' : companyName,
    "shopname":shopName == null ? '' : shopName,
    "shopurl":shopURL == null ? '' : shopURL,
    "seller":seller == null ? '' : seller.toString()
  };
}