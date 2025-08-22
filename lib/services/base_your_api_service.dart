import '../models/your_data_model.dart';

/// ==============================================================================
/// API SERVICE INTERFACE TEMPLATE
/// ==============================================================================
/// Define the contract for your API service

abstract class BaseYourApiService {
  Future<List<YourDataModel>> getAllItems({
    int page = 1,
    Map<String, dynamic>? filters,
  });

  Future<YourDataModel> getItemDetails({required String itemId});

  Future<YourDataModel> createItem({required Map<String, dynamic> data});

  Future<YourDataModel> updateItem({
    required String itemId,
    required Map<String, dynamic> data,
  });

  Future<bool> deleteItem({required String itemId});

  Future<bool> batchDeleteItems({required List<String> itemIds});
}
