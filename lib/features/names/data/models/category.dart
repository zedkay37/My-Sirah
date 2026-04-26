enum Category {
  praise,
  prophethood,
  intercession,
  eschatology,
  purity,
  virtues,
  miraj,
  guidance,
  light,
  nobility,
  devotion;

  static Category? fromSlug(String slug) {
    for (final value in Category.values) {
      if (value.name == slug) return value;
    }
    return null;
  }
}
