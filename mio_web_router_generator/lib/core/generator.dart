import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:glob/glob.dart';
import 'package:mio_web_router/mio_web_router.dart';
import 'package:dart_style/dart_style.dart';
import 'package:mio_web_router_generator/core/models/page_model.dart';
import 'package:source_gen/source_gen.dart';

class WebRouterGenerator extends GeneratorForAnnotation<InitRouter> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final generateForDir = annotation
        .read('generateForDir')
        .listValue
        .map((e) => e.toStringValue());

    final parser = annotation.read('paramParser').objectValue;
    final paramParserType = parser.type;

    final dirPattern = generateForDir.length > 1
        ? '{${generateForDir.join(',')}}'
        : '${generateForDir.first}';
    final rotePathFiles = Glob("$dirPattern/**.route.json", recursive: true);

    final assets = await buildStep.findAssets(rotePathFiles).toList();
    final pages = <PageModel>[];
    for (final id in assets) {
      final str = await buildStep.readAsString(id);
      pages.add(PageModel.fromJson(jsonDecode(str)));
    }

    final routeGeneratorSrc =
        _generateRouteGenerator(element.displayName, pages, paramParserType);

    final routerClassSrc = _generateRouter(
      element.displayName,
      pages.where((element) => element.path != RoutePage.unknown).toList(),
      paramParserType,
    );

    final argRoutes = <ParamsModel>[];
    for (PageModel page in pages) {
      argRoutes.addAll(page.params.where((element) => element.isArg));
    }

    final library = Library((b) => b
      ..body.addAll([
        Directive.import("package:flutter/cupertino.dart"),
        Directive.import("package:mio_web_router/mio_web_router.dart"),
        Directive.import(paramParserType?.element?.library?.identifier ?? ''),
        ...pages.map((e) => e.widgetModule).map((e) {
          return Directive.import(e);
        }),
        ...argRoutes.map((e) => e.typeModule).map((e) {
          return Directive.import(e);
        }),
        _generateDefaultBuilderSrc(),
        routeGeneratorSrc,
        routerClassSrc,
      ]));

    final emitter = DartEmitter();

    return DartFormatter().format('${library.accept(emitter)}');
  }

  String _generateRouterPathForPage(PageModel page) {
    return 'RouterPath(path: "${page.path}", builder: (ctx, map) => ${_generateConstructorString(page)})';
  }

  String _generateConstructorString(PageModel model) {
    return '${model.params.isEmpty ? 'const' : ''} ${model.widgetName}(${_generateConstructorParams(model.params)})';
  }

  String _generateConstructorParams(List<ParamsModel> params) {
    final mapParams = <String, String>{};
    params.forEach((e) {
      mapParams[e.name] = e.isArg
          ? '${e.type}(${_generateConstructorParams(e.params)})'
          : '_paramParser.parse(map["${e.pathName}"])';
    });

    return mapParams.toString().replaceAll('{', '').replaceAll('}', '');
  }

  Field _parserField(DartType? paramParserType) {
    return Field(
      (b) => b
        ..name = '_paramParser'
        ..type = refer('ParamParser')
        ..static = true
        ..modifier = FieldModifier.constant
        ..assignment = Code(
          '${paramParserType?.getDisplayString(withNullability: false) ?? ''}()',
        ),
    );
  }

  Class _generateRouteGenerator(
    String className,
    List<PageModel> pages,
    DartType? paramParserType,
  ) {
    final unknownPage =
        pages.any((element) => element.path == RoutePage.unknown)
            ? pages.where((element) => element.path == RoutePage.unknown).first
            : null;

    final routers = pages
        .where((element) => element.path != RoutePage.unknown)
        .map((e) => _generateRouterPathForPage(e))
        .toList();

    return Class(
      (b) => b
        ..name = '${className}RouteGenerator'
        ..fields.add(_parserField(paramParserType))
        ..fields.add(
          Field(
            (b) => b
              ..name = '_paths'
              ..type = refer('List<RouterPath>')
              ..static = true
              ..modifier = FieldModifier.final$
              ..assignment = Code('$routers'),
          ),
        )
        ..fields.add(
          Field(
            (b) => b
              ..name = '_unknownPath'
              ..type = refer('RouterPath?')
              ..static = true
              ..modifier = FieldModifier.final$
              ..assignment = Code(
                unknownPage == null
                    ? 'null'
                    : _generateRouterPathForPage(unknownPage),
              ),
          ),
        )
        ..methods.add(
          Method(
            (b) => b
              ..name = 'onGenerateRoute'
              ..static = true
              ..returns = refer('Route<dynamic>?')
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..type = refer('RouteSettings')
                    ..name = 'settings',
                ),
              )
              ..optionalParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'builder'
                    ..defaultTo = Code('const _DefaultCupertinoRouteBuilder()')
                    ..type = refer('RouteBuilder'),
                ),
              )
              ..body = Code("""
    final requestUri = Uri.parse(settings.name ?? '');
    path: for (RouterPath router in _paths) {
      final pathUri = Uri.parse(router.path);
      final uriSegments = requestUri.pathSegments;
      final pathSegments = pathUri.pathSegments;
      if (uriSegments.length == pathSegments.length) {
        final paramIndex = <int>[];
        for (String segment in pathSegments) {
          final index = pathSegments.indexOf(segment);
          if (segment.startsWith(':')) {
            paramIndex.add(index);
            continue;
          } else if (uriSegments[index] != segment) {
           continue path;
          }
        }
        final paramsMap = <String, String>{};
        for (int index in paramIndex) {
          final key = pathSegments[index].substring(1);
          final value = uriSegments[index];
          paramsMap[key] = value;
        }
        paramsMap.addAll(requestUri.queryParameters);

        return builder.build(settings, router, paramsMap);
      }
    }
    // If no match is found, [WidgetsApp.onUnknownRoute] handles it.
    return null;
              """),
          ),
        )
        ..methods.add(
          Method(
            (b) => b
              ..name = 'onUnknownRoute'
              ..static = true
              ..returns = refer('Route<dynamic>?')
              ..requiredParameters.add(
                Parameter(
                  (b) => b
                    ..type = refer('RouteSettings')
                    ..name = 'settings',
                ),
              )
              ..optionalParameters.add(
                Parameter(
                  (b) => b
                    ..name = 'builder'
                    ..defaultTo = Code('const _DefaultCupertinoRouteBuilder()')
                    ..type = refer('RouteBuilder'),
                ),
              )
              ..body = Code('''
              if (_unknownPath == null) return null;
              return builder.build(settings, _unknownPath!, {});
              '''),
          ),
        ),
    );
  }

  Class _generateRouter(
    String className,
    List<PageModel> pages,
    DartType? paramParserType,
  ) {
    return Class(
      (b) => b
        ..name = '${className}Router'
        ..fields.add(_parserField(paramParserType))
        ..methods.addAll(
          pages.map(
            (page) {
              return Method(
                (b) => b
                  ..name = 'get${page.widgetName}RoutePath'
                  ..static = true
                  ..returns = refer('String')
                  ..optionalParameters.addAll(
                    page.params.map(_generateParam),
                  )
                  ..optionalParameters.add(
                    Parameter(
                      (b) => b
                        ..name = 'customQueryParams'
                        ..named = true
                        ..type = refer('Map<String, String>')
                        ..defaultTo = Code('const <String, String>{}'),
                    ),
                  )
                  ..body = _generateRouteCode(page),
              );
            },
          ),
        ),
    );
  }

  Parameter _generateParam(ParamsModel param) {
    switch (param.isArg) {
      case true:
        return Parameter(
          (b) => b
            ..type = refer(param.type + param.nullableSuffix, param.typeModule)
            ..named = true
            ..required = param.isRequired
            ..name = param.name,
        );
      default:
        return Parameter(
          (b) => b
            ..type = refer(param.type + param.nullableSuffix, param.typeModule)
            ..named = true
            ..required = param.isRequired
            ..name = param.name,
        );
    }
  }

  Code _generateRouteCode(PageModel page) {
    final uri = Uri.parse(page.path);
    var path = uri.path;
    final segments =
        uri.pathSegments.where((element) => element.startsWith(':'));
    for (final segment in segments) {
      path = path.replaceAll(segment, '\${_params["${segment.substring(1)}"]}');
    }
    final defaultParamsMap = <String, String>{};
    final query = <String, String>{};

    void _processParams(List<ParamsModel> params, [String? argName]) {
      for (final param in params) {
        final paramName =
            argName == null ? param.name : '${argName}.${param.name}';
        if (param.isRequired) {
          if (param.isArg) {
            _processParams(param.params, paramName);
          } else {
            defaultParamsMap['"${param.pathName}"'] = paramName;
          }
        } else {
          query['"${param.pathName}"'] = paramName;
        }
      }
      ;
    }

    _processParams(page.params);

    return Code('''
    var _params = <String, dynamic>$defaultParamsMap;
    var _query = <String, dynamic>$query;
    
    _query.addAll(customQueryParams);
    
    _query.removeWhere((key, value) => value == null);
    _params.removeWhere((key, value) => value == null);
    
    _query = _query.map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));
    _params = _params.map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));
    
    final _newUri = Uri(queryParameters: _query, path: '$path');
    if (_query.isEmpty) {
      return _newUri.path;
    } else {
      return _newUri.toString();
    }
    ''');
  }

  Code _generateDefaultBuilderSrc() {
    return Code('''
abstract class RouteBuilder {
  const RouteBuilder();

  Route<dynamic>? build(RouteSettings settings, RouterPath routerPath,
    Map<String, String> params);
}

class _DefaultCupertinoRouteBuilder implements RouteBuilder {
  const _DefaultCupertinoRouteBuilder();

  @override
  Route<dynamic>? build(RouteSettings settings, RouterPath routerPath,
      Map<String, String> params) {
    return CupertinoPageRoute(
      builder: (context) => routerPath.builder(context, params),
      settings: settings,
    );
  }
}
    ''');
  }
}
