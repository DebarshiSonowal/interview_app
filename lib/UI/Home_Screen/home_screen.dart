import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_app/Constants/assets.dart';
import 'package:interview_app/Constants/constants.dart';
import 'package:interview_app/Constants/route_names.dart';
import 'package:interview_app/Model/employee.dart';
import 'package:interview_app/Navigation/navigate.dart';
import 'package:interview_app/bloc/cubit.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Employee List",
          style: GoogleFonts.roboto().copyWith(
            color: Colors.white,
            fontSize: 15.sp,
          ),
        ),
        backgroundColor: Constants.primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigation.instance.navigate(Routes.addEmployeeScreen);
        },
        backgroundColor: Constants.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Constants.bgColor,
        height: double.infinity,
        width: double.infinity,
        child: BlocBuilder<DataCubit, List<Employee>>(
          builder: (context, data) {
            if (data.isEmpty) {
              return Center(
                child: Image.asset(Assets.noImages),
              );
            }
            return Column(
              children: [
                filterListBasedCurrent(data).isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                        ),
                        width: double.infinity,
                        height: 5.h,
                        child: Row(
                          children: [
                            Text(
                              "Current employees",
                              style: GoogleFonts.roboto().copyWith(
                                color: Constants.primaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = filterListBasedCurrent(data)[index];
                    return PresentEmployees(
                      item: item,
                      delete: () {
                        context.read<DataCubit>().delete(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Employee data has been deleted",
                                  style: GoogleFonts.roboto().copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    (Navigation.instance.navigatorKey.currentContext??context).read<DataCubit>()
                                        .undo();
                                    ScaffoldMessenger.of(Navigation.instance.navigatorKey.currentContext??context).clearSnackBars();
                                  },
                                  child: Text(
                                    "Undo",
                                    style: GoogleFonts.roboto().copyWith(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: filterListBasedCurrent(data).length,
                ),
                filterListBasedPast(data).isNotEmpty
                    ? Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                        ),
                        width: double.infinity,
                        height: 5.h,
                        child: Row(
                          children: [
                            Text(
                              "Past employees",
                              style: GoogleFonts.roboto().copyWith(
                                color: Constants.primaryColor,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = filterListBasedPast(data)[index];
                    return WithStartAndEnd(
                      item: item,
                      delete: () {
                        context.read<DataCubit>().delete(item);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Employee data has been deleted",
                                  style: GoogleFonts.roboto().copyWith(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigation.instance.navigatorKey.currentContext
                                        ?.read<DataCubit>()
                                        .undo();
                                    ScaffoldMessenger.of(Navigation.instance.navigatorKey.currentContext??context).clearSnackBars();
                                  },
                                  child: Text(
                                    "Undo",
                                    style: GoogleFonts.roboto().copyWith(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: filterListBasedPast(data).length,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.h,
                  ),
                  // height: 8.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Text(
                        "Swipe to delete",
                        style: GoogleFonts.roboto().copyWith(
                          color: Colors.black38,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Employee> filterListBasedPast(List<Employee> employees) {
    return employees.where((e) => e.to != null).toList();
  }

  List<Employee> filterListBasedCurrent(List<Employee> employees) {
    return employees.where((e) => e.to == null).toList();
  }
}

class PresentEmployees extends StatelessWidget {
  const PresentEmployees({
    super.key,
    required this.item,
    required this.delete,
  });

  final Function delete;
  final Employee item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        delete();
        return true;
      },
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigation.instance.navigate(Routes.editEmployeeScreen,
              args: context
                  .read<DataCubit>()
                  .state
                  .indexWhere((element) => element == item));
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.5.h,
          ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: GoogleFonts.roboto().copyWith(
                  color: Colors.black,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(
                height: 0.2.h,
              ),
              Text(
                item.jobTitle,
                style: GoogleFonts.roboto().copyWith(
                  color: Colors.black38,
                  fontSize: 9.5.sp,
                ),
              ),
              SizedBox(
                height: 0.2.h,
              ),
              Text(
                "From ${item.from}",
                style: GoogleFonts.roboto().copyWith(
                  color: Colors.black38,
                  fontSize: 9.5.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WithStartAndEnd extends StatelessWidget {
  const WithStartAndEnd({
    super.key,
    required this.item,
    required this.delete,
  });

  final Function delete;
  final Employee item;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) async {
        delete();
        return true;
      },
      background: const ColoredBox(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          Navigation.instance.navigate(Routes.editEmployeeScreen,
              args: context
                  .read<DataCubit>()
                  .state
                  .indexWhere((element) => element == item));
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.5.h,
          ),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: GoogleFonts.roboto().copyWith(
                  color: Colors.black,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(
                height: 0.2.h,
              ),
              Text(
                item.jobTitle,
                style: GoogleFonts.roboto().copyWith(
                  color: Colors.black38,
                  fontSize: 9.5.sp,
                ),
              ),
              SizedBox(
                height: 0.2.h,
              ),
              Text(
                "${item.from} - ${item.to}",
                style: GoogleFonts.roboto().copyWith(
                  color: Colors.black38,
                  fontSize: 9.5.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
