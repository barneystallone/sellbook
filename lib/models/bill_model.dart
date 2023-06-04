import 'book_model.dart';
import 'user_model.dart';

class BillModel {
  late UserModel user;
  late List<BookModel> listBook;
  late int dateCreatedTimeStamp;
  late int tienGiam;

  BillModel({
    required this.user,
    required this.listBook,
    required this.dateCreatedTimeStamp,
    this.tienGiam = 0,
  });
  BillModel.fromJson(Map<String, dynamic> json) {
    user = UserModel.fromJson(json['user']);
    listBook =
        ((json['listBook'] as List<dynamic>).cast<Map<String, dynamic>>())
            .map((e) => BookModel.fromJson(e))
            .toList();
    dateCreatedTimeStamp = json['dateCreatedTimeStamp'];
    tienGiam = json['tienGiam'];
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'listBook': listBook,
      'dateCreatedTimeStamp': dateCreatedTimeStamp,
      'tienGiam': tienGiam,
    };
  }

  DateTime get dateCreated =>
      DateTime.fromMillisecondsSinceEpoch(dateCreatedTimeStamp);

  @override
  String toString() {
    return '{user: $user,listBook: $listBook, dateCreatedTimeStamp: $dateCreatedTimeStamp, tienGiam: $tienGiam}';
  }
}

final List<BillModel> bills = [
  BillModel(
    user: users[0],
    listBook: [
      BookModel(
        id: 1,
        imagePath: 'assets/images/sach1.jpg',
        name: 'Giáo trình lập trình JAVA',
        price: 40000,
        quantity: 4,
        author: 'Đoàn Văn Ban-Đoàn Văn Trung',
      ),
      BookModel(
        id: 2,
        imagePath: 'assets/images/sach2.png',
        name: 'Ứng dụng Excel',
        price: 58000,
        quantity: 2,
        author: 'Trịnh Hoài Sơn',
      ),
    ],
    dateCreatedTimeStamp: DateTime(2023, 6, 1).millisecondsSinceEpoch,
  ),
  BillModel(
    user: users[1],
    listBook: [
      BookModel(
        id: 10,
        imagePath: 'assets/images/sach10.jpg',
        name: 'Practical Node.js',
        price: 123000,
        quantity: 1,
        author: 'Azat Mardan',
      ),
      BookModel(
        id: 2,
        imagePath: 'assets/images/sach2.png',
        name: 'Ứng dụng Excel',
        price: 58000,
        quantity: 3,
        author: 'Trịnh Hoài Sơn',
      ),
    ],
    dateCreatedTimeStamp: DateTime(2023, 5, 31).millisecondsSinceEpoch,
  ),
];
