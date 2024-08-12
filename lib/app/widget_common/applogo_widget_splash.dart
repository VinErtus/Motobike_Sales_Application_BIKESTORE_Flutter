import 'package:bikestore/app/consts/consts.dart';
import 'package:velocity_x/velocity_x.dart';

Widget applogoWidgetSplash() {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50.0), // Điều chỉnh radius theo ý bạn
    child: Image.asset(icAppLogo0)
        .box
        .white
        .size(100, 100)
        .padding(const EdgeInsets.all(1))
        .make(),
  );
}
