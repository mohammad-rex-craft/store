import 'package:flutter/material.dart';
import 'package:storeflow/database/database.dart';
import 'package:storeflow/widget/common/bar.dart';
import '../../common/btn.dart';
import '../../common/input.dart';

class CreateClient extends StatefulWidget {
  const CreateClient({super.key});

  @override
  State<CreateClient> createState() => _CreateClientState();
}

class _CreateClientState extends State<CreateClient> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _clientUrlController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _clientAddressController = TextEditingController();
  final DatabaseService db = DatabaseService();
  bool _isLoading = false;

  @override
  void dispose() {
    _clientNameController.dispose();
    _clientUrlController.dispose();
    _clientPhoneController.dispose();
    _clientAddressController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _clientNameController.clear();
    _clientUrlController.clear();
    _clientPhoneController.clear();
    _clientAddressController.clear();
  }

  Future<void> _saveClient() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await db.create(
          table: 'client',
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
          successMessage: 'Client created successfully!',
        );
        if (mounted) {
          _clearFields();
        }
      } catch (e) {
        // The error is already handled by the showAlert in DatabaseService
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
      appBar: const Bar(
        title: 'Create New Client',
        color: Colors.pinkAccent,
      ),
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
                  controller: _clientPhoneController,
                  labelText: 'Phone',
                  hintText: 'Enter the client phone (optional)',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                Input(
                  controller: _clientUrlController,
                  labelText: 'Client URL (optional)',
                  hintText: 'Enter the client URL',
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 32),
                Btn(
                  title: 'Save Client',
                  onTap: _saveClient,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
