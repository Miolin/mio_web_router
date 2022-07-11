import 'package:example/application/application.dart';
import 'package:flutter/material.dart';
import 'package:mio_web_router/core/route_page.dart';

@RoutePage(path: '/')
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ApplicationRouter.getUsersPageRoutePath(),
                );
              },
              child: const Text('Go to All users'),
            ),
          ],
        ),
      ),
    );
  }
}
