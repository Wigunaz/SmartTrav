import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Data simulasi dari server (Nanti dipindah ke HomeController)
  final List<Map<String, dynamic>> _trendingPackages = [
    {
      'id': 1,
      'nama_paket': 'Kuta-Ubud Paket Hemat',
      'agency': 'Global Tours',
      'harga': 'Rp 1.200.000',
      'rating': '4.7 (1.5k reviews)',
      'image_url': 'https://images.unsplash.com/photo-1537996194471-e657df975ab4',
    },
    {
      'id': 2,
      'nama_paket': 'Nusa Penida Explorer',
      'agency': 'Nippon Express',
      'harga': 'Rp 1.850.000',
      'rating': '4.9 (2.1k reviews)',
      'image_url': 'https://images.unsplash.com/photo-1596402184320-417e7178b2cd',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            SizedBox(height: 4),
            Text('Hello, Alex', style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 24.0),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================== CARD ATAS: TRIP & ESCROW STATUS ==================
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.1),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Ongoing Trip Status', 
                        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontWeight: FontWeight.w500)
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.15), 
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: const Text(
                          'Secured in Escrow', 
                          style: TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold)
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ALEX', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          SizedBox(height: 4),
                          Text('Traveler Client', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                      Icon(Icons.directions_walk_rounded, color: Colors.white.withOpacity(0.8), size: 28),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('GLOBAL', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          SizedBox(height: 4),
                          Text('Local Guide', style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // KATEGORI TENGAH DI-ILANGIN TOTAL, LANGSUNG JUMP KE TRENDING SECTION
            const SizedBox(height: 32),

            // ================== SECTION 2: TRENDING PACKAGES ==================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trending Packages',
                  style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('See All', style: TextStyle(color: Color(0xFF3B82F6), fontWeight: FontWeight.w600)),
                )
              ],
            ),
            const SizedBox(height: 8),

            // Gridview Dinamis merender Katalog Terpopuler dari Server
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72, 
              ),
              itemCount: _trendingPackages.length,
              itemBuilder: (context, index) {
                final package = _trendingPackages[index];
                return _buildTrendingCard(
                  title: package['nama_paket'],
                  agency: package['agency'],
                  price: package['harga'],
                  rating: package['rating'],
                  imageUrl: package['image_url'],
                  onTap: () {
                    // Action pas paket diklik
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET BUILDER: Card paket terpopuler lokal
  Widget _buildTrendingCard({
    required String title,
    required String agency,
    required String price,
    required String rating,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(17)),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.image_not_supported_rounded, color: Color(0xFF94A3B8)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'by $agency',
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          rating, 
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF3B82F6)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}