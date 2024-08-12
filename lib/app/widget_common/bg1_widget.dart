import 'package:bikestore/app/consts/consts.dart';

// Widget bgWidget({Widget? child}) {
//   return Container(
//     decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage(imgBackground), fit: BoxFit.fill)),
//     child: child,
//   );
// }

Widget bgWidget1({required Widget child}) {
  return Container(
    decoration: const  BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/bg1.png'), // Đường dẫn đến hình ảnh nền
        fit: BoxFit.fill,
      ),
    ),
    child: child,
  );
}