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
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;
import 'package:vlad_diplome/data/utils/guards.dart' as _i8;
import 'package:vlad_diplome/ui/pages/employees.dart' as _i3;
import 'package:vlad_diplome/ui/pages/home.dart' as _i2;
import 'package:vlad_diplome/ui/pages/login.dart' as _i1;
import 'package:vlad_diplome/ui/pages/materials_details.dart' as _i5;
import 'package:vlad_diplome/ui/pages/materials_types.dart' as _i4;

class AppRouter extends _i6.RootStackRouter {
  AppRouter({
    _i7.GlobalKey<_i7.NavigatorState>? navigatorKey,
    required this.checkIfUserLoggedIn,
  }) : super(navigatorKey);

  final _i8.CheckIfUserLoggedIn checkIfUserLoggedIn;

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    LoginPageRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.LoginPage(),
      );
    },
    HomePageRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    EmployeesPageRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.EmployeesPage(),
      );
    },
    MaterialsTypesListPageRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.MaterialsTypesListPage(),
      );
    },
    MaterialsDetailsListPageRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.MaterialsDetailsListPage(),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/login',
          fullMatch: true,
        ),
        _i6.RouteConfig(
          LoginPageRoute.name,
          path: '/login',
          guards: [checkIfUserLoggedIn],
        ),
        _i6.RouteConfig(
          HomePageRoute.name,
          path: '',
          guards: [checkIfUserLoggedIn],
        ),
        _i6.RouteConfig(
          EmployeesPageRoute.name,
          path: '/employees',
          guards: [checkIfUserLoggedIn],
        ),
        _i6.RouteConfig(
          MaterialsTypesListPageRoute.name,
          path: '/materialsTypes',
          guards: [checkIfUserLoggedIn],
        ),
        _i6.RouteConfig(
          MaterialsDetailsListPageRoute.name,
          path: '/materials',
          guards: [checkIfUserLoggedIn],
        ),
        _i6.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginPageRoute extends _i6.PageRouteInfo<void> {
  const LoginPageRoute()
      : super(
          LoginPageRoute.name,
          path: '/login',
        );

  static const String name = 'LoginPageRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomePageRoute extends _i6.PageRouteInfo<void> {
  const HomePageRoute()
      : super(
          HomePageRoute.name,
          path: '',
        );

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i3.EmployeesPage]
class EmployeesPageRoute extends _i6.PageRouteInfo<void> {
  const EmployeesPageRoute()
      : super(
          EmployeesPageRoute.name,
          path: '/employees',
        );

  static const String name = 'EmployeesPageRoute';
}

/// generated route for
/// [_i4.MaterialsTypesListPage]
class MaterialsTypesListPageRoute extends _i6.PageRouteInfo<void> {
  const MaterialsTypesListPageRoute()
      : super(
          MaterialsTypesListPageRoute.name,
          path: '/materialsTypes',
        );

  static const String name = 'MaterialsTypesListPageRoute';
}

/// generated route for
/// [_i5.MaterialsDetailsListPage]
class MaterialsDetailsListPageRoute extends _i6.PageRouteInfo<void> {
  const MaterialsDetailsListPageRoute()
      : super(
          MaterialsDetailsListPageRoute.name,
          path: '/materials',
        );

  static const String name = 'MaterialsDetailsListPageRoute';
}
