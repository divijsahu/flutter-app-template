import 'package:flutter/foundation.dart';

import 'base_provider.dart';
import '../models/your_data_model.dart';
import '../services/your_api_service.dart';

/// ==============================================================================
/// PROVIDER TEMPLATE - Updated with BaseProvider Integration
/// ==============================================================================
///
/// This template follows the Best provider architecture pattern.
/// It includes network-aware operations, error handling, and loading states.
///
/// SECTIONS:
/// 1. PROVIDER DATA - State variables and data models
/// 2. PROVIDER METHODS - Local business logic and utility methods
/// 3. PROVIDER API METHODS - Network calls with error handling
/// 4. MISCELLANEOUS VARIABLES - Additional state and dependencies
/// ==============================================================================

class YourProvider extends BaseProvider {
  // ************** PROVIDER DATA **************

  /// All items managed by this provider
  List<YourDataModel> _items = [];
  List<YourDataModel> get items => _items;
  set items(List<YourDataModel> value) {
    if (_items != value) {
      _items = value;
      notifyListeners();
    }
  }

  /// Selected item for detail/update operations
  YourDataModel? _selectedItem;
  YourDataModel? get selectedItem => _selectedItem;
  set selectedItem(YourDataModel? value) {
    if (_selectedItem != value) {
      _selectedItem = value;
      notifyListeners();
    }
  }

  /// Multiple item selection for batch operations
  final List<YourDataModel> _selectedItems = [];
  List<YourDataModel> get selectedItems => List.unmodifiable(_selectedItems);

  /// Pagination data (if needed)
  int _currentPage = 1;
  int get currentPage => _currentPage;
  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;

  // ************** PROVIDER METHODS **************

