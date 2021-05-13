class ValidationField {
  final String value;
  final String error;

  ValidationField({this.value, this.error});

  bool hasError() {
    return error != null;
  }

  bool isEmpty() {
    if (value == null) return true;
    return value.isEmpty;
  }

  bool isEmptyAndHasError() {
    return hasError() || isEmpty();
  }

  static String validateInteger(String value) {
    if (int.tryParse(value) == null) {
      return 'El campo debe ser un número';
    }
    return null;
  }

  static String validateLength(String value, {int min, int max}) {
    if (min != null && value.length < min) {
      return 'La longitud del campo debe ser mayor a $min.';
    }
    if (max != null && value.length > max) {
      return 'La longitud del campo debe ser menor a $max.';
    }
    return null;
  }

  static String validateEmail(String value) {
    final regExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regExp.hasMatch(value)) {
      return 'Correo inválido.';
    }
    return null;
  }

  static String validateConfirmEquals(String value, String confirmation) {
    if (value == null || confirmation == null) return null;
    if (value.length == 0 && confirmation.length == 0) return null;
    if (value != confirmation) {
      return 'Los campos no coinciden.';
    }
    return null;
  }
}
