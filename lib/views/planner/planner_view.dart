import 'package:flutter/material.dart';
import '../../controllers/planner_controller.dart';

class PlannerView extends StatefulWidget {
  const PlannerView({Key? key}) : super(key: key);

  @override
  State<PlannerView> createState() => _PlannerViewState();
}

class _PlannerViewState extends State<PlannerView> with TickerProviderStateMixin {
  final PlannerController _controller = PlannerController();

  // State lokal baru untuk kriteria planner yang mengalir ke bawah
  int _passengerCount = 1;
  String _selectedTravelStyle = 'Standard';

  // Opsi untuk filter dropdown dan chips
  final List<String> _destinations = ['Bali, Indonesia', 'Yogyakarta', 'Lombok', 'Labuan Bajo'];
  final List<String> _travelStyles = ['Backpacker', 'Standard', 'Luxury'];

  @override
  void initState() {
    super.initState();
    
    // 1. Inisialisasi konfigurasi dasar dari controller
    _controller.initData();
    
    // 2. PAKSA KOSONGKAN/RESET data awal agar sinkron dengan sistem form mengalir ke bawah
    _controller.model.totalBudget = 0.0;
    _controller.model.destination = ''; 
    _controller.model.durationDays = 0;
    _controller.model.selectedAgency = ''; // Nanti ini diisi nama paket yang dipilih
    
    // Sinkronisasi ke state lokal awal
    _passengerCount = 1;
    _selectedTravelStyle = 'Standard';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.checkBudgetConstraint(context);
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
            // ================== SECTION 1: SET TOTAL BUDGET ==================
            const Text(
              "SET TOTAL BUDGET",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
            ),
            const SizedBox(height: 8),
            TextFormField(
              key: ValueKey(_controller.model.totalBudget),
              initialValue: _controller.model.totalBudget == 0.0 ? '' : _controller.model.totalBudget.toInt().toString(),
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              decoration: InputDecoration(
                hintText: '0',
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  child: Text('Rp ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
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

            // ================== SECTION 2: DESTINATION & DURATION ==================
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("DESTINATION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _controller.model.destination.isEmpty ? null : _controller.model.destination,
                        hint: const Text('Select Location', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14)),
                        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        items: _destinations.map((String value) {
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
                        key: ValueKey(_controller.model.durationDays),
                        initialValue: _controller.model.durationDays == 0 ? '' : _controller.model.durationDays.toString(),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        decoration: InputDecoration(
                          hintText: '0',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _controller.updateDuration(int.tryParse(value) ?? 0);
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

            // ================== SECTION 3: PASSENGER COUNT (COUNTER) ==================
            const Text("NUMBER OF TRAVELERS", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Persons", style: TextStyle(color: Color(0xFF0F172A), fontSize: 15, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _passengerCount > 1 
                            ? () => setState(() => _passengerCount--) 
                            : null,
                        icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF3B82F6)),
                      ),
                      Text(
                        '$_passengerCount',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _passengerCount++),
                        icon: const Icon(Icons.add_circle_outline, color: Color(0xFF3B82F6)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ================== SECTION 4: TRAVEL STYLE (CHIPS) ==================
            const Text("TRAVEL STYLE", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _travelStyles.map((style) {
                final isSelected = _selectedTravelStyle == style;
                return _buildAnimatedFilterChip(
                  label: style,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedTravelStyle = style),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // ================== SECTION 5: AVAILABLE AGENCY PACKAGES ==================
            const Text("AVAILABLE PACKAGES BASED ON BUDGET", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildAnimatedAgencyCard(
                    name: 'Paket Kuta-Ubud 3D2N',
                    agency: 'Global Tours',
                    totalPrice: 'Rp 1.200.000',
                    rating: '4.7 (1.5k reviews)',
                    isSelected: _controller.model.selectedAgency == 'Global Tours',
                    onTap: () => setState(() => _controller.selectAgency('Global Tours', 1200000.00)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildAnimatedAgencyCard(
                    name: 'Paket Nusa Penida Explorer',
                    agency: 'Nippon Express',
                    totalPrice: 'Rp 1.850.000',
                    rating: '4.9 (2.1k reviews)',
                    isSelected: _controller.model.selectedAgency == 'Nippon Express',
                    onTap: () => setState(() => _controller.selectAgency('Nippon Express', 1850000.00)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ================== SECTION 6: ESTIMATED COSTS SUMMARY ==================
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Estimated Cost Summary', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  _buildCostRow('Base Package Fee', _controller.model.selectedAgency.isEmpty ? 'Rp 0' : 'Rp ${_controller.model.hotelAndAgencyCost.toInt()}'),
                  const SizedBox(height: 12),
                  _buildCostRow('Platform Admin (10%)', 'Included'),
                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, thickness: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Package Price', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        'Rp ${_controller.model.totalEstimatedCost.toInt().toString().replaceAllMapped(RegExp(r"(\d{1,3})(?=(\d{3})+(?!\d))"), (Match m) => "${m[1]},")}',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  // Tombol Checkout / Pesan Paket yang interaktif
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 700),
                    firstCurve: Curves.easeOutCubic,
                    secondCurve: Curves.easeInCubic,
                    crossFadeState: !isOverlimit && _controller.model.totalEstimatedCost > 0 
                        ? CrossFadeState.showFirst 
                        : CrossFadeState.showSecond,
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
                                  content: Text('Processing Down Payment to Escrow... safe trip! ✈️'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Book Package Now", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(width: 8),
                                Icon(Icons.assignment_turned_in_rounded, color: Colors.white, size: 18),
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

  Widget _buildAnimatedFilterChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected 
              ? [BoxShadow(color: const Color(0xFF0F172A).withOpacity(0.15), blurRadius: 8, offset: const Offset(0, 4))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF64748B),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedAgencyCard({
    required String name,
    required String agency,
    required String totalPrice,
    required String rating,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
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
              ? [BoxShadow(color: const Color(0xFF3B82F6).withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 6))]
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
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  child: const Icon(Icons.check_circle, color: Color(0xFF3B82F6), size: 20),
                )
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name, 
              key: const ValueKey('pkg_title'), 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)), 
              maxLines: 2, 
              overflow: TextOverflow.ellipsis
            ),
            const SizedBox(height: 2),
            Text('by $agency', style: const TextStyle(color: Color(0xFF64748B), fontSize: 11)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 12),
                const SizedBox(width: 4),
                Expanded(child: Text(rating, style: const TextStyle(color: Color(0xFF64748B), fontSize: 10), overflow: TextOverflow.ellipsis)),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFF0F172A),
              ),
              child: Text(totalPrice),
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