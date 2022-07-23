import 'dart:convert';
//import 'dart:html';
//import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:book_app/models/book_detail_response.dart';
import 'package:book_app/models/bool_list_response.dart';
import 'package:book_app/views/image_view_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class DetailBookPage extends StatefulWidget {
  const DetailBookPage({Key? key, required this.isbn}) : super(key: key);
  final String isbn;
  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  BookDetailResponse? detailBook;
  fetcDetailBookApi() async {
    print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/books/${widget.isbn}');
    var response = await http.get(
      url,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      detailBook = BookDetailResponse.fromJson(jsonDetail);
      setState(() {});
      fetcSimiliarBookApi(detailBook!.title!);
    }
    //print(await http.read(Uri.parse('https://example.com/foobar.txt')));
  }

  BookListResponse? similiarBooks;
  fetcSimiliarBookApi(String title) async {
    print(widget.isbn);
    var url = Uri.parse('https://api.itbook.store/1.0/search/${title}');
    var response = await http.get(
      url,
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonDetail = jsonDecode(response.body);
      similiarBooks = BookListResponse.fromJson(jsonDetail);
      setState(() {});
    }
    //print(await http.read(Uri.parse('https://example.com/foobar.txt')));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetcDetailBookApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: detailBook == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageViewScreen(imageUrl: detailBook!.image!),
                            ),
                          );
                        },
                        child: Image.network(
                          detailBook!.image!,
                          height: 150,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detailBook!.title!,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                detailBook!.authors!,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    Icons.star,
                                    color:
                                        index < int.parse(detailBook!.rating!)
                                            ? Colors.yellow
                                            : Colors.grey,
                                  ),
                                ),
                              ),
                              Text(
                                detailBook!.subtitle!,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              ),
                              Text(
                                detailBook!.price!,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            //fixedSize: Size(double.infinity, 50),
                            ),
                        onPressed: () async {
                          print("url");
                          Uri uri = Uri.parse(detailBook!.url!);
                          // Coba ngelink
                          // if (await canLaunch(uri)) {
                          //   await launch(uri);
                          // } else {
                          //   print("tidak berhasil navigasi");
                          // }
                          // Coba ngelink
                          try {
                            (await canLaunchUrl(uri))
                                ? launchUrl(uri)
                                : print("tidak berhasil navigasi");
                          } catch (e) {
                            print("error");
                            print(e);
                          }
                        },
                        child: Text("BUY")),
                  ),
                  SizedBox(height: 20),
                  Text(detailBook!.desc!),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Year:" + detailBook!.year!),
                      Text("ISBN" + detailBook!.isbn13!),
                      Text(detailBook!.pages! + "Page"),
                      Text("Publishrt:" + detailBook!.publisher!),
                      Text("Language:" + detailBook!.language!),

                      //Text(detailBook!.rating!),
                    ],
                  ),
                  Divider(),
                  similiarBooks == null
                      ? CircularProgressIndicator()
                      : Container(
                          height: 180,
                          child: ListView.builder(
                            //shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: similiarBooks!.books!.length,
                            //physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final current = similiarBooks!.books![index];
                              return Container(
                                width: 100,
                                child: Column(
                                  children: [
                                    Image.network(
                                      current.image!,
                                      height: 100,
                                    ),
                                    Text(
                                      current.title!,
                                      maxLines: 3,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                ],
              ),
            ),
    );
  }
}
