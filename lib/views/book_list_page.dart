import 'dart:convert';

import 'package:book_app/models/bool_list_response.dart';
import 'package:book_app/views/detail_book_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookListPage extends StatefulWidget {
  const BookListPage({Key? key}) : super(key: key);

  @override
  State<BookListPage> createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookListResponse? bookList;
  fetcBookApi() async {
    var url = Uri.parse('https://api.itbook.store/1.0/new');
    var response = await http.get(
      url,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonBookList = jsonDecode(response.body);
      bookList = BookListResponse.fromJson(jsonBookList);
      setState(
        () {},
      );
    }

    //print(await http.read(Uri.parse('https://example.com/foobar.txt')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetcBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Catalouge"),
      ),
      body: Container(
        child: bookList == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: bookList!.books!.length,
                itemBuilder: (context, index) {
                  final currenBook = bookList!.books![index];
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
    );
  }
}
