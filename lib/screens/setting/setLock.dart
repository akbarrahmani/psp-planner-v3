// ignore_for_file: unrelated_type_equality_checks, must_be_immutable, prefer_typing_uninitialized_variables, file_names

part of './setting.dart';

class SetLock extends GetView {
  var callback;
  SetLock({super.key, this.callback});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('تنظیم رمز عبور برنامه'),
        ),
        body: lockScreen(
            setPass: setting.getAt(0)!.password == '',
            setOff: setting.getAt(0)!.password != '',
            biometric: false,
            callback: (v) {
              callback(v);
            }));
  }
}
