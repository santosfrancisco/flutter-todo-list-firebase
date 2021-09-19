class Validator {
  static String? validateField({required String? value}) {
    if (value != null && value.isEmpty) {
      return 'Texto não pode ser vazio';
    }

    return null;
  }

  static String? validateUserID({required String uid}) {
    if (uid.isEmpty) {
      return 'Informe um usuário para prosseguir';
    } else if (uid.length <= 2) {
      return 'Usuário precisa ter ao menos 3 caracteres';
    }

    return null;
  }
}
