import 'package:auto_route/auto_route.dart';
import 'package:vlad_diplome/data/utils/guards.dart';
import 'package:vlad_diplome/ui/pages/home.dart';
import 'package:vlad_diplome/ui/pages/login.dart';
import 'package:vlad_diplome/ui/pages/employees.dart';
import 'package:vlad_diplome/ui/pages/materials.dart';
import 'package:vlad_diplome/ui/pages/materials_accounting.dart';
import 'package:vlad_diplome/ui/pages/materials_types.dart';

const String loginPath = "/login";
const String employeesPath = "/employees";
const String materialsPath = "/materials";
const String materialsTypesPath = "/materialsTypes";
const String materialsAccountingPath = "/accounting";
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
      page: MaterialsAccountingPage,
      path: materialsAccountingPath,
      guards: [CheckIfUserLoggedIn]
    ),
    AutoRoute(
      page: MaterialsAccountingPage,
      path: materialsAccountingPath,
      guards: [CheckIfUserLoggedIn]
    ),
    AutoRoute(
      page: MaterialsListPage,
      path: materialsPath,
      guards: [CheckIfUserLoggedIn]
    ),
    RedirectRoute(path: '*', redirectTo: "/")
  ],
)

class $AppRouter {}