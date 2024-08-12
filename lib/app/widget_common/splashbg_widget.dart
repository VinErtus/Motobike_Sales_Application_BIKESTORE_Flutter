import 'package:bikestore/app/consts/consts.dart';

Widget splashbgWidget({Widget? child}) {
  return Container(
    decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(imgBackgroundSplash), fit: BoxFit.fill)),
    child: child,
  );
}
