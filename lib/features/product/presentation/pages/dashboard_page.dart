import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/product_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // ── Header (SliverAppBar) ──────────────────────────────────
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            backgroundColor: Colors.blue[900],
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'RentBike Premium',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 15)],
                ),
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1511994298241-608e28f14fde?auto=format&fit=crop&q=80&w=1200',
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, stack) => Container(
                      color: Colors.blue[900],
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent, Colors.black87],
                        stops: [0.0, 0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Judul Explore ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Explore Bikes',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(Icons.directions_bike_rounded, color: Colors.blue[800], size: 28),
                ],
              ),
            ),
          ),

          // ── Handling Status Loading / Error ────────────────────────
          if (productState.status == ProductStatus.loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (productState.status == ProductStatus.error)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  productState.errorMessage ?? 'Gagal memuat produk',
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            )
          else if (productState.products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text('Belum ada sepeda tersedia.')),
            )
          else
            // ── Grid Katalog ─────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = productState.products[index];
                    final isLowStock = product.stock > 0 && product.stock <= 5;
                    final isOutOfStock = product.stock == 0;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.withOpacity(0.1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1. Gambar Sepeda
                            Expanded(
                              flex: 5,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _buildProductImage(product.imageUrl, index),
                                  // Badge stok habis
                                  if (isOutOfStock)
                                    Container(
                                      color: Colors.black.withOpacity(0.5),
                                      child: const Center(
                                        child: Text(
                                          'HABIS',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 14,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  // Label kategori di pojok atas
                                  if (product.category.isNotEmpty)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.blue[900]!.withOpacity(0.85),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          product.category,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // 2. Info produk
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Nama produk
                                    Text(
                                      product.name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        height: 1.3,
                                        color: Colors.black87,
                                      ),
                                    ),

                                    // Stok
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 11,
                                          color: isOutOfStock
                                              ? Colors.red
                                              : isLowStock
                                                  ? Colors.orange
                                                  : Colors.green[700],
                                        ),
                                        const SizedBox(width: 3),
                                        Text(
                                          isOutOfStock
                                              ? 'Stok habis'
                                              : 'Stok: ${product.stock}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: isOutOfStock
                                                ? Colors.red
                                                : isLowStock
                                                    ? Colors.orange
                                                    : Colors.green[700],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Harga & icon cart
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            'Rp ${_formatPrice(product.price)}',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: isOutOfStock ? Colors.grey[200] : Colors.blue[50],
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Icon(
                                            Icons.add_shopping_cart,
                                            color: isOutOfStock ? Colors.grey : Colors.blue[900],
                                            size: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: productState.products.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  /// Format harga: >= 1jt → "1,5jt", < 1jt → "750rb"
  String _formatPrice(double price) {
    if (price >= 1000000) {
      final juta = price / 1000000;
      return juta == juta.roundToDouble()
          ? '${juta.toInt()}jt'
          : '${juta.toStringAsFixed(1)}jt';
    } else {
      return '${(price / 1000).toStringAsFixed(0)}rb';
    }
  }

  Widget _buildProductImage(String imageUrl, int index) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder(index);
    }

    String finalUrl = imageUrl;
    if (!imageUrl.startsWith('http')) {
      finalUrl = 'http://192.168.0.105:8080${imageUrl.startsWith('/') ? imageUrl : '/$imageUrl'}';
    }

    return Image.network(
      finalUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(index),
    );
  }

  Widget _buildPlaceholder(int index) {
    final fallbackImages = [
      'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&q=80&w=400',
      'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?auto=format&fit=crop&q=80&w=400',
      'https://images.unsplash.com/photo-1262601715426-bacfa951edba?auto=format&fit=crop&q=80&w=400',
      'https://images.unsplash.com/photo-1507035895480-2b3156c31fc4?auto=format&fit=crop&q=80&w=400',
    ];
    return Image.network(
      fallbackImages[index % fallbackImages.length],
      fit: BoxFit.cover,
      errorBuilder: (context, err, stack) => Container(
        color: Colors.grey[200],
        child: const Icon(Icons.pedal_bike, size: 30, color: Colors.grey),
      ),
    );
  }
}