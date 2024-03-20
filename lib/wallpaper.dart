// ignore_for_file: avoid_print, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wallpaper_app/full_screen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;
  String uri = 'https://api.pexels.com/v1/curated?per_page=80';

//functions for to  hit pexels apis
  fetchApi() async {
    try {
      await http.get(Uri.parse(uri), headers: {
        'Authorization':
            'mivCsBlqzzrHUFFNkdSrmP47KUByHiMuKQy3SNG6T9NZ1f6hJign3IrK'
      }).then((value) {
        Map result = jsonDecode(value.body);
        setState(() {
          images = result['photos'];
        });
        print(images.length);
      });
    } catch (e) {
      print(e.toString());
    }
  }

//load mmore images in on tap of load more button increment the page by 1//
  loadMore() async {
    setState(() {
      page = page + 1;
    });

    await http.get(
        Uri.parse('https://api.pexels.com/v1/curated?per_page=80&page=' +
            page.toString()),
        headers: {
          'Authorization':
              'mivCsBlqzzrHUFFNkdSrmP47KUByHiMuKQy3SNG6T9NZ1f6hJign3IrK'
        }).then((value) {
      Map result = jsonDecode(value.body);

      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

//call api first on build
  @override
  void initState() {
    super.initState();
    fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 2,
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 2,
                ),
                itemCount: images.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        (MaterialPageRoute(
                            builder: (context) => FullScreen(
                                imageUrl: images[index]['src']['large']))),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          images[index]['src']['tiny'],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          InkWell(
            onTap: () {
              loadMore();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              color: Colors.black,
              child: const Center(
                child: Text(
                  "Load more",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
