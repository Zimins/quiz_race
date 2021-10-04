import 'package:get/get.dart';

class QuizController extends GetxController {
  RxInt leftSeconds = 5.obs;

  void setLeftSeconds(int second) {
    leftSeconds = second.obs;
  }
}