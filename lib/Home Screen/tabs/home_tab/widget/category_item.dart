import 'package:eventlyapp/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:eventlyapp/generated/l10n.dart';

class CategoryModel {
  final String index;
  final String name;
  final IconData iconData;
  final String? imagePath;

  const CategoryModel({
    required this.index,
    required this.name,
    required this.iconData,
    this.imagePath,
  });

  static List<CategoryModel> getCategoriesWithAll(BuildContext context) {
    return [
      CategoryModel(
          index: "0",
          name: S.of(context).all,
          iconData: AntDesign.compass_outline,
          ),
      CategoryModel(
        index: "1",
        name: S.of(context).sport,
        iconData: Icons.sports_soccer_outlined,
        
      ),
      CategoryModel(
        index: "2",
        name: S.of(context).birthday,
        iconData: Icons.cake_outlined,
      ),
      CategoryModel(
        index: "3",
        name: S.of(context).meeting,
        iconData: Icons.meeting_room_outlined,
      ),
      CategoryModel(
        index: "4",
        name: S.of(context).gaming,
        iconData: Icons.sports_esports_outlined,
      ),
      CategoryModel(
        index: "5",
        name: S.of(context).workshop,
        iconData: Icons.build_outlined,
      ),
      CategoryModel(
        index: "6",
        name: S.of(context).bookClub,
        iconData: Icons.menu_book_outlined,
      ),
      CategoryModel(
        index: "7",
        name: S.of(context).exhibition,
        iconData: Icons.museum_outlined,
      ),
      CategoryModel(
        index: "8",
        name: S.of(context).holiday,
        iconData: Icons.beach_access_outlined,
      ),
      CategoryModel(
        index: "9",
        name: S.of(context).eating,
        iconData: Icons.restaurant_outlined,
      ),
    ];
  }

  static List<CategoryModel> getCategories(BuildContext context) {
    return [
      CategoryModel(
        index: "0",
        name: S.of(context).sport,
        iconData: Icons.sports_soccer_outlined,
        imagePath: AppAssets.sportEvent
      ),
      CategoryModel(
        index: "1",
        name: S.of(context).birthday,
        iconData: Icons.cake_outlined,
                imagePath: AppAssets.birthdayEvent

      ),
      CategoryModel(
        index: "2",
        name: S.of(context).meeting,
        iconData: Icons.meeting_room_outlined,
                imagePath: AppAssets.meetingimage

      ),
      CategoryModel(
        index: "3",
        name: S.of(context).gaming,
        iconData: Icons.sports_esports_outlined,
                imagePath: AppAssets.gamingEvent

      ),
      CategoryModel(
        index: "4",
        name: S.of(context).workshop,
        iconData: Icons.build_outlined,
                imagePath: AppAssets.workshopEvent

      ),
      CategoryModel(
        index: "5",
        name: S.of(context).bookClub,
        iconData: Icons.menu_book_outlined,
                imagePath: AppAssets.bookclubEvent

      ),
      CategoryModel(
        index: "6",
        name: S.of(context).exhibition,
        iconData: Icons.museum_outlined,
                imagePath: AppAssets.bexhibitionEvent

      ),
      CategoryModel(
        index: "7",
        name: S.of(context).holiday,
        iconData: Icons.beach_access_outlined,
                imagePath: AppAssets.holidayEvent

      ),
      CategoryModel(
        index: "8",
        name: S.of(context).eating,
        iconData: Icons.restaurant_outlined,
                imagePath: AppAssets.eatingEvent

      ),
    ];
  }

  static CategoryModel? getCategoryByIndex(String index, BuildContext context) {
    try {
      return getCategoriesWithAll(context).firstWhere(
        (category) => category.index == index,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryModel &&
          runtimeType == other.runtimeType &&
          index == other.index;

  @override
  int get hashCode => index.hashCode;

  @override
  String toString() => 'CategoryModel(index: $index, name: $name)';
}
