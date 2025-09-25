import '../../Model/User.dart';
import '../../utils/valueNotifier.dart';

class StaffController {
  final TabNotifier tabController = TabNotifier();
  late final User currentUser;
  void changeTab(int index) {
    tabController.changeTab(index);
  }

  StaffController({required this.currentUser});

  void dispose() {
    tabController.dispose();
  }
}
