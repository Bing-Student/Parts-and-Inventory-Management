import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportingScreen extends StatefulWidget {
  const ReportingScreen({super.key});

  @override
  State<ReportingScreen> createState() => _ReportingScreenState();
}

class _ReportingScreenState extends State<ReportingScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int selectedPeriod = 0; // 0: This Month, 1: This Quarter, 2: This Year

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF43B02A),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text(
          'Reports & Analytics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Period Selector
              _buildPeriodSelector(),
              const SizedBox(height: 20),

              // Key Metrics Cards
              _buildKeyMetricsSection(),
              const SizedBox(height: 25),

              // Inventory Overview Chart
              _buildInventoryOverviewChart(),
              const SizedBox(height: 25),

              // Top Requested Parts Chart
              _buildTopRequestedPartsChart(),
              const SizedBox(height: 25),

              // Spending Analysis Chart
              _buildSpendingAnalysisChart(),
              const SizedBox(height: 25),

              // Warehouse Utilization Chart
              _buildWarehouseUtilizationChart(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    final periods = ['This Month', 'This Quarter', 'This Year'];
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: periods.asMap().entries.map((entry) {
          int index = entry.key;
          String period = entry.value;
          bool isSelected = selectedPeriod == index;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedPeriod = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF43B02A) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKeyMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Total Parts', '1,248', Icons.inventory, Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard('Low Stock', '23', Icons.warning, Colors.orange)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Total Orders', '156', Icons.shopping_cart, Colors.purple)),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard('Total Value', '\$45,230', Icons.attach_money, Colors.green)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.trending_up, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryOverviewChart() {
    return _buildChartContainer(
      title: 'Inventory Status Distribution',
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sectionsSpace: 2,
            centerSpaceRadius: 50,
            sections: [
              PieChartSectionData(
                color: Colors.green,
                value: 65,
                title: 'In Stock\n65%',
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                color: Colors.orange,
                value: 20,
                title: 'Low Stock\n20%',
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                color: Colors.red,
                value: 10,
                title: 'Out of Stock\n10%',
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                radius: 60,
              ),
              PieChartSectionData(
                color: Colors.grey,
                value: 5,
                title: 'Damaged\n5%',
                titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                radius: 60,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRequestedPartsChart() {
    return _buildChartContainer(
      title: 'Top Requested Parts This Month',
      child: SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 50,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const parts = ['Brake Pads', 'Oil Filter', 'Spark Plugs', 'Air Filter', 'Tires'];
                    if (value.toInt() < parts.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          parts[value.toInt()],
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 45, color: const Color(0xFF43B02A))]),
              BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 38, color: const Color(0xFF43B02A))]),
              BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 32, color: const Color(0xFF43B02A))]),
              BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 28, color: const Color(0xFF43B02A))]),
              BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 25, color: const Color(0xFF43B02A))]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpendingAnalysisChart() {
    return _buildChartContainer(
      title: 'Monthly Spending Trend',
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 5000,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[300]!,
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                    if (value.toInt() < months.length) {
                      return Text(
                        months[value.toInt()],
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '\$${(value / 1000).toInt()}k',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: 5,
            minY: 0,
            maxY: 25000,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  const FlSpot(0, 15000),
                  const FlSpot(1, 18000),
                  const FlSpot(2, 12000),
                  const FlSpot(3, 22000),
                  const FlSpot(4, 19000),
                  const FlSpot(5, 24000),
                ],
                isCurved: true,
                color: const Color(0xFF43B02A),
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 4,
                      color: Colors.white,
                      strokeWidth: 2,
                      strokeColor: const Color(0xFF43B02A),
                    );
                  },
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF43B02A).withOpacity(0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarehouseUtilizationChart() {
    return _buildChartContainer(
      title: 'Warehouse Utilization',
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 100,
            barTouchData: BarTouchData(enabled: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    const warehouses = ['Warehouse A', 'Warehouse B', 'Warehouse C'];
                    if (value.toInt() < warehouses.length) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          warehouses[value.toInt()],
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}%',
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [BarChartRodData(toY: 85, color: Colors.blue, width: 20)],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [BarChartRodData(toY: 72, color: Colors.green, width: 20)],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [BarChartRodData(toY: 95, color: Colors.orange, width: 20)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartContainer({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.dmSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2E7D32),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
