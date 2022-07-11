import 'package:example/application/application.router.dart';
import 'package:example/pages/users/test/user_test_page_args.dart';
import 'package:flutter/material.dart';
import 'package:mio_web_router/core/route_page.dart';

@RoutePage(path: '/users/:uuid')
class UserPage extends StatelessWidget {
  final String uuid;
  final bool? showSubtitle;

  const UserPage({
    Key? key,
    required this.uuid,
    this.showSubtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const testUuid = '123422';
    return Scaffold(
      appBar: AppBar(
        title: Text('User uuid: $uuid'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showSubtitle == true) const Text('Subtitle'),
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  ApplicationRouter.getUserTestPageRoutePath(
                    args: UserTestPageArgs(
                      userUuid: uuid,
                      testUuid: testUuid,
                    ),
                  ),
                );
              },
              child: Text('Go to $uuid user test: $testUuid'),
            ),
          ],
        ),
      ),
    );
  }
}
