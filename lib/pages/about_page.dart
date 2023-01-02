import 'package:bus/app/pages.dart';
import 'package:flutter/material.dart';

import '../app/localizations.dart';
import '/exports/widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.localize(8),
        ),
      ),
      body: ListView(
        children: [
          PromptTile(
            AppLocalizations.localize(8),
          ),
          MenuTile(
            leading: Icons.directions,
            trailing: Icons.arrow_right,
            title: AppLocalizations.localize(10),
            subtitle: 'Tìm đường đi tối ưu bằng xe buýt',
            onTap: () => showSearch(
              context: context,
              delegate: DirectionPage(),
            ),
          ),
          MenuTile(
            leading: Icons.manage_search,
            trailing: Icons.arrow_right,
            title: AppLocalizations.localize(4),
            subtitle: 'Tra cứu nhanh các thông tin về hoạt động xe buýt',
            onTap: () => AppPages.push(context, AppPages.lookup.path),
          ),
          MenuTile(
            title: AppLocalizations.localize(2),
            subtitle: 'Quản lý danh sách yêu thích của bạn',
            leading: Icons.follow_the_signs,
            trailing: Icons.arrow_right,
            onTap: () => showSearch(
              context: context,
              delegate: DirectionPage(),
            ),
          ),
          MenuTile(
            title: AppLocalizations.localize(50),
            subtitle: 'Hỗ trợ người dùng tất cả các ngày trong tuần',
            leading: Icons.support,
            trailing: Icons.arrow_right,
            onTap: () => showSearch(
              context: context,
              delegate: DirectionPage(),
            ),
          ),
        ],
      ),
    );
  }
}
