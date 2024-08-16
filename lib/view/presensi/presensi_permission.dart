import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:presensi_mobile/config/supabase.dart';
import 'package:presensi_mobile/view/screen.dart';

class PresensiPermission extends StatefulWidget {
  final int userId;
  final int shiftId;
  const PresensiPermission({
    required this.userId,
    required this.shiftId,
    super.key
  });

  @override
  PresensiPermissionState createState() => PresensiPermissionState();
}

class PresensiPermissionState extends State<PresensiPermission> {
  File? _pickedFile;
  String? _selectedReason;
  String? _fileName;
  DateTime? _selectedDate;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
        _fileName = result.files.single.name;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitFile() async {
    if (_pickedFile != null && _selectedReason != null && _selectedDate != null) {
      final supabase = supabaseClient;
      String tanggalMasuk = DateFormat('yyyy-MM-dd').format(_selectedDate!);

      // Check if an entry already exists for the selected date
      final existingData = await supabase.from('attendances').select()
          .eq('employee_id', widget.userId)
          .eq('tanggal_masuk', tanggalMasuk);

      if (existingData.isEmpty) {
        await supabase.from('attendances').insert({
          'employee_id': widget.userId,
          'shift_id': widget.shiftId,
          'tanggal_masuk': tanggalMasuk,
          'waktu_masuk': null,
          'status_masuk': _selectedReason,
          'long_masuk': null,
          'lat_masuk': null,
          'tanggal_keluar': tanggalMasuk,
          'waktu_keluar': null,
          'status_keluar': _selectedReason,
          'long_keluar': null,
          'lat_keluar': null,
        });
        _showResultModal(context, 'Pengajuan $_selectedReason berhasil');
        setState(() {
          _pickedFile = null;
          _selectedReason = null;
          _selectedDate = null;
          _fileName = null;
        });
      } else {
        _showResultModal(context, 'Data kehadiran sudah ada untuk tanggal ini.');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a reason, a file, and a date first'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showResultModal(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Result'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReasonIcon(String reason, String imagePath) {
    bool isSelected = _selectedReason == reason;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedReason = reason;
        });
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isSelected ? 4 : 0), // Add padding inside for the border
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 4,
              ),
            ),
            child: ClipOval(
              child: Container(
                color: Colors.white, // To make sure the padding area is white
                child: Padding(
                  padding: const EdgeInsets.all(4.0), // Padding inside the border
                  child: Image(
                    image: AssetImage(imagePath),
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reason,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Screen(
                userId: widget.userId,
              )),
            );
          },
        ),
      ),

      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Alasan Tidak Hadir?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildReasonIcon('Izin/Cuti', 'assets/cuti.png'),
                _buildReasonIcon('Sakit', 'assets/sakit.png'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.blue[200],
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pilih tanggal dibawah ini:',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate == null
                                  ? 'Pilih Tanggal'
                                  : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                              style: TextStyle(
                                color: _selectedDate == null ? Colors.grey : Colors.black,
                                fontSize: 16.0,
                              ),
                            ),
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Upload file dibawah ini:',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _fileName ?? 'Choose File',
                            style: TextStyle(
                              color: _fileName == null ? Colors.grey : Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _pickFile,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Browse'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          onPressed: _submitFile,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            elevation: 5,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Submit File',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}