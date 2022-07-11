import 'package:mio_web_router/mio_web_router.dart';

class UserTestPageArgs {
  final String userUuid;
  final String testUuid;

  UserTestPageArgs({
    @RoutePageParam(paramName: 'uuid') required this.userUuid,
    required this.testUuid,
  });
}
