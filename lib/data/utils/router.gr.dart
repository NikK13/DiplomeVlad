// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:vlad_diplome/data/utils/guards.dart' as _i9;
import 'package:vlad_diplome/ui/pages/employees.dart' as _i3;
import 'package:vlad_diplome/ui/pages/home.dart' as _i2;
import 'package:vlad_diplome/ui/pages/login.dart' as _i1;
import 'package:vlad_diplome/ui/pages/materials.dart' as _i6;
import 'package:vlad_diplome/ui/pages/materials_accounting.dart' as _i5;
import 'package:vlad_diplome/ui/pages/materials_types.dart' as _i4;

class AppRouter extends _i7.RootStackRouter {
  AppRouter({
    _i8.GlobalKey<_i8.NavigatorState>? navigatorKey,
    required this.checkIfUserLoggedIn,
  }) : super(navigatorKey);

  final _i9.CheckIfUserLoggedIn checkIfUserLoggedIn;

  @override
  final Map<String, _i7.PageFactory> pagesMap = {
    LoginPageRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.LoginPage(),
      );
    },
    HomePageRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    EmployeesPageRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.EmployeesPage(),
      );
    },
    MaterialsTypesListPageRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.MaterialsTypesListPage(),
      );
    },
    MaterialsAccountingPageRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.MaterialsAccountingPage(),
      );
    },
    MaterialsListPageRoute.name: (routeData) {
      return _i7.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.MaterialsListPage(),
      );
    },
  };

  @override
  List<_i7.RouteConfig> get routes => [
        _i7.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/login',
          fullMatch: true,
        ),
        _i7.RouteConfig(
          LoginPageRoute.name,
          path: '/login',
          guards: [checkIfUserLoggedIn],
        ),
        _i7.RouteConfig(
          HomePageRoute.name,
          path: '',
          guards: [checkIfUserLoggedIn],
        ),
        _i7.RouteConfig(
          EmployeesPageRoute.name,
          path: '/employees',
          guards: [checkIfUserLoggedIn],
        ),
        _i7.RouteConfig(
          MaterialsTypesListPageRoute.name,
          path: '/materialsTypes',
          guards: [checkIfUserLoggedIn],
        ),
        _i7.RouteConfig(
          MaterialsAccountingPageRoute.name,
          path: '/accounting',
          guards: [checkIfUserLoggedIn],
        ),
        _i7.RouteConfig(
          MaterialsAccountingPageRoute.name,
          path: '/accounting',
          guards: [checkIfUserLoggedIn],
        ),
        _i7.RouteConfig(
          MaterialsListPageRoute.name,
          path: '/materials',
          guards: [checkIfUserLoggedIn],
        ),
        _i7.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginPageRoute extends _i7.PageRouteInfo<void> {
  const LoginPageRoute()
      : super(
          LoginPageRoute.name,
          path: '/login',
        );

  static const String name = 'LoginPageRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomePageRoute extends _i7.PageRouteInfo<void> {
  const HomePageRoute()
      : super(
          HomePageRoute.name,
          path: '',
        );

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i3.EmployeesPage]
class EmployeesPageRoute extends _i7.PageRouteInfo<void> {
  const EmployeesPageRoute()
      : super(
          EmployeesPageRoute.name,
          path: '/employees',
        );

  static const String name = 'EmployeesPageRoute';
}

/// generated route for
/// [_i4.MaterialsTypesListPage]
class MaterialsTypesListPageRoute extends _i7.PageRouteInfo<void> {
  const MaterialsTypesListPageRoute()
      : super(
          MaterialsTypesListPageRoute.name,
          path: '/materialsTypes',
        );

  static const String name = 'MaterialsTypesListPageRoute';
}

/// generated route for
/// [_i5.MaterialsAccountingPage]
class MaterialsAccountingPageRoute extends _i7.PageRouteInfo<void> {
  const MaterialsAccountingPageRoute()
      : super(
          MaterialsAccountingPageRoute.name,
          path: '/accounting',
        );

  static const String name = 'MaterialsAccountingPageRoute';
}

/// generated route for
/// [_i6.MaterialsListPage]
class MaterialsListPageRoute extends _i7.PageRouteInfo<void> {
  const MaterialsListPageRoute()
      : super(
          MaterialsListPageRoute.name,
          path: '/materials',
        );

  static const String name = 'MaterialsListPageRoute';
}
