// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// WebRouterGenerator
// **************************************************************************

import 'package:flutter/cupertino.dart';
import 'package:mio_web_router/mio_web_router.dart';
import 'package:mio_web_router/core/param_parser.dart';
import 'package:example/pages/home/home_page.dart';
import 'package:example/pages/users/test/user_test_page.dart';
import 'package:example/pages/users/user_page.dart';
import 'package:example/pages/users/users_page.dart';
import 'package:example/pages/users/test/user_test_page_args.dart';

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

class ApplicationRouteGenerator {
  static const ParamParser _paramParser = DefaultParamParser();

  static final List<RouterPath> _paths = [
    RouterPath(path: "/", builder: (ctx, map) => const HomePage()),
    RouterPath(
        path: "/users/:uuid/:testUuid",
        builder: (ctx, map) => UserTestPage(
            args: UserTestPageArgs(
                userUuid: _paramParser.parse(map["uuid"]),
                testUuid: _paramParser.parse(map["testUuid"])))),
    RouterPath(
        path: "/users/:uuid",
        builder: (ctx, map) => UserPage(
            uuid: _paramParser.parse(map["uuid"]),
            showSubtitle: _paramParser.parse(map["showSubtitle"]))),
    RouterPath(path: "/users", builder: (ctx, map) => const UsersPage())
  ];

  static final RouterPath? _unknownPath = null;

  static Route<dynamic>? onGenerateRoute(RouteSettings settings,
      [RouteBuilder builder = const _DefaultCupertinoRouteBuilder()]) {
    final requestUri = Uri.parse(settings.name ?? '');
    path:
    for (RouterPath router in _paths) {
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
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings,
      [RouteBuilder builder = const _DefaultCupertinoRouteBuilder()]) {
    if (_unknownPath == null) return null;
    return builder.build(settings, _unknownPath!, {});
  }
}

class ApplicationRouter {
  static const ParamParser _paramParser = DefaultParamParser();

  static String getHomePageRoutePath(
      {Map<String, String> customQueryParams = const <String, String>{}}) {
    var _params = <String, dynamic>{};
    var _query = <String, dynamic>{};

    _query.addAll(customQueryParams);

    _query.removeWhere((key, value) => value == null);
    _params.removeWhere((key, value) => value == null);

    _query = _query
        .map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));
    _params = _params
        .map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));

    final _newUri = Uri(queryParameters: _query, path: '/');
    if (_query.isEmpty) {
      return _newUri.path;
    } else {
      return _newUri.toString();
    }
  }

  static String getUserTestPageRoutePath(
      {required UserTestPageArgs args,
      Map<String, String> customQueryParams = const <String, String>{}}) {
    var _params = <String, dynamic>{
      "uuid": args.userUuid,
      "testUuid": args.testUuid
    };
    var _query = <String, dynamic>{};

    _query.addAll(customQueryParams);

    _query.removeWhere((key, value) => value == null);
    _params.removeWhere((key, value) => value == null);

    _query = _query
        .map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));
    _params = _params
        .map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));

    final _newUri = Uri(
        queryParameters: _query,
        path: '/users/${_params["uuid"]}/${_params["testUuid"]}');
    if (_query.isEmpty) {
      return _newUri.path;
    } else {
      return _newUri.toString();
    }
  }

  static String getUserPageRoutePath(
      {required String uuid,
      bool? showSubtitle,
      Map<String, String> customQueryParams = const <String, String>{}}) {
    var _params = <String, dynamic>{"uuid": uuid};
    var _query = <String, dynamic>{"showSubtitle": showSubtitle};

    _query.addAll(customQueryParams);

    _query.removeWhere((key, value) => value == null);
    _params.removeWhere((key, value) => value == null);

    _query = _query
        .map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));
    _params = _params
        .map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));

    final _newUri =
        Uri(queryParameters: _query, path: '/users/${_params["uuid"]}');
    if (_query.isEmpty) {
      return _newUri.path;
    } else {
      return _newUri.toString();
    }
  }

  static String getUsersPageRoutePath(
      {Map<String, String> customQueryParams = const <String, String>{}}) {
    var _params = <String, dynamic>{};
    var _query = <String, dynamic>{};

    _query.addAll(customQueryParams);

    _query.removeWhere((key, value) => value == null);
    _params.removeWhere((key, value) => value == null);

    _query = _query
        .map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));
    _params = _params
        .map((key, value) => MapEntry(key, _paramParser.parseToUri(value)));

    final _newUri = Uri(queryParameters: _query, path: '/users');
    if (_query.isEmpty) {
      return _newUri.path;
    } else {
      return _newUri.toString();
    }
  }
}
