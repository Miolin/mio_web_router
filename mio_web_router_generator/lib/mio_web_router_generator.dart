library mio_web_router_generator;

import 'package:build/build.dart';
import 'package:mio_web_router_generator/core/annotation_generator.dart';
import 'package:mio_web_router_generator/core/generator.dart';
import 'package:source_gen/source_gen.dart';

Builder routerAnnotationBuilder(BuilderOptions options) {
  return LibraryBuilder(
    WebRouteAnnotationGenerator(),
    formatOutput: (generated) => generated.replaceAll(RegExp(r'//.*|\s'), ''),
    generatedExtension: '.route.json',
  );
}

Builder routerBuilder(BuilderOptions options) {
  return LibraryBuilder(
    WebRouterGenerator(),
    generatedExtension: '.router.dart',
  );
}

