import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployerPostJobScreen extends StatefulWidget {
  @override
  _EmployerPostJobScreenState createState() => _EmployerPostJobScreenState();
}

class _EmployerPostJobScreenState extends State<EmployerPostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _wageCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  final _workersNeededCtrl = TextEditingController();
  
  String _selectedCategory = "Construction";
  DateTime? _startDate;
  DateTime? _endDate;
  String _selectedShift = "7AM - 2PM";
  bool _isPosting = false;

  final categories = ["Construction", "Electrical", "Delivery", "Plumbing", "Painting", "Carpenter", "Welder", "Other"];
  final shifts = ["7AM - 2PM", "8AM - 4PM", "9AM - 5PM", "10AM - 6PM", "Flexible"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Post New Job"),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Title
              _buildSectionTitle("Job Title", Icons.work),
              _buildTextField(
                controller: _titleCtrl,
                hint: "e.g., Construction Worker",
                validator: (v) => v!.isEmpty ? "Please enter job title" : null,
              ),

              SizedBox(height: 16),

              // Category & Wage Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Category", Icons.category),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCategory,
                              isExpanded: true,
                              items: categories.map((c) => DropdownMenuItem(
                                value: c, child: Text(c))).toList(),
                              onChanged: (v) => setState(() => _selectedCategory = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("Daily Wage (₹)", Icons.currency_rupee),
                        _buildTextField(
                          controller: _wageCtrl,
                          hint: "e.g., 600",
                          keyboardType: TextInputType.number,
                          validator: (v) => v!.isEmpty ? "Required" : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Location
              _buildSectionTitle("Location", Icons.location_on),
              _buildTextField(
                controller: _locationCtrl,
                hint: "e.g., Andheri, Mumbai",
                validator: (v) => v!.isEmpty ? "Please enter location" : null,
              ),

              SizedBox(height: 16),

              // Workers Needed
              _buildSectionTitle("Workers Needed", Icons.people),
              _buildTextField(
                controller: _workersNeededCtrl,
                hint: "e.g., 5",
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Please enter number of workers" : null,
              ),

              SizedBox(height: 16),

              // Shift
              _buildSectionTitle("Work Shift", Icons.schedule),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedShift,
                    isExpanded: true,
                    items: shifts.map((s) => DropdownMenuItem(
                      value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _selectedShift = v!),
                  ),
                ),
              ),

              SizedBox(height: 16),

              // Start & End Date
              _buildSectionTitle("Job Duration", Icons.calendar_today),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      label: "Start Date",
                      date: _startDate,
                      onTap: () => _selectDate(isStart: true),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildDatePicker(
                      label: "End Date / Deadline",
                      date: _endDate,
                      onTap: () => _selectDate(isStart: false),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Description
              _buildSectionTitle("Job Description", Icons.description),
              _buildTextField(
                controller: _descriptionCtrl,
                hint: "Describe the job responsibilities...",
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Please enter description" : null,
              ),

              SizedBox(height: 24),

              // Post Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isPosting ? null : _postJob,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isPosting
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("POST JOB",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.orange, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                date != null
                    ? "${date.day}/${date.month}/${date.year}"
                    : label,
                style: TextStyle(
                    color: date != null ? Colors.black87 : Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (_startDate ?? DateTime.now())
          : (_endDate ?? DateTime.now().add(Duration(days: 7))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData(colorScheme: ColorScheme.light(primary: Colors.orange)),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          // Auto-set end date to 30 days after start if not set
          if (_endDate == null) {
            _endDate = picked.add(Duration(days: 30));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _postJob() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select start and end dates"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final docRef = await FirebaseFirestore.instance.collection('jobs').add({
        'title': _titleCtrl.text.trim(),
        'category': _selectedCategory,
        'wage': _wageCtrl.text.trim(),
        'location': _locationCtrl.text.trim(),
        'workersNeeded': int.tryParse(_workersNeededCtrl.text.trim()) ?? 1,
        'shift': _selectedShift,
        'description': _descriptionCtrl.text.trim(),
        'startDate': _startDate,
        'endDate': _endDate,
        'employerId': user?.uid,
        'employerName': user?.displayName ?? 'Employer',
        'applicationCount': 0,
        'createdAt': DateTime.now(),
        'isActive': true,
      });

      // Create notification for workers
      await FirebaseFirestore.instance.collection('notifications').add({
        'type': 'new_job',
        'title': 'New Job Available',
        'body': '${_titleCtrl.text.trim()} job posted in ${_locationCtrl.text.trim()}',
        'jobId': docRef.id,
        'createdAt': DateTime.now(),
        'read': false,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Job posted successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPosting = false);
      }
    }
  }
}