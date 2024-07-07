import 'package:task_manager/data/models/user_model.dart';

class SignInWrapperModel {
  String? status;
  String? token;
  UserModel? user;

  SignInWrapperModel({this.status, this.token, this.user});

  SignInWrapperModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    token = json['token'];
    user = json['data'] != null ? UserModel.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['token'] = token;
    if (user != null) {
      data['data'] = user!.toJson();
    }
    return data;
  }
}