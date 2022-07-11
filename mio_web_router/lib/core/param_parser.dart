abstract class ParamParser {
  const ParamParser();

  T? parse<T>(String? param);

  String parseToUri<T>(T? param);
}

class DefaultParamParser extends ParamParser {
  const DefaultParamParser();

  @override
  T? parse<T>(String? param) {
    switch (T) {
      case String:
        return param as T?;
      case int:
        return int.tryParse(param ?? '') as T?;
      case double:
        return double.tryParse(param ?? '') as T?;
      case bool:
        return (param == null ? null : param == 'true') as T?;
      default:
        return param as T?;
    }
  }

  @override
  String parseToUri<T>(T? param) {
    if (param == null) return '';

    switch (T) {
      case String:
        return param as String;
      case int:
        return param.toString();
      case double:
        return (param as double).toStringAsFixed(2);
      case bool:
        return (param as bool).toString();
      default:
        return param.toString();
    }
  }

}