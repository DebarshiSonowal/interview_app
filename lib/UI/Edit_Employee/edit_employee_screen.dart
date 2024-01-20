import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:interview_app/Constants/assets.dart';
import 'package:interview_app/Constants/route_names.dart';
import 'package:interview_app/Navigation/navigate.dart';
import 'package:interview_app/bloc/cubit.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/constants.dart';
import '../../Model/employee.dart';
import '../Add_Employee/custom_date_picker_dialog_to.dart';
import '../Add_Employee/date_picker_dialog.dart';

// import 'custom_date_picker_dialog_to.dart';
// import 'date_picker_dialog.dart';

class EditEmployeeScreen extends StatefulWidget {
  const EditEmployeeScreen({super.key, required this.index});

  final int index;

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {
  final employeeName = TextEditingController();
  String selectedDesignation = "";
  DateTime from = DateTime.now();
  DateTime? to;
  Employee? deleted;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      setState(() {
        employeeName.text = context
            .read<DataCubit>()
            .state[widget.index].name;
        selectedDesignation =
            context
                .read<DataCubit>()
                .state[widget.index].jobTitle;
        from = DateFormat("dd MMM yyyy")
            .parse(context
            .read<DataCubit>()
            .state[widget.index].from);
        if (context
            .read<DataCubit>()
            .state[widget.index].to != null) {
          to = DateFormat("dd MMM yyyy")
              .parse(context
              .read<DataCubit>()
              .state[widget.index].to!);
        }
        // debugPrint("${selectedDesignation} \n ${context.read<DataCubit>().state[widget.index].jobTitle}");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Edit Employee Details",
          style: GoogleFonts.roboto().copyWith(
            color: Colors.white,
            fontSize: 15.sp,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              deleted = context
                  .read<DataCubit>()
                  .delete(context
                  .read<DataCubit>()
                  .state[widget.index]);
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
                          ScaffoldMessenger.of(
                              Navigation.instance.navigatorKey.currentContext
                              !).clearSnackBars();
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
              Navigation.instance.navigateAndRemoveUntil(Routes.mainScreen);
            },
            child: const Icon(
              Icons.restore_from_trash,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
        ],
        backgroundColor: Constants.primaryColor,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 3.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 5.h,
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0.2.h,
                    ),
                    alignLabelWithHint: true,
                    // labelText: "",
                    // labelStyle: TextStyle(
                    //     color: myFocusNode.hasFocus ? Colors.purple : Colors.black
                    // ),
                    hintText: "Employee Name",
                    hintStyle: GoogleFonts.roboto().copyWith(
                      color: Colors.black38,
                      fontSize: 12.sp,
                    ),
                    prefixIcon: Image.asset(
                      Assets.personImage,
                      // color: Constants.primaryColor,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                        color: Constants.borderColor,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                        color: Constants.borderColor,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                        color: Constants.borderColor,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                        color: Constants.borderColor,
                      ),
                    ),
                    disabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                        color: Constants.borderColor,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(0.0)),
                      borderSide: BorderSide(
                        color: Constants.borderColor,
                      ),
                    ),
                  ),
                  style: GoogleFonts.roboto().copyWith(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  validator: (value) =>
                  value!.isEmpty ? 'Please, fill this field.' : null,
                  controller: employeeName,
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            GestureDetector(
              onTap: () =>
                  showOptions(context, (String val) {
                    setState(() {
                      selectedDesignation = val;
                    });
                  }),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Constants.borderColor,
                    ),
                  ),
                  width: double.infinity,
                  height: 5.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                    vertical: 0.2.h,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Assets.bagImage,
                        // color: Constants.primaryColor,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      SizedBox(
                        width: 70.w,
                        height: double.infinity,
                        child: Row(
                          children: [
                            Text(
                              selectedDesignation == ""
                                  ? "Role Selected"
                                  : selectedDesignation,
                              style: GoogleFonts.roboto().copyWith(
                                color: selectedDesignation == ""
                                    ? Colors.black38
                                    : Colors.black,
                                fontSize:
                                selectedDesignation == "" ? 12.sp : 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Constants.primaryColor,
                        size: 18.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
              ),
              child: SizedBox(
                width: 95.w,
                height: 5.h,
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDateTimeDialog(
                              (val) {
                            setState(() {
                              from = val;
                            });
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Constants.borderColor,
                          ),
                        ),
                        width: 40.w,
                        height: 5.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.2.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              Assets.dateImage,
                              // color: Constants.primaryColor,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            SizedBox(
                              width: 24.w,
                              height: double.infinity,
                              child: Row(
                                children: [
                                  Text(
                                    (DateFormat("dd MMM yyyy").format(from) ==
                                        DateFormat("dd MMM yyyy")
                                            .format(DateTime.now()))
                                        ? "Today"
                                        : DateFormat("dd MMM yyyy")
                                        .format(from),
                                    style: GoogleFonts.roboto().copyWith(
                                      color: Colors.black,
                                      fontSize: (DateFormat("dd MMM yyyy")
                                          .format(from) ==
                                          DateFormat("dd MMM yyyy")
                                              .format(DateTime.now()))
                                          ? 12.sp
                                          : 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 9.w,
                      height: 5.h,
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward,
                          color: Constants.primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showToDateTimeDialog(
                              (val) {
                            if (val != null && from.isBefore(val)) {
                              setState(() {
                                to = val;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Text(
                                        "Invalid date. It should be after the from date",
                                        style: GoogleFonts.roboto().copyWith(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              // Navigation.instance.navigateAndRemoveUntil(Routes.mainScreen);
                            }
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Constants.borderColor,
                          ),
                        ),
                        width: 40.w,
                        height: 5.h,
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.2.h,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              Assets.dateImage,
                              // color: Constants.primaryColor,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            SizedBox(
                              width: 24.w,
                              height: double.infinity,
                              child: Row(
                                children: [
                                  Text(
                                    to == null
                                        ? "No Date"
                                        : DateFormat("dd MMM yyyy").format(to!),
                                    style: GoogleFonts.roboto().copyWith(
                                      color: to == null
                                          ? Colors.black38
                                          : Colors.black,
                                      fontSize: to == null ? 12.sp : 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Constants.borderColor,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 3.w,
                // vertical: 2.h,
              ),
              height: 7.h,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 24.w,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 2.w,
                          ),
                        ),
                        // backgroundColor: MaterialStateProperty.all(Constants.primaryColor),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigation.instance.goBack();
                      },
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.roboto().copyWith(
                          color: Constants.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  SizedBox(
                    width: 24.w,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Constants.primaryColor),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(
                              color: Constants.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (employeeName.text.isNotEmpty&&selectedDesignation!="") {
                          context.read<DataCubit>().editEmployee(
                            widget.index,
                            Employee(
                              employeeName.text,
                              selectedDesignation,
                              DateFormat("dd MMM yyyy").format(from),
                              to == null
                                  ? null
                                  : DateFormat("dd MMM yyyy").format(to!),
                            ),
                          );
                          Navigation.instance
                              .navigateAndRemoveUntil(Routes.mainScreen);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    "Please fill up the relevant fields",
                                    style: GoogleFonts.roboto().copyWith(
                                      color: Colors.white,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          // Navigation.instance.navigateAndRemoveUntil(Routes.mainScreen);

                        }
                      },
                      child: Text(
                        "Save",
                        style: GoogleFonts.roboto().copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  showOptions(BuildContext context, Function(String val) onTap) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      enableDrag: true,
      context: context,
      builder: (context) {
        return Container(
          height: 28.h,
          // margin: EdgeInsets.symmetric(
          //   // horizontal: 2.w,
          // ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Center(
            child: ListView.separated(
              itemBuilder: (context, index) {
                var item = Constants.designation[index];
                return GestureDetector(
                  onTap: () {
                    onTap(item);
                    Navigation.instance.goBack();
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: 5.h,
                    child: Center(
                      child: Text(
                        item,
                        style: GoogleFonts.roboto().copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Constants.borderColor,
                );
              },
              itemCount: Constants.designation.length,
            ),
          ),
        );
      },
    );
  }

  showDateTimeDialog(Function(DateTime val) onTap) {
    showDialog(
      barrierDismissible: true,
      context: context,
      barrierColor: Colors.black38,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
          ),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content: CustomDatePickerDialog(onTap: (val) => onTap(val)),
        );
      },
    );
  }

  void showToDateTimeDialog(Null Function(DateTime? val) onTap) {
    showDialog(
      barrierDismissible: true,
      context: context,
      barrierColor: Colors.black38,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
          ),
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          content:
          CustomDatePickerDialogTo(onTap: (DateTime? val) => onTap(val)),
        );
      },
    );
  }
}
