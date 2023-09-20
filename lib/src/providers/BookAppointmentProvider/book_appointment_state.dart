import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:trapp/src/models/index.dart';

class BookAppointmentState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final BookAppointmentModel? bookAppointmentModel;
  final int? step;
  final int? completedStep;
  final int? slotsProgressState; // 0: init, 1: progressing, 2: success, 3: failed
  final Map<String, dynamic>? slots;
  final Map<String, dynamic>? bookListData;
  final Map<String, dynamic>? bookListMetaData;
  final bool? isRefresh;

  BookAppointmentState({
    @required this.progressState,
    @required this.message,
    @required this.bookAppointmentModel,
    @required this.step,
    @required this.completedStep,
    @required this.slotsProgressState,
    @required this.slots,
    @required this.bookListData,
    @required this.bookListMetaData,
    @required this.isRefresh,
  });

  factory BookAppointmentState.init() {
    return BookAppointmentState(
      progressState: 0,
      message: "",
      bookAppointmentModel: BookAppointmentModel(),
      step: 1,
      completedStep: 0,
      slotsProgressState: 0,
      slots: Map<String, dynamic>(),
      bookListData: Map<String, dynamic>(),
      bookListMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  BookAppointmentState copyWith({
    int? progressState,
    String? message,
    BookAppointmentModel? bookAppointmentModel,
    int? step,
    int? completedStep,
    int? slotsProgressState,
    Map<String, dynamic>? slots,
    Map<String, dynamic>? bookListData,
    Map<String, dynamic>? bookListMetaData,
    bool? isRefresh,
  }) {
    return BookAppointmentState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      bookAppointmentModel: bookAppointmentModel ?? this.bookAppointmentModel,
      step: step ?? this.step,
      completedStep: completedStep ?? this.completedStep,
      slotsProgressState: slotsProgressState ?? this.slotsProgressState,
      slots: slots ?? this.slots,
      bookListData: bookListData ?? this.bookListData,
      bookListMetaData: bookListMetaData ?? this.bookListMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  BookAppointmentState update({
    int? progressState,
    String? message,
    BookAppointmentModel? bookAppointmentModel,
    int? step,
    int? completedStep,
    int? slotsProgressState,
    Map<String, dynamic>? slots,
    Map<String, dynamic>? bookListData,
    Map<String, dynamic>? bookListMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      bookAppointmentModel: bookAppointmentModel,
      step: step,
      completedStep: completedStep,
      slotsProgressState: slotsProgressState,
      slots: slots,
      bookListData: bookListData,
      bookListMetaData: bookListMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "bookAppointmentModel": bookAppointmentModel,
      "step": step,
      "completedStep": completedStep,
      "slotsProgressState": slotsProgressState,
      "slots": slots,
      "bookListData": bookListData,
      "bookListMetaData": bookListMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        bookAppointmentModel!,
        step!,
        completedStep!,
        slotsProgressState!,
        slots!,
        bookListData!,
        bookListMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
