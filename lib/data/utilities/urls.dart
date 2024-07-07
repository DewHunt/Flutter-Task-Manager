class Urls {
  static const _baseUrl = 'https://task.teamrabbil.com/api/v1';
  static const registration = '$_baseUrl/registration';
  static const login = '$_baseUrl/login';
  static const createTask = '$_baseUrl/createTask';
  static const newTaskList = '$_baseUrl/listTaskByStatus/New';
  static const completedTaskList = '$_baseUrl/listTaskByStatus/Completed';
  static const canceledTaskList = '$_baseUrl/listTaskByStatus/Canceled';
  static const progressTaskList = '$_baseUrl/listTaskByStatus/Progress';
  static const taskStatusCount = '$_baseUrl/taskStatusCount';
  static deleteTask(String id) => '$_baseUrl/deleteTask/$id';
  static editTask(String id, String status) => '$_baseUrl/updateTaskStatus/$id/$status';
  static const profileUpdate = '$_baseUrl/profileUpdate';
  static recoverVerifyEmail(String email) => '$_baseUrl/RecoverVerifyEmail/$email';
  static recoverVerifyOTP(String email, String otp) => '$_baseUrl/RecoverVerifyOTP/$email/$otp';
  static const recoverResetPass = '$_baseUrl/RecoverResetPass';
}