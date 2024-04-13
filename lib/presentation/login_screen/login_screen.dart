import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mmm_s_application3/core/app_export.dart';
import 'package:mmm_s_application3/core/utils/storage_utils.dart';
import 'package:mmm_s_application3/widgets/custom_elevated_button.dart';
import 'package:mmm_s_application3/widgets/custom_text_form_field.dart';

// ignore_for_file: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  TextEditingController studentAdvisorIDController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors
            .transparent, // Set Scaffold's background color to transparent
        resizeToAvoidBottomInset: false,
        body: Stack(
          // Use Stack to overlay the gradient on top of Scaffold
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.30, 1.0], // 65% of blue, 35% of white
                ),
              ),
            ),
            SingleChildScrollView(
              // Use SingleChildScrollView to allow scrolling
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 55.v),
                  child: Column(
                    children: [
                      _buildInfoSection(context),
                      SizedBox(height: 33.v),
                      Padding(
                        padding: EdgeInsets.only(left: 49.h, right: 51.h),
                        child: CustomTextFormField(
                          controller: studentAdvisorIDController,
                          hintText: "Student/Advisor ID",
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(194, 184, 184, 1)),
                          fillColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 14.v),
                      Padding(
                        padding: EdgeInsets.only(left: 49.h, right: 51.h),
                        child: CustomTextFormField(
                          controller: passwordController,
                          hintText: "Password",
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.visiblePassword,
                          obscureText: true,
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(194, 184, 184, 1)),
                          fillColor: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                      SizedBox(height: 29.v),
                      CustomElevatedButton(
                        text: "Login",
                        margin: EdgeInsets.only(left: 49.h, right: 50.h),
                        onPressed: () {
                          onTapLogin(context);
                        },
                        backgroundColor: Color.fromARGB(255, 72, 106, 228),
                      ),
                      SizedBox(height: 5.v),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Section Widget
  Widget _buildInfoSection(BuildContext context) {
    return SizedBox(
      height: 343.v,
      width: double.maxFinite,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 72.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Login",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      shadows: [
                        Shadow(
                          color: Colors.blue.shade900.withOpacity(
                              0.8), // Darker and more prominent blue shadow
                          blurRadius:
                              4, // Increase blur radius for more pronounced shadow
                          offset: Offset(
                              2, 2), // Increase shadow offset for more depth
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 9.v),
                  SizedBox(
                    width: 230.h,
                    child: Text(
                      "Chat your way to success! \nLogin to begin your journey ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: CustomTextStyles.bodyLargePrimary.copyWith(
                        color: Color.fromARGB(255, 255, 255,
                            255), // Set text color to ARGB(255, 72, 106, 228)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomImageView(
            imagePath: ImageConstant.imgAdvisageniuslogo6,
            height: 249.v,
            width: 375.h,
            alignment: Alignment.topCenter,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // Navigates to the homepageScreen when the action is triggered.
  onTapLogin(BuildContext context) async {
    String username = studentAdvisorIDController.text;
    String password = passwordController.text;

    if (_formKey.currentState?.validate() ?? false) {
      // Send the credentials to the backend
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      // Check the response status
      if (response.statusCode == 200) {
        // Parse the response JSON
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Check if the login was successful
        if (responseData['status'] == true) {
          print('Login successful!');
          print(responseData);

          final String jwtToken = responseData['jwtToken'];
          await saveToken('loginToken', jwtToken);

          // Fetch user details
          final userResponse = await http.post(
            Uri.parse('http://10.0.2.2:8000/api/getUserdetails'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'token': jwtToken}),
          );

          if (userResponse.statusCode == 200) {
            final userData = jsonDecode(userResponse.body);
            print('User Details: $userData');

            // Navigate to the homepage
            Navigator.pushReplacementNamed(context, AppRoutes.homepageScreen);
          } else {
            // Failed to fetch user details, handle the error
            print(
                'Failed to fetch user details. Status code: ${userResponse.statusCode}');
          }
        } else {
          // Login failed, handle the error
          print('Login failed. ${responseData['message']}');
        }
      } else {
        // Login failed, handle the error
        print('Login failed. Status code: ${response.statusCode}');
      }
    }
  }
}
