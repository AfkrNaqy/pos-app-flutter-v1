import 'package:get/get.dart';

import '../../data/datasources/product_remote_data_source.dart';
import '../../data/models/product_model.dart';

class ProductController extends GetxController {
  final ProductRemoteDataSource _remoteDataSource = ProductRemoteDataSource();
  // final CategoryController _categoryController = Get.put(CategoryController());

  // Observable list of products
  final RxList<Product> products = <Product>[].obs;
  // Observable for loading state
  final RxBool isLoading = false.obs;
  // Observable for error messages
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final fetchedProducts = await _remoteDataSource.getProducts();
      products.assignAll(fetchedProducts); // Update the observable list
    } catch (e) {
      errorMessage.value = 'Failed to fetch products: $e';
      Get.snackbar(
        'Error',
        'Gagal mengambil data produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _remoteDataSource.addProduct(product);
      products.add(product); // Add the new product to the observable list
      Get.snackbar(
        'Success',
        'Produk ${product.name} berhasil ditambahkan!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to add product: $e';
      Get.snackbar(
        'Error',
        'Gagal menambahkan produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow; // Rethrow to allow the UI to handle it if needed
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _remoteDataSource.deleteProduct(productId);
      products.removeWhere(
        (p) => p.id == productId,
      ); // Remove from the observable list
      Get.snackbar(
        'Success',
        'Produk berhasil dihapus!',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = 'Failed to delete product: $e';
      Get.snackbar(
        'Error',
        'Gagal menghapus produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
