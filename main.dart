import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(EnergyTrackerApp());
}

class EnergyTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EnergyScreen(),
    );
  }
}

class EnergyScreen extends StatefulWidget {
  @override
  _EnergyScreenState createState() => _EnergyScreenState();
}

class _EnergyScreenState extends State<EnergyScreen> with SingleTickerProviderStateMixin {
  int energy = 10;
  int maxEnergy = 10;
  List<bool> batteries = [true, true, true];
  AudioPlayer player = AudioPlayer();

  void changeEnergy(int amount) {
    setState(() {
      energy = (energy + amount).clamp(0, maxEnergy);
    });
  }

  void useBattery(int index) {
    setState(() {
      if (batteries[index]) batteries[index] = false;
    });
  }

  void resetEnergy() async {
    await player.play(AssetSource('powerup.mp3'));
    for (int i = energy; i <= maxEnergy; i++) {
      await Future.delayed(Duration(milliseconds: 50));
      setState(() {
        energy = i;
      });
    }
  }

  LinearGradient getGradient() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.red,
        Colors.yellow,
        Colors.green,
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }

  @override
  Widget build(BuildContext context) {
    double barHeight = MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => changeEnergy(-3),
                  child: Text("-3 Energie"),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: resetEnergy,
                  child: Text("Aufladen"),
                ),
              ],
            ),
            SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, color: Colors.white),
                  onPressed: () => changeEnergy(-1),
                ),
                Stack(
                  children: [
                    Container(
                      width: 60,
                      height: barHeight,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: 60,
                        height: barHeight * (energy / maxEnergy),
                        decoration: BoxDecoration(
                          gradient: getGradient(),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () => changeEnergy(1),
                ),
              ],
            ),
            SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return IconButton(
                  iconSize: 40,
                  icon: Icon(
                    batteries[index] ? Icons.battery_full : Icons.battery_alert,
                    color: batteries[index] ? Colors.green : Colors.grey,
                  ),
                  onPressed: () => useBattery(index),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
