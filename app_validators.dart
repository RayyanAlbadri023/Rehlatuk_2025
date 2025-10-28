class AppValidators {
  // Validate full name (at least 2 words, only letters and spaces)
  static String? validateFullName(String? value, {String language = 'English'}) {
    if (value == null || value.trim().isEmpty) {
      return language == 'Arabic' ? 'الاسم مطلوب' : 'Full name is required';
    }
    final nameRegex = RegExp(r'^[a-zA-Z ]+$');
    if (!nameRegex.hasMatch(value)) {
      return language == 'Arabic' ? 'الاسم يجب أن يحتوي على أحرف فقط' : 'Name must contain only letters';
    }
    if (!value.trim().contains(' ')) {
      return language == 'Arabic' ? 'يرجى إدخال الاسم الكامل' : 'Please enter full name';
    }
    return null;
  }

  // Validate email
  static String? validateEmail(String? value, {String language = 'English'}) {
    if (value == null || value.trim().isEmpty) {
      return language == 'Arabic' ? 'البريد الإلكتروني مطلوب' : 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return language == 'Arabic' ? 'صيغة البريد الإلكتروني غير صحيحة' : 'Invalid email format';
    }
    return null;
  }

  // Validate phone
  static String? validatePhone(String? value, {String language = 'English'}) {
    if (value == null || value.trim().isEmpty) {
      return language == 'Arabic' ? 'رقم الهاتف مطلوب' : 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value)) {
      return language == 'Arabic' ? 'رقم الهاتف غير صالح' : 'Invalid phone number';
    }
    return null;
  }

  // Validate password
  static String? validatePassword(String? value, {String language = 'English'}) {
    if (value == null || value.isEmpty) {
      return language == 'Arabic' ? 'كلمة المرور مطلوبة' : 'Password is required';
    }
    final passwordRegex =
    RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return language == 'Arabic'
          ? 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل وتحتوي على أحرف كبيرة وصغيرة ورقم ورمز'
          : 'Password must be at least 8 characters and include uppercase, lowercase, number, and symbol';
    }
    return null;
  }
}
