import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors - Green
  static const primary = Color(0xFF5EA500);
  static const primaryDark = Color(0xFF4A8400);
  static const primaryLight = Color(0xFFD4F5A0);

  // Status Colors
  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  // Attendance Colors
  static const checkIn = Color(0xFF22C55E);
  static const checkOut = Color(0xFFEF4444);
  static const late = Color(0xFFF59E0B);
  static const absent = Color(0xFF6B7280);

  // Neutral Colors
  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const textLight = Color(0xFF9CA3AF);
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE5E7EB);
}

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
