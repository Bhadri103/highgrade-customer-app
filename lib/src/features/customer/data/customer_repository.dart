import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/api_client.dart';
import '../../../core/utils/map_ext.dart';
import '../domain/customer_models.dart';

class CustomerRepository {
  CustomerRepository({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;
  static const _cartKey = 'p4u_customer_cart';
  static const _wishlistKey = 'p4u_customer_wishlist';
  static const _locationKey = 'p4u_customer_location';

  Future<CustomerHomeData> getHome() async {
    final results = await Future.wait([
      _safeList(() => _api.getList('/api/v1/content/banners', query: {'limit': 20, 'offset': 0})),
      _safeList(() => _api.getList('/api/v1/catalog/categories', query: {'limit': 50, 'offset': 0, 'kind': 'product', 'includeInactive': false})),
      _safeList(() => _api.getList('/api/v1/catalog/categories', query: {'limit': 50, 'offset': 0, 'kind': 'service', 'includeInactive': false})),
      _safeList(() => _api.getList('/api/v1/content/featured-products', query: {'limit': 20, 'offset': 0})),
      _safeList(() => _api.getList('/api/v1/content/service-highlights', query: {'limit': 12, 'offset': 0})),
      _safeList(() => _api.getList('/api/v1/content/popups', query: {'limit': 10, 'offset': 0})),
    ]);
    final home = await _safeMap(() => _api.getJson('/api/v1/content/home'));
    final products = results[3].isEmpty
        ? await browseProducts()
        : results[3].map(_normalizeProduct).toList();
    final services = results[4].isEmpty
        ? await this.services()
        : results[4].map(_normalizeService).toList();
    return CustomerHomeData(
      banners: results[0],
      categories: results[1].map(_normalizeCategory).toList(),
      serviceCategories: results[2].map(_normalizeCategory).toList(),
      products: products.take(10).toList(),
      services: services.take(10).toList(),
      storeBanners: results[5],
      assets: _assetMap(home ?? {}),
    );
  }

  Future<List<Map<String, dynamic>>> browseProducts({String? category, String? search, String? sort}) async {
    final rows = await _safeList(
      () => _api.getList(
        '/api/v1/catalog/browse/products',
        query: {
          'limit': 50,
          'offset': 0,
          'categoryId': category,
          'category': category,
          'q': search,
          'search': search,
          'sort': sort,
        },
      ),
    );
    return rows.map(_normalizeProduct).toList();
  }

  Future<Map<String, dynamic>?> product(String id) async {
    final data = await _safeMap(() => _api.getJson('/api/v1/catalog/products/$id'));
    return data == null ? null : _normalizeProduct(data);
  }

  Future<List<Map<String, dynamic>>> productVariants(String productId) async {
    final product = await this.product(productId);
    final variants = product?['variants'];
    return variants is List ? apiItems(variants) : [];
  }

  Future<List<Map<String, dynamic>>> categories() async {
    final rows = await _safeList(() => _api.getList('/api/v1/catalog/categories', query: {'limit': 100, 'offset': 0, 'kind': 'product'}));
    return rows.map(_normalizeCategory).toList();
  }

  Future<List<Map<String, dynamic>>> services({String? category, String? search}) async {
    final rows = await _safeList(
      () => _api.getList(
        '/api/v1/catalog/services',
        query: {'limit': 50, 'offset': 0, 'categoryId': category, 'category': category, 'q': search, 'search': search},
      ),
    );
    return rows.map(_normalizeService).toList();
  }

  Future<Map<String, dynamic>?> service(String id) async {
    final data = await _safeMap(() => _api.getJson('/api/v1/catalog/services/$id'));
    return data == null ? null : _normalizeService(data);
  }

  Future<List<Map<String, dynamic>>> serviceReviews(String serviceId) async {
    if (!await apiSession.hasToken()) return [];
    return _safeList(() => _api.getList('/api/v1/commerce/reviews', query: {'targetType': 'service', 'targetId': serviceId}, auth: true));
  }

  Future<void> bookService({
    required String customerId,
    required Map<String, dynamic> service,
    required DateTime date,
    required String timeSlot,
    required String address,
    String? notes,
  }) async {
    await _api.postJson(
      '/api/v1/commerce/bookings',
      body: {
        'vendorId': service.s('vendor_id', service.s('vendorId')),
        'serviceId': service.s('id', service.s('serviceId')),
        'bookingDate': date.toIso8601String().split('T').first,
        'timeSlot': timeSlot,
        'address': address,
        'notes': notes,
        'totalAmount': service.n('price').toStringAsFixed(2),
      },
      auth: true,
    );
  }

  Future<Map<String, dynamic>?> vendor(String id) async {
    final data = await _safeMap(() => _api.getJson('/api/v1/catalog/vendors/$id'));
    return data == null ? null : _normalizeVendor(data);
  }

  Future<List<Map<String, dynamic>>> vendorProducts(String id) async {
    final rows = await _safeList(() => _api.getList('/api/v1/catalog/vendors/$id/products', query: {'limit': 50, 'offset': 0}));
    return rows.map(_normalizeProduct).toList();
  }

  Future<List<Map<String, dynamic>>> orders(String customerId) async {
    if (!await apiSession.hasToken()) return [];
    final id = await apiSession.customerId() ?? customerId;
    final rows = await _safeList(() => _api.getList('/api/v1/commerce/customers/$id/orders', auth: true));
    return rows.map(_normalizeOrder).toList();
  }

  Future<Map<String, dynamic>?> order(String id) async {
    final data = await _safeMap(() => _api.getJson('/api/v1/commerce/orders/$id', auth: true));
    return data == null ? null : _normalizeOrder(data);
  }

  Future<void> placeOrder({
    required String customerId,
    required CartSummary summary,
    required Map<String, dynamic>? address,
    String paymentMode = 'cod',
  }) async {
    if (summary.items.isEmpty) throw const ApiException('Cart is empty.');
    await _api.postJson(
      '/api/v1/commerce/orders',
      body: {
        'items': summary.items
            .map((item) => {
                  'productId': item.productId,
                  'quantity': item.qty,
                  'price': item.price,
                  'vendorId': item.vendorId,
                  'metadata': {'productName': item.title, 'variantId': item.variantId},
                })
            .toList(),
        'addressId': address?.s('id'),
        'address': address,
        'paymentMode': paymentMode,
        'redeemPoints': summary.pointsUsed,
      },
      auth: true,
    );
    await clearCart();
  }

  Future<Map<String, dynamic>?> profile(String customerId) async {
    if (!await apiSession.hasToken()) return null;
    final data = await _safeMap(() => _api.getJson('/api/v1/profile/me', auth: true));
    final profile = apiObject(data?['profile'] ?? data?['customer'] ?? data?['user'] ?? data);
    if (profile != null) await apiSession.saveProfile(profile);
    return profile;
  }

  Future<Map<String, dynamic>> profileWithStats(String customerId) async {
    final customer = await profile(customerId) ?? {};
    final orderCount = await orders(customerId);
    final addresses = await customerAddresses(customerId);
    return {
      ...customer,
      'total_orders': orderCount.length,
      'total_ads': 0,
      'saved_addresses': addresses.length,
    };
  }

  Future<void> updateProfile(String customerId, Map<String, dynamic> data) async {
    final payload = {
      if (data['name'] != null) 'fullName': data['name'],
      if (data['fullName'] != null) 'fullName': data['fullName'],
      if (data['email'] != null) 'email': data['email'],
      if (data['avatar_url'] != null) 'avatarUrl': data['avatar_url'],
      if (data['avatarUrl'] != null) 'avatarUrl': data['avatarUrl'],
      'metadata': data,
    };
    await _api.patchJson('/api/v1/profile/me', body: payload, auth: true);
  }

  Future<List<Map<String, dynamic>>> customerAddresses(String customerId) async {
    if (!await apiSession.hasToken()) return [];
    final rows = await _safeList(() => _api.getList('/api/v1/profile/me/addresses', auth: true));
    return rows.map(_normalizeAddress).toList();
  }

  Future<void> saveAddress(String customerId, Map<String, dynamic> address) async {
    final payload = _addressPayload(address);
    final id = address['id']?.toString();
    if (id == null || id.isEmpty) {
      await _api.postJson('/api/v1/profile/me/addresses', body: payload, auth: true);
    } else {
      await _api.putJson('/api/v1/profile/me/addresses/$id', body: payload, auth: true);
    }
  }

  Future<void> deleteAddress(String id) => _api.deleteJson('/api/v1/profile/me/addresses/$id', auth: true);

  Future<List<Map<String, dynamic>>> walletTransactions(String customerId) async {
    if (!await apiSession.hasToken()) return [];
    final data = await _safeMap(() => _api.getJson('/api/v1/profile/me/wallet', auth: true));
    return apiItems(data?['transactions'] ?? data?['items'] ?? data);
  }

  Future<List<Map<String, dynamic>>> referrals(String customerId) async {
    if (!await apiSession.hasToken()) return [];
    return _safeList(() => _api.getList('/api/v1/profile/me/referrals', auth: true));
  }

  Future<List<Map<String, dynamic>>> kycDocuments(String customerId) async => [];

  Future<void> submitKyc(String customerId, Map<String, dynamic> payload) async {
    throw const ApiException('KYC upload is not available in the new API collection yet.');
  }

  Future<List<Map<String, dynamic>>> classifieds({String? category, String? search}) async {
    final rows = await _safeList(() => _api.getList('/api/v1/content/classified', query: {'category': category, 'q': search, 'search': search}));
    return rows;
  }

  Future<Map<String, dynamic>?> classified(String id) async {
    final rows = await classifieds();
    for (final row in rows) {
      if (row.s('id') == id) return row;
    }
    return null;
  }

  Future<void> createClassified(String customerId, Map<String, dynamic> data) async {
    throw const ApiException('Classified posting is not available in the new API collection yet.');
  }

  Future<List<Map<String, dynamic>>> supportTickets(String customerId) async => [];

  Future<void> createSupportTicket(String customerId, Map<String, dynamic> data) async {
    throw const ApiException('Support tickets are not available in the new API collection yet.');
  }

  Future<List<Map<String, dynamic>>> properties({String? transactionType, String? search}) async => [];

  Future<Map<String, dynamic>?> property(String id) async => null;

  Future<void> createProperty(String customerId, Map<String, dynamic> data) async {
    throw const ApiException('Home Finder posting is not available in the new API collection yet.');
  }

  Future<List<Map<String, dynamic>>> savedSearches(String customerId) async => [];

  Future<List<Map<String, dynamic>>> propertyMessages(String customerId) async => [];

  Future<List<Map<String, dynamic>>> rentTrackers(String customerId) async => [];

  Future<void> saveRentTracker(String customerId, Map<String, dynamic> data) async {
    throw const ApiException('Rent tracker API is not available in the new API collection yet.');
  }

  Future<Map<String, num>> estimatePropertyValue({required String propertyType, int? bhk, String? city}) async {
    return {'low': 0, 'average': 0, 'high': 0};
  }

  Future<List<Map<String, dynamic>>> socialFeed() async {
    final authed = await apiSession.hasToken();
    final rows = await _safeList(() => _api.getList(authed ? '/api/v1/social/feed' : '/api/v1/social/feed/public', auth: authed));
    return rows;
  }

  Future<Map<String, dynamic>?> socialPost(String postId) async {
    if (!await apiSession.hasToken()) return null;
    return _safeMap(() => _api.getJson('/api/v1/social/posts/$postId', auth: true));
  }

  Future<List<Map<String, dynamic>>> socialComments(String postId) async {
    if (!await apiSession.hasToken()) return [];
    return _safeList(() => _api.getList('/api/v1/social/posts/$postId/comments', auth: true));
  }

  Future<void> createSocialPost(String userId, Map<String, dynamic> data) async {
    await _api.postJson(
      '/api/v1/social/posts',
      body: {
        'contentText': data['content_text'] ?? data['contentText'] ?? data['caption'] ?? '',
        'mediaUrls': data['media_urls'] ?? data['mediaUrls'] ?? [],
        'postType': data['post_type'] ?? data['postType'] ?? 'text',
        'visibility': data['visibility'] ?? 'public',
        'location': data['location'],
        'tags': data['tags'] ?? [],
        'category': data['category'] ?? 'general',
      },
      auth: true,
    );
  }

  Future<List<Map<String, dynamic>>> socialProfiles({String? search}) async {
    if (!await apiSession.hasToken()) return [];
    final rows = await _safeList(() => _api.getList('/api/v1/social/users/suggestions', query: {'q': search}, auth: true));
    return rows;
  }

  Future<Map<String, dynamic>?> socialProfile(String userId) async {
    if (!await apiSession.hasToken()) return null;
    final path = userId == 'me' ? '/api/v1/social/users/me/profile' : '/api/v1/social/users/$userId/profile';
    return _safeMap(() => _api.getJson(path, auth: true));
  }

  Future<List<Map<String, dynamic>>> socialNotifications(String userId) async {
    if (!await apiSession.hasToken()) return [];
    return _safeList(() => _api.getList('/api/v1/social/notifications/me', auth: true));
  }

  Future<List<Map<String, dynamic>>> socialConversations(String userId) async {
    if (!await apiSession.hasToken()) return [];
    return _safeList(() => _api.getList('/api/v1/social/messages/conversations', auth: true));
  }

  Future<List<Map<String, dynamic>>> socialMessages(String conversationId) async {
    if (!await apiSession.hasToken()) return [];
    return _safeList(() => _api.getList('/api/v1/social/messages/conversations/$conversationId/messages', auth: true));
  }

  Future<void> accountDeletionRequest(String customerId) async {
    throw const ApiException('Account deletion request API is not available in the new API collection yet.');
  }

  Future<List<CartItem>> cartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final local = decodeCart(prefs.getString(_cartKey));
    if (local.isNotEmpty || !await apiSession.hasToken()) return local;
    final remote = await _safeList(() => _api.getList('/api/v1/commerce/cart', auth: true));
    final items = remote.map(_cartItemFromApi).toList();
    if (items.isNotEmpty) await _saveCart(items);
    return items;
  }

  Future<void> _saveCart(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cartKey, encodeCart(items));
  }

