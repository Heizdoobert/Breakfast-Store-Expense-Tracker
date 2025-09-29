import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters

// --- AddExpenseViewButton ---
// This widget is designed to be placed somewhere in your UI
// to navigate to the AddExpenseView.
class AddExpenseViewButton extends StatelessWidget {
  final VoidCallback? onReturn; // Callback for returning to the previous screen
  const AddExpenseViewButton({super.key, this.onReturn});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddExpenseView()),
        ).then((_) {
          // _loadExpense();
          if (onReturn != null) onReturn!();
        });
      },
      tooltip: 'Thêm chi tiêu', // Vietnamese for 'Add Expense'
      child: const Icon(Icons.add),
    );
  }
}

// --- AddExpenseView ---
// This is the actual screen/view for adding a new expense.
class AddExpenseView extends StatefulWidget {
  const AddExpenseView({super.key});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  // Controllers for text input fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // For date picking
  DateTime? _selectedDate;

  // Key for form validation
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize date to today if desired, or leave as null
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ??
          DateTime.now(), // Start from current selection or today
      firstDate: DateTime(2000), // Allow dates from year 2000 onwards
      lastDate: DateTime(2101), // Allow dates up to year 2101
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to handle the expense submission
  void _submitExpense() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, process the data
      final String title = _titleController.text;
      final double amount = double.parse(_amountController.text);
      final String notes = _notesController.text;
      final DateTime date =
          _selectedDate!; // We know it's not null if form is valid

      // --- TODO: Implement your actual expense saving logic here ---
      // For example, you might:
      // 1. Add it to a local list in memory.
      // 2. Save it to a persistent storage like SharedPreferences or SQLite.
      // 3. Send it to a backend API.
      // 4. Update a state management solution (Provider, Riverpod, Bloc).

      print('Expense Details:');
      print('Title: $title');
      print('Amount: $amount');
      print('Date: $date');
      print('Notes: $notes');

      // Show a success message and potentially navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Expense added successfully!')),
      );

      // Navigator.pop(context); // Uncomment this line to automatically go back after saving
    } else {
      // If the form is invalid, the error messages will be shown by the validators.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm chi tiêu'), // Vietnamese for 'Add Expense'
        backgroundColor: Theme.of(
          context,
        ).colorScheme.inversePrimary, // Example styling
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Allows scrolling if content overflows
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Title Field
                const Text(
                  'Tiêu đề',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText:
                        'Nhập tiêu đề chi tiêu', // Vietnamese for 'Enter expense title'
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 15.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập tiêu đề'; // Vietnamese for 'Please enter title'
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Amount Field
                const Text(
                  'Số tiền',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    // Allow digits and at most one decimal point
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  decoration: const InputDecoration(
                    hintText:
                        'Nhập số tiền chi tiêu', // Vietnamese for 'Enter expense amount'
                    prefixText: '\$', // Optional: currency symbol
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 15.0,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập số tiền'; // Vietnamese for 'Please enter amount'
                    }
                    final double? amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return 'Vui lòng nhập số tiền hợp lệ lớn hơn 0'; // Vietnamese for 'Please enter a valid amount greater than 0'
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date Field
                const Text(
                  'Ngày',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'Chưa chọn ngày' // Vietnamese for 'No date chosen'
                            : 'Ngày đã chọn: ${_selectedDate!.toLocal().toString().split(' ')[0]}', // Display date in YYYY-MM-DD format
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text(
                        'Chọn ngày',
                      ), // Vietnamese for 'Choose Date'
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Notes Field
                const Text(
                  'Ghi chú',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  maxLines: 3, // Allows for multiple lines of notes
                  decoration: const InputDecoration(
                    hintText:
                        'Nhập ghi chú về chi tiêu (tùy chọn)', // Vietnamese for 'Enter expense notes (optional)'
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 15.0,
                    ),
                  ),
                  // No validator needed for optional notes
                ),
                const SizedBox(height: 24),

                // Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: _submitExpense,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      'Thêm chi tiêu',
                    ), // Vietnamese for 'Add Expense'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
