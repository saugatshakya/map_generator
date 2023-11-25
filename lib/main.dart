import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/material.dart';
import 'package:map_generator/mapping.dart';

void main() {
  runApp(const MyApp());
}

List<String> globalPossibilities = [
  cornerRT,
  cornerLT,
  cornerLB,
  cornerRB,
  tLRB,
  tTBR,
  tLRT,
  tTBL,
  crossLRTB,
  crossTBLR,
  empty,
  lineLR,
  lineTB,
];

// ImageProvider cornerRTCache = AssetImage(cornerRT);
// ImageProvider cornerLTCache = AssetImage(cornerLT);
// ImageProvider cornerLBCache = AssetImage(cornerLB);
// ImageProvider cornerRBCache = AssetImage(cornerRB);
// ImageProvider tLRBCache = AssetImage(tLRB);
// ImageProvider tTBRCache = AssetImage(tTBR);
// ImageProvider tLRTCache = AssetImage(tLRT);
// ImageProvider tTBLCache = AssetImage(tTBL);
// ImageProvider crossLRTBCache = AssetImage(crossLRTB);
// ImageProvider crossTBLRCache = AssetImage(crossTBLR);
// ImageProvider emptyCache = AssetImage(empty);
// ImageProvider lineLRCache = AssetImage(lineLR);
// ImageProvider lineTBCache = AssetImage(lineTB);
// ImageProvider getImageProvider(String input) {
//   switch (input) {
//     case 'assets/cornerRT.png':
//       return cornerRTCache;
//     case 'assets/cornerLT.png':
//       return cornerLTCache;
//     case 'assets/cornerLB.png':
//       return cornerLBCache;
//     case 'assets/cornerRB.png':
//       return cornerRBCache;
//     case 'assets/tLRB.png':
//       return tLRBCache;
//     case 'assets/tTBR.png':
//       return tTBRCache;
//     case 'assets/tLRT.png':
//       return tLRTCache;
//     case 'assets/tTBL.png':
//       return tTBLCache;
//     case 'assets/crossLRTB.png':
//       return crossLRTBCache;
//     case 'assets/crossTBLR.png':
//       return crossTBLRCache;
//     case 'assets/empty.png':
//       return emptyCache;
//     case 'assets/lineLR.png':
//       return lineLRCache;
//     case 'assets/lineTB.png':
//       return lineTBCache;
//     default:
//       throw Exception('Invalid input provided');
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int gridSize = 64;
  double tileSize = 8;
  List<List<String?>> map = [];

  start() async {
    await generateStartingCells();
    await getCells(0, 0);
    log("completed");
    return;
    // getCells(0, gridSize - 1);
    // getCells(gridSize - 1, 0);
    // getCells(gridSize - 1, gridSize - 1);

    // for ((int i, int j) iteration in iterations) {
    //   getCells(iteration.$1, iteration.$2);
    // }
    // List<(int i, int j)> newiterations = await getFirstCell();
    // for ((int i, int j) iteration in newiterations) {
    //   getCells(iteration.$1, iteration.$2);
    // }
    // List<(int i, int j)> newnewiterations = await getFirstCell();
    // for ((int i, int j) iteration in newnewiterations) {
    //   getCells(iteration.$1, iteration.$2);
    // }
  }

  Future<List<(int i, int j)>> getNextIterations(int i, int j) async {
    List<(int i, int j)> iterations = [];
    if (i - 1 >= 0 && map[i - 1][j] == null) {
      iterations.add((i - 1, j));
    }
    if (i + 1 < gridSize && map[i + 1][j] == null) {
      iterations.add((i + 1, j));
    }
    if (j - 1 >= 0 && map[i][j - 1] == null) {
      iterations.add((i, j - 1));
    }
    if (j + 1 < gridSize && map[i][j + 1] == null) {
      iterations.add((i, j + 1));
    }
    return iterations;
  }

  Future<void> getCells(int i, int j) async {
    List<String> possibilities = [
      cornerRT,
      cornerLT,
      cornerLB,
      cornerRB,
      tLRB,
      tTBR,
      tLRT,
      tTBL,
      crossLRTB,
      crossTBLR,
      empty,
      lineLR,
      lineTB,
    ];
    //check for up
    if (i - 1 < 0) {
      possibilities.removeWhere((element) => element.contains("T"));
    } else if (map[i - 1][j] != null) {
      String data = map[i - 1][j]!;
      if (data.contains("B")) {
        possibilities.removeWhere((element) => !element.contains("T"));
      } else {
        possibilities.removeWhere((element) => element.contains("T"));
      }
    }
    //check for down
    if (i + 1 > gridSize - 1) {
      possibilities.removeWhere((element) => element.contains("B"));
    } else if (map[i + 1][j] != null) {
      String data = map[i + 1][j]!;
      if (data.contains("T")) {
        possibilities.removeWhere((element) => !element.contains("B"));
      } else {
        possibilities.removeWhere((element) => element.contains("B"));
      }
    }
    //check for left
    if (j - 1 < 0) {
      possibilities.removeWhere((element) => element.contains("L"));
    } else if (map[i][j - 1] != null) {
      String data = map[i][j - 1]!;

      if (data.contains("R")) {
        possibilities.removeWhere((element) => !element.contains("L"));
      } else {
        possibilities.removeWhere((element) => element.contains("L"));
      }
    }
    //check for right
    if (j + 1 > gridSize - 1) {
      possibilities.removeWhere((element) => element.contains("R"));
    } else if (map[i][j + 1] != null) {
      String data = map[i][j + 1]!;

      if (data.contains("L")) {
        possibilities.removeWhere((element) => !element.contains("R"));
      } else {
        possibilities.removeWhere((element) => element.contains("R"));
      }
    }
    if (possibilities.isEmpty) {
      map[i][j] = empty;
    } else {
      String legalMove = possibilities[Random().nextInt(possibilities.length)];
      map[i][j] = legalMove;
    }
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {});
    List<(int i, int j)> iterations = await getNextIterations(i, j);
    await Future.delayed(const Duration(milliseconds: 300));
    for ((int i, int j) iteration in iterations) {
      getCells(iteration.$1, iteration.$2);
    }
  }

  Future<List<(int i, int j)>> getFirstCell() async {
    (int i, int j) randomStartingPoint = (
      Random().nextInt(gridSize - 2) + 1,
      Random().nextInt(gridSize - 2) + 1
    );
    String randomStarter =
        globalPossibilities[Random().nextInt(globalPossibilities.length)];
    map[randomStartingPoint.$1][randomStartingPoint.$2] = randomStarter;
    return getNextIterations(randomStartingPoint.$1, randomStartingPoint.$2);
  }

  Future<void> generateStartingCells() async {
    for (int i = 0; i < gridSize; i++) {
      map.add([]);
      for (int j = 0; j < gridSize; j++) {
        map[i].add(null);
      }
    }
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   precacheImage(cornerRTCache, context);
  //   precacheImage(cornerLTCache, context);
  //   precacheImage(cornerLBCache, context);
  //   precacheImage(cornerRBCache, context);
  //   precacheImage(tLRBCache, context);
  //   precacheImage(tTBRCache, context);
  //   precacheImage(tLRTCache, context);
  //   precacheImage(tTBLCache, context);
  //   precacheImage(crossLRTBCache, context);
  //   precacheImage(crossTBLRCache, context);
  //   precacheImage(emptyCache, context);
  //   precacheImage(lineLRCache, context);
  //   precacheImage(lineTBCache, context);
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (int i = 0; i < gridSize; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  for (int j = 0; j < gridSize; j++)
                    SizedBox(
                      width: tileSize,
                      height: tileSize,
                      // decoration:
                      //     BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: map[i][j] == null
                          ? const SizedBox()
                          : Container(
                              width: tileSize,
                              height: tileSize,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(map[i][j]!),
                                      // image: getImageProvider(map[i][j]!),
                                      fit: BoxFit.cover)),
                            ),
                    )
                ],
              )
          ],
        ),
      )),
    );
  }
}