  Future<void> addToCart(Map<String, dynamic> product, {int qty = 1, Map<String, String>? selectedAttributes, String? variantId}) async {
    final cart = await cartItems();
    final parentId = product['parent_item_id']?.toString();
    if (parentId != null && parentId.isNotEmpty) {
      final conflict = cart.where((item) => item.parentItemId == parentId && item.vendorId != product.s('vendor_id') && item.productId != product.s('id'));
      if (conflict.isNotEmpty) {
        throw const ApiException('This product is already added from another vendor. Please remove it first.');
      }
    }
    final productId = product.s('id');
    final cartId = variantId == null ? productId : '${productId}__$variantId';
    final index = cart.indexWhere((item) => item.id == cartId);
    if (index >= 0) {
      cart[index] = cart[index].copyWith(qty: cart[index].qty + qty);
    } else {
      cart.add(CartItem(
        id: cartId,
        productId: productId,
        title: product.s('title', product.s('name')),
        price: product.n('price', product.n('sellPrice', product.n('finalPrice'))),
        qty: qty,
        vendor: product.s('vendor_name', product.s('vendorName')),
        vendorId: product.s('vendor_id', product.s('vendorId')),
        image: product.s('image', product.s('thumbnailUrl')).isEmpty ? null : product.s('image', product.s('thumbnailUrl')),
        parentItemId: parentId,
        variantId: variantId,
        selectedAttributes: selectedAttributes,
        tax: product.n('tax'),
        discount: product.n('discount', product.n('discountAmount')),
        maxPoints: product.i('max_points_redeemable', product.i('maxPointsRedeemable')),
      ));
    }
    await _saveCart(cart);
    await _syncCart(cart);
  }

