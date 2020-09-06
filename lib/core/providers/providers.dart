import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class BusyState extends StateNotifier<bool> {
  BusyState() : super(false);
  static final busyStateProvider = StateNotifierProvider((_) => BusyState());

  get isBusy => this.state;

  busy() => this.state = true;
  notBusy() => this.state = false;
}
