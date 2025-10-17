import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventlyapp/Home%20Screen/tabs/home_tab/widget/category_item.dart';
import 'package:eventlyapp/model/event.dart';
import 'package:eventlyapp/utils/firebase_utils.dart';
import 'package:flutter/material.dart';

enum SortOption {
  dateAscending, // Oldest first
  dateDescending, // Newest first
  titleAZ, // A to Z
  titleZA, // Z to A
}

class EventListProvider extends ChangeNotifier {
  List<EventModel> eventList = [];
  List<EventModel> filterEventList = [];
  late CategoryModel category;
  List<CategoryModel> categoryList = [];

  SortOption currentSortOption = SortOption.dateAscending;
  String? currentCategoryFilter;

  void updateIsFavoriteEvent(EventModel event, BuildContext context,String uid) async {
    try {
      // Toggle immediately for offline mode
      event.isFavorite = !event.isFavorite;
      notifyListeners(); // Notify UI to rebuild immediately

      // Check if context is still valid before showing snackbar
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Favorite updated!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );

      // Try to update Firebase in background (may fail in offline mode)
      try {
        await FirebaseUtils.updateEventInFireStore(event,uid).then((value) {
          return;
        }
          // const Duration(seconds: 2),
          // onTimeout: () {
          //   return;
          // },
        );
      } catch (e) {
        print('Firebase update failed (offline mode): $e');
      }
    } catch (e) {
      if (!context.mounted) return;

      event.isFavorite = !event.isFavorite;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  List<CategoryModel> getCategoriesWithAll(BuildContext context) {
    return categoryList = CategoryModel.getCategoriesWithAll(context);
  }

  void getEventCollections(String uid) async {
    QuerySnapshot<EventModel> querySnapShot =
        await FirebaseUtils.getEventToFirestore(uid).get();

    eventList = querySnapShot.docs.map((doc) {
      EventModel event = doc.data();
      event.id = doc.id;

      return event;
    }).toList();

    _applyFilterAndSort();
  }

  void filterEventsByCategory(int tabIndex, BuildContext context) {
    final categories = CategoryModel.getCategoriesWithAll(context);
    final selectedCategory = categories[tabIndex];

    currentCategoryFilter = selectedCategory.id;
    _applyFilterAndSort();
  }

  void setSortOption(SortOption option) {
    currentSortOption = option;
    _applyFilterAndSort();
  }

  void _applyFilterAndSort() {
    if (currentCategoryFilter == null || currentCategoryFilter == "all") {
      filterEventList = List.from(eventList);
    } else {
      filterEventList = eventList.where((event) {
        return event.categoryId == currentCategoryFilter;
      }).toList();
    }

    _sortEvents();

    notifyListeners();
  }

  void _sortEvents() {
    switch (currentSortOption) {
      case SortOption.dateAscending:
        filterEventList
            .sort((a, b) => a.eventDateTime.compareTo(b.eventDateTime));
        break;

      case SortOption.dateDescending:
        filterEventList
            .sort((a, b) => b.eventDateTime.compareTo(a.eventDateTime));
        break;

      case SortOption.titleAZ:
        filterEventList.sort((a, b) =>
            a.eventTitle.toLowerCase().compareTo(b.eventTitle.toLowerCase()));
        print("🔤 Sorted by title A-Z");
        break;

      case SortOption.titleZA:
        filterEventList.sort((a, b) =>
            b.eventTitle.toLowerCase().compareTo(a.eventTitle.toLowerCase()));
        break;
    }
  }

  String getSortOptionName(SortOption option) {
    switch (option) {
      case SortOption.dateAscending:
        return "Date (Oldest First)";
      case SortOption.dateDescending:
        return "Date (Newest First)";
      case SortOption.titleAZ:
        return "Title (A-Z)";
      case SortOption.titleZA:
        return "Title (Z-A)";
    }
  }
}
