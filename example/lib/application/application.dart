import 'package:example/application/application.router.dart';
import 'package:flutter/material.dart';
import 'package:mio_web_router/mio_web_router.dart';

export 'package:example/application/application.router.dart'
    show ApplicationRouter;

@InitRouter()
class Application extends StatelessWidget {
  const Application({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      title: 'Mio Web Router Generator',
      initialRoute: '/',
      onGenerateRoute: ApplicationRouteGenerator.onGenerateRoute,

      ///Example for change page route animation
      onUnknownRoute: (settings) => ApplicationRouteGenerator.onUnknownRoute(
        settings,
        MaterialRouteBuilder(),
      ),
    );
  }
}

class MaterialRouteBuilder implements RouteBuilder {
  @override
  Route<dynamic>? build(RouteSettings settings, RouterPath routerPath,
      Map<String, String> params) {
    return MaterialPageRoute(
      builder: (context) => routerPath.builder(context, params),
      settings: settings,
    );
  }
}
