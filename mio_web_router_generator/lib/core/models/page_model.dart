class PageModel {
  final String path;
  final String widgetName;
  final String widgetModule;
  final List<ParamsModel> params;

  PageModel(this.path, this.widgetName, this.widgetModule, this.params);

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      json['path'],
      json['widgetName'],
      json['widgetModule'],
      json['params']
          .map((e) => ParamsModel.fromJson(e))
          .toList()
          .cast<ParamsModel>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'widgetName': widgetName,
        'widgetModule': widgetModule,
        'params': params.map((e) => e.toJson()).toList(),
      };
}

class ParamsModel {
  final bool isRequired;
  final bool isArg;
  final String nullableSuffix;
  final String name;

  ///ignored if [isArg] == true
  final String pathName;
  final String type;
  final String typeModule;
  final List<ParamsModel> params;

  ParamsModel(
    this.isRequired,
    this.isArg,
    this.name,
    this.pathName,
    this.type,
    this.typeModule,
    this.nullableSuffix,
    this.params,
  );

  factory ParamsModel.fromJson(Map<String, dynamic> json) {
    return ParamsModel(
      json['isRequired'],
      json['isArg'],
      json['name'],
      json['pathName'],
      json['type'],
      json['typeModule'],
      json['nullableSuffix'],
      json['params']
          .map((e) => ParamsModel.fromJson(e))
          .toList()
          .cast<ParamsModel>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'isRequired': isRequired,
        'isArg': isArg,
        'name': name,
        'pathName': pathName,
        'type': type,
        'typeModule': typeModule,
        'nullableSuffix': nullableSuffix,
        'params': params.map((e) => e.toJson()).toList(),
      };
}