  Future<void> updateCartItem(String itemId, int qty) async {
    final cart = await cartItems();
    final index = cart.indexWhere((item) => item.id == itemId);
    if (index < 0) return;
    if (qty <= 0) {
      cart.removeAt(index);
    } else {
      cart[index] = cart[index].copyWith(qty: qty);
    }
    await _saveCart(cart);
    await _syncCart(cart);
  }

  Future<void> clearCart() async {
    await _saveCart([]);
    if (await apiSession.hasToken()) {
      await _api.deleteJson('/api/v1/commerce/cart', auth: true).catchError((_) => <String, dynamic>{});
    }
  }

  Future<CartSummary> cartSummary({int pointsUsed = 0}) async {
    final items = await cartItems();
    final subtotal = items.fold<num>(0, (sum, item) => sum + item.price * item.qty);
    final tax = items.fold<num>(0, (sum, item) => sum + item.tax * item.qty);
    final discount = items.fold<num>(0, (sum, item) => sum + item.discount * item.qty);
    var platformFee = 0;
    if (await apiSession.hasToken()) {
      final quote = await _safeMap(() => _api.postJson('/api/v1/commerce/checkout/quote', body: {'itemTotal': subtotal, 'discount': discount}, auth: true));
      platformFee = quote?.i('platformFee', quote.i('platform_fee')) ?? 0;
    }
    return CartSummary(items: items, subtotal: subtotal, tax: tax, discount: discount, platformFee: platformFee, pointsUsed: pointsUsed);
  }

