class UserModel {
  String? username;
  String? password;
  String? phoneNumber;
  String? address;
  bool? isVip;
  UserModel({
    this.username,
    this.password,
    this.phoneNumber,
    this.address,
    this.isVip = false,
  });
  UserModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    isVip = json['isVip'];
  }
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
      'isVip': isVip,
    };
  }

  @override
  String toString() {
    return '{username: $username, password: $password, phoneNumber: $phoneNumber, address: $address, isVip: $isVip}';
  }
}

final users = [
  UserModel(
    username: 'vinh@gmail.com',
    password: 'vinh',
    phoneNumber: '0999999999',
    address: '123 Tôn Đức Thắng, Hoà Minh, Cẩm Lệ, Đà Nẵng',
    isVip: true,
  ),
  UserModel(
    username: 'viet@gmail.com',
    password: 'viet',
    phoneNumber: '0123456789',
    address: '123 Ngô Thì Nhậm, Hoà Minh, Liên Chiểu, Đà Nẵng',
  ),
  UserModel(
    username: 'dieu@gmail.com',
    password: 'dieu',
    phoneNumber: '0123456789',
    address: '113 Ngô Thì Nhậm, Hoà Minh, Liên Chiểu, Đà Nẵng',
    isVip: true,
  ),
  UserModel(
    username: 'tien@gmail.com',
    password: 'tien',
    phoneNumber: '0123456789',
    address: '133 Ngô Thì Nhậm, Hoà Minh, Liên Chiểu, Đà Nẵng',
  ),
];
