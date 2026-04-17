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
  bool _hasFetched = false;

  @override
  void initState() {
    super.initState();
    // Tunggu frame pertama selesai, cek apakah sudah authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tryFetchProducts();
    });
  }

  void _tryFetchProducts() {
    final authState = context.read<AuthProvider>();
    if (authState.status == AuthStatus.authenticated && !_hasFetched) {
      _hasFetched = true;
      context.read<ProductProvider>().fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductProvider>();
    final authState = context.watch<AuthProvider>();

    // Jika baru saja authenticated dan belum fetch, fetch sekarang
    if (authState.status == AuthStatus.authenticated && !_hasFetched) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _tryFetchProducts());
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
          // ─── Header ────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 240.0,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF0D47A1),
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.white),
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'RentBike Premium',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                    ),
                  ),
                  Text(
                    'Sewa sepeda impianmu hari ini',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 6)],
                    ),
                  ),
                ],
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1511994298241-608e28f14fde?auto=format&fit=crop&q=80&w=1200',
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, p) =>
                        p == null ? child : Container(color: const Color(0xFF0D47A1)),
                    errorBuilder: (ctx, e, st) =>
                        Container(color: const Color(0xFF0D47A1)),
                  ),
                  // gradient dari atas transparan → bawah gelap
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x330D47A1), Color(0xEE0D47A1)],
                        stops: [0.0, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Section title ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Katalog Sepeda',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D2060),
                    ),
                  ),
                  if (productState.status == ProductStatus.loaded)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0D47A1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${productState.products.length} unit',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ─── State: loading / error / empty / grid ──────────────────
          if (productState.status == ProductStatus.loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF0D47A1)),
                    SizedBox(height: 14),
                    Text('Memuat katalog...',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else if (productState.status == ProductStatus.error)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          color: Colors.grey, size: 60),
                      const SizedBox(height: 12),
                      Text(
                        productState.errorMessage ?? 'Gagal memuat produk',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else if (productState.products.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.pedal_bike_rounded,
                        size: 64, color: Colors.grey),
                    SizedBox(height: 10),
                    Text('Belum ada sepeda tersedia.',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  // Aspect ratio: lebar ≈ 170px, tinggi card ≈ 260px → 170/260 ≈ 0.65
                  childAspectRatio: 0.65,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final p = productState.products[index];
                    return _BikeCard(product: p, index: index);
                  },
                  childCount: productState.products.length,
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CARD WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _BikeCard extends StatelessWidget {
  final dynamic product;
  final int index;

  const _BikeCard({required this.product, required this.index});

  static const _fallback = [
    'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1620614051012-1d5422ab88ef?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1549419131-ab1ab73f9104?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1507035895480-2b3156c31fc4?auto=format&fit=crop&q=80&w=600',
  ];

  @override
  Widget build(BuildContext context) {
    final bool outOfStock = product.stock == 0;
    final bool lowStock = product.stock > 0 && product.stock <= 5;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A0D47A1),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── GAMBAR: 58% tinggi card ─────────────────────────────
          Expanded(
            flex: 58,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Gambar utama
                _NetImage(_resolveUrl(product.imageUrl), index),

                // Gradient bawah untuk readability text
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x88000000)],
                      stops: [0.55, 1.0],
                    ),
                  ),
                ),

                // ── Badge HABIS ────────────────────────────────────
                if (outOfStock)
                  Positioned.fill(
                    child: Container(
                      color: const Color(0x99000000),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.red[700],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'STOK HABIS',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),

                // ── Badge kategori (kiri atas) ─────────────────────
                if ((product.category as String).isNotEmpty)
                  Positioned(
                    top: 9,
                    left: 9,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xDD0D47A1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),

                // ── Harga di overlay bawah gambar ─────────────────
                Positioned(
                  bottom: 8,
                  left: 10,
                  child: Text(
                    'Rp ${_fmtPrice(product.price as double)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── INFO BAWAH: 42% tinggi card ────────────────────────
          Expanded(
            flex: 42,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(11, 10, 11, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama sepeda
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0D2060),
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Deskripsi singkat
                  if ((product.description as String).isNotEmpty)
                    Text(
                      product.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF8A94A6),
                        height: 1.4,
                      ),
                    ),

                  const Spacer(),

                  // Stok + tombol cart
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Dot + teks stok
                      Container(
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: outOfStock
                              ? Colors.red
                              : lowStock
                                  ? Colors.orange
                                  : const Color(0xFF00C853),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          outOfStock
                              ? 'Habis'
                              : lowStock
                                  ? 'Sisa ${product.stock}'
                                  : 'Stok ${product.stock}',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: outOfStock
                                ? Colors.red
                                : lowStock
                                    ? Colors.orange
                                    : const Color(0xFF00C853),
                          ),
                        ),
                      ),

                      // Tombol cart
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: outOfStock
                              ? const Color(0xFFF0F0F0)
                              : const Color(0xFF0D47A1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 16,
                          color:
                              outOfStock ? Colors.grey : Colors.white,
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
    );
  }

  String _resolveUrl(String url) {
    if (url.isEmpty) return _fallback[index % _fallback.length];
    if (!url.startsWith('http')) {
      return 'http://192.168.0.105:8080${url.startsWith('/') ? url : '/$url'}';
    }
    return url;
  }

  String _fmtPrice(double price) {
    if (price >= 1000000) {
      final juta = price / 1000000;
      return juta == juta.roundToDouble()
          ? '${juta.toInt()}jt'
          : '${juta.toStringAsFixed(1)}jt';
    }
    return '${(price / 1000).toStringAsFixed(0)}rb';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NETWORK IMAGE WIDGET dengan loading shimmer
// ─────────────────────────────────────────────────────────────────────────────
class _NetImage extends StatelessWidget {
  final String url;
  final int index;

  static const _fallback = [
    'https://images.unsplash.com/photo-1485965120184-e220f721d03e?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1532298229144-0ec0c57515c7?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1620614051012-1d5422ab88ef?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1549419131-ab1ab73f9104?auto=format&fit=crop&q=80&w=600',
    'https://images.unsplash.com/photo-1507035895480-2b3156c31fc4?auto=format&fit=crop&q=80&w=600',
  ];

  const _NetImage(this.url, this.index);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return _Shimmer();
      },
      errorBuilder: (ctx, err, st) => Image.network(
        _fallback[index % _fallback.length],
        fit: BoxFit.cover,
        loadingBuilder: (ctx, child, progress) =>
            progress == null ? child : _Shimmer(),
        errorBuilder: (ctx, e, s) => Container(
          color: const Color(0xFFE8ECF2),
          alignment: Alignment.center,
          child: const Icon(Icons.pedal_bike_rounded,
              size: 40, color: Color(0xFFB0BEC5)),
        ),
      ),
    );
  }
}

// Shimmer loading placeholder
class _Shimmer extends StatefulWidget {
  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 0.9).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        color: Color.lerp(
            const Color(0xFFDDE3EE), const Color(0xFFF0F4FF), _anim.value),
      ),
    );
  }
}