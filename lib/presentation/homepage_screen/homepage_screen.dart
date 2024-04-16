import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;
import 'package:mmm_s_application3/core/app_export.dart';
import 'package:mmm_s_application3/core/utils/storage_utils.dart';


class HomepageScreen extends StatelessWidget {
  const HomepageScreen({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserInfo>(
      future: _getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator if data is being fetched
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle error case
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been successfully fetched, use it to build UI
          UserInfo userInfo = snapshot.data!;

          return SafeArea(
            child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.blue,
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent, // Set scaffold's background color to transparent
              body: SingleChildScrollView(
                child: Container(
                  width: double.maxFinite,
                  //padding: EdgeInsets.symmetric(horizontal: 10.h),
                  child: Column(
                    children: [
                      _buildAdvisaGenius(context),
                      SizedBox(height: 26.v),
                      _buildFifteen(context, userInfo.fullName),
                      SizedBox(height: 15.v),
                      _buildEleven(context, userInfo.major, userInfo.username),
                      SizedBox(height: 18.v),
                      _buildFour(context),
                      //SizedBox(height: 3.v),
                      //_buildOneMillionFortyTwoThousandTwentyFour(context),
                      SizedBox(height: 31.v),
                      _buildChatWithGenie(context),
                      SizedBox(height: 26.v),
                      _buildTwo(context),
                      SizedBox(height: 5.v),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: _buildBottomBar(context),
            ),
          ));
        }
      },
    );
  }

  /// Section Widget
Widget _buildAdvisaGenius(BuildContext context) {
  return Container(
    height: 50.v,
    decoration: BoxDecoration(
      color: Color(0XFF486AE4),
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(30.h),
      ),
    ),
    alignment: Alignment.center,
    child: Text(
      "Advisa Genius",
      style: CustomTextStyles.displaySmallindigoA200,
    ),
  );
}


  

