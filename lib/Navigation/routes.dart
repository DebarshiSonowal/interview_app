import 'package:flutter/material.dart';
import 'package:interview_app/Constants/route_names.dart';
import 'package:interview_app/UI/Home_Screen/home_screen.dart';

import '../Common_Widgets/fade_transition_builder.dart';
import '../UI/Add_Employee/add_employee_screen.dart';
import '../UI/Edit_Employee/edit_employee_screen.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // if (settings.name == null || settings.name == "") {
  //   return FadeTransitionPageRouteBuilder(page: HomeScreen());
  // }
  switch (settings.name) {
    case Routes.mainScreen:
      return FadeTransitionPageRouteBuilder(page: const HomeScreen());
    case Routes.addEmployeeScreen:
      return FadeTransitionPageRouteBuilder(page: const AddEmployeeScreen());
    case Routes.editEmployeeScreen:
      return FadeTransitionPageRouteBuilder(
          page: EditEmployeeScreen(
        index: settings.arguments as int,
      ));
    default:
      return FadeTransitionPageRouteBuilder(page: Container());
  }
}
