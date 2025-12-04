// category_bloc.dart

import 'package:rxdart/rxdart.dart';
import 'package:proyecto_pos/models/category.dart';
import 'package:proyecto_pos/resp/category_repository.dart';

class CategoryBloc {
  final BehaviorSubject<List<Category>> _categories =
      BehaviorSubject<List<Category>>();
  final CategoryRepository _categoryRepository = CategoryRepository();

  Stream<List<Category>> get categories => _categories.stream;

  // READ
  Future<void> fetchCategories(int userId) async {
    final categories = await _categoryRepository.getCategories(userId: userId);
    _categories.sink.add(categories);
  }

  // CREATE
  Future<void> createCategory(Category category) async {
    final success = await _categoryRepository.createCategory(
      category: category,
    );

    if (success && category.userid != null) {
      fetchCategories(category.userid!);
    }
  }

  // UPDATE
  Future<void> updateCategory(Category category) async {
    final success = await _categoryRepository.updateCategory(
      category: category,
    );

    if (success && category.userid != null) {
      fetchCategories(category.userid!);
    }
  }

  // DELETE
  Future<void> deleteCategory({
    required int categoryId,
    required int userId,
  }) async {
    final success = await _categoryRepository.deleteCategory(
      categoryId: categoryId,
    );

    if (success) {
      fetchCategories(userId);
    }
  }

  void dispose() {
    _categories.close();
  }
}
