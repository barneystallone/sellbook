import 'package:flutter/material.dart';
import 'package:sellbook/models/book_model.dart';
import 'package:intl/intl.dart';
import 'package:sellbook/resources/app_color.dart';

import 'custom_icon_button.dart';

class BookItem extends StatelessWidget {
  const BookItem({
    super.key,
    required this.book,
    required this.increment,
    required this.decrement,
  });

  final BookModel book;
  final VoidCallback increment;
  final VoidCallback decrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRect(
            child: Image.asset(book.imagePath,
                width: 60, height: 80, fit: BoxFit.cover)),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: SizedBox(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (book.name.length > 37)
                            ? '${book.name.substring(0, 34)}...'
                            : book.name,
                        style: const TextStyle(
                            fontSize: 15, color: Colors.black87),
                      ),
                      Text(
                        book.author,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                    ]),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      NumberFormat.simpleCurrency(
                              locale: 'vi_VN', decimalDigits: 0)
                          .format(book.price),
                      style: const TextStyle(color: AppColor.red),
                    ),
                    Row(
                      children: [
                        Visibility(
                          visible: book.quantity > 0,
                          replacement: const SizedBox(
                            width: 20,
                          ),
                          child: CustomIconButton(
                            onTap: decrement,
                            icon: const Icon(Icons.remove,
                                size: 16.0, color: AppColor.red),
                            outlineBorder:
                                Border.all(color: AppColor.red, width: 1),
                            padding: const EdgeInsets.all(4),
                          ),
                        ),
                        Visibility(
                          visible: book.quantity > 0,
                          replacement: const SizedBox(
                            width: 44,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '${book.quantity}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        CustomIconButton(
                          onTap: increment,
                          icon: const Icon(Icons.add,
                              size: 16.0, color: AppColor.white),
                          color: AppColor.red,
                          padding: const EdgeInsets.all(5),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ))
      ],
    );
  }
}
