import 'package:flutter/material.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../data/Models/product_model.dart';

enum ProductStatus { initial, loading, loaded, error }

class ProductProvider extends ChangeNotifier {
  final ProductRepository _repository = ProductRepositoryImpl();
  
  ProductStatus _status = ProductStatus.initial;
  List<ProductModel> products = [];
  String? errorMessage;

  ProductStatus get status => _status;

  Future<void> fetchProducts() async {
    _status = ProductStatus.loading;
    // Gunakan Future.microtask agar tidak bentrok dengan build UI saat dipanggil di initState
    Future.microtask(() => notifyListeners()); 
    
    try {
      products = await _repository.getProducts();
      _status = ProductStatus.loaded;
    } catch (e) {
      errorMessage = e.toString();
      _status = ProductStatus.error;
    }
    notifyListeners();
  }
}