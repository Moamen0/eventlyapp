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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class EditEventScreen extends StatefulWidget {
  final EventModel event;

  const EditEventScreen({super.key, required this.event});

  @override
  State<EditEventScreen> createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  int selectedIndex = 0;
  late TextEditingController titleController;
  late TextEditingController describtionController;
  DateTime? selectedDate;
  TimeOfDay? selectTime;
  String formatTime = "";
  String formatDate = "";
  String selectEventImage = "";
  var formKey = GlobalKey<FormState>();
  late UserProvider userProvider;

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
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.event.eventTitle);
    describtionController =
        TextEditingController(text: widget.event.eventDescribtion);
    selectedDate = widget.event.eventDateTime;
    formatTime = widget.event.eventTime;
    selectEventImage = widget.event.eventImage;

    try {
      final timeParts = widget.event.eventTime.split(':');
      if (timeParts.length >= 2) {
        int hour = int.parse(timeParts[0]);
        int minute = int.parse(timeParts[1].split(' ')[0]);

        if (widget.event.eventTime.toLowerCase().contains('pm') && hour != 12) {
          hour += 12;
        } else if (widget.event.eventTime.toLowerCase().contains('am') &&
            hour == 12) {
          hour = 0;
        }

        selectTime = TimeOfDay(hour: hour, minute: minute);
      }
    } catch (e) {
      selectTime = TimeOfDay.now();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      final categories = CategoryModel.getCategories(context);
      selectedIndex = categories
          .indexWhere((category) => category.id == widget.event.categoryId);
      if (selectedIndex == -1) selectedIndex = 0;

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    describtionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final categories = CategoryModel.getCategories(context);
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
          'Edit Event',
          style: AppStyle.reglur22Primary,
        ),
        actions: [
          IconButton(
            onPressed: () => _showDeleteConfirmation(context),
            icon: Icon(
              Icons.delete_outline,
              color: Colors.red,
              size: 28,
            ),
          ),
        ],
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
                  initialIndex: selectedIndex,
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
                        : formatTime,
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
                    onPressed: updateEvent,
                    text: 'Update Event',
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
    if (pickedDate != null) {
      selectedDate = pickedDate;
      setState(() {});
    }
  }

  void chooseTime() async {
    var pickedTime = await showTimePicker(
      context: context,
      initialTime: selectTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      selectTime = pickedTime;
      formatTime = selectTime!.format(context);
      setState(() {});
    }
  }

  void updateEvent() {
    if (formKey.currentState?.validate() == true) {
      final categories = CategoryModel.getCategories(context);

      EventModel updatedEvent = EventModel(
          id: widget.event.id,
          categoryId: categories[selectedIndex].id,
          eventTitle: titleController.text,
          eventDescribtion: describtionController.text,
          eventImage: eventImageList[selectedIndex],
          eventDateTime: selectedDate!,
          eventTime: formatTime);

      FirebaseUtils.updateEventInFireStore(
              updatedEvent, userProvider.currentUser?.id ?? "")
          .then(
        (value) {
          print("Event updated successfully");
          eventListProvider
              .getEventCollections(userProvider.currentUser?.id ?? '');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Event updated successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        },
      );
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(
            'Delete Event',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          content: Text(
            'Are you sure you want to delete "${widget.event.eventTitle}"? This action cannot be undone.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _deleteEvent();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent() {
    FirebaseUtils.deleteEventFromFireStore(widget.event.id!, userProvider.currentUser?.id ?? "").then(
      (value) {
        print("Event deleted successfully");
        eventListProvider.getEventCollections(userProvider.currentUser?.id ?? '');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🗑️ Event deleted successfully!'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );

        Navigator.pop(context);
      },
    ).catchError((error) {
      print("Error deleting event: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error deleting event'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}