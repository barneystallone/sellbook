class BookModel {
  late int id;
  late String imagePath;
  late String name;
  late String author;
  late int price;
  late int quantity;

  BookModel({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.author,
    this.price = 0,
    this.quantity = 0,
  });
  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imagePath = json['imagePath'];
    name = json['name'];
    author = json['author'];
    price = json['price'];
    quantity = json['quantity'];
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'name': name,
      'author': author,
      'price': price,
      'quantity': quantity
    };
  }

  @override
  String toString() {
    return '{id: $id,imagePath: $imagePath, name: $name, author: $author, price: $price, quantity: $quantity}';
  }
}

final List<BookModel> books = [
  BookModel(
    id: 1,
    imagePath: 'assets/images/sach1.jpg',
    name: 'Giáo trình lập trình JAVA',
    price: 40000,
    quantity: 0,
    author: 'Đoàn Văn Ban-Đoàn Văn Trung',
  ),
  BookModel(
    id: 2,
    imagePath: 'assets/images/sach2.png',
    name: 'Ứng dụng Excel',
    price: 58000,
    quantity: 0,
    author: 'Trịnh Hoài Sơn',
  ),
  BookModel(
    id: 3,
    imagePath: 'assets/images/sach3.png',
    name: 'Giáo trình lập trình ANDROID',
    price: 99000,
    quantity: 0,
    author: 'Lê Hoàng Sơn(Chủ biên)-Nguyễn Thọ Thông',
  ),
  BookModel(
    id: 7,
    imagePath: 'assets/images/sach7.jpg',
    name: 'Beginning App Development with Flutter',
    price: 88000,
    quantity: 0,
    author: 'Rap Bayne',
  ),
  BookModel(
    id: 8,
    imagePath: 'assets/images/sach8.jpg',
    name: 'Beginning IOS AR Game Development',
    price: 145000,
    quantity: 0,
    author: 'Allan Fowler',
  ),
  BookModel(
    id: 9,
    imagePath: 'assets/images/sach9.jpg',
    name: 'Beginning CouchDB',
    price: 150000,
    quantity: 0,
    author: 'Joe Lennon',
  ),
  BookModel(
    id: 10,
    imagePath: 'assets/images/sach10.jpg',
    name: 'Practical Node.js',
    price: 123000,
    quantity: 0,
    author: 'Azat Mardan',
  ),
];
