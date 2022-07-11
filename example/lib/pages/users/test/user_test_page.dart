import 'package:example/pages/users/test/user_test_page_args.dart';
import 'package:flutter/material.dart';
import 'package:mio_web_router/mio_web_router.dart';

@RoutePage(path: '/users/:uuid/:testUuid')
class UserTestPage extends StatelessWidget {
  final UserTestPageArgs args;

  const UserTestPage({
    Key? key,
    @RoutePageArgs() required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User uuid: ${args.userUuid}'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Test uuid: ${args.testUuid}'),
      ),
    );
  }
}
