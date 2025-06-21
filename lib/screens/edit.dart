import 'package:flutter/material.dart';
import '../utility/theme.dart';
import '../widget/common/bar.dart';
import '../widget/screens/edit/edit_card.dart';

class Edit extends StatefulWidget {
  const Edit({super.key});

  @override
  EditState createState() => EditState();
}

class EditState extends State<Edit> {
  late Map<String, dynamic> routeArgs;
  late String type;
  late String title;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      title = routeArgs['type'] == 'orders' ? 'Order' : 'Production';
      type = routeArgs['type'];
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: Bar(
        title: 'Edit $title',
        color: type == 'orders' ? AppTheme.colorError : AppTheme.colorInfo,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: EditCard(item: routeArgs['items'], table: type),
      ),
    );
  }
}




