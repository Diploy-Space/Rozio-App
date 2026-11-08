import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/features/pos/controllers/barcode_scan_controller.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/dashboard/controllers/bottom_menu_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/features/dashboard/widgets/gradient_border_widget.dart';
import 'package:sixvalley_vendor_app/features/menu/widgets/menu_widget.dart';



class NavBarScreen extends StatefulWidget {
  const NavBarScreen({super.key});

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  final PageStorageBucket bucket = PageStorageBucket();

  void _loadData(){

  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<BottomMenuController>(builder: (context,menuController,_) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        body: PageStorage(bucket: bucket, child: menuController.currentScreen),
        floatingActionButton: UnicornOutlineButtonWidget(strokeWidth: 0, radius: 50,
          gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor
          ],
              begin: Alignment.topCenter, end: Alignment.bottomCenter),

          child: FloatingActionButton(backgroundColor: Theme.of(context).primaryColor, elevation: 1,
            onPressed: (){
            Provider.of<BarcodeScanController>(context,listen: false).scanProductBarCode(context);
            },


              child: Padding(padding: const EdgeInsets.all(15.0),
                  child: Image.asset(Images.scanner)))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(height: 60,
          decoration: BoxDecoration(color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha:0.14),
              blurRadius: 80, offset: const Offset(0, 20)),
            BoxShadow(color: Theme.of(context).cardColor,
                blurRadius: 0.5, offset: const Offset(0, 0)),]),

          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _BottomNavItem(tap: () => menuController.selectHomePage(),
                icon: Images.pos,
                name: getTranslated('pos', context)!, isSelected: menuController.currentTab == 0,),
              _BottomNavItem(tap: () => menuController.selectPosScreen(),
                icon: Images.order, name: getTranslated('my_order', context)!, isSelected: menuController.currentTab == 1),
              const SizedBox(height: 20, width: 20),
              _BottomNavItem(tap: () => menuController.selectItemsScreen(),
                icon: Images.productIcon, name: getTranslated('products', context)!, isSelected: menuController.currentTab == 2,
              ),
              _BottomNavItem(tap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (con) => const MenuBottomSheetWidget()
                );
              },
                icon: Images.menu, name: getTranslated('menu', context)!, isSelected: menuController.currentTab == 3,
              ),
            ],
          ),
        ),
      );
    });


  }
}

class _BottomNavItem extends StatelessWidget {
  final String icon;
  final String name;
  final VoidCallback? tap;
  final bool isSelected;

  const _BottomNavItem({
    required this.icon,
    required this.name,
    this.tap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.headlineMedium?.color;
    return InkWell(onTap: tap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
          SizedBox(height: Dimensions.navbarIconSize, width: Dimensions.navbarIconSize,
            child: Image.asset(icon, fit: BoxFit.contain, color: color),
          ),
          const SizedBox(height: 6.0),

          Text(name, style: TextStyle(color: color, fontSize: Dimensions.navbarFontSize, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}


