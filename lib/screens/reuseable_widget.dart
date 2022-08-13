import 'package:flutter/material.dart';

class ReuseableWidget extends StatefulWidget {
  const ReuseableWidget({super.key, required this.title, required this.value});

  final String title, value;

  @override
  State<ReuseableWidget> createState() => _ReuseableWidgetState();
}

class _ReuseableWidgetState extends State<ReuseableWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text(widget.title, style: Theme.of(context).textTheme.subtitle2,),

          Text(widget.value, style: Theme.of(context).textTheme.subtitle2,),
        ],
      ),
    );
  }
}