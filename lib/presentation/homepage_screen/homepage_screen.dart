import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:mmm_s_application3/core/app_export.dart';
import 'package:mmm_s_application3/core/utils/storage_utils.dart';
import 'package:mmm_s_application3/widgets/custom_elevated_button.dart';

class HomepageScreen extends StatelessWidget {
  const HomepageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              children: [
                _buildPageTitle(context),
                SizedBox(height: 44.v),
                FutureBuilder(
                  future: _getUserInfo(),
                  builder: (context, AsyncSnapshot<UserInfo> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final userInfo = snapshot.data!;
                      return Text(
                        "Welcome, ${userInfo.fullName}.",
                        style:
                            CustomTextStyles.titleLargeDMSansOnPrimaryContainer,
                      );
                    }
                  },
                ),
                SizedBox(height: 42.v),
                CustomImageView(
                  imagePath: ImageConstant.imgAdvisageniuslogo6171x90,
                  height: 171.v,
                  width: 90.h,
                  onPressed: () {},
                ),
                SizedBox(height: 14.v),
                Text(
                  "Your Genie For Academic Advice",
                  style: CustomTextStyles.titleLargeOpenSansPrimary,
                ),
                SizedBox(height: 15.v),
                _buildUserInfo(),
                SizedBox(height: 42.v),
                CustomElevatedButton(
                  height: 49.v,
                  width: 179.h,
                  text: "Chat with Genie ↴",
                  onPressed: () {
                    onTapChatWithGenie(context);
                  },
                ),
                SizedBox(height: 5.v),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(context),
      ),
    );
  }

  Widget _buildPageTitle(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 136.h, vertical: 5.v),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: fs.Svg(ImageConstant.imgGroup4),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.v),
          Container(
            width: 95.h,
            margin: EdgeInsets.only(right: 7.h),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Advisa", style: theme.textTheme.displaySmall),
                  TextSpan(text: "\n", style: CustomTextStyles.displaySmall36),
                  TextSpan(
                      text: "Genius", style: theme.textTheme.headlineMedium),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return SizedBox(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 14.v),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: fs.Svg(ImageConstant.imgGroup3),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                onTapChatWithGenie(context);
              },
              child: Container(
                height: 85.adaptSize,
                width: 85.adaptSize,
                margin: EdgeInsets.only(right: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 4.v),
                decoration: AppDecoration.fillIndigoA200.copyWith(
                  borderRadius: BorderRadiusStyle.roundedBorder42,
                ),
                child: CustomImageView(
                  imagePath: ImageConstant.imgAdvisorImage1,
                  height: 75.adaptSize,
                  width: 75.adaptSize,
                  alignment: Alignment.bottomCenter,
                  onPressed: () {}, // Dummy onPressed callback
                ),
              ),
            ),
            CustomImageView(
              imagePath: ImageConstant.imgContrast,
              height: 45.adaptSize,
              width: 45.adaptSize,
              margin: EdgeInsets.only(left: 82.h, top: 39.v, bottom: 2.v),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return FutureBuilder(
      future: _getUserInfo(),
      builder: (context, AsyncSnapshot<UserInfo> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final userInfo = snapshot.data!;
          return Column(
            children: [
              Text(
                "Student ID: ${userInfo.username}",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
              SizedBox(height: 10),
              // Text(
              //   "Account Type: ${userInfo.accountType}",
              //   style: TextStyle(fontSize: 8,color: Colors.white),
              // ),
              // SizedBox(height: 10),
              // Text(
              //   "Full Name: ${userInfo.fullName}",
              //   style: TextStyle(fontSize: 10,color: Colors.white),
              // ),
              SizedBox(height: 10),
              Text(
                "Major: ${userInfo.major}",
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ],
          );
        }
      },
    );
  }

  Future<UserInfo> _getUserInfo() async {
    final String? storedJwtToken = await getToken('loginToken');
    if (storedJwtToken != null) {
      final response = await http.post(
        Uri.parse(
            'https://capstone-m000pwytn-mohammad-yaseens-projects-0fcc5971.vercel.app/api/getUserdetails'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': storedJwtToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return UserInfo(
          username: responseData['username'],
          accountType: responseData['accountType'],
          fullName: responseData['fullName'],
          major: responseData['major'],
        );
      } else {
        throw Exception('Failed to fetch user info');
      }
    } else {
      throw Exception('Token not found');
    }
  }

  onTapChatWithGenie(BuildContext context) async {
    final String? storedJwtToken = await getToken('loginToken');
    await printStoredValues();

    if (storedJwtToken != null) {
      // Send the token to the backend
      final response = await http.post(
        Uri.parse(
            'https://capstone-m000pwytn-mohammad-yaseens-projects-0fcc5971.vercel.app/api/update-or-verify-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'token': storedJwtToken}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          // Token is valid, start the chat session
          final String jwtToken = responseData['convoToken'];
          await saveToken('convoToken', jwtToken);

          Navigator.pushNamed(context, AppRoutes.chatScreen);
        } else {
          // Token is not valid, handle the error
          print('Token verification failed. ${responseData['message']}');
        }
      } else {
        // Request to verify token failed, handle the error
        print('Failed to verify token. Status code: ${response.statusCode}');
      }
    } else {
      print('Token not found.');
    }
  }
}

class UserInfo {
  final String username;
  final String accountType;
  final String fullName;
  final String major;

  UserInfo({
    required this.username,
    required this.accountType,
    required this.fullName,
    required this.major,
  });
}
