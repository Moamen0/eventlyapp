import 'package:eventlyapp/Home%20Screen/tabs/home_tab/event_item.dart';
import 'package:eventlyapp/Home%20Screen/tabs/widgets/custom_textformfiled.dart';
import 'package:eventlyapp/Providers/event_list.dart';
import 'package:eventlyapp/generated/l10n.dart';
import 'package:eventlyapp/utils/app_color.dart';
import 'package:eventlyapp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03),
        child: Column(
          children: [
            CustomTextformfiled(
              controller: searchController,
              borderSideColor: AppColor.primaryLightColor,
              hintText: S.of(context).search_for_event,
              hintStyle: AppStyle.bold14Primarylight,
              prefixIcon: Icon(Clarity.search_line),
              prefixIconColor: AppColor.primaryLightColor,
            ),
            Expanded(
              child: Consumer<EventListProvider>(
                builder: (context, eventListProvider, child) {
                  // Filter favorite events
                  final favoriteEvents = eventListProvider.eventList
                      .where((event) => event.isFavorite == true)
                      .toList();

                  // Filter by search text
                  final filteredEvents = favoriteEvents
                      .where((event) => event.eventTitle
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
                      .toList();

                  if (filteredEvents.isEmpty) {
                    return Center(
                      child: Text(
                        searchController.text.isEmpty
                            ? 'No favorite events yet'
                            : 'No events found',
                        style: AppStyle.bold16Primary,
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.only(top: height * 0.02),
                    itemBuilder: (context, index) {
                      return EventItem(event: filteredEvents[index]);
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: height * 0.01,
                      );
                    },
                    itemCount: filteredEvents.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}