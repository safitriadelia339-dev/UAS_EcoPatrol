import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
//import '../models/report_model.dart';
//import '../providers/report_provider.dart';

class AddReportScreen extends ConsumerStatefulWidget {
  const AddReportScreen({super.key});

  @override
  ConsumerState<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends ConsumerState<AddReportScreen> {
  // Controller untuk input text
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  // Variable untuk foto dan lokasi
  File? _imageFile;
  double? _latitude;
  double? _longitude;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  //fungsi ambil foto
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  //fungsi pilih sumber foto
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pilih Foto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.blue),
              title: const Text("Kamera"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.green),
              title: const Text("Galeri"),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  //fungsi ambil lokasi
  Future<void> _getLocation() async {
    //cek gps aktif/tidak
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage("GPS tidak aktif, Mohon aktifkan GPS");
      return;
    }
    //cek permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //ambil koordinat
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  //menyimpan laporan
  void _submitReport() {
    // Validasi
    if (_titleController.text.isEmpty) {
      _showMessage("Judul tidak boleh kosong");
      return;
    }
    if (_imageFile == null) {
      _showMessage("Foto wajib dilampirkan");
      return;
    }
    if (_latitude == null) {
      _showMessage("Lokasi belum ditandai");
      return;
    }

    //Buat objek laporan
    final newReport = ReportModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descController.text,
      imagePath: _imageFile!.path,
      latitude: _latitude!,
      longitude: _longitude!,
      status: "pending",
      createdAt: DateTime.now(),
    );

    //menyimpan ke provider
    ref.read(reportProvider.notifier).addReport(newReport);

    // Kembali ke dashboard
    Navigator.pop(context);
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Laporan Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //input jdul
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Judul Laporan",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            //input desc
            TextField(
              controller: _descController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Deskripsi",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            //tombol ambil foto
            ElevatedButton.icon(
              onPressed: _showImageSourceDialog,
              icon: const Icon(Icons.camera_alt),
              label: Text(_imageFile == null ? "Ambil Foto" : "Ganti Foto"),
            ),
            const SizedBox(height: 16),

            //preview foto
            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_imageFile!, height: 200, fit: BoxFit.cover),
              ),
            const SizedBox(height: 16),

            //tombol ambil lokasi
            ElevatedButton.icon(
              onPressed: _getLocation,
              icon: const Icon(Icons.location_on),
              label: Text(
                _latitude == null ? "Ambil Lokasi Terkini" : "Lokasi Diambil",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _latitude == null ? null : Colors.green,
              ),
            ),

            //menampilkan koordinat lokasi
            if (_latitude != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Lat: ${_latitude!.toStringAsFixed(6)}, "
                  "Long: ${_longitude!.toStringAsFixed(6)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            const SizedBox(height: 24),

            //kirim laporan
            ElevatedButton(
              onPressed: _submitReport,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue,
              ),
              child: const Text(
                "Kirim Laporan",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
