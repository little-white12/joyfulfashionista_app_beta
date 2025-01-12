import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:joyfulfashionista_app/common/index.dart';
import 'package:joyfulfashionista_app/pages/index.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _MainViewGetX();
  }
}

class _MainViewGetX extends GetView<MainController> {
  const _MainViewGetX({Key? key}) : super(key: key);

  // main view
  Widget _buildView() {
    DateTime? lastPressedAt;
    return WillPopScope(
      // Prevent two consecutive clicks to exit
      onWillPop: () async {
        if (lastPressedAt == null ||
            DateTime.now().difference(lastPressedAt!) >
                const Duration(seconds: 1)) {
          lastPressedAt = DateTime.now();
          Loading.toast('Press again to exit');
          return false;
        }
        await SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        return true;
      },
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        // navigation bar
        bottomNavigationBar: GetBuilder<MainController>(
          id: 'navigation',
          builder: (controller) {
            return Obx(() => BuildNavigation(
                  currentIndex: controller.currentIndex,
                  items: [
                    NavigationItemModel(
                      label: LocaleKeys.tabBarHome.tr,
                      icon: AssetsSvgs.navHomeSvg,
                    ),
                    NavigationItemModel(
                      label: LocaleKeys.tabBarCart.tr,
                      icon: AssetsSvgs.navCartSvg,
                      // Cart quantity
                      count: CartService.to.lineItemsCount,
                    ),
                    NavigationItemModel(
                      label: LocaleKeys.tabBarMessage.tr,
                      icon: AssetsSvgs.navMessageSvg,
                      count: 1,
                    ),
                    NavigationItemModel(
                      label: LocaleKeys.tabBarProfile.tr,
                      icon: AssetsSvgs.navProfileSvg,
                    ),
                  ],
                  onTap: controller.onJumpToPage, // toggle tab event
                ));
          },
        ),
        // Content page
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.pageController,
          onPageChanged: controller.onIndexChanged,
          children: const [
            HomePage(),
            CartIndexPage(),
            MsgIndexPage(),
            MyIndexPage(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
      init: MainController(),
      id: "main",
      builder: (_) => _buildView(),
    );
  }
}
