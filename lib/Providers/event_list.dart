import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventlyapp/Home%20Screen/tabs/home_tab/widget/category_item.dart';
import 'package:eventlyapp/model/event.dart';
import 'package:eventlyapp/utils/firebase_utils.dart';
import 'package:flutter/material.dart';

enum SortOption {
  dateAscending,    // Oldest first
  dateDescending,   // Newest first
  titleAZ,          // A to Z
  titleZA,          // Z to A
}

class EventListProvider extends ChangeNotifier {
  List<EventModel> eventList = [];
  List<EventModel> filterEventList = [];
  late CategoryModel category;
  List<CategoryModel> categoryList = [];
  
  SortOption currentSortOption = SortOption.dateAscending;
  String? currentCategoryFilter;

  List<CategoryModel> getCategoriesWithAll(BuildContext context) {
    return categoryList = CategoryModel.getCategoriesWithAll(context);
  }

  void getEventCollections() async {
    print("🔄 Fetching events from Firestore...");
    
    QuerySnapshot<EventModel> querySnapShot =
        await FirebaseUtils.getEventToFirestore().get();
    
    eventList = querySnapShot.docs.map((doc) {
      EventModel event = doc.data();
      event.id = doc.id;
      
      print("📄 Loaded event: ${event.eventTitle} (ID: ${event.id})");
      return event;
    }).toList();
    
    print("✅ Total events loaded: ${eventList.length}");
    
    _applyFilterAndSort();
  }

  void filterEventsByCategory(int tabIndex, BuildContext context) {
    final categories = CategoryModel.getCategoriesWithAll(context);
    final selectedCategory = categories[tabIndex];
    
    print("🔍 Filtering by category: ${selectedCategory.id} (${selectedCategory.name})");
    print("📊 Total events: ${eventList.length}");
    
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
      print("📋 Showing all categories");
    } else {
      filterEventList = eventList.where((event) {
        return event.categoryId == currentCategoryFilter;
      }).toList();
      print("📋 Filtered to category: $currentCategoryFilter");
    }

    _sortEvents();
    
    print("✅ Filtered events count: ${filterEventList.length}");
    notifyListeners();
  }

  void _sortEvents() {
    switch (currentSortOption) {
      case SortOption.dateAscending:
        filterEventList.sort((a, b) => a.eventDateTime.compareTo(b.eventDateTime));
        print("📅 Sorted by date ascending");
        break;
        
      case SortOption.dateDescending:
        filterEventList.sort((a, b) => b.eventDateTime.compareTo(a.eventDateTime));
        print("📅 Sorted by date descending");
        break;
        
      case SortOption.titleAZ:
        filterEventList.sort((a, b) => 
          a.eventTitle.toLowerCase().compareTo(b.eventTitle.toLowerCase()));
        print("🔤 Sorted by title A-Z");
        break;
        
      case SortOption.titleZA:
        filterEventList.sort((a, b) => 
          b.eventTitle.toLowerCase().compareTo(a.eventTitle.toLowerCase()));
        print("🔤 Sorted by title Z-A");
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