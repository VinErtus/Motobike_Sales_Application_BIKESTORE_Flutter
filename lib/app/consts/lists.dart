import 'package:bikestore/app/consts/consts.dart';
import 'package:bikestore/app/consts/images.dart';

class SocialIcon {
  final String imagePath;
  final String link;

  SocialIcon({
    required this.imagePath,
    required this.link,
  });
}

List<SocialIcon> socialIconList = [
  SocialIcon(
      imagePath: 'assets/images/googlelogo.png',
      link:
          'https://accounts.google.com/InteractiveLogin/signinchooser?elo=1&ifkv=AS5LTATaxzvbXQMN6sg0f50gqsMrAIlCf59YTnaSJ7cpTf9TtcJe0I1ZwIP16uadfEpKKMdigzMAvw&ddm=0&flowName=GlifWebSignIn&flowEntry=ServiceLogin'),
  SocialIcon(
      imagePath: 'assets/images/facebooklogo.png',
      link: 'https://vi-vn.facebook.com/login.php/'),
];

const sliderList = [imgSlider1, imgSlider2, imgSlider3];

const categoriesList = [honda, yamaha, vinfast, ducati, suzuki, kawasaki];
const categoriesImage = [
  imgBrands11,
  imgBrands21,
  imgBrands31,
  // imgBrands41,
  // imgBrands51,
  // imgBrands61
];

const categoriesPhankhuc = [giare, trungcap, cancaocap, caocap];
const mauxe = [imgxe1, imgxe2, imgxe3, imgxe4, imgxe5, imgxe6];

const profileButtonIcon = [icEdit1, icOrder, icHeart, icChat];
const profileButtonList = [chinhsuathongtin, donhangcuatoi, sanphamyeuthich, lienhehotro];