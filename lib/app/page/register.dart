import 'package:bikestore/app/consts/colors.dart';
import 'package:bikestore/app/widget_common/bg_wigdet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/api.dart';
import '../model/register.dart';
import 'auth/login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _shadowAnimation = Tween<double>(begin: 4.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Future<String> register() async {
  //   return await APIRepository().register(Signup(
  //       accountID: _accountController.text,
  //       birthDay: _birthDayController.text,
  //       password: _passwordController.text,
  //       confirmPassword: _confirmPasswordController.text,
  //       fullName: _fullNameController.text,
  //       phoneNumber: _phoneNumberController.text,
  //       schoolKey: _schoolKeyController.text,
  //       schoolYear: _schoolYearController.text,
  //       gender: getGender(),
  //       imageUrl: _imageURL.text,
  //       numberID: _numberIDController.text));
  // }

  Future<String> register() async {
    return await APIRepository().register(Signup(
        accountID: _accountController.text,
        birthDay: '1/1/2000',
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        fullName: _fullNameController.text,
        phoneNumber: _phoneNumberController.text,
        schoolKey: '2024',
        schoolYear: 'K24',
        gender: getGender(),
        imageUrl: _imageURL.text,
        numberID: _numberIDController.text));
  }

  @override
  Widget build(BuildContext context) {
    return bgWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            "Đăng ký",
            style: GoogleFonts.montserrat(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,

        ),

        // backgroundColor: Colors.black,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 245, 244, 244),
                    borderRadius: BorderRadius.circular(25),

                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        "Tạo tài khoản",
                        style: GoogleFonts.montserrat(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(_accountController, "Tài khoản", Icons.person),
                      // TextFormField(
                      //   controller: _accountController,
                      //   decoration: InputDecoration(
                      //     labelText: "Tài khoản",
                      //     labelStyle: const TextStyle(color: Colors.grey),
                      //     prefixIcon: const Icon(Icons.person,
                      //         color: Color.fromARGB(255, 5, 85, 179)),
                      //     filled: true,
                      //     fillColor: Colors.white,
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(15.0),
                      //     ),
                      //   ),
                      //   validator: (value) {
                      //     if (value == null || value.isEmpty) {
                      //       return 'Vui lòng nhập tài khoản';
                      //     }
                      //     return null;
                      //   },
                      // ),
                      _buildTextField(_passwordController, "Mật khẩu", Icons.lock),
                      _buildTextField(_confirmPasswordController, "Nhập lại mật khẩu", Icons.lock),
                      _buildTextField(_fullNameController, "Họ & tên", Icons.person_outline),
                      _buildTextField(_numberIDController, "Mã số SV", Icons.vpn_key),
                      _buildTextField(_phoneNumberController, "Số điện thoại", Icons.phone),
                      // _buildTextField(_birthDayController, "Ngày sinh", Icons.calendar_today),
                      // _buildTextField(_schoolYearController, "Năm học", Icons.school),
                      // _buildTextField(_schoolKeyController, "Mã trường", Icons.key),
                      SizedBox(height: 20),
                      _buildGenderSelection(),
                      SizedBox(height: 20),
                      _buildTextField(_imageURL, "Hình ảnh đại diện (URL)", Icons.image),
                      SizedBox(height: 30),
                      _buildRegisterButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: label.toLowerCase().contains('password'),
        style: GoogleFonts.montserrat(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.montserrat(color: Colors.grey[500]),
          icon: Icon(icon, color: const Color.fromARGB(255, 5, 85, 179)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color.fromARGB(255, 5, 85, 179)),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _gender = 1;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _gender == 1 ? const Color.fromARGB(255, 44, 141, 252) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromARGB(255, 44, 141, 252), width: 2),
              ),
              child: Center(
                child: Text(
                  "Nam",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _gender == 1 ? Colors.white : Color.fromARGB(255, 5, 85, 179),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _gender = 2;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _gender == 2 ? const Color.fromARGB(255, 44, 141, 252) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromARGB(255, 44, 141, 252), width: 2),
              ),
              child: Center(
                child: Text(
                  "Nữ",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _gender == 2 ? Colors.white : const Color.fromARGB(255, 5, 85, 179),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _gender = 3;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: _gender == 3 ? const Color.fromARGB(255, 44, 141, 252) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromARGB(255, 44, 141, 252), width: 2),
              ),
              child: Center(
                child: Text(
                  "Khác",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _gender == 3 ? Colors.white : const Color.fromARGB(255, 5, 85, 179),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return GestureDetector(
          onTapDown: (_) {
            _animationController.forward();
            _registerUser();
          },
          onTapUp: (_) {
            _animationController.reverse();

          },
          onTapCancel: () {
            _animationController.reverse();
          },
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color.fromARGB(255, 5, 85, 179), const Color.fromARGB(255, 5, 85, 179)!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 5, 85, 179).withOpacity(0.5),
                    blurRadius: _shadowAnimation.value,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    "Đăng ký",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _registerUser() async {
    String response = await register();
    if (response == "ok") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đăng ký thành công!"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  String getGender() {
    if (_gender == 1) {
      return "Nam";
    } else if (_gender == 2) {
      return "Nữ";
    }
    return "Khác";
  }
}
