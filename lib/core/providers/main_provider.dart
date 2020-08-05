import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class BusyState extends StateNotifier<bool> {
  BusyState() : super(false);
  busy() => state = true;
  notBusy() => state = false;
}

final busyStateProvider = StateNotifierProvider((_) => BusyState());

final headerFormKey = Provider((_) => GlobalKey<FormState>());
final contentFormKey = Provider((_) => GlobalKey<FormState>());
final imageUrlFormKey = Provider((_) => GlobalKey<FormState>());
