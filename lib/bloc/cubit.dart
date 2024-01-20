import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Model/employee.dart';

class DataCubit extends Cubit<List<Employee>> {
  List<Employee> _stateHistory = [];

  DataCubit() : super(List<Employee>.empty(growable: true));

  void _updateState(List<Employee> val) {
    _stateHistory = List.from(val); // Make a copy of the list
  }

  void undo() {
    if (_stateHistory.isNotEmpty) {
      state.clear();
      state.addAll(_stateHistory);
      _stateHistory.clear();
      emit(List.from(state)); // Emit a copy of the updated state
    }
  }

  void addEmployee(Employee val) {
    _updateState(state);
    state.add(val);
    emit(List.from(state)); // Emit a copy of the updated state
    // Fluttertoast.showToast(msg: "Employee Added Successfully");
  }

  void editEmployee(int index, Employee val) {
    _updateState(state);
    state[index] = val;
    emit(List.from(state)); // Emit a copy of the updated state
  }

  void insertAt(int index, Employee val) {
    _updateState(state);
    state.insert(index, val);
    emit(List.from(state)); // Emit a copy of the updated state
  }

  Employee delete(Employee val) {
    _updateState(state);
    var item = state.firstWhere((element) => element == val);
    state.removeWhere((element) => element == val);
    emit(List.from(state)); // Emit a copy of the updated state
    return item;
  }
}