  Future<Set<String>> wishlist() async {
    if (await apiSession.hasToken()) {
      final rows = await _safeList(() => _api.getList('/api/v1/profile/me/wishlist', auth: true));
      if (rows.isNotEmpty) {
        return rows
            .map((row) => row.s('productId', row.s('product_id', row.s('id'))))
            .where((id) => id.isNotEmpty)
            .toSet();
      }
    }
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_wishlistKey);
    if (raw == null) return {};
    final decoded = jsonDecode(raw);
    if (decoded is! List) return {};
    return decoded.map((e) => e.toString()).toSet();
  }

  Future<void> toggleWishlist(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final items = await wishlist();
    final remove = items.contains(id);
    if (remove) {
      items.remove(id);
    } else {
      items.add(id);
    }
    await prefs.setString(_wishlistKey, jsonEncode(items.toList()));
    if (await apiSession.hasToken()) {
      if (remove) {
        await _api.deleteJson('/api/v1/profile/me/wishlist/$id', auth: true).catchError((_) => <String, dynamic>{});
      } else {
        await _api.postJson('/api/v1/profile/me/wishlist', body: {'productId': id}, auth: true).catchError((_) => <String, dynamic>{});
      }
    }
  }

  Future<List<Map<String, dynamic>>> wishlistProducts() async {
    if (await apiSession.hasToken()) {
      final rows = await _safeList(() => _api.getList('/api/v1/profile/me/wishlist', auth: true));
      final products = rows.map((row) => row['product'] is Map ? Map<String, dynamic>.from(row['product'] as Map) : row).toList();
      return products.map(_normalizeProduct).toList();
    }
    final ids = (await wishlist()).toList();
    final products = <Map<String, dynamic>>[];
    for (final id in ids) {
      final item = await product(id);
      if (item != null) products.add(item);
    }
    return products;
  }

  Future<String?> selectedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_locationKey);
  }

  Future<void> saveSelectedLocation(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, value);
  }

  Future<void> _syncCart(List<CartItem> items) async {
    if (!await apiSession.hasToken()) return;
    await _api.putJson(
      '/api/v1/commerce/cart',
      body: {
        'items': items
            .map((item) => {
                  'productId': item.productId,
                  'quantity': item.qty,
                  'unitPrice': item.price,
                  'vendorId': item.vendorId,
                  'metadata': {'productName': item.title, 'variantId': item.variantId},
                })
            .toList(),
      },
      auth: true,
    ).catchError((_) => <String, dynamic>{});
  }

  CartItem _cartItemFromApi(Map<String, dynamic> row) {
    final product = row['product'] is Map ? Map<String, dynamic>.from(row['product'] as Map) : <String, dynamic>{};
    final merged = {...product, ...row};
    final productId = merged.s('productId', merged.s('product_id', merged.s('id')));
    return CartItem(
      id: merged.s('itemId', merged.s('item_id', productId)),
      productId: productId,
      title: merged.s('title', merged.s('name', merged.s('productName'))),
      price: merged.n('unitPrice', merged.n('price', merged.n('finalPrice'))),
      qty: merged.i('quantity', merged.i('qty', 1)),
      vendor: merged.s('vendorName', merged.s('vendor_name')),
      vendorId: merged.s('vendorId', merged.s('vendor_id')),
      image: merged.s('image', merged.s('thumbnailUrl')),
      tax: merged.n('tax'),
      discount: merged.n('discount', merged.n('discountAmount')),
    );
  }

  Map<String, dynamic> _normalizeProduct(Map<String, dynamic> row) {
    final vendor = row['vendor'] is Map ? Map<String, dynamic>.from(row['vendor'] as Map) : <String, dynamic>{};
    final image = row.s('image', row.s('imageUrl', row.s('thumbnailUrl')));
    return {
      ...row,
      'id': row.s('id', row.s('productId')),
      'title': row.s('title', row.s('name', row.s('productName'))),
      'price': row.n('price', row.n('sellPrice', row.n('finalPrice'))),
      'discount': row.n('discount', row.n('discountAmount')),
      'tax': row.n('tax'),
      'stock': row.i('stock', row.i('availableStock')),
      'image': image.isNotEmpty ? image : _firstString(row['bannerUrls'] ?? row['images'] ?? row['mediaUrls']),
      'vendor_id': row.s('vendor_id', row.s('vendorId', vendor.s('id'))),
      'vendor_name': row.s('vendor_name', row.s('vendorName', vendor.s('businessName', vendor.s('business_name')))),
      'category_name': row.s('category_name', row.s('categoryName')),
      'status': row.s('status', row['isActive'] == false ? 'inactive' : 'active'),
    };
  }

  Map<String, dynamic> _normalizeService(Map<String, dynamic> row) {
    return {
      ...row,
      'id': row.s('id', row.s('serviceId')),
      'title': row.s('title', row.s('displayName', row.s('name'))),
      'price': row.n('price', row.n('basePrice')),
      'image': row.s('image', row.s('iconUrl', row.s('thumbnailUrl'))),
      'vendor_id': row.s('vendor_id', row.s('vendorId')),
      'category_name': row.s('category_name', row.s('categoryName')),
      'status': row.s('status', row['isActive'] == false ? 'inactive' : 'active'),
    };
  }

  Map<String, dynamic> _normalizeVendor(Map<String, dynamic> row) => {
        ...row,
        'id': row.s('id', row.s('vendorId')),
        'business_name': row.s('business_name', row.s('businessName')),
        'name': row.s('name', row.s('ownerName')),
        'mobile': row.s('mobile', row.s('phone')),
      };

  Map<String, dynamic> _normalizeCategory(Map<String, dynamic> row) => {
        ...row,
        'id': row.s('id', row.s('categoryId')),
        'name': row.s('name', row.s('title')),
        'image': row.s('image', row.s('imageUrl', row.s('iconUrl'))),
      };

  Map<String, dynamic> _normalizeOrder(Map<String, dynamic> row) => {
        ...row,
        'id': row.s('id', row.s('orderId')),
        'total': row.n('total', row.n('totalAmount', row.n('grandTotal'))),
        'created_at': row.s('created_at', row.s('createdAt')),
        'payment_status': row.s('payment_status', row.s('paymentStatus')),
      };

  Map<String, dynamic> _normalizeAddress(Map<String, dynamic> row) => {
        ...row,
        'id': row.s('id', row.s('addressId')),
        'name': row.s('name', row.s('label')),
        'mobile': row.s('mobile', row.s('phone')),
        'address_line': row.s('address_line', row.s('line1')),
        'is_default': row['is_default'] ?? row['isDefault'] ?? false,
      };

  Map<String, dynamic> _addressPayload(Map<String, dynamic> address) => {
        'label': address.s('label', address.s('name', 'Home')),
        'line1': address.s('line1', address.s('address_line')),
        'line2': address.s('line2'),
        'city': address.s('city'),
        'state': address.s('state'),
        'pincode': address.s('pincode'),
        'latitude': address['latitude'],
        'longitude': address['longitude'],
        'isDefault': address['is_default'] ?? address['isDefault'] ?? false,
      };

  Map<String, String> _assetMap(Map<String, dynamic> home) {
    final assets = <String, String>{};
    final rawAssets = home['assets'];
    if (rawAssets is Map) {
      for (final entry in rawAssets.entries) {
        assets[entry.key.toString()] = entry.value.toString();
      }
    }
    return assets;
  }

  String _firstString(Object? value) {
    if (value is List && value.isNotEmpty) return value.first?.toString() ?? '';
    return '';
  }

  Future<List<Map<String, dynamic>>> _safeList(Future<List<Map<String, dynamic>>> Function() loader) async {
    try {
      return await loader();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> _safeMap(Future<Map<String, dynamic>> Function() loader) async {
    try {
      return await loader();
    } catch (_) {
      return null;
    }
  }
}