  /// Toggle selection for batch operations
  void toggleItemSelection(YourDataModel item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  /// Clear all selections
  void clearSelection() {
    _selectedItems.clear();
    notifyListeners();
  }

  /// Check if item is selected
  bool isItemSelected(YourDataModel item) {
    return _selectedItems.contains(item);
  }

  /// Get item by ID
  YourDataModel? getItemById(String id) {
    try {
      return _items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add item to local list (optimistic update)
  void addItemLocally(YourDataModel item) {
    if (!_items.any((existingItem) => existingItem.id == item.id)) {
      _items.insert(0, item); // Add to beginning
      notifyListeners();
    }
  }

  /// Update item in local list
  void updateItemLocally(YourDataModel updatedItem) {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  /// Remove item from local list
  void removeItemLocally(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    _selectedItems.removeWhere((item) => item.id == itemId);
    if (_selectedItem?.id == itemId) {
      _selectedItem = null;
    }
    notifyListeners();
  }

  /// Reset all data
  void resetData() {
    _items.clear();
    _selectedItems.clear();
    _selectedItem = null;
    _currentPage = 1;
    _hasMoreData = true;
    error = null;
    notifyListeners();
  }

  // ************** PROVIDER API METHODS **************

  /// Fetch all items with network-aware error handling
  Future<void> fetchAllItems({
    bool refreshData = false,
    Map<String, dynamic>? filters,
  }) async {
    try {
      // Reset pagination if refreshing
      if (refreshData) {
        _currentPage = 1;
        _hasMoreData = true;
      }

      await executeNetworkCall(
        () async {
          final result = await _apiService.getAllItems(
            page: _currentPage,
            filters: filters,
          );

          if (refreshData || _currentPage == 1) {
            items = result;
          } else {
            // Append for pagination
            _items.addAll(result);
            notifyListeners();
          }

          // Update pagination state
          _hasMoreData = result.length >= 20; // Assuming 20 items per page
        },
        customErrorMessage:
            'Failed to fetch items. Please check your connection and try again.',
      );
    } catch (e) {
      debugPrint('Error fetching items: $e');
      // Error is already set by executeNetworkCall
    }
  }

  /// Fetch item details by ID
  Future<void> fetchItemDetails({required String itemId}) async {
    try {
      await executeNetworkCall(
        () async {
          final result = await _apiService.getItemDetails(itemId: itemId);
          selectedItem = result;
        },
        customErrorMessage:
            'Failed to fetch item details. Please check your connection and try again.',
      );
    } catch (e) {
      debugPrint('Error fetching item details: $e');
    }
  }

  /// Create new item with optimistic updates
  Future<bool> createItem({
    required Map<String, dynamic> itemData,
    bool useOptimisticUpdate = true,
  }) async {
    YourDataModel? tempItem;

    try {
      // Optimistic update
      if (useOptimisticUpdate) {
        tempItem = YourDataModel.fromJson({
          ...itemData,
          'id': 'temp_${DateTime.now().millisecondsSinceEpoch}',
        });
        addItemLocally(tempItem);
      }

      return await executeNetworkCall(
        () async {
          final result = await _apiService.createItem(data: itemData);

          // Remove temp item and add real item
          if (tempItem != null) {
            removeItemLocally(tempItem.id);
          }
          addItemLocally(result);

          selectedItem = result;
          return true;
        },
        customErrorMessage:
            'Failed to create item. Please check your connection and try again.',
      );
    } catch (e) {
      // Rollback optimistic update
      if (tempItem != null) {
        removeItemLocally(tempItem.id);
      }
      debugPrint('Error creating item: $e');
      return false;
    }
  }

  /// Update existing item with network handling
  Future<bool> updateItem({
    required String itemId,
    required Map<String, dynamic> updateData,
    bool useOptimisticUpdate = true,
  }) async {
    YourDataModel? originalItem;

    try {
      // Store original for rollback
      if (useOptimisticUpdate) {
        originalItem = getItemById(itemId);
        if (originalItem != null) {
          // Apply optimistic update
          final updatedItem = YourDataModel.fromJson({
            ...originalItem.toJson(),
            ...updateData,
          });
          updateItemLocally(updatedItem);
        }
      }

      return await executeNetworkCall(
        () async {
          final result = await _apiService.updateItem(
            itemId: itemId,
            data: updateData,
          );

          updateItemLocally(result);
          if (_selectedItem?.id == itemId) {
            selectedItem = result;
          }
          return true;
        },
        customErrorMessage:
            'Failed to update item. Please check your connection and try again.',
      );
    } catch (e) {
      // Rollback optimistic update
      if (originalItem != null) {
        updateItemLocally(originalItem);
      }
      debugPrint('Error updating item: $e');
      return false;
    }
  }

  /// Delete item with network handling
  Future<bool> deleteItem({
    required String itemId,
    bool useOptimisticUpdate = true,
  }) async {
    YourDataModel? originalItem;

    try {
      // Store original for rollback
      if (useOptimisticUpdate) {
        originalItem = getItemById(itemId);
        removeItemLocally(itemId);
      }

      return await executeNetworkCall(
        () async {
          final success = await _apiService.deleteItem(itemId: itemId);

          if (!success) {
            throw Exception('Failed to delete item');
          }

          // Ensure item is removed locally
          removeItemLocally(itemId);
          return true;
        },
        customErrorMessage:
            'Failed to delete item. Please check your connection and try again.',
      );
    } catch (e) {
      // Rollback optimistic update
      if (originalItem != null) {
        addItemLocally(originalItem);
      }
      debugPrint('Error deleting item: $e');
      return false;
    }
  }

  /// Load more items for pagination
  Future<void> loadMoreItems() async {
    if (!_hasMoreData || isLoading) return;

    _currentPage++;
    await fetchAllItems();
  }

  /// Refresh data (pull-to-refresh)
  Future<void> refreshData() async {
    await fetchAllItems(refreshData: true);
  }

  /// Batch operations with retry logic
  Future<bool> batchDeleteItems({required List<String> itemIds}) async {
    try {
      return await executeWithRetry(
        () async {
          final success = await _apiService.batchDeleteItems(itemIds: itemIds);

          if (success) {
            // Remove items locally
            for (final itemId in itemIds) {
              removeItemLocally(itemId);
            }
          }

          return success;
        },
        maxRetries: 3,
        customErrorMessage:
            'Failed to delete items. Please check your connection and try again.',
      );
    } catch (e) {
      debugPrint('Error in batch delete: $e');
      return false;
    }
  }

  // ************** MISCELLANEOUS VARIABLES **************

  /// Dependency Injection: API Service
  final YourApiService _apiService;

  /// Constructor with dependency injection
  YourProvider(this._apiService);

  /// Additional loading states for specific operations
  bool _isCreating = false;
  bool get isCreating => _isCreating;
  set isCreating(bool value) {
    if (_isCreating != value) {
      _isCreating = value;
      notifyListeners();
    }
  }

  bool _isUpdating = false;
  bool get isUpdating => _isUpdating;
  set isUpdating(bool value) {
    if (_isUpdating != value) {
      _isUpdating = value;
      notifyListeners();
    }
  }

  bool _isDeleting = false;
  bool get isDeleting => _isDeleting;
  set isDeleting(bool value) {
    if (_isDeleting != value) {
      _isDeleting = value;
      notifyListeners();
    }
  }

  /// Search and filter state
  String _searchQuery = '';
  String get searchQuery => _searchQuery;
  set searchQuery(String value) {
    if (_searchQuery != value) {
      _searchQuery = value;
      notifyListeners();
      // Trigger search with debouncing if needed
    }
  }

  /// Filtered items based on search query
  List<YourDataModel> get filteredItems {
    if (_searchQuery.isEmpty) return _items;

    return _items.where((item) {
      return item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    // Clean up any streams, timers, or listeners here
    super.dispose();
  }
}
