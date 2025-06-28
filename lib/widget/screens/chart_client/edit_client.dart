import 'package:flutter/material.dart';
import 'package:storeflow/database/database.dart';
import 'package:storeflow/widget/common/bar.dart';
import 'package:storeflow/widget/common/btn.dart';
import 'package:storeflow/widget/common/input.dart';
import 'package:storeflow/utility/theme.dart';

class EditClient extends StatefulWidget {
  const EditClient({super.key});

  @override
  State<EditClient> createState() => _EditClientState();
}

class _EditClientState extends State<EditClient> {
  late Map<String, dynamic> routeArgs;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _clientNameController;
  late TextEditingController _clientUrlController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _clientAddressController;
  final DatabaseService db = DatabaseService();
  bool _isLoading = false;

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      _clientNameController = TextEditingController(text: routeArgs['name']);
      _clientUrlController = TextEditingController(text: routeArgs['url']);
      _clientPhoneController = TextEditingController(text: routeArgs['phone']);
      _clientAddressController = TextEditingController(
        text: routeArgs['address'],
      );
      _isInit = true;
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientUrlController.dispose();
    _clientPhoneController.dispose();
    _clientAddressController.dispose();

    super.dispose();
  }

  Future<void> _updateClient() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await db.update(
          table: 'client',
          id: routeArgs['id'],
          data: {
            'name': _clientNameController.text,
            'url': _clientUrlController.text.isEmpty
                ? null
                : _clientUrlController.text,
            'phone': _clientPhoneController.text.isEmpty
                ? null
                : _clientPhoneController.text,
            'address': _clientAddressController.text.isEmpty
                ? null
                : _clientAddressController.text,
          },
          context: context,
          successMessage: 'Client updated successfully!',
        );
      } catch (e) {
        // Error is handled by showAlert in DatabaseService
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Bar(title: 'Edit Client', color: AppTheme.colorWarning),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Input(
                  controller: _clientNameController,
                  labelText: 'Client Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the client name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Input(
                  controller: _clientAddressController,
                  labelText: 'Address',
                  hintText: 'Enter the client address',
                  keyboardType: TextInputType.streetAddress,
                ),
                const SizedBox(height: 16),
                Input(
                  controller: _clientUrlController,
                  labelText: 'Client Map URL (optional)',
                  hintText: 'Enter Google Maps URL',
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 16),
                Input(
                  controller: _clientPhoneController,
                  labelText: 'Phone',
                  hintText: 'Enter the client phone (optional)',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 32),
                Btn(
                  title: 'Update Client',
                  onTap: _updateClient,
                  isLoading: _isLoading,
                  btnType: BtnType.warning,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
