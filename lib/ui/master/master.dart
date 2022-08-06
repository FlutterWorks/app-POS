import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sultanpos/state/app.dart';
import 'package:sultanpos/ui/master/pricegroup/pricegroup.dart';
import 'package:sultanpos/ui/master/unit/unit.dart';
import 'package:sultanpos/ui/util/color.dart';

class MasterRootWidget extends StatelessWidget {
  MasterRootWidget({Key? key}) : super(key: key);

  final widgets = [
    () => const UnitWidget(),
    () => const PriceGroupWidget(),
  ];

  final tabs = ['Unit', 'Group Harga'];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: AppState().masterState!,
      child: Builder(
        builder: (ctx) {
          final bgColor = Theme.of(context).scaffoldBackgroundColor;
          return DefaultTabController(
            length: tabs.length,
            animationDuration: const Duration(milliseconds: 100),
            child: Column(
              children: [
                Container(
                  color: lighterOrDarkerColor(Theme.of(context), bgColor),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: tabs.map((e) => Tab(text: e)).toList(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Expanded(child: TabBarView(children: [UnitWidget(), PriceGroupWidget()])),
                /*Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 100),
                    child: Builder(builder: (ctx) {
                      final index = ctx.select<MasterState, int>((value) => value.currentIndex);
                      return widgets[index]();
                    }),
                  ),
                )*/
              ],
            ),
          );
        },
      ),
    );
  }
}
