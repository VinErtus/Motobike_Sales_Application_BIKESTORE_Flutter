import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({Key? key}) : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> with SingleTickerProviderStateMixin {
  late User user;
  late AnimationController _animationController;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    user = User.userEmpty();
    _getDataUser();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _backgroundAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? strUser = pref.getString('user');

    if (strUser != null) {
      setState(() {
        user = User.fromJson(jsonDecode(strUser));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildBackground(),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                _buildProfileHeader(),
                const SizedBox(height: 30),
                _buildDetailsList(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          // decoration: BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [Color.fromARGB(255, 252, 170, 78), Color.fromARGB(
          //         255, 255, 216, 166)],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //     stops: [0.3, 1.0],
          //   ),
          // ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Center(
              child: Text(
                'Thông tin cá nhân',
                style: GoogleFonts.bebasNeue(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 20),
                user.imageURL!.length < 5
                    ? const CircleAvatar(

                  radius: 50,
                  backgroundImage:
                  AssetImage('assets/images/default_avatar.png'),
                )
                    : CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.black,

                  backgroundImage: NetworkImage(
                    user.imageURL!,
                  ),
                ),
                const SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Tên: ', style: GoogleFonts.bebasNeue(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1976D2),
                        ),),
                        Text(
                          user.fullName ?? 'Không có tên',
                          style: GoogleFonts.bebasNeue(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text('Mã: ', style: GoogleFonts.lato(
                          fontSize: 16,
                          color: Colors.black,
                        ),),
                        Text(
                          user.idNumber ?? 'Không có ID',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDetailItem(Icons.person, 'Họ & Tên', user.fullName),
        _buildDetailItem(Icons.phone, 'Số điện thoại', user.phoneNumber),
        _buildDetailItem(Icons.wc, 'Giới tính', user.gender),
        // _buildDetailItem(Icons.cake, 'Ngày sinh', user.birthDay),
        // _buildDetailItem(Icons.school, 'Niên khóa', user.schoolYear),
        // _buildDetailItem(Icons.vpn_key, 'Mã lớp', user.schoolKey),
        _buildDetailItem(Icons.calendar_today, 'Ngày tạo', user.dateCreated),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        color: Colors.white,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          leading: Icon(icon, color: Color(0xFF1976D2), size: 30),
          title: Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          trailing: Text(
            value ?? 'Không có dữ liệu',
            style: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color.fromARGB(255, 93, 92, 92),
            ),
          ),
        ),
      ),
    );
  }
}
