import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class PermitForm extends StatefulWidget {
  const PermitForm({super.key});

  @override
  State<PermitForm> createState() => _RegisterState();
}

class _RegisterState extends State<PermitForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _datetimeController = TextEditingController();
  final TextEditingController _idcardController = TextEditingController();
  final TextEditingController _departmentController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  final TextEditingController _positionLevelController =
      TextEditingController();
  final TextEditingController _positionNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _totalDateController = TextEditingController();
  final TextEditingController _requestingPurposeController =
      TextEditingController();
  final TextEditingController _requestInOutController = TextEditingController();
  final TextEditingController _requestTypeController = TextEditingController();
  String _requestType = 'Goods';
  final TextEditingController _areaTypeController = TextEditingController();
  final TextEditingController _vehicleTypeController = TextEditingController();
  final TextEditingController _plateNoController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _endDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _datetimeController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  // Function to calculate total days between start and end dates
  void _calculateTotalDate() {
    final startDate = DateFormat('yyyy-MM-dd').parse(_startDateController.text);
    final endDate = DateFormat('yyyy-MM-dd').parse(_endDateController.text);
    
    // Calculate the difference in days
    final difference = endDate.difference(startDate).inDays;
    _totalDateController.text = difference.toString();
  }

  // Function to select Start Date
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      _calculateTotalDate(); // Recalculate total date after selecting start date
    }
  }

  // Function to select End Date
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      _calculateTotalDate(); // Recalculate total date after selecting end date
    }
  }

  // Function to handle the form submission (registration)
  Future<void> _registerUser() async {
    // Handle form submission
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select both start and end dates.')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Mock API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.203.50:8080/flutter_login/permit_form.php'),
        body: {
          'datetime': _datetimeController.text, // Now set to current datetime
          'idcard': _idcardController.text.trim(),
          'name': _nameController.text.trim(),
          'department': _departmentController.text.trim(),
          'section': _sectionController.text.trim(),
          'position_level': _positionLevelController.text.trim(),
          'position_name': _positionNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone_number': _phoneNumberController.text.trim(),
          'start_date': _startDateController.text.trim(),
          'end_date': _endDateController.text.trim(),
          'total_date': _totalDateController.text.trim(),
          'requesting_purpose': _requestingPurposeController.text.trim(),
          'request_in_out': _requestInOutController.text.trim(),
          'request_type': _requestTypeController,
          'area_type': _areaTypeController.text.trim(),
          'vehicle_type': _vehicleTypeController.text.trim(),
          'plate_no': _plateNoController.text.trim(),
          'status': _statusController.text.trim(),
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Connection timed out. Please try again.');
      });

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful!')),
        );
        Navigator.pushNamed(context, 'permit_form');
        _clearFields();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Registration Failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearFields() {
    _datetimeController.clear();
    _idcardController.clear();
    _nameController.clear();
    _departmentController.clear();
    _sectionController.clear();
    _positionLevelController.clear();
    _positionNameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _totalDateController.clear();
    _requestingPurposeController.clear();
    _requestInOutController.clear();
    _areaTypeController.clear();
    _vehicleTypeController.clear();
    _plateNoController.clear();
    _statusController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          shrinkWrap: true,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Form Request',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                _buildTextFormField(
                    _datetimeController, 'Date Time', Icons.date_range),
                const SizedBox(height: 10),
                _buildTextFormField(
                    _idcardController, 'Id Card', Icons.card_membership),
                const SizedBox(height: 10),
                _buildTextFormField(_nameController, 'Name', Icons.person),
                const SizedBox(height: 10),
                _buildTextFormField(
                    _departmentController, 'Department', Icons.business),
                const SizedBox(height: 10),
                _buildTextFormField(_sectionController, 'Section', Icons.group),
                const SizedBox(height: 10),
                _buildTextFormField(
                    _positionLevelController, 'Position Level', Icons.work),
                const SizedBox(height: 10),
                _buildTextFormField(
                    _positionNameController, 'Position Name', Icons.badge),
                const SizedBox(height: 10),
                _buildTextFormField(_emailController, 'Email', Icons.email),
                const SizedBox(height: 10),
                _buildTextFormField(
                    _phoneNumberController, 'Phone Number', Icons.phone),
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: () => _selectStartDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _startDateController,
                      decoration: InputDecoration(
                        labelText: 'Start Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => _selectEndDate(context),
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _endDateController,
                      decoration: InputDecoration(
                        labelText: 'End Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                TextFormField(
                  controller: _totalDateController,
                  decoration: const InputDecoration(
                    labelText: 'Total Date',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  readOnly: true, // Make it read-only so the user can't edit it
                ),

                const SizedBox(height: 10),
                _buildTextFormField(_requestingPurposeController,
                    'Requesting Purpose', Icons.note),
                const SizedBox(height: 10),
                _buildTextFormField(_requestInOutController,
                    'Request In or Out', Icons.exit_to_app),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Request Type',
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: ['Goods', 'Visitor', 'Oxygen']
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _requestType = value!;
                    });
                  },
                ),
                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Area Type',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  items: ['Zone A', 'Zone B', 'Zone C']
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _requestType = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),
                _buildTextFormField(_vehicleTypeController, 'Vehicle Type',
                    Icons.directions_car),
                const SizedBox(height: 10),
                _buildTextFormField(
                    _plateNoController, 'Plate No', Icons.car_repair),
                const SizedBox(height: 10),
                _buildTextFormField(
                    _statusController, 'Status', Icons.check_circle),
                const SizedBox(height: 10),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3F60A0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: _isLoading ? null : _registerUser,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'SUBMIT',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Navigate to Register
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'login');
                  },
                  child: const Text("Don't have an account? SIGN IN"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String labelText, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        prefixIcon: Icon(icon),
      ),
    );
  }
}
