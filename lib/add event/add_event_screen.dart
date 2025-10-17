import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventlyapp/Home%20Screen/tabs/home_tab/widget/category_item.dart';
import 'package:eventlyapp/Home%20Screen/tabs/home_tab/widget/event_tab_item.dart';
import 'package:eventlyapp/Home%20Screen/tabs/widgets/custom_elevated_button.dart';
import 'package:eventlyapp/Home%20Screen/tabs/widgets/custom_textformfiled.dart';
import 'package:eventlyapp/Providers/event_list.dart';
import 'package:eventlyapp/Providers/user_provider.dart';
import 'package:eventlyapp/add%20event/widget/add_Time&Date.dart';
import 'package:eventlyapp/generated/l10n.dart';
import 'package:eventlyapp/model/event.dart';
import 'package:eventlyapp/utils/app_assets.dart';
import 'package:eventlyapp/utils/app_color.dart';
import 'package:eventlyapp/utils/app_style.dart';
import 'package:eventlyapp/utils/firebase_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  int selectedIndex = 0;
  TextEditingController titleController = TextEditingController();
  TextEditingController describtionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectTime;
  String formatTime = "";
  String formatDate = "";
  String selectEventImage = "";
  var formKey = GlobalKey<FormState>();

  List<String> eventImageList = [
    AppAssets.sportEvent,
    AppAssets.birthdayEvent,
    AppAssets.meetingimage,
    AppAssets.gamingEvent,
    AppAssets.workshopEvent,
    AppAssets.bookclubEvent,
    AppAssets.bexhibitionEvent,
    AppAssets.holidayEvent,
    AppAssets.eatingEvent,
  ];

  late EventListProvider eventListProvider;
  late UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final allCategories = CategoryModel.getCategoriesWithAll(context);
    final categories = allCategories.skip(1).toList();

    final selectedCategory = categories[selectedIndex];
    eventListProvider = Provider.of<EventListProvider>(context);
    userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColor.primaryLightColor),
        backgroundColor: Colors.transparent,
        title: Text(
          S.of(context).CreateEvent,
          style: AppStyle.reglur22Primary,
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.018),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(16)),
                width: double.infinity,
                child: eventImageList[selectedIndex].isNotEmpty
                    ? Image.asset(
                        eventImageList[selectedIndex],
                        fit: BoxFit.cover,
                        cacheWidth: (width * 0.94).round(),
                        cacheHeight: (height * 0.25).round(),
                      )
                    : const SizedBox(),
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
                        selectedIndex = index;
                        setState(() {});
                      },
                      isScrollable: true,
                      indicatorColor: Colors.transparent,
                      dividerColor: Colors.transparent,
                      tabAlignment: TabAlignment.start,
                      tabs: categories
                          .map((category) => EventTabItem(
                              isSelected:
                                  selectedIndex == categories.indexOf(category),
                              selectedBgColor: AppColor.primaryLightColor,
                              selectedFgColor: Theme.of(context).splashColor,
                              unSelectedBgColor: Colors.transparent,
                              unSelectedFgColor: AppColor.primaryLightColor,
                              category: category))
                          .toList())),
              SizedBox(
                height: height * 0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    S.of(context).title,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomTextformfiled(
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Enter Title";
                        }
                        return null;
                      },
                      hintText: S.of(context).eventTitle,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset(
                          AppAssets.titleIcon,
                          color: Theme.of(context).hoverColor,
                        ),
                      ),
                      controller: titleController),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    S.of(context).describtion,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomTextformfiled(
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Enter Description";
                        }
                        return null;
                      },
                      maxLines: 5,
                      hintText: S.of(context).eventDescription,
                      controller: describtionController),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  AddTime_date(
                      iconPath: AppAssets.dateIcon,
                      text: S.of(context).eventDate,
                      choose_timeOrdate: selectedDate == null
                          ? S.of(context).chooseDate
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                      onChooseEventDateOrTime: chooseDate),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  AddTime_date(
                    iconPath: AppAssets.timeIcon,
                    text: S.of(context).eventTime,
                    choose_timeOrdate: selectTime == null
                        ? S.of(context).chooseTime
                        : formatTime!,
                    onChooseEventDateOrTime: chooseTime,
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Text(
                    S.of(context).location,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomElevatedButton(
                    padding: EdgeInsets.symmetric(vertical: height * 0.01),
                    borderColor: AppColor.primaryLightColor,
                    onPressed: () {
                      //todo location
                    },
                    hasIcon: true,
                    hasSuffix: true,
                    backgroundColor: Colors.transparent,
                    iconWidget: Container(
                      margin: EdgeInsets.symmetric(horizontal: width * 0.03),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: AppColor.primaryLightColor,
                          borderRadius: BorderRadius.circular(8)),
                      child: Icon(
                        Icons.my_location_outlined,
                        size: 29,
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                    text: S.of(context).chooseEventLocation,
                    textStyle: AppStyle.medium16Primary,
                    iconWidgetSuf: Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: AppColor.primaryLightColor,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomElevatedButton(
                    onPressed: addEvent,
                    text: S.of(context).addEvent,
                  )
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  void chooseDate() async {
    var pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: selectedDate ?? DateTime.now(),
    );
    selectedDate = pickedDate;
    setState(() {});
  }

  void chooseTime() async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    selectTime = pickedTime;
    if (selectTime != null) {
      formatTime = selectTime!.format(context);
    }
    setState(() {});
  }

  void addEvent() {
    if (formKey.currentState?.validate() == true) {
      final categories = CategoryModel.getCategories(context);

      EventModel event = EventModel(
          categoryId: categories[selectedIndex].id,
          eventTitle: titleController.text,
          eventDescribtion: describtionController.text,
          eventImage: selectEventImage = eventImageList[selectedIndex],
          eventDateTime: selectedDate!,
          eventTime: formatTime);

      FirebaseUtils.addEventToFireStore(event ,userProvider.currentUser?.id?? "" ).then(
        (value) {
          print("Event added successfully");
          eventListProvider.getEventCollections(userProvider.currentUser?.id ?? '');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Event added successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 1),
            ),
          );
          Navigator.pop(context);
        },
      );

      // timeout(
      //   Duration(seconds: 1),
      //   onTimeout: () {
      //     print("Event added successfully");
      //     eventListProvider.getEventCollections();
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(
      //         content: Text('✅ Event added successfully!'),
      //         backgroundColor: Colors.green,
      //         duration: Duration(seconds: 1),
      //       ),
      //     );
      //     Navigator.pop(context);
      //   },
      // );
    }
  }

  @override
  void dispose() {
    super.dispose();
    eventListProvider.getEventCollections(userProvider.currentUser?.id ?? '');
  }
}
