import 'package:flutter/material.dart';
import 'package:rgbremote/widgets/remote_button.dart';

const kWS10W500 = TextStyle(
  fontSize: 10,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

const kWS15W500 = TextStyle(
  fontSize: 15,
  color: Colors.white,
  fontWeight: FontWeight.w500,
);

const kBS15W500 = TextStyle(
  fontSize: 15,
  color: Colors.black,
  fontWeight: FontWeight.w500,
);

class RemoteScreen extends StatelessWidget {
  const RemoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: const Color(0xFFDEE7E8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: Color(0xFF243E51), width: 10),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemoteButton(0),
                  RemoteButton(1),
                  RemoteButton(2, labelStyle: kWS15W500),
                  RemoteButton(3, labelStyle: kWS15W500),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemoteButton(4, labelStyle: kWS15W500),
                  RemoteButton(5, labelStyle: kWS15W500),
                  RemoteButton(6, labelStyle: kWS15W500),
                  RemoteButton(7, labelStyle: kBS15W500),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemoteButton(12),
                  RemoteButton(16),
                  RemoteButton(20),
                  RemoteButton(8, labelStyle: kWS10W500),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemoteButton(13),
                  RemoteButton(17),
                  RemoteButton(21),
                  RemoteButton(9, labelStyle: kWS10W500),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemoteButton(14),
                  RemoteButton(18),
                  RemoteButton(22),
                  RemoteButton(10, labelStyle: kWS10W500),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemoteButton(15),
                  RemoteButton(19),
                  RemoteButton(23),
                  RemoteButton(11, labelStyle: kWS10W500),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
