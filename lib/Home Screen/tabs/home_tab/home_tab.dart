import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventlyapp/Home%20Screen/tabs/home_tab/event_item.dart';
import 'package:eventlyapp/Home%20Screen/tabs/home_tab/widget/category_item.dart';
import 'package:eventlyapp/Home%20Screen/tabs/home_tab/widget/event_tab_item.dart';
import 'package:eventlyapp/Providers/app_language_provider.dart';
import 'package:eventlyapp/Providers/app_theme_provider.dart';
import 'package:eventlyapp/Providers/event_list.dart';
import 'package:eventlyapp/generated/l10n.dart';
import 'package:eventlyapp/model/event.dart';
import 'package:eventlyapp/utils/app_color.dart';
import 'package:eventlyapp/utils/app_style.dart';
import 'package:eventlyapp/utils/firebase_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int selectedIndex = 0;
  late EventListProvider eventListProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        eventListProvider.getEventCollections();
        eventListProvider.filterEventsByCategory(0, context);
        
        setState(() {}); // Refresh UI after fetching events
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    eventListProvider = Provider.of<EventListProvider>(context, listen: false);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final categories = CategoryModel.getCategoriesWithAll(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).welcome_back,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Text(
                  "Moamen Abdallah",
                  style: AppStyle.bold24White,
                )
              ],
            ),
            Row(
              children: [
                // Sort button
                IconButton(
                  onPressed: () {
                    _showSortDialog(context);
                  },
                  icon: Icon(
                    Icons.sort,
                    color: AppColor.primaryLightbgColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    themeProvider.toggleTheme();
                  },
                  icon: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: AppColor.primaryLightbgColor,
                  ),
                ),
                Card(
                  color: AppColor.primaryLightbgColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: EdgeInsets.all(7.0),
                    child: InkWell(
                      onTap: () {
                        if (languageProvider.appLanguage == "en") {
                          languageProvider.changeLanguage("ar");
                        } else {
                          languageProvider.changeLanguage("en");
                        }
                      },
                      child: Text(
                        languageProvider.appLanguage == "en" ? "EN" : "AR",
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.011, horizontal: width * .03),
            height: height * .13,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppColor.primaryLightbgColor,
                    ),
                    Text(
                      S.of(context).alexandria,
                      style: AppStyle.reglur16White,
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                DefaultTabController(
                    length: categories.length,
                    child: TabBar(
                        labelPadding:
                            EdgeInsets.symmetric(horizontal: width * 0.02),
                        onTap: (index) {
                          print(
                              "🔵 Tab clicked: $index (${categories[index].name})");
                          selectedIndex = index;
                          eventListProvider.filterEventsByCategory(
                              index, context);
                          setState(() {});
                        },
                        isScrollable: true,
                        indicatorColor: Colors.transparent,
                        dividerColor: Colors.transparent,
                        tabAlignment: TabAlignment.start,
                        tabs: categories
                            .map((category) => EventTabItem(
                                isSelected: selectedIndex ==
                                    categories.indexOf(category),
                                selectedBgColor: Theme.of(context).focusColor,
                                selectedFgColor: Theme.of(context).canvasColor,
                                unSelectedBgColor: Colors.transparent,
                                unSelectedFgColor: AppColor.primaryLightbgColor,
                                category: category))
                            .toList()))
              ],
            ),
          ),
          Consumer<EventListProvider>(
            builder: (context, provider, child) {
              return Expanded(
                child: provider.filterEventList.isEmpty
                    ? Center(
                        child: Text(
                          S.of(context).no_event_found,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      )
                    : ListView.separated(
                        padding: EdgeInsets.only(top: height * 0.02),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * 0.03),
                            child: EventItem(
                              event: provider.filterEventList[index],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: height * 0.01,
                          );
                        },
                        itemCount: provider.filterEventList.length),
              );
            },
          )
        ],
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<EventListProvider>(
          builder: (context, provider, child) {
            return AlertDialog(
              title: Text(
                'Sort Events',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSortOption(
                    dialogContext,
                    'Date (Oldest First)',
                    SortOption.dateAscending,
                    Icons.arrow_upward,
                    provider,
                  ),
                  _buildSortOption(
                    dialogContext,
                    'Date (Newest First)',
                    SortOption.dateDescending,
                    Icons.arrow_downward,
                    provider,
                  ),
                  _buildSortOption(
                    dialogContext,
                    'Title (A-Z)',
                    SortOption.titleAZ,
                    Icons.sort_by_alpha,
                    provider,
                  ),
                  _buildSortOption(
                    dialogContext,
                    'Title (Z-A)',
                    SortOption.titleZA,
                    Icons.sort_by_alpha,
                    provider,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    SortOption option,
    IconData icon,
    EventListProvider provider,
  ) {
    final isSelected = provider.currentSortOption == option;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColor.primaryLightColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColor.primaryLightColor : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: AppColor.primaryLightColor)
          : null,
      onTap: () {
        provider.setSortOption(option);
        Navigator.pop(context);
      },
    );
  }
}