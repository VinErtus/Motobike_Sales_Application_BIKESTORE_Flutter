import 'package:bikestore/app/consts/consts.dart';

// Widget bgWidget({Widget? child}) {
//   return Container(
//     decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage(imgBackground), fit: BoxFit.fill)),
//     child: child,
//   );
// }

Widget bgWidgetspl({required Widget child}) {
  return Container(
    decoration: const  BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/icons/splash.png'), // Đường dẫn đến hình ảnh nền
        fit: BoxFit.fill,
      ),
    ),
    child: child,
  );
}