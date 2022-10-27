 
import 'package:auto_route/auto_route.dart';
import 'package:blink_comparison/injector.dart';
import 'package:blink_comparison/ui/app_router.gr.dart';
import 'package:blink_comparison/ui/settings/page/appearance_cubit.dart';
import 'package:blink_comparison/ui/settings/settings_pages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../locale.dart';
import 'model.dart';
import 'page/camera_cubit.dart';

class SettingsPage extends StatefulWidget with AutoRouteWrapper {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppearanceSettingsCubit>(
          create: (context) => getIt<AppearanceSettingsCubit>(),
        ),
        BlocProvider<CameraSettingsCubit>(
          create: (context) => getIt<CameraSettingsCubit>(),
        ),
      ],
      child: this,
    );
  }
}

class _SettingsPageState extends State<SettingsPage> {
  final _routerKey = GlobalKey<AutoRouterState>();
  final _tabsKey = GlobalKey<AutoTabsRouterState>();

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: AutoRouter(
        key: _routerKey,
      ),
      tablet: _TwoPaneBody(
        initRoute: SettingsRouteItem.all.first,
        tabsKey: _tabsKey,
      ),
    );
  }
}

class _TwoPaneBody extends StatefulWidget {
  final SettingsRouteItem initRoute;
  final GlobalKey<AutoTabsRouterState> tabsKey;

  const _TwoPaneBody({
    Key? key,
    required this.initRoute,
    required this.tabsKey,
  }) : super(key: key);

  @override
  _TwoPaneBodyState createState() => _TwoPaneBodyState();
}

class _TwoPaneBodyState extends State<_TwoPaneBody> {
  late SettingsRouteItem _currentRoute;
  final List<PageRouteInfo> _routes = SettingsRouteItem.all
      .map(
        (r) => r.when(
          appearance: () => const AppearanceSettingsRoute(),
          camera: () => const CameraSettingsRoute(),
        ),
      )
      .toList();

  @override
  void initState() {
    super.initState();

    _currentRoute = widget.initRoute;
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).settings,
        ),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final int pagesListFlex =
              orientation == Orientation.landscape ? 2 : 3;
          const int pageFlex = 7;

          final mediaQuery = MediaQuery.of(context);
          final startPadding = textDirection == TextDirection.rtl
              ? mediaQuery.padding.right
              : mediaQuery.padding.left;
          final width = mediaQuery.size.width;
          final flexSum = pagesListFlex + pageFlex;
          final pagesListWidth =
              (pagesListFlex * width) / flexSum + startPadding;
          final pageWidth = (pageFlex * width) / flexSum - startPadding;

          return Row(
            children: [
              Container(
                width: pagesListWidth,
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    end: BorderSide(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                child: SettingsPagesList(
                  selectedRoute: _currentRoute,
                  onSelected: (route) {
                    setState(() => _currentRoute = route);
                    _onSelected(route);
                  },
                ),
              ),
              SizedBox(
                width: pageWidth,
                child: MediaQuery.removePadding(
                  context: context,
                  removeLeft: textDirection != TextDirection.rtl,
                  removeRight: textDirection == TextDirection.rtl,
                  child: AutoTabsRouter(
                    key: widget.tabsKey,
                    routes: _routes,
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void _onSelected(SettingsRouteItem route) {
    widget.tabsKey.currentState?.controller?.setActiveIndex(
      SettingsRouteItem.all.indexOf(route),
    );
  }
}
