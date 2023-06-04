import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import '../components/book_item.dart';
import '../components/search_box.dart';
import '../components/td_app_bar.dart';
import '../models/book_model.dart';
import '../models/user_model.dart';
import '../resources/app_color.dart';
import '../services/local/shared_prefs.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animations/animations.dart';

import 'check_out.dart';

class HomePage extends StatefulWidget {
  final UserModel user;
  // final String title;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SharedPrefs _prefs = SharedPrefs();
  late TextEditingController _searchController;
  late FocusNode _focusNode;
  late String _searchText;
  late int _totalPrice;
  late int _totalQuantity;
  late double _cartHeight;
  late double _cartMaxHeight;
  List<BookModel> _books = [];
  List<BookModel> _booksInCart = [];
  List<BookModel> _searchBooks = [];

  Widget overlay = Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColor.black.withOpacity(0.5));

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchController = TextEditingController();
    _searchText = '';
    _totalPrice = 0;
    _totalQuantity = 0;
    _cartHeight = 0;
    _cartMaxHeight = 600;
    initBooks();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool status = await _showDialog(
          title: 'Đồng ý để thoát khỏi ứng dụng',
        );
        if (!status) return false;

        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return true;
        //  Future.value(false);
      },
      child: Scaffold(
          backgroundColor: AppColor.bgColor,
          appBar: TdAppBar(
              overlay: (_cartHeight > 0)
                  ? GestureDetector(
                      onTap: toggleOverlay,
                      child: overlay,
                    )
                  : null,
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
                            focusNode: _focusNode,
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
                              increment: () => increment(_searchBooks[index]),
                              decrement: () => setState(() {
                                decrement(_searchBooks[index]);
                              }),
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
              if (_cartHeight > 0)
                GestureDetector(
                  onTap: toggleOverlay,
                  child: overlay,
                ),

              // Footer + Cart Modal
              if (_totalQuantity > 0) ...[
                Positioned(
                  left: 0.0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        height: _cartHeight,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Container(
                          color: AppColor.bgColor,
                          child: Column(
                            children: [
                              if (_cartHeight != 0)
                                SizedBox(
                                  height: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _showDialogWithCB(
                                                title:
                                                    'Xóa tất cả sản phẩm trong giỏ hàng?',
                                                successCb: resetCart);
                                          },
                                          child: const Text(
                                            'Xóa tất cả',
                                            style: TextStyle(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w400,
                                                color: AppColor.red),
                                          ),
                                        ),
                                        const Text(
                                          'Giỏ hàng',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        GestureDetector(
                                            onTap: toggleOverlay,
                                            child: const Padding(
                                              padding: EdgeInsets.only(
                                                  top: 10,
                                                  left: 14,
                                                  bottom: 10),
                                              child: Icon(
                                                Icons.close,
                                                size: 24,
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(
                                      left: 14.0,
                                      right: 14.0,
                                      bottom: 18.0,
                                      top: 10.0),
                                  itemCount: _booksInCart.length,
                                  itemBuilder: (context, index) {
                                    BookModel book =
                                        _booksInCart.toList()[index];
                                    return BookItem(
                                      book: book,
                                      increment: () =>
                                          increment(_booksInCart[index]),
                                      decrement: () {
                                        if (_booksInCart[index].quantity == 1) {
                                          _showDialogWithCB(
                                              title:
                                                  'Bạn có muốn xóa sản phẩm này ra khỏi giỏ hàng',
                                              successCb: () {
                                                setState(() {
                                                  decrement(
                                                      _booksInCart[index]);
                                                  _booksInCart.removeAt(index);
                                                  if (_booksInCart.isEmpty) {
                                                    toggleOverlay();
                                                  }
                                                });
                                              });
                                        } else {
                                          setState(() {
                                            decrement(_booksInCart[index]);
                                          });
                                        }
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(height: 16, thickness: 1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: toggleOverlay,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      badges.Badge(
                                        badgeContent: Text(
                                          '$_totalQuantity',
                                          style: const TextStyle(
                                              color: AppColor.white,
                                              fontSize: 8),
                                        ),
                                        position: badges.BadgePosition.topEnd(
                                            end: -4),
                                        badgeStyle: const badges.BadgeStyle(
                                            padding: EdgeInsets.only(
                                                top: 4,
                                                left: 4,
                                                right: 3,
                                                bottom: 3)),
                                        badgeAnimation:
                                            const badges.BadgeAnimation.slide(
                                                animationDuration: Duration(
                                                    milliseconds: 200)),
                                        child: const Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 28,
                                            color: AppColor.red),
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
                                onTap: redirectToCheckOut,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  height: double.infinity,
                                  color: AppColor.red,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Đặt hàng',
                                    style: TextStyle(color: AppColor.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ],
          )),
    );
  }

  void searchBook() {
    setState(() {
      final String _searchlowerCase = _searchText.toLowerCase();
      _searchBooks = _books
          .where((element) =>
              element.name.toLowerCase().contains(_searchlowerCase))
          .toList();
    });
  }

  initBooks() {
    _prefs.getBooks().then((value) {
      setState(() {
        // _books = value ?? books;
        _books = value ??
            (jsonDecode(jsonEncode(books)).cast<Map<String, dynamic>>()
                    as List<Map<String, dynamic>>)
                .map((e) => BookModel.fromJson(e))
                .toList();
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

  void decrement(BookModel item) {
    if (item.quantity >= 1) {
      // setState(() {
      item.quantity = item.quantity - 1;
      _books[_books.indexWhere((book) => book.id == item.id)] = item;
      _prefs.setBooks(books: _books);
      _totalPrice -= item.price;
      --_totalQuantity;
      // });
    }
  }

  void increment(BookModel item) {
    setState(() {
      ++item.quantity;
      _books[_books.indexWhere((book) => book.id == item.id)] = item;
      _prefs.setBooks(books: _books);
      _totalPrice += item.price;
      ++_totalQuantity;
    });
  }

  void toggleOverlay() {
    setState(() {
      unFocusTextField();
      if ((_cartHeight == 0)) {
        _cartHeight = _cartMaxHeight;
        _booksInCart = _books.where((book) => book.quantity > 0).toList();
        return;
      }
      _cartHeight = 0;
    });
  }

  void resetCart() {
    setState(() {
      _booksInCart = [];

      _books = (jsonDecode(jsonEncode(books)).cast<Map<String, dynamic>>()
              as List<Map<String, dynamic>>)
          .map((e) => BookModel.fromJson(e))
          .toList();

      // _books = _books.map((book) {
      //   book.quantity = 0;
      //   return book;
      // }).toList();
      _searchBooks = _searchBooks.map((book) {
        book.quantity = 0;
        return book;
      }).toList();
      _totalPrice = 0;
      _totalQuantity = 0;
      _prefs.setBooks(books: _books);
      toggleOverlay();
    });
  }

  void unFocusTextField() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  Future<bool> _showDialog({required String title}) async {
    bool? status = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('😍'),
        content: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 22.0),
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
    return status ?? false;
  }

  void _showDialogWithCB(
      {required String title, required VoidCallback successCb}) async {
    bool status = await _showDialog(title: title);
    if (status) {
      successCb();
    }
  }

  redirectToCheckOut() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CheckOut(
                  cartListItem:
                      _books.where((book) => book.quantity > 0).toList(),
                  user: widget.user,
                )));
  }
}
