import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:mio_web_router/mio_web_router.dart';
import 'package:mio_web_router_generator/core/models/page_model.dart';
import 'package:source_gen/source_gen.dart';

class WebRouteAnnotationGenerator extends GeneratorForAnnotation<RoutePage> {
  @override
  generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ClassElement) {
      final name = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Remove the [RoutePage] annotation from `$name`.',
      );
    }

    final routePage = RoutePage(
      path: annotation.peek('path')?.stringValue ?? '',
    );

    if (routePage.path.trim().isEmpty) {
      final name = element.displayName;
      throw InvalidGenerationSourceError(
        'Generator cannot target `$name`.',
        todo: 'Empty [RoutePage.path] for `$name`.',
      );
    }

    final params = <ParamsModel>[];
    element.unnamedConstructor?.parameters
        .where((element) => element.name != 'key')
        .forEach(
      (e) {
        if (e.metadata.any(
            (metadata) => metadata.element?.displayName == 'RoutePageArgs')) {
          params.add(_processArgsParam(e));
        } else {
          params.add(_processDefaultParam(e));
        }
      },
    );

    final pageModel = PageModel(
      routePage.path,
      element.displayName,
      element.library.identifier,
      params,
    );

    return jsonEncode(pageModel.toJson());
  }

  String _getNullableSuffix(NullabilitySuffix nullabilitySuffix) {
    switch (nullabilitySuffix) {
      case NullabilitySuffix.question:
        return '?';
      case NullabilitySuffix.star:
        return '*';
      case NullabilitySuffix.none:
        return '';
    }
  }

  ParamsModel _processArgsParam(ParameterElement parameterElement) {
    final argParams = <ParamsModel>[];
    if (parameterElement.type.element is ClassElement) {
      final classElement = parameterElement.type.element as ClassElement;
      classElement.unnamedConstructor?.parameters.forEach((element) {
        argParams.add(_processDefaultParam(element));
      });
    }

    return _crateModel(parameterElement, true, parameterElement.name, argParams);
  }

  ParamsModel _processDefaultParam(ParameterElement parameterElement) {
    var paramName = parameterElement.name;
    if (parameterElement.metadata
        .any((metadata) => metadata.element?.displayName == 'RoutePageParam')) {
      final annotation = parameterElement.metadata.firstWhere(
          (metadata) => metadata.element?.displayName == 'RoutePageParam');
      final name = annotation
              .computeConstantValue()
              ?.getField('paramName')
              ?.toStringValue() ??
          '';
      if (name.isNotEmpty) {
        paramName = name;
      }
    }

    return _crateModel(parameterElement, false, paramName, []);
  }

  ParamsModel _crateModel(ParameterElement parameterElement, bool isArg, String pathName, List<ParamsModel> params) {
    return ParamsModel(
      parameterElement.isRequired,
      isArg,
      parameterElement.name,
      pathName,
      parameterElement.type.element?.name ?? '',
      parameterElement.type.element?.library?.identifier ?? '',
      _getNullableSuffix(parameterElement.type.nullabilitySuffix),
      params,
    );
  }
}
