import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class BusyState extends StateNotifier<bool> {
  BusyState() : super(false);
  busy() => state = true;
  notBusy() => state = false;
}

final busyStateProvider = StateNotifierProvider((_) => BusyState());
