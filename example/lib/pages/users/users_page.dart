import 'package:example/application/application.dart';
import 'package:flutter/material.dart';
import 'package:mio_web_router/core/route_page.dart';

@RoutePage(path: '/users')
class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const uuid = 'test323';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
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
                  ApplicationRouter.getUserPageRoutePath(uuid: uuid),
                );
              },
              child: const Text('Go to $uuid user'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ApplicationRouter.getUserPageRoutePath(
                    uuid: uuid,
                    showSubtitle: true,
                  ),
                );
              },
              child: const Text('Go to $uuid user (enable subtitle)'),
            ),
          ],
        ),
      ),
    );
  }
}
