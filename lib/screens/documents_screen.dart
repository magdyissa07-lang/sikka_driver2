import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/app_theme.dart';
import '../services/document_service.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});
  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final _types = const {
    'license': 'رخصة القيادة',
    'insurance': 'التأمين',
    'car_registration': 'استمارة السيارة',
    'criminal_record': 'الفيش والتشبيه',
  };

  final Set<String> _uploaded = {};
  bool _uploading = false;
  String? _error;

  Future<void> _pickAndUpload(String type) async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() { _uploading = true; _error = null; });
    try {
      await DocumentService.upload(type: type, filePath: file.path);
      setState(() => _uploaded.add(type));
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('رفع المستندات')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
              ),
            ..._types.entries.map((e) {
              final done = _uploaded.contains(e.key);
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(e.value),
                  trailing: done
                      ? const Icon(Icons.check_circle, color: AppColors.success)
                      : TextButton(
                          onPressed: _uploading ? null : () => _pickAndUpload(e.key),
                          child: const Text('رفع', style: TextStyle(color: AppColors.accent)),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
