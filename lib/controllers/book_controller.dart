import 'dart:convert';

import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/models/bool_list_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class BookController extends ChangeNotifier {
  BookListResponse? bookList;
  fetcBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookList = BookListResponse.fromJson(jsonBookList);
      notifyListeners();
    }

    //print(await http.read(Uri.parse('https://example.com/foobar.txt')));
  }

  BookDetailResponse? detailBook;
  fetcDetailBookApi(isbn) async {
    var url = Uri.parse('https://api.itbook.store/1.0/books/$isbn');
    var response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      notifyListeners();
      fetcSimiliarBookApi(detailBook!.title!);
    }
    //print(await http.read(Uri.parse('https://example.com/foobar.txt')));
  }

  BookListResponse? similiarBooks;
  fetcSimiliarBookApi(String title) async {
    //print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/search/$title');
    var response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      similiarBooks = BookListResponse.fromJson(jsonDetail);
      notifyListeners();
    }
    //print(await http.read(Uri.parse('https://example.com/foobar.txt')));
  }
}
