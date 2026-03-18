// Re-export AppColors from theme for backward compatibility
export '../theme/app_colors.dart' show AppColors;

class AppStrings {
  static const appName = 'Employee App';

  // Auth
  static const login = 'Login';
  static const register = 'Register';
  static const email = 'Email';
  static const password = 'Password';
  static const confirmPassword = 'Confirm Password';
  static const name = 'Full Name';
  static const forgotPassword = 'Forgot Password?';
  static const dontHaveAccount = "Don't have an account? ";
  static const alreadyHaveAccount = 'Already have an account? ';

  // Navigation
  static const home = 'Home';
  static const attendance = 'Attendance';
  static const history = 'History';
  static const profile = 'Profile';

  // Attendance
  static const checkIn = 'Check In';
  static const checkOut = 'Check Out';
  static const checkedIn = 'Checked In';
  static const checkedOut = 'Checked Out';
  static const notCheckedIn = 'Not Checked In';

  // Status
  static const present = 'Present';
  static const late = 'Late';
  static const absent = 'Absent';
  static const leave = 'Leave';

  // Profile
  static const logout = 'Logout';
  static const editProfile = 'Edit Profile';
}

class AppDurations {
  static const splash = Duration(seconds: 2);
  static const animation = Duration(milliseconds: 300);
}
