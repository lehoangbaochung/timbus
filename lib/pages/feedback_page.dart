import 'package:bus/widgets/prompt_tile.dart';
import 'package:bus/app/pages.dart';
import 'package:bus/extensions/context.dart';

import 'package:flutter/material.dart';

String _getSurveyUrl(String id) => 'https://docs.google.com/forms/d/e/$id/viewform?usp=sf_link';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Phản hồi'),
        leading: IconButton(
          tooltip: 'Trở về',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            tooltip: 'Hướng dẫn',
            icon: const Icon(Icons.help_outline),
            onPressed: () => AppPages.push(context, AppPages.help.path),
          ),
        ],
      ),
      body: Column(
        children: [
          const PromptTile(
            'Ý kiến đóng góp của bạn sẽ giúp chúng tôi nâng cao chất lượng dịch vụ trong thời gian tới.',
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  isThreeLine: true,
                  title: const Text(
                    'Dịch vụ',
                    style: TextStyle(color: Colors.blue),
                  ),
                  subtitle: const Text(
                    'Nếu quý khách chưa hài lòng về dịch vụ xe buýt xin vui lòng góp ý tại đây.',
                  ),
                  leading: const SizedBox(
                    height: double.infinity,
                    child: CircleAvatar(
                      foregroundColor: Colors.blue,
                      child: Icon(Icons.send_time_extension),
                    ),
                  ),
                  trailing: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.open_in_new),
                  ),
                  onTap: () => context.launch(
                    _getSurveyUrl(
                      '1FAIpQLScQLYEyRKEaXYcuGUa1tRq5ma17fvoJ679jeXBdq_FJuEVwrQ',
                    ),
                  ),
                ),
                ListTile(
                  isThreeLine: true,
                  title: const Text(
                    'Khảo sát',
                    style: TextStyle(color: Colors.blue),
                  ),
                  subtitle: const Text(
                    'Kính mong quý khách thực hiện phiếu khảo sát để nâng cao chất lượng dịch vụ xe buýt.',
                  ),
                  leading: const SizedBox(
                    height: double.infinity,
                    child: CircleAvatar(
                      foregroundColor: Colors.blue,
                      child: Icon(Icons.content_paste_go),
                    ),
                  ),
                  trailing: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.open_in_new),
                  ),
                  onTap: () => context.launch(
                    _getSurveyUrl(
                      '1FAIpQLSd_nI3J8cxbMDbyaEp-xe9MH6unaF6ajhjfHN48f200THDBbQ',
                    ),
                  ),
                ),
                ListTile(
                  isThreeLine: true,
                  title: const Text(
                    'Ứng dụng',
                    style: TextStyle(color: Colors.blue),
                  ),
                  subtitle: const Text(
                    'Mọi góp ý của quý khách sẽ được chúng tôi ghi nhận và nâng cấp trong các phiên bản sau.',
                  ),
                  leading: const SizedBox(
                    height: double.infinity,
                    child: CircleAvatar(
                      foregroundColor: Colors.blue,
                      child: Icon(Icons.send_to_mobile),
                    ),
                  ),
                  trailing: const SizedBox(
                    height: double.infinity,
                    child: Icon(Icons.open_in_new),
                  ),
                  onTap: () => context.launch(
                    _getSurveyUrl(
                      '1FAIpQLSd_nI3J8cxbMDbyaEp-xe9MH6unaF6ajhjfHN48f200THDBbQ',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
