import 'package:code_factory_middle/common/view/root_tab.dart';
import 'package:code_factory_middle/common/view/splash_screen.dart';
import 'package:code_factory_middle/restaurant/view/restaurant_detail_screen.dart';
import 'package:code_factory_middle/user/model/user_model.dart';
import 'package:code_factory_middle/user/provider/user_me_provider.dart';
import 'package:code_factory_middle/user/view/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final authProvider = ChangeNotifierProvider(
  (ref) => AuthProvider(ref: ref),
);

class AuthProvider extends ChangeNotifier {
  final Ref ref;

  AuthProvider({
    required this.ref,
  }) {
    ref.listen<UserModelBase?>(userMeProvider, (previous, next) {
      // listen 을 하면 userMeProvider 에서 반환하는 UserModel 이
      // Loading, Error 등을 확인할 수 있다.
      if (previous != next) {
        // 변경사항이 생겼을 때만 알려준다.
        notifyListeners();
      }
    });
  }

  List<GoRoute> get routes => [
        GoRoute(
          path: '/',
          name: RootTab.routeName,
          builder: (context, state) => RootTab(),
          routes: [
            GoRoute(
              path: 'restaurant/:rid',
              builder: (_, state) => RestaurantDetailScreen(
                id: state.pathParameters['rid']!,
              ),
            ),
          ],
        ),
        GoRoute(
          path: '/splash',
          name: SplashScreen.routeName,
          builder: (context, state) => SplashScreen(),
        ),
        GoRoute(
          path: '/login',
          name: LoginScreen.routeName,
          builder: (context, state) => LoginScreen(),
        ),
      ];

  // SplashScreen 로직
  // 앱이 처음 시작하면 토큰 여부로 로그인 스크린에 보내거나 홈 스크린 으로 보낸다.
  String? redirectLogic(BuildContext context, GoRouterState state) {
    final UserModelBase? user = ref.read(userMeProvider);

    // loggingIn: 로그인을 하려는 상태 인지. 로그인 화면에 있으면 그 상태이다.
    final loggingIn = state.location == '/login';

    // 유저 정보가 없는데
    // 로그인 중이면 그대로 로그인 페이지에 둔다.
    // 만약에 로그인중이 아니라면 로그인 페이지로 이동!!
    if (user == null) {
      return loggingIn ? null : '/login';
    }

    // UserModel 사용자 정보가 있는 상태면
    // 로그인 중이거나 현재 위치가 SlashScreen 이면 홈으로 이동
    if (user is UserModel) {
      return loggingIn || state.location == '/splash' ? '/' : null;
    }

    // UserModelError
    // 로그인 하는 중이 아니라면 로그인 페이지로 보내면 된다.
    // 여기서 로그아웃 로직까지 있으면 좋다.
    if (user is UserModelError) {
      return !loggingIn ? '/login' : null;
    }

    // 나머지는 모두 가던길 가라.
    return null;
  }
}
