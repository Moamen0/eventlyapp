import 'package:eventlyapp/model/event.dart';
import 'package:eventlyapp/utils/app_color.dart';
import 'package:eventlyapp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';

class EventItem extends StatefulWidget {
  const EventItem({super.key, required this.event});
  final EventModel event;
  @override
  State<EventItem> createState() => _EventItemState();
}

class _EventItemState extends State<EventItem> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .27,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColor.primaryLightColor,
          width: 2,
        ),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            widget.event.eventImage, 
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.01),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.03, vertical: height * 0.008),
                child: Column(
                  children: [
                    Text(
                      widget.event.eventDateTime.day.toString(),
                      style: AppStyle.bold20Primary,
                    ),
                    Text(
                      DateFormat("MMM").format(widget.event.eventDateTime),
                      style: AppStyle.bold14Primarylight,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.03, vertical: height * 0.004),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.event.eventTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      icon: Icon(
                        isLiked ? Clarity.heart_solid : Clarity.heart_line,
                        color: AppColor.primaryLightColor,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}