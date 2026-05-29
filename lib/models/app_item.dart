class AppItem {
  final String name;
  final String packageName;
  final String? iconUrl;

  const AppItem({
    required this.name,
    required this.packageName,
    this.iconUrl,
  });

  static const List<AppItem> defaultApps = [
    AppItem(name: 'Phone', packageName: 'com.android.dialer'),
    AppItem(name: 'Maps', packageName: 'com.google.android.apps.maps'),
    AppItem(name: 'Music', packageName: 'com.google.android.apps.youtube.music'),
    AppItem(name: 'Settings', packageName: 'com.android.settings'),
    AppItem(name: 'Chrome', packageName: 'com.android.chrome'),
    AppItem(name: 'Messages', packageName: 'com.google.android.apps.messaging'),
    AppItem(name: 'Camera', packageName: 'com.android.camera'),
    AppItem(name: 'Calendar', packageName: 'com.google.android.calendar'),
  ];
}

class ShortcutSlot {
  final String? packageName;
  final bool isEmpty;

  const ShortcutSlot({this.packageName}) : isEmpty = packageName == null;
}
