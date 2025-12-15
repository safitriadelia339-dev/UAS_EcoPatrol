import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../models/report_model.dart';
import '../providers/report_provider.dart';

class EditReportScreen extends ConsumerStatefulWidget {
  final Report report;

  const EditReportScreen({
    super.key,
    required this.report,
  });

  @override
  _EditReportScreenState createState() => _EditReportScreenState();
}

class _EditReportScreenState extends ConsumerState<EditReportScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _workDescriptionController;
  final ImagePicker _picker = ImagePicker();
  File? _completionPhoto;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _workDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _workDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _completionPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _completionPhoto = File(pickedFile.path);
      });
    }
  }

  Future<void> _markAsComplete() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        await ref.read(reportProvider.notifier).markReportAsCompleted(
          reportId: widget.report.id!,
          workDescription: _workDescriptionController.text.trim(),
          completionPhotoPath: _completionPhoto?.path,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Laporan berhasil ditandai selesai!'),
              backgroundColor: Colors.green,
            ),
          );

          // Kembali ke dashboard
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tandai Selesai'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Laporan yang akan diselesaikan:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '📝 ${widget.report.title}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '📍 ${widget.report.latitude.toStringAsFixed(4)}, ${widget.report.longitude.toStringAsFixed(4)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Deskripsi Pekerjaan
              const Text(
                'Deskripsi Pekerjaan yang Dilakukan:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _workDescriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Sampah telah dibersihkan, selokan telah lancar, tembok telah dicat ulang...',
                  border: OutlineInputBorder(),
                  labelText: 'Deskripsi Pekerjaan',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi pekerjaan wajib diisi';
                  }
                  if (value.trim().length < 10) {
                    return 'Deskripsi minimal 10 karakter';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 25),

              // Upload Foto Hasil
              const Text(
                'Foto Hasil Pengerjaan:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Ambil foto setelah pekerjaan selesai (opsional)',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera),
                          title: const Text('Ambil Foto Baru'),
                          onTap: () {
                            Navigator.pop(context);
                            _takePhoto();
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Pilih dari Galeri'),
                          onTap: () {
                            Navigator.pop(context);
                            _pickImage();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _completionPhoto == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_a_photo,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap untuk menambahkan foto',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _completionPhoto!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              if (_completionPhoto != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.edit),
                        label: const Text('Ganti Foto'),
                      ),
                      const SizedBox(width: 20),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _completionPhoto = null;
                          });
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              // Tombol Submit
              Center(
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  onPressed: _markAsComplete,
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    'Konfirmasi Selesai',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Warning
              Card(
                color: Colors.yellow[50],
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            'Perhatian',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Setelah ditandai selesai, status tidak dapat dikembalikan ke pending\n'
                            '• Pastikan pekerjaan sudah benar-benar selesai\n'
                            '• Foto hasil akan menjadi bukti penyelesaian',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}