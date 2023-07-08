// import 'package:abulfadhwl_android/providers/data_provider.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

// class PositionSeekWidget extends StatefulWidget {
//   final Duration currentPosition;
//   final DataProvider dataProvider;
//   final Duration duration;
//   final Function(Duration) seekTo;

//   const PositionSeekWidget({
//     required this.currentPosition,
//     required this.duration,
//     required this.dataProvider,
//     required this.seekTo,
//   });

//   @override
//   _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
// }

// class _PositionSeekWidgetState extends State<PositionSeekWidget> {
//   late Duration _visibleValue;
//   bool listenOnlyUserInterraction = false;
//   double get percent => widget.duration.inMilliseconds == 0
//       ? 0
//       : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

//   @override
//   void initState() {
//     super.initState();
//     _visibleValue = widget.currentPosition;
//   }

//   @override
//   void didUpdateWidget(PositionSeekWidget oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (!listenOnlyUserInterraction) {
//       _visibleValue = widget.currentPosition;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         PlayerBuilder.isPlaying(
//             player: widget.dataProvider.assetsAudioPlayer,
//             builder: (context, isPlaying) {
//               return NeumorphicSlider(
//                 min: 0,
//                 height: 6,
//                 sliderHeight: 10,
//                 max: widget.duration.inMilliseconds.toDouble(),
//                 value: percent * widget.duration.inMilliseconds.toDouble(),
//                 style: SliderStyle(
//                     thumbBorder:
//                         NeumorphicBorder(color: dataProvider.btnColor, width: 10),
//                     variant: dataProvider.btnColor,
//                     accent: dataProvider.btnColor,
//                     disableDepth: true),
//                 onChangeEnd: (double newValue1) {
//                   setState(() {
//                     listenOnlyUserInterraction = true;
//                     widget.seekTo(_visibleValue);
//                   });
//                 },
//                 onChangeStart: (double newValue2) {
//                   setState(() {
//                     // listen
//                     listenOnlyUserInterraction = true;
//                     widget.seekTo(_visibleValue);
//                   });
//                 },
//                 onChanged: (newValue) {
//                   setState(() {
//                     final to = Duration(milliseconds: newValue.floor());
//                     _visibleValue = to;
//                   });
//                 },
//               );
//             }),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               SizedBox(
//                 child: Text(durationToString(widget.currentPosition)),
//               ),
//               SizedBox(
//                 child: Text(durationToString(widget.duration)),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }
// }

// String durationToString(Duration duration) {
//   String twoDigits(int n) {
//     if (n >= 10) return '$n';
//     return '0$n';
//   }

//   final twoDigitHours =
//       twoDigits(duration.inHours.remainder(Duration.hoursPerDay));
//   final twoDigitMinutes =
//       twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
//   final twoDigitSeconds =
//       twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));

//   if (duration.inHours == 0) {
//     return '$twoDigitMinutes:$twoDigitSeconds';
//   } else {
//     return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
//   }
// }
