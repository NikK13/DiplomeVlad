import 'package:auto_route/auto_route.dart';
import 'package:vlad_diplome/data/utils/guards.dart';
import 'package:vlad_diplome/ui/pages/home.dart';
import 'package:vlad_diplome/ui/pages/login.dart';
import 'package:vlad_diplome/ui/pages/employees.dart';
import 'package:vlad_diplome/ui/pages/materials_details.dart';
import 'package:vlad_diplome/ui/pages/materials_types.dart';

const String loginPath = "/login";
const String employeesPath = "/employees";
const String materialsTypesPath = "/materialsTypes";
const String materialsListsPath = "/materials";
const String settingsPagePath = "/settings";
const String homePath = "";

@AdaptiveAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(
      initial: true,
      page: LoginPage,
      path: loginPath,
      guards: [CheckIfUserLoggedIn]
    ),
    AutoRoute(
      page: HomePage,
      path: homePath,
      guards: [CheckIfUserLoggedIn]
    ),
    AutoRoute(
      page: EmployeesPage,
      path: employeesPath,
      guards: [CheckIfUserLoggedIn]
    ),
    AutoRoute(
      page: MaterialsTypesListPage,
      path: materialsTypesPath,
      guards: [CheckIfUserLoggedIn]
    ),
    AutoRoute(
      page: MaterialsDetailsListPage,
      path: materialsListsPath,
      guards: [CheckIfUserLoggedIn]
    ),
    RedirectRoute(path: '*', redirectTo: "/")
  ],
)

class $AppRouter {}