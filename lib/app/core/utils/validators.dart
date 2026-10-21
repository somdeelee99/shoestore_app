class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'ກະລຸນາປ້ອນອີເມວ';
    final regex = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!regex.hasMatch(value.trim())) return 'ຮູບແບບອີເມວບໍ່ຖືກຕ້ອງ';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'ກະລຸນາປ້ອນເບີໂທ';
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) return 'ເບີໂທຕ້ອງມີຢ່າງໜ້ອຍ 8 ຕົວເລກ';
    return null;
  }

  static String? required(String? value, [String label = 'ຊ່ອງນີ້']) {
    if (value == null || value.trim().isEmpty) return 'ກະລຸນາປ້ອນ$label';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'ກະລຸນາປ້ອນລະຫັດຜ່ານ';
    if (value.length < 6) return 'ລະຫັດຜ່ານຢ່າງໜ້ອຍ 6 ໂຕອັກສອນ';
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    if (value != original) return 'ລະຫັດຜ່ານບໍ່ຕົງກັນ';
    return null;
  }
}
