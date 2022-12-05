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
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:flutter/material.dart' as _i10;
import 'package:vlad_diplome/data/utils/guards.dart' as _i11;
import 'package:vlad_diplome/ui/pages/employees.dart' as _i3;
import 'package:vlad_diplome/ui/pages/home.dart' as _i2;
import 'package:vlad_diplome/ui/pages/login.dart' as _i1;
import 'package:vlad_diplome/ui/pages/materials.dart' as _i8;
import 'package:vlad_diplome/ui/pages/materials_accounting.dart' as _i7;
import 'package:vlad_diplome/ui/pages/materials_types.dart' as _i6;
import 'package:vlad_diplome/ui/pages/stocks.dart' as _i4;
import 'package:vlad_diplome/ui/pages/vendors.dart' as _i5;

class AppRouter extends _i9.RootStackRouter {
  AppRouter({
    _i10.GlobalKey<_i10.NavigatorState>? navigatorKey,
    required this.checkIfUserLoggedIn,
  }) : super(navigatorKey);

  final _i11.CheckIfUserLoggedIn checkIfUserLoggedIn;

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    LoginPageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.LoginPage(),
      );
    },
    HomePageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.HomePage(),
      );
    },
    EmployeesPageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.EmployeesPage(),
      );
    },
    StocksListPageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.StocksListPage(),
      );
    },
    VendorsListPageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.VendorsListPage(),
      );
    },
    MaterialsTypesListPageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.MaterialsTypesListPage(),
      );
    },
    MaterialsAccountingPageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.MaterialsAccountingPage(),
      );
    },
    MaterialsListPageRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.MaterialsListPage(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/login',
          fullMatch: true,
        ),
        _i9.RouteConfig(
          LoginPageRoute.name,
          path: '/login',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          HomePageRoute.name,
          path: '',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          EmployeesPageRoute.name,
          path: '/employees',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          StocksListPageRoute.name,
          path: '/stocks',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          VendorsListPageRoute.name,
          path: '/vendors',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          MaterialsTypesListPageRoute.name,
          path: '/materialsTypes',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          MaterialsAccountingPageRoute.name,
          path: '/accounting',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          MaterialsAccountingPageRoute.name,
          path: '/accounting',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          MaterialsListPageRoute.name,
          path: '/materials',
          guards: [checkIfUserLoggedIn],
        ),
        _i9.RouteConfig(
          '*#redirect',
          path: '*',
          redirectTo: '/',
          fullMatch: true,
        ),
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginPageRoute extends _i9.PageRouteInfo<void> {
  const LoginPageRoute()
      : super(
          LoginPageRoute.name,
          path: '/login',
        );

  static const String name = 'LoginPageRoute';
}

/// generated route for
/// [_i2.HomePage]
class HomePageRoute extends _i9.PageRouteInfo<void> {
  const HomePageRoute()
      : super(
          HomePageRoute.name,
          path: '',
        );

  static const String name = 'HomePageRoute';
}

/// generated route for
/// [_i3.EmployeesPage]
class EmployeesPageRoute extends _i9.PageRouteInfo<void> {
  const EmployeesPageRoute()
      : super(
          EmployeesPageRoute.name,
          path: '/employees',
        );

  static const String name = 'EmployeesPageRoute';
}

/// generated route for
/// [_i4.StocksListPage]
class StocksListPageRoute extends _i9.PageRouteInfo<void> {
  const StocksListPageRoute()
      : super(
          StocksListPageRoute.name,
          path: '/stocks',
        );

  static const String name = 'StocksListPageRoute';
}

/// generated route for
/// [_i5.VendorsListPage]
class VendorsListPageRoute extends _i9.PageRouteInfo<void> {
  const VendorsListPageRoute()
      : super(
          VendorsListPageRoute.name,
          path: '/vendors',
        );

  static const String name = 'VendorsListPageRoute';
}

/// generated route for
/// [_i6.MaterialsTypesListPage]
class MaterialsTypesListPageRoute extends _i9.PageRouteInfo<void> {
  const MaterialsTypesListPageRoute()
      : super(
          MaterialsTypesListPageRoute.name,
          path: '/materialsTypes',
        );

  static const String name = 'MaterialsTypesListPageRoute';
}

/// generated route for
/// [_i7.MaterialsAccountingPage]
class MaterialsAccountingPageRoute extends _i9.PageRouteInfo<void> {
  const MaterialsAccountingPageRoute()
      : super(
          MaterialsAccountingPageRoute.name,
          path: '/accounting',
        );

  static const String name = 'MaterialsAccountingPageRoute';
}

/// generated route for
/// [_i8.MaterialsListPage]
class MaterialsListPageRoute extends _i9.PageRouteInfo<void> {
  const MaterialsListPageRoute()
      : super(
          MaterialsListPageRoute.name,
          path: '/materials',
        );

  static const String name = 'MaterialsListPageRoute';
}
