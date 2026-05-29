import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';
import '../models/app_item.dart';
import '../theme/app_colors.dart';

class AppDrawerScreen extends StatefulWidget {
  const AppDrawerScreen({super.key});

  @override
  State<AppDrawerScreen> createState() => _AppDrawerScreenState();
}

class _AppDrawerScreenState extends State<AppDrawerScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favorites = {'Phone', 'Maps', 'Music'};

  List<AppItem> get _filteredApps {
    if (_searchQuery.isEmpty) return AppItem.defaultApps;
    return AppItem.defaultApps
        .where((app) => app.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  List<AppItem> get _favoriteApps {
    return AppItem.defaultApps.where((app) => _favorites.contains(app.name)).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            _Header(context),
            _SearchBar(),
            if (_favoriteApps.isNotEmpty) ...[
              _SectionLabel('FAVORITES'),
              _FavoritesRow(_favoriteApps),
            ],
            _SectionLabel('ALL APPS'),
            Expanded(child: _AppGrid(_filteredApps)),
          ],
        ),
      ),
    );
  }

  Widget _Header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GlassCard(
            padding: const EdgeInsets.all(4),
            borderRadius: 12,
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 22),
          ),
          const Spacer(),
          const Text(
            'APPS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 3,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _SearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v),
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search apps...',
          hintStyle: const TextStyle(color: AppColors.textDim),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textDim, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: AppColors.textDim, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _SectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: AppColors.glassBorder, thickness: 0.5)),
        ],
      ),
    );
  }

  Widget _FavoritesRow(List<AppItem> apps) {
    return Container(
      height: 80,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: apps.map((app) => Expanded(
          child: _AppIcon(app, isFavorite: true),
        )).toList(),
      ),
    );
  }

  Widget _AppIcon(AppItem app, {bool isFavorite = false}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        onLongPress: () {
          if (isFavorite) {
            setState(() => _favorites.remove(app.name));
          } else {
            setState(() => _favorites.add(app.name));
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isFavorite ? Border.all(color: AppColors.neonBlue.withValues(alpha: 0.3)) : null,
            color: isFavorite ? AppColors.neonBlue.withValues(alpha: 0.05) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Icon(
                  _iconFor(app.name),
                  color: AppColors.textPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                app.name,
                style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _AppGrid(List<AppItem> apps) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) => _AppIcon(apps[index]),
    );
  }

  IconData _iconFor(String name) {
    switch (name.toLowerCase()) {
      case 'phone': return Icons.phone_rounded;
      case 'maps': return Icons.navigation_rounded;
      case 'music': return Icons.music_note_rounded;
      case 'settings': return Icons.settings_rounded;
      case 'chrome': return Icons.language_rounded;
      case 'messages': return Icons.message_rounded;
      case 'camera': return Icons.camera_alt_rounded;
      case 'calendar': return Icons.calendar_month_rounded;
      default: return Icons.apps_rounded;
    }
  }
}
