class RouterPath {
  const RouterPath({
    required this.path,
    required this.builder,
  });

  final String path;
  final dynamic Function(dynamic, Map<String, String>) builder;
}
