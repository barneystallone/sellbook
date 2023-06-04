import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sellbook/models/bill_model.dart';
import 'package:sellbook/pages/check_out.dart';

import '../components/search_box.dart';
import '../components/td_app_bar.dart';
import '../models/user_model.dart';
import '../resources/app_color.dart';
import '../services/local/shared_prefs.dart';

class ListBill extends StatefulWidget {
  final UserModel user;
  const ListBill({super.key, required this.user});

  @override
  State<ListBill> createState() => _ListBillState();
}

class _ListBillState extends State<ListBill> {
  late TextEditingController _searchController;
  final SharedPrefs _prefs = SharedPrefs();
  late FocusNode _focusNode;
  late String _searchText;
  List<BillModel> _bills = [];
  List<BillModel> _searchBills = [];

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _searchController = TextEditingController();
    _searchText = '';
    initBills();
  }

  initBills() {
    _prefs.getBills().then((value) {
      setState(() {
        // _books = value ?? books;
        _bills = value ??
            (jsonDecode(jsonEncode(bills)).cast<Map<String, dynamic>>()
                    as List<Map<String, dynamic>>)
                .map((e) => BillModel.fromJson(e))
                .toList();
        _searchBills = [..._bills];
      });
    });
  }

  searchBill() {
    _searchBills = _bills
        .where((bill) => (bill.user.username as String)
            .toLowerCase()
            .contains(_searchText.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bgColor,
      appBar: TdAppBar(
        title: 'Hóa đơn',
        user: widget.user,
        isHomePage: false,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  top: 16.0,
                ),
                child: SearchBox(
                    focusNode: _focusNode,
                    onChanged: (value) => setState(() {
                          _searchText = value;

                          searchBill();
                        }),
                    controller: _searchController),
              ),
              const SizedBox(height: 20),
              buildDataTable(),
            ]),
          ))
        ],
      ),
    );
  }

  Widget buildDataTable() {
    final columns = ['Username', 'Date Created', 'Total Price'];
    return DataTable(columns: getColumns(columns), rows: getRows(_searchBills));
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((column) => DataColumn(
              label: Text(
            column,
            style: const TextStyle(fontSize: 13),
          )))
      .toList();

  List<DataRow> getRows(List<BillModel> bills) => bills.map((bill) {
        final cells = [
          bill.user.username,
          DateFormat('dd-MM-yyyy').format(bill.dateCreated),
          NumberFormat.currency(locale: 'vi_VN', decimalDigits: 0, symbol: 'đ')
              .format(bill.totalPrice)
        ];
        return DataRow(
            cells: getCells(cells),
            onLongPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckOut(
                      cartListItem: bill.listBook,
                      user: bill.user,
                      dateCreatedStr: DateFormat('HH:mm - dd/MM/yyyy')
                          .format(bill.dateCreated),
                      readOnly: true,
                    ),
                  ));
              print(bill);
            });
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(Text(
            data,
            style: const TextStyle(fontSize: 11),
          )))
      .toList();
}
