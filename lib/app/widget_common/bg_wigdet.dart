import 'package:bikestore/app/consts/consts.dart';

// Widget bgWidget({Widget? child}) {
//   return Container(
//     decoration: const BoxDecoration(
//         image: DecorationImage(
//             image: AssetImage(imgBackground), fit: BoxFit.fill)),
//     child: child,
//   );
// }

Widget bgWidget({required Widget child}) {
  return Container(
    decoration: const  BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/bg.png'), // Đường dẫn đến hình ảnh nền
        fit: BoxFit.fill,
      ),
    ),
    child: child,
  );
}