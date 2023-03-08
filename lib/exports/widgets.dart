import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

export '/widgets/colored_tab_bar.dart';
export '/widgets/menu_tile.dart';
export '/widgets/prompt_tile.dart';

/// A circular progress indicator that centers its parent.
const centeredLoadingIndicator = Center(
  child: CircularProgressIndicator(),
);

final mapLayer = TileLayer(
  urlTemplate: 'https://www.google.com/maps/vt/pb=!1m4!1m3!1i{z}!2i{x}!3i{y}!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425',
);
