import 'package:flutter/material.dart';
import 'package:timetracker/app/bottom_navigation/tab_item.dart';
import 'package:timetracker/app/home/account/account_page.dart';
import 'package:timetracker/app/home/entries/entries_page.dart';
import 'package:timetracker/app/home/jobs/jobs_page.dart';

import 'cupertino_home_scaffold.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (context) => EntriesPage.create(context),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    //this is to make sure when we tap the tabItem, we will go to that page
    // instead of pressing the back button
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: is called everytime when we press the back button in Android
      onWillPop: () async =>
          //maybePop() means it will only pop if there is more than one route,
          //and in this case it will return true, and if only one route, no pop
          //and return false
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
