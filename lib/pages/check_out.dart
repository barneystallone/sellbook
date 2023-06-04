import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellbook/models/bill_model.dart';
import 'package:sellbook/models/book_model.dart';
import 'package:sellbook/models/user_model.dart';
import 'package:sellbook/resources/app_color.dart';

import '../components/custom_button.dart';
import '../services/local/shared_prefs.dart';
import 'required_auth.dart';

class CheckOut extends StatefulWidget {
  final List<BookModel> cartListItem;
  final bool readOnly;
  final String? dateCreatedStr;
  final UserModel user;
  const CheckOut(
      {super.key,
      required this.cartListItem,
      required this.user,
      this.dateCreatedStr,
      this.readOnly = false});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  final SharedPrefs _prefs = SharedPrefs();
  final double _discount = 0.1;
  late bool expandBill;
  late ScrollController _scrollController;
  late int _totalPrice;
  late int _tienGiam;
  bool allowPop = true;
  @override
  initState() {
    super.initState();
    expandBill = false;
    _scrollController = ScrollController();
    _totalPrice = widget.cartListItem
        .map((e) => e.quantity * e.price)
        .reduce((value, element) => value + element);
    _tienGiam =
        (widget.user.isVip ?? false) ? (_totalPrice * _discount).round() : 0;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return allowPop;
      },
      child: Scaffold(
        backgroundColor: AppColor.bgColor,
        body: SafeArea(
          child: Container(
            color: const Color.fromARGB(255, 228, 230, 243),
            child: Stack(children: [
              Positioned.fill(
                child: Container(
                  padding: widget.readOnly
                      ? const EdgeInsets.only(top: 70)
                      : const EdgeInsets.only(top: 70, bottom: 160),
                  child: ListView(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: AppColor.bgColor,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(86, 215, 215, 218),
                                blurRadius: 15,
                                offset: Offset(0, 4),
                                spreadRadius: 5,
                              )
                            ]),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.pin_drop_outlined,
                              size: 14,
                              color: AppColor.red,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Địa chỉ giao hàng',
                                      style: TextStyle(
                                        fontSize: 14,
                                      )),
                                  const SizedBox(height: 10),
                                  Text(
                                      '${widget.user.username} | ${widget.user.phoneNumber}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      )),
                                  const SizedBox(height: 6),
                                  Text('${widget.user.address} ',
                                      style: const TextStyle(
                                        fontSize: 14,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.dateCreatedStr != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.schedule_outlined,
                                size: 14,
                                color: AppColor.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                    'Đặt vào lúc ${widget.dateCreatedStr}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                              ),
                            ],
                          ),
                        ),
                      // Thông tin hóa đơn
                      Container(
                        decoration: const BoxDecoration(
                            color: AppColor.bgColor,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(86, 215, 215, 218),
                                blurRadius: 15,
                                offset: Offset(0, 4),
                                spreadRadius: 5,
                              )
                            ]),
                        padding: const EdgeInsets.only(
                            left: 12.0, right: 12.0, bottom: 12.0),
                        child: SizedBox(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20.0),
                                child: const Text(
                                  'Thông tin đơn hàng',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              AnimatedContainer(
                                height: expandBill
                                    ? 60 *
                                        min(4, widget.cartListItem.length * 1.0)
                                    : 60,
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.easeInOut,
                                child: ListView.separated(
                                  controller: _scrollController,
                                  physics: expandBill
                                      ? null
                                      : const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: widget.cartListItem.length,
                                  itemBuilder: (context, index) {
                                    BookModel book =
                                        widget.cartListItem.toList()[index];
                                    String itemName =
                                        '${book.quantity} x ${book.name}';
                                    return SizedBox(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          ClipRect(
                                              child: Image.asset(
                                            book.imagePath,
                                            width: 30,
                                            fit: BoxFit.cover,
                                          )),
                                          const SizedBox(width: 8.0),
                                          Expanded(
                                              child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                itemName.length > 42
                                                    ? '${itemName.substring(0, 38)}...'
                                                    : itemName,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )
                                            ],
                                          )),
                                          Text(
                                            NumberFormat.currency(
                                                    locale: 'vi_VN',
                                                    decimalDigits: 0,
                                                    symbol: 'đ')
                                                .format(
                                                    book.price * book.quantity),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Phân cách
                      SizedBox(
                        height: 54,
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                height: 54,
                                endIndent: 4,
                                thickness: 0.1,
                                color: Colors.black54,
                              ),
                            ),
                            if (widget.cartListItem.length > 1)
                              GestureDetector(
                                onTap: () => setState(() {
                                  expandBill = !expandBill;
                                  _scrollController.animateTo(0,
                                      duration:
                                          const Duration(milliseconds: 150),
                                      curve: Curves.easeInOut);
                                }),
                                child: Text(
                                  expandBill ? 'Thu gọn 👆' : 'Xem thêm 👇',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            const Expanded(
                              child: Divider(
                                height: 54,
                                indent: 4,
                                thickness: 0.1,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Summarize
                      Container(
                        decoration: const BoxDecoration(
                            color: AppColor.bgColor,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(86, 215, 215, 218),
                                blurRadius: 15,
                                offset: Offset(0, 4),
                                spreadRadius: 5,
                              )
                            ]),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Tổng cộng (${widget.cartListItem.length} món)',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54)),
                                  Text(
                                      NumberFormat.currency(
                                              locale: 'vi_VN', symbol: 'đ')
                                          .format(_totalPrice),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54)),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 0.5,
                              height: 20,
                            ),
                            SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: const [
                                      Text('Giảm giá ',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black54)),
                                      Icon(
                                        Icons.help_outline,
                                        color: Colors.black54,
                                        size: 13,
                                      )
                                    ],
                                  ),
                                  Text(
                                      NumberFormat.currency(
                                              locale: 'vi_VN', symbol: 'đ')
                                          .format(_tienGiam),
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.black54)),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tổng cộng',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                        NumberFormat.currency(
                                                locale: 'vi_VN', symbol: 'đ')
                                            .format(_totalPrice - _tienGiam),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: AppColor.red)),
                                    const SizedBox(
                                      height: 14,
                                    ),
                                    const Text('Đã bao gồm thuế',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: AppColor.bgColor,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(84, 185, 186, 192),
                            offset: Offset(0, 6),
                            blurRadius: 9,
                            spreadRadius: 0.5,
                          )
                        ]),
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.0, vertical: 18.0),
                              child: Icon(
                                Icons.arrow_back,
                                size: 24,
                              ),
                            )),
                        Text(
                          widget.readOnly
                              ? 'Thông tin đơn hàng'
                              : 'Xác nhận đơn hàng',
                          style:
                              const TextStyle(fontSize: 18, letterSpacing: 1),
                        ),
                      ],
                    ),
                  )),
              if (!widget.readOnly)
                Positioned(
                    left: 0.0,
                    right: 0.0,
                    bottom: 0,
                    child: Container(
                      color: AppColor.bgColor,
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 30),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.receipt_long_outlined,
                                  color: Colors.orange[300],
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Bằng việc nhấn "Đặt đơn", bạn đồng ý tuân theo Điều khoản dịch vụ và Quy chế của chúng tôi',
                                    style:
                                        TextStyle(overflow: TextOverflow.clip),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomButton(
                            onPressed: () {
                              BillModel bill = BillModel(
                                  user: widget.user,
                                  listBook: widget.cartListItem,
                                  dateCreatedTimeStamp:
                                      DateTime.now().millisecondsSinceEpoch,
                                  tienGiam: _tienGiam);
                              print(bill);

                              _prefs.addBill(bill: bill).then((value) =>
                                  _prefs.deletetBooks().then((value) {
                                    showSnackBar('Đặt hàng thành công');
                                    Timer(const Duration(milliseconds: 1200),
                                        () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const RequiredAuth(),
                                        ),
                                      );
                                      setState(() {
                                        allowPop = true;
                                      });
                                    });
                                  }));
                              setState(() {
                                allowPop = false;
                              });
                            },
                            title:
                                'Đặt đơn - ${NumberFormat.currency(locale: "vi_VN", symbol: "VNĐ").format(_totalPrice - _tienGiam)}',
                            padding: null,
                            shape: const RoundedRectangleBorder(),
                            backgroundColor: AppColor.red,
                            width: double.infinity,
                          ),
                        ],
                      ),
                    ))
            ]),
          ),
        ),
      ),
    );
  }

  void showSnackBar(display) {
    final snackBar = SnackBar(
      content: Text(display),
      duration: const Duration(milliseconds: 800),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