  /// Section Widget
  Widget _buildFifteen(BuildContext context, String fullName) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: 116.v,
        width: 288.h,
        margin: EdgeInsets.only(left: 18.h),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 38.h,
                  top: 17.v,
                ),
                child: Text(
                  "Welcome,",
                  style: theme.textTheme.headlineSmall!.copyWith(
    color: Color(0XFF486AE4),),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(bottom: 34.v),
                child: Text(
                  fullName,
                  style: theme.textTheme.headlineSmall!.copyWith(
    color: Color(0XFF486AE4),),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 116.adaptSize,
                width: 116.adaptSize,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        height: 116.v,
                        width: 9.h,
                        margin: EdgeInsets.only(left: 17.h),
                        decoration: BoxDecoration(
                          color: Color(0XFF486AE4),
                          borderRadius: BorderRadius.circular(
                            4.h,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 9.v,
                        width: 116.h,
                        margin: EdgeInsets.only(bottom: 15.v),
                        decoration: BoxDecoration(
                          color: Color(0XFF486AE4),
                          borderRadius: BorderRadius.circular(
                            4.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
Widget _buildInformationSystemIS(BuildContext context, String major) {
  return Container(
    width: 230.h,
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    decoration: BoxDecoration(
      
      color: Colors.white,
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Center(
      child: Text(
        major,
        style: TextStyle(
          color: Color(0XFF486AE4),
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}



  /// Section Widget
  /// Section Widget
Widget _buildSixtyMillionOneHundredThousand(BuildContext context, String username) {
  return Container(
    width: 100.h,
    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
    decoration: BoxDecoration(
      color: Colors.white,
      
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Center(
      child: Text(
        username,
        style: TextStyle(
          color: Color(0XFF486AE4),
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}



  /// Section Widget
  Widget _buildEleven(BuildContext context, String major, String username) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.center, // Center the widgets horizontally
      children: [
        _buildInformationSystemIS(context, major),
        SizedBox(width: 5.h), // Adjusted the width of SizedBox for spacing
        _buildSixtyMillionOneHundredThousand(context, username),
      ],
    );
  }

  /// Section Widget
  /// Section Widget
/// Section Widget
Widget _buildFour(BuildContext context) {
  return Container(
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 18.h, vertical: 10.v),
    padding: EdgeInsets.all(20.0),
    decoration: BoxDecoration(
      color: Color(0XFF486AE4),
      border: Border.all(
        color: Colors.white,
        width: 3.0,
      ),
      borderRadius: BorderRadius.circular(20.0),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomImageView(
          imagePath: ImageConstant.imgAdvisageniuslogo6171x90,
          width: 50.h,
          onPressed: () {},
        ),
        SizedBox(width: 20.h),
        Expanded(
          child: Text(
            "Achieve Academic Excellence Your AI Academic Companion!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}



  /// Section Widget
  // Widget _buildOneMillionFortyTwoThousandTwentyFour(BuildContext context) {
  //   // Get the current date
  //   DateTime now = DateTime.now();

  //   // Format the date as required
  //   String formattedDate = "${now.day.toString().padLeft(2, '0')} - "
  //       "${now.month.toString().padLeft(2, '0')} - "
  //       "${now.year}";

  //   return CustomElevatedButton(
  //     height: 30.v,
  //     width: 170.h,
  //     text: formattedDate,
  //     buttonStyle: CustomButtonStyles.fillPrimaryTL15,
  //     buttonTextStyle: CustomTextStyles.titleLargeRobotoGray50001,
  //   );
  // }

  /// Section Widget
Widget _buildChatWithGenie(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {
        onTapChatWithGenie(context);
      },
      borderRadius: BorderRadius.circular(25.0),
      child: Ink(
        decoration: BoxDecoration(
          color: Color(0XFF486AE4),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat, color: Colors.white), // Add an icon
              SizedBox(width: 8.0),
              Text(
                "Tap to Chat",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}









  /// Section Widget
  /// Section Widget
Widget _buildTwo(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 18.h),
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 22.v,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0XFF486AE4), // Set the border color here
              width: 3.0, // Set the border width here
            ),
            color: Colors.white, // Change to the desired color for the container
            borderRadius: BorderRadius.circular(15.0), // Adjust the border radius as needed
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Important Dates",
                
                style: TextStyle(
                    color: Color(0XFF486AE4), // Change the text color here
                    fontSize: 18.0, // Adjust the font size as needed
                    fontWeight: FontWeight.bold, // Adjust the font weight as needed
                  )
              ),
              SizedBox(height: 26.v),
              Padding(
                padding: EdgeInsets.only(right: 6.h),
                child: _buildEight(
                  context,
                  lastDayToRegister: "Deferred Exams ",
                  month: "May 1, 2024",
                  
                ),
              ),
              SizedBox(height: 10.v),
              Divider(
                indent: 3.h,
                endIndent: 11.h,
                color: Color(0XFF486AE4),
              ),
              SizedBox(height: 14.v),
              Padding(
                padding: EdgeInsets.only(right: 6.h),
                child: _buildEight(
                  context,
                  lastDayToRegister: "Last Day to Register ",
                  month: "May 2, 2024",
                  
                ),
              ),
              SizedBox(height: 9.v),
              Divider(
                indent: 3.h,
                endIndent: 11.h,
                color: Color(0XFF486AE4),
              ),
              SizedBox(height: 12.v),
              Padding(
                padding: EdgeInsets.only(right: 6.h),
                child: _buildEight(
                  context,
                  lastDayToRegister: "First Day of Classes ",
                  month: "May 5, 2024",
                ),
              ),
              SizedBox(height: 10.v),
              Divider(
                indent: 3.h,
                endIndent: 11.h,
                color: Color(0XFF486AE4),
              ),
              SizedBox(height: 14.v),
              Padding(
                padding: EdgeInsets.only(right: 6.h),
                child: _buildEight(
                  context,
                  lastDayToRegister: "Last Add/Drop Date ",
                  month: "May 9, 2024",
                ),
              ),
              SizedBox(height: 16.v),
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    ),
  );
}


  /// Common widget
  Widget _buildEight(
    BuildContext context, {
    required String lastDayToRegister,
    required String month,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lastDayToRegister,
          
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Color(0XFF486AE4)
            ,
          ),
        ),
        Text(
          month,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: Color(0XFF486AE4),

          ),
        ),
      ],
    );
  }

Widget _buildBottomBar(BuildContext context) {
  return SizedBox(
    child: Transform.translate(
      offset: Offset(0.0, 6.0), // Adjust the vertical offset as needed
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: 17.h, vertical: 14.v),
        margin: EdgeInsets.only(top: 5.0),
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
                margin: EdgeInsets.only(right: 10.0, top: 1.0),
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
    ),
  );
}


  Future<UserInfo> _getUserInfo() async {
    final String? storedJwtToken = await getToken('loginToken');
    if (storedJwtToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/getUserdetails'),
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
        Uri.parse('http://10.0.2.2:8000/api/update-or-verify-token'),
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
