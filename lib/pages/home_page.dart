import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import '../components/book_item.dart';
import '../components/search_box.dart';
import '../components/td_app_bar.dart';
import '../models/book_model.dart';
import '../resources/app_color.dart';
import '../components/list_book.dart';
import '../services/local/shared_prefs.dart';
import 'package:badges/badges.dart' as badges;

class HomePage extends StatefulWidget {
  // final String title;
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  final SharedPrefs _prefs = SharedPrefs();
  String _searchText = '';
  int _totalPrice = 0;
  int _totalQuantity = 0;
  List<BookModel> _books = [];
  List<BookModel> _searchBooks = [];
  @override
  void initState() {
    super.initState();
    initBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.bgColor,
        appBar: TdAppBar(
            rightPressed: () async {
              bool? status = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('😍'),
                  content: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Do you want to logout?',
                          style: TextStyle(fontSize: 22.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
              if (status ?? false) {
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              }
            },
            title: 'Sellbook'),
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 16.0,
                      bottom: (_totalQuantity > 0) ? 64 : 12),
                  child: Column(
                    children: [
                      SearchBox(
                          onChanged: (value) => setState(() {
                                _searchText = value;
                                searchBook();
                              }),
                          controller: _searchController),
                      const SizedBox(height: 20),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Tủ sách',
                            style: TextStyle(
                                fontSize: 16,
                                color: AppColor.red,
                                fontWeight: FontWeight.w500)),
                      ),
                      const SizedBox(height: 10),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _searchBooks.length,
                        itemBuilder: (context, index) {
                          BookModel book = _searchBooks.toList()[index];
                          return BookItem(
                            book: book,
                            increment: () => increment(index),
                            decrement: () => decrement(index),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const Divider(height: 16, thickness: 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_totalQuantity > 0)
              Positioned(
                left: 0.0,
                right: 0,
                bottom: 0,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      color: HexColor('#eeeff5'),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(39, 49, 49, 49),
                          offset: Offset(0.0, 3.0),
                          blurRadius: 10.0,
                          spreadRadius: 5,
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              badges.Badge(
                                badgeContent: Text(
                                  '$_totalQuantity',
                                  style: const TextStyle(
                                      color: AppColor.white, fontSize: 8),
                                ),
                                position: badges.BadgePosition.topEnd(end: -4),
                                badgeStyle: const badges.BadgeStyle(
                                    padding: EdgeInsets.only(
                                        top: 4, left: 4, right: 3, bottom: 3)),
                                badgeAnimation:
                                    const badges.BadgeAnimation.slide(
                                        animationDuration:
                                            Duration(milliseconds: 200)),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 28,
                                      color: AppColor.red),
                                ),
                              ),
                              Text(
                                  NumberFormat.currency(
                                          locale: 'vi_VN',
                                          decimalDigits: 0,
                                          symbol: 'VNĐ')
                                      .format(_totalPrice),
                                  style: const TextStyle(
                                    color: AppColor.red,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          height: double.infinity,
                          color: AppColor.red,
                          alignment: Alignment.center,
                          child: const Text(
                            'Thanh toán',
                            style: TextStyle(color: AppColor.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
          ],
        ));
  }

  void searchBook() {
    setState(() {
      _searchBooks = _books
          .where((element) => element.name.contains(_searchText))
          .toList();
    });
  }

  initBooks() {
    _prefs.getBooks().then((value) {
      setState(() {
        _books = value ?? books;
        _searchBooks = [..._books];
        _totalPrice = _books
            .map((e) => e.price * e.quantity)
            .reduce((value, element) => value + element);
        _totalQuantity = _books
            .map((e) => e.quantity)
            .reduce((value, element) => value + element);
      });
    });
  }

  void decrement(int index) {
    if (_searchBooks[index].quantity >= 1) {
      setState(() {
        _searchBooks[index].quantity = _searchBooks[index].quantity - 1;
        _books[_books.indexWhere((book) => book.id == _searchBooks[index].id)] =
            _searchBooks[index];
        _prefs.setBooks(books: _books);
        _totalPrice -= _searchBooks[index].price;
        --_totalQuantity;
      });
    }
  }

  void increment(int index) {
    setState(() {
      ++_searchBooks[index].quantity;
      _books[_books.indexWhere((book) => book.id == _searchBooks[index].id)] =
          _searchBooks[index];
      _prefs.setBooks(books: _books);
      _totalPrice += _searchBooks[index].price;
      ++_totalQuantity;
    });
  }
}
