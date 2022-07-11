<p>
<a href="https://img.shields.io/badge/License-MIT-green"><img
align="center" src="https://img.shields.io/badge/License-MIT-green" alt="MIT License"></a>
<a href="https://pub.dev/packages/mio_web_router"><img
align="center" src="https://img.shields.io/badge/pub-0.0.1-orange" alt="pub version"></a>
</p>

---

- [Installation](#installation)
- [Setup](#setup)
- [Registering route](#registering-route)
- [Registering route with arguments](#registering-route-with-arguments)
- [Navigation](#navigation)

## Installation

```yaml
dependencies:
  # add mio_web_router to your dependencies
  mio_web_router:

dev_dependencies:
  # add the generator to your dev_dependencies
  mio_web_router_generator:
  # add build runner if not already added
  build_runner:
```

## Setup

---

1. Define a top-level class (lets call it Application) then annotate it with @InitRouter().
2. Call the **Generated** func ```ApplicationRouteGenerator.onGenerateRoute``` and ```ApplicationRouteGenerator.onUnknownRoute``` in your application params.

```dart
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
      onUnknownRoute: ApplicationRouteGenerator.onUnknownRoute,
    );
  }
}
```
Note: you can tell mio_web_router what directories to generate for using the generateForDir property inside of @InitRouter.
The following example will only process files inside of the test folder.

```dart
@InitRouter(generateForDir: ['test'])
```

## Registering route

---

All you have to do now is annotate your route page classes with @RoutePage and let the generator do the work.

```dart
@RoutePage(path: '/')
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

@RoutePage(path: '/users/:uuid')
class UserPage extends StatefulWidget {
  final String uuid;

  const UserPage({Key? key, required this.uuid}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}
```

## Registering route with arguments

---

```dart
class UserTestPageArgs {
  final String userUuid;
  final String testUuid;

  UserTestPageArgs({
    @RoutePageParam(paramName: 'uuid') required this.userUuid,
    required this.testUuid,
  });
}

@RoutePage(path: '/users/:uuid/:testUuid')
class UserTestPage extends StatelessWidget {
  final UserTestPageArgs args;

  const UserTestPage({
    Key? key,
    @RoutePageArgs() required this.args,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User uuid: ${args.userUuid}'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Test uuid: ${args.testUuid}'),
      ),
    );
  }
}
```


## Navigation

---

```dart
//for empty page constructor
Navigator.of(context).pushNamed(ApplicationRouter.getUsersPageRoutePath());

//with named params
Navigator.of(context).pushNamed(ApplicationRouter.getUserPageRoutePath(uuid: uuid));

//with arguments model
Navigator.of(context).pushNamed(
  ApplicationRouter.getUserTestPageRoutePath(
    args: UserTestPageArgs(
      userUuid: uuid,
      testUuid: testUuid,
    ),
  ),
);
```
