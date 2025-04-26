import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../bloc/ecg_bloc.dart';
import '../../repository/ecg_repository.dart';
import '../../models/ecg_data_point.dart';

class EcgPage extends StatefulWidget {
  const EcgPage({Key? key}) : super(key: key);

  @override
  State<EcgPage> createState() => _EcgPageState();
}

class _EcgPageState extends State<EcgPage> {
  late EcgBloc _ecgBloc;
  
  @override
  void initState() {
    super.initState();
    // Create the repository and bloc
    final repository = EcgRepository();
    _ecgBloc = EcgBloc(repository: repository);
  }
  
  @override
  void dispose() {
    _ecgBloc.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ECG Monitor'),
      ),
      body: StreamBuilder<EcgState>(
        stream: _ecgBloc.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final state = snapshot.data!;
          
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Data source indicator
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      state.isUsingRealData 
                          ? Icons.bluetooth_connected 
                          : Icons.bluetooth_disabled,
                      color: state.isUsingRealData ? Colors.blue : Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      state.isUsingRealData 
                          ? 'Using real ECG data' 
                          : 'Using simulated ECG data',
                      style: TextStyle(
                        color: state.isUsingRealData ? Colors.blue : Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // ECG Chart
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildEcgChart(state.dataPoints),
                ),
              ),
              
              // Diagnosis
              Container(
                padding: const EdgeInsets.all(16.0),
                color: _getDiagnosisColor(state.diagnosis),
                child: Column(
                  children: [
                    const Text(
                      'Diagnosis:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.diagnosis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildEcgChart(List<EcgDataPoint> dataPoints) {
    if (dataPoints.isEmpty) {
      return const Center(child: Text('No ECG data available'));
    }
    
    // Convert data points to FL Chart spots
    final spots = dataPoints.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();
    
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 0.5,
          verticalInterval: 20,
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.5,
              reservedSize: 40,
            ),
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: dataPoints.length.toDouble() - 1,
        minY: -1.1,
        maxY: 2.1,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: false,
            color: Colors.red,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
  
  Color _getDiagnosisColor(String diagnosis) {
    if (diagnosis.contains('arrhythmia')) {
      return Colors.red.withOpacity(0.2);
    } else if (diagnosis.contains('Normal')) {
      return Colors.green.withOpacity(0.2);
    }
    return Colors.grey.withOpacity(0.2);
  }
}
