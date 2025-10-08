import 'package:flutter/material.dart';

abstract class BaseController extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _hasLoaded= false;
  bool get shouldLoadData => !_hasLoaded;

  Future<void> loadData(Future<void> Function() fetchDataFunction) async  {
      _hasLoaded = true;
      _isLoading = true;
      notifyListeners();

      try {
        await fetchDataFunction();
      } catch (e) {
        debugPrint('❌ Error loading data: ${runtimeType.toString()}: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}