import 'package:mio_web_router/core/param_parser.dart';
import 'package:mio_web_router/mio_web_router.dart';

class RoutePage {
  final String path;

  static const String unknown = 'unknown';

  const RoutePage({required this.path});
}

class RoutePageArgs {
  const RoutePageArgs();
}

class RoutePageParam {
  final String? paramName;

  const RoutePageParam({
    this.paramName,
  });
}

class InitRouter {
  final List<String> generateForDir;
  final ParamParser paramParser;

  const InitRouter([
    this.generateForDir = const ['lib'],
    this.paramParser = const DefaultParamParser(),
  ]);
}
