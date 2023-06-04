import 'dart:convert';
import 'package:sellbook/models/bill_model.dart';
import 'package:sellbook/models/book_model.dart';
import 'package:sellbook/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/todo_model.dart';

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<TodoModel>?> getTodos({bool isDeleted = false}) async {
    SharedPreferences prefs = await _prefs;
    String key = isDeleted ? 'deletedTodos' : 'todos';
    String? data = prefs.getString(key);
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<TodoModel> todos = maps.map((e) => TodoModel.fromJson(e)).toList();
    return todos;
  }

  Future<void> addTodos(
      {required List<TodoModel> todos, bool isDeleted = false}) async {
    List<Map<String, dynamic>> maps = todos.map((e) => e.toJson()).toList();
    String key = isDeleted ? 'deletedTodos' : 'todos';
    SharedPreferences prefs = await _prefs;
    prefs.setString(key, jsonEncode(maps));
  }

  Future<List<BookModel>?> getBooks() async {
    SharedPreferences prefs = await _prefs;
    const String key = 'books';
    String? data = prefs.getString(key);
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<BookModel> todos = maps.map((e) => BookModel.fromJson(e)).toList();
    return todos;
  }

  Future<void> setBooks({required List<BookModel> books}) async {
    List<Map<String, dynamic>> maps = books.map((e) => e.toJson()).toList();
    const String key = 'books';
    SharedPreferences prefs = await _prefs;
    prefs.setString(key, jsonEncode(maps));
  }

  Future<void> deletetBooks() async {
    const String key = 'books';
    SharedPreferences prefs = await _prefs;
    prefs.remove(key);
  }

  Future<UserModel?> getCurrentUser() async {
    SharedPreferences prefs = await _prefs;
    String? data = prefs.getString('user');
    if (data == null) return null;
    return UserModel.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> setCurrentUser(UserModel user) async {
    SharedPreferences prefs = await _prefs;
    Map<String, dynamic> map = user.toJson();
    prefs.setString('user', jsonEncode(map));
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await _prefs;
    prefs.remove('user');
  }

  Future<List<BillModel>?> getBills() async {
    SharedPreferences prefs = await _prefs;
    const String key = 'bills';
    String? data = prefs.getString(key);
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<BillModel> bills = maps.map((e) => BillModel.fromJson(e)).toList();
    return bills;
  }

  Future<void> setBills({required List<BillModel> bills}) async {
    List<Map<String, dynamic>> maps = bills.map((e) => e.toJson()).toList();
    const String key = 'bills';
    SharedPreferences prefs = await _prefs;
    prefs.setString(key, jsonEncode(maps));
  }

  Future<void> addBill({required BillModel bill}) async {
    List<BillModel> bills = await getBills() ?? [];
    print('length: ${bills.length}');
    bills.add(bill);
    await setBills(bills: bills);
  }
}
