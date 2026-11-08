import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/paginated_list_view_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/retail_wholesale_tab_widget.dart';
import 'package:sixvalley_vendor_app/features/transaction/widgets/transaction_shimmer_widget.dart';
import 'package:sixvalley_vendor_app/helper/color_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/features/transaction/controllers/transaction_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/transaction/controllers/wholesale_transaction_controller.dart';
import 'package:sixvalley_vendor_app/features/wholesale/transaction/widgets/wholesale_transaction_widget.dart';
import 'package:sixvalley_vendor_app/theme/controllers/theme_controller.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/custom_app_bar_widget.dart';
import 'package:sixvalley_vendor_app/common/basewidgets/no_data_screen.dart';
import 'package:sixvalley_vendor_app/features/transaction/widgets/transaction_widget.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> with SingleTickerProviderStateMixin {

  late final TabController _orderTypeTabController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _wholesaleScrollController = ScrollController();
  bool _wholesaleLoaded = false;

  void _loadData(BuildContext context){
    Provider.of<TransactionController>(context, listen: false).getTransactionList(context, 'all','','');
    Provider.of<TransactionController>(context, listen: false).initMonthTypeList();
    Provider.of<TransactionController>(context, listen: false).initYearList();
  }

  double filterHeight = 45;


  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _orderTypeTabController = TabController(length: 2, vsync: this);
    _orderTypeTabController.addListener(() {
      if(!_orderTypeTabController.indexIsChanging) {
        if(_orderTypeTabController.index == 1 && !_wholesaleLoaded) {
          _wholesaleLoaded = true;
          Provider.of<WholesaleTransactionController>(context, listen: false).setIndex(context, 0);
        }
        setState(() {});
      }
    });
    _loadData(context);
  }

  @override
  void dispose() {
    _orderTypeTabController.dispose();
    _scrollController.dispose();
    _wholesaleScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Navigator.canPop(context),
      onPopInvokedWithResult: (didPop, result) async{
        Provider.of<TransactionController>(context, listen: false).getTransactionList(context, 'all','','');
      },
      child: Scaffold(
        appBar: CustomAppBarWidget(title: getTranslated('transactions', context), isAction: true),
        body: Consumer<TransactionController>(
          builder: (context, transactionProvider, child) {

            return Column(children: [
                RetailWholesaleTabWidget(controller: _orderTypeTabController),

                SizedBox(height: 65,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      TransactionTypeButton(text: 'all', index: 0, isWholesale: _orderTypeTabController.index == 1),
                      TransactionTypeButton(text: 'pending', index: 1, isWholesale: _orderTypeTabController.index == 1),
                      TransactionTypeButton(text: 'approved', index: 2, isWholesale: _orderTypeTabController.index == 1),
                      TransactionTypeButton(text: 'denied', index: 3, isWholesale: _orderTypeTabController.index == 1),
                    ],
                  )),

                Expanded(child: _orderTypeTabController.index != 0 ? _WholesaleTransactionListView(scrollController: _wholesaleScrollController) :
                  transactionProvider.transactionList != null ? transactionProvider.transactionList!.isNotEmpty ?

                 SingleChildScrollView(
                   controller: _scrollController,
                   child: PaginatedListViewWidget(
                     scrollController: _scrollController,
                     totalSize: transactionProvider.transactionTotalSize,
                     offset: transactionProvider.transactionOffset,
                     onPaginate: (int? offset) async {
                       await transactionProvider.loadMoreTransactions(context, offset ?? 1);
                     },
                     itemView: ListView.builder(
                       itemCount: transactionProvider.transactionList!.length,
                       padding: EdgeInsets.zero,
                       physics: const NeverScrollableScrollPhysics(),
                       shrinkWrap: true,
                       itemBuilder: (context, index) => TransactionWidget(transactionModel: transactionProvider.transactionList![index]),
                     ),
                   ),
                 ) : const NoDataScreen() : const TransactionShimmerWidget(),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

class _WholesaleTransactionListView extends StatelessWidget {
  final ScrollController scrollController;
  const _WholesaleTransactionListView({required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<WholesaleTransactionController>(
      builder: (context, wholesaleTransactionController, child) {
        final transactionList = wholesaleTransactionController.transactionList;

        return transactionList != null ? transactionList.isNotEmpty ?
        SingleChildScrollView(
          controller: scrollController,
          child: PaginatedListViewWidget(
            scrollController: scrollController,
            totalSize: wholesaleTransactionController.transactionTotalSize,
            offset: wholesaleTransactionController.transactionOffset,
            onPaginate: (int? offset) async {
              await wholesaleTransactionController.loadMoreTransactions(context, offset ?? 1);
            },
            itemView: ListView.builder(
              itemCount: transactionList.length,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => WholesaleTransactionWidget(transactionModel: transactionList[index]),
            ),
          ),
        ) : const NoDataScreen() : const TransactionShimmerWidget();
      },
    );
  }
}

class TransactionTypeButton extends StatelessWidget {
  final String text;
  final int index;
  final bool isWholesale;
  const TransactionTypeButton({super.key, required this.text, required this.index, this.isWholesale = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeMedium),
        child: InkWell(
          onTap: (){
            if(isWholesale) {
              Provider.of<WholesaleTransactionController>(context, listen: false).setIndex(context, index);
            } else {
              Provider.of<TransactionController>(context, listen: false).setIndex(context, index);
            }
          },
          child: Consumer2<TransactionController, WholesaleTransactionController>(builder: (context, retailTransactionController, wholesaleTransactionController, child) {
            final int selectedIndex = isWholesale ? wholesaleTransactionController.transactionTypeIndex : retailTransactionController.transactionTypeIndex;
            return Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge,),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedIndex == index ? Theme.of(context).primaryColor : Provider.of<ThemeController>(context).darkTheme ?
                ColorHelper.blendColors(Colors.white, Theme.of(context).highlightColor, 0.9) :
                Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(Dimensions.paddingSizeLarge),
              ),
              child: Text(getTranslated(text, context)!, style: selectedIndex == index
                  ? titilliumBold.copyWith(color: selectedIndex == index
                  ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).textTheme.bodyLarge?.color):
              robotoRegular.copyWith(color: selectedIndex == index
                  ? Theme.of(context).colorScheme.secondaryContainer : Theme.of(context).textTheme.bodyLarge?.color)),
            );
          },
          ),
        ),
      ),
    );
  }
}