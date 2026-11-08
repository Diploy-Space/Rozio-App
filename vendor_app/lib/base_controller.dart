/// BaseController
///
/// A generic abstract class that provides common loading/error handling for
/// all `ChangeNotifier` based controllers. Concrete controllers can extend this
/// class to avoid boiler‑plate code.
///
/// Usage example:
/// ```dart
/// class AddProductController extends BaseController<AddProductController> {
///   Future<void> createProduct(ProductModel model) async {
///     await runAsync(() async {
///       // Your business logic here, e.g. Dio request
///     });
///   }
/// }
/// ```
import 'package:flutter/foundation.dart';

abstract class BaseController<T extends ChangeNotifier> extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Wraps an async operation and automatically updates loading & error state.
  /// Returns the result of the callback.
  @protected
  Future<R> runAsync<R>(Future<R> Function() action) async {
    _isLoading = true;
    _error = null;
    notif
      final result = await action();
      return result;
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

