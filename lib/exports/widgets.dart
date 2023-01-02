import 'package:bus/extensions/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

export '../widgets/menu_tile.dart';
export '../widgets/prompt_tile.dart';
export '../pages/place_page.dart';

/// A circular progress indicator that centers its child.
const centeredLoadingIndicator = Center(
  child: CircularProgressIndicator(),
);

/// A widget that displays a horizontal row of [Tab]s with a specified [Color].
class ColoredTabBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a tab bar that paints its area with the specified [Color].
  const ColoredTabBar({
    super.key,
    required this.color,
    required this.tabBar,
  });

  /// The color to paint the background area with.
  final Color color;
  final TabBar tabBar;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: tabBar,
    );
  }
}

final mapLayer = TileLayer(
  urlTemplate: 'https://www.google.com/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425',
);

final locationMarker = StreamBuilder(
  stream: Geolocator.getPositionStream(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final position = snapshot.requireData;
      return CircleLayer(
        circles: [
          CircleMarker(
            point: position.toLatLng(),
            radius: 40,
            borderStrokeWidth: 40,
            useRadiusInMeter: true,
            color: Colors.blue,
            borderColor: Colors.blue.withOpacity(0.4),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  },
);
