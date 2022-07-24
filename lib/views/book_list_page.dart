//import 'dart:convert';

import 'package:book_app/controllers/book_controller.dart';
//import 'package:book_app/models/bool_list_response.dart';
import 'package:book_app/views/detail_book_page.dart';
import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookController? bookController;

  @override
  void initState() {
    super.initState();
    bookController = Provider.of<BookController>(context, listen: false);
    bookController!.fetcBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Catalouge"),
      ),
      body: Consumer<BookController>(
        child: const Center(child: CircularProgressIndicator()),
        builder: (context, controller, child) => Container(
          child: bookController!.bookList == null
              ? child
              : ListView.builder(
                  itemCount: bookController!.bookList!.books!.length,
                  itemBuilder: (context, index) {
                    final currenBook = bookController!.bookList!.books![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailBookPage(
                              isbn: currenBook.isbn13!,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Image.network(
                            currenBook.image!,
                            height: 100,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(currenBook.title!),
                                  Text(currenBook.subtitle!),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Text(currenBook.price!)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
