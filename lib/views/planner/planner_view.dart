import 'package:flutter/material.dart';
import '../../controllers/planner_controller.dart';

class PlannerView extends StatefulWidget {
  const PlannerView({Key? key}) : super(key: key);

  @override
  State<PlannerView> createState() => _PlannerViewState();
}

class _PlannerViewState extends State<PlannerView> with TickerProviderStateMixin {
  final PlannerController _controller = PlannerController();

  // State lokal untuk interaksi dinamis attractions & foods
  final List<String> _selectedAttractions = ['Shibuya Crossing', 'Mount Fuji'];
  final List<String> _selectedFoods = ['Ramen'];

  @override
  void initState() {
    super.initState();
    _controller.initData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.checkBudgetConstraint(context);
    });
  }

  // Fungsi toggle item wisata dengan animasi state
  void _toggleAttraction(String name) {
    setState(() {
      if (_selectedAttractions.contains(name)) {
        _selectedAttractions.remove(name);
      } else {
        _selectedAttractions.add(name);
      }
      _controller.model.selectedAttractions = _selectedAttractions;
    });
  }

  // Fungsi toggle item kuliner dengan animasi state
  void _toggleFood(String name) {
    setState(() {
      if (_selectedFoods.contains(name)) {
        _selectedFoods.remove(name);
      } else {
        _selectedFoods.add(name);
      }
      _controller.model.selectedFoods = _selectedFoods;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOverlimit = _controller.model.isOverlimit;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFF1F5F9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 16),
              onPressed: () => Navigator.maybePop(context),
            ),
          ),
        ),
        title: const Text(
          'Trip Planner',
          style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================== SECTION: SET TOTAL BUDGET ==================
            const Text(
              "SET TOTAL BUDGET",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _controller.model.totalBudget.toInt().toString(),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              decoration: InputDecoration(
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Text('\$', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                ),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _controller.updateBudget(double.tryParse(value) ?? 0.0);
                  _controller.checkBudgetConstraint(context);
                });
              },
            ),
            const SizedBox(height: 24),

            // ================== ROW: DESTINATION & DURATION ==================
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DESTINATION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _controller.model.destination,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        items: ['Tokyo, Japan', 'Bali, Indonesia', 'Paris, France'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 15)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            if (newValue != null) {
                              _controller.model.destination = newValue;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DURATION (DAYS)", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: _controller.model.durationDays.toString(),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _controller.updateDuration(int.tryParse(value) ?? 1);
                            _controller.checkBudgetConstraint(context);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ================== SECTION: HOTEL & VILLA'S ==================
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("HOTEL & VILLA'S", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _controller.model.selectedHotel,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  items: ['Shinagawa Prince Hotel', 'The Ritz-Carlton Tokyo', 'Hotel New Otani', 'Park Hyatt Tokyo'].map((String hotel) {
                    return DropdownMenuItem<String>(
                      value: hotel,
                      child: Text(hotel, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 15), overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue != null) {
                        _controller.model.selectedHotel = newValue;
                      }
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ================== SECTION: TOURIST ATTRACTIONS ==================
            const Text("TOURIST ATTRACTIONS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Shibuya Crossing', 'Mount Fuji', 'Akihabara', 'Senso-ji'].map((item) {
                final isSelected = _selectedAttractions.contains(item);
                return _buildAnimatedFilterChip(
                  label: isSelected ? item : '+ $item',
                  isSelected: isSelected,
                  onTap: () => _toggleAttraction(item),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // ================== SECTION: TYPICAL FOODS ==================
            const Text("TYPICAL FOODS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Ramen', 'Sushi', 'Takoyaki'].map((item) {
                final isSelected = _selectedFoods.contains(item);
                return _buildAnimatedFilterChip(
                  label: isSelected ? item : '+ $item',
                  isSelected: isSelected,
                  onTap: () => _toggleFood(item),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // ================== SECTION: SELECT AGENCY ==================
            const Text("SELECT AGENCY", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAnimatedAgencyCard(
                    name: 'Nippon Express',
                    price: '\$420/day',
                    rating: '4.9 (2.1k reviews)',
                    isSelected: _controller.model.selectedAgency == 'Nippon Express',
                    onTap: () => setState(() => _controller.selectAgency('Nippon Express', 420.00)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnimatedAgencyCard(
                    name: 'Global Tours',
                    price: '\$380/day',
                    rating: '4.7 (1.5k reviews)',
                    isSelected: _controller.model.selectedAgency == 'Global Tours',
                    onTap: () => setState(() => _controller.selectAgency('Global Tours', 380.00)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ================== BOX: ESTIMATED COSTS SUMMARY ==================
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estimated Costs', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildCostRow('Flights (Round Trip)', '\$${_controller.model.flightCost.toInt()}.00'),
                  const SizedBox(height: 12),
                  _buildCostRow('Hotel & Agency (${_controller.model.durationDays} Days)', '\$${_controller.model.hotelAndAgencyCost.toInt()}.00'),
                  const SizedBox(height: 12),
                  _buildCostRow('Activities & Food', '\$${_controller.model.activitiesAndFoodCost.toInt()}.00'),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Estimated', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        '\$${_controller.model.totalEstimatedCost.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}.00',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  // ANIMASI ELEGAN: Tombol "Let's Flight" muncul melambat hanya jika budget cukup
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 700), // Lambat dan halus
                    firstCurve: Curves.easeOutCubic,
                    secondCurve: Curves.easeInCubic,
                    crossFadeState: !isOverlimit ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    secondChild: const SizedBox(width: double.infinity),
                    firstChild: Column(
                      children: [
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Processing payment... safe flight! ✈️'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text("Let's Flight", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.flight_takeoff_rounded, color: Colors.white, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _controller.checkBudgetConstraint(context),
        backgroundColor: const Color(0xFF0F172A),
        child: const Icon(Icons.analytics_outlined, color: Colors.white),
      ),
    );
  }

  // ================== ANIMATED COMPONENTS BUILDERS ==================

  // 1. Animasi Slow-Elegant untuk Penambahan & Penghapusan Wisata/Makanan (Chips)
  Widget _buildAnimatedFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500), // Transisi warna melambat dan rileks
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected 
              ? [BoxShadow(color: const Color(0xFF0F172A).withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 400),
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontFamily: 'Inter',
              ),
              child: Text(label),
            ),
            // Ikon penutup mengecil/membesar dengan animasi transisi struktural
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              width: isSelected ? 20 : 0,
              child: isSelected
                  ? const Padding(
                      padding: EdgeInsets.only(left: 6.0),
                      child: Icon(Icons.close, color: Colors.white, size: 14),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // 2. Animasi Slow-Elegant untuk Pemilihan Kartu Agensi Wisata
  Widget _buildAnimatedAgencyCard({
    required String name,
    required String price,
    required String rating,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600), // Animasi border & shadow halus bergaya profesional
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected 
              ? [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 6))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network('https://images.unsplash.com/photo-1537996194471-e657df975ab4', width: 32, height: 32, fit: BoxFit.cover),
                ),
                AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.elasticOut,
                  child: const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 20),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF0F172A))),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 14),
                const SizedBox(width: 4),
                Text(rating, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 400),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF64748B),
              ),
              child: Text(price),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String title, String cost) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
        Text(cost, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}