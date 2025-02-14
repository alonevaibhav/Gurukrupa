import 'package:get/get.dart';
import '../Controller/auth_controller.dart';

Future<void> init() async{
  Get.lazyPut(()=>AuthController(), fenix: true);
}