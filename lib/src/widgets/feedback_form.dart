import 'package:flutter/material.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  FeedbackFormState createState() => FeedbackFormState();
}

class FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();
  double _rating = 0.0;

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitFeedback() {
    if (_formKey.currentState?.validate() ?? false) {
      final feedback = _feedbackController.text.trim();
      final email = _emailController.text.trim();

      debugPrint('Feedback submitted: $feedback');
      if (email.isNotEmpty) {
        debugPrint('Contact email: $email');
      }

      _formKey.currentState?.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted. Thank you!'),
        ),
      );

      if (_rating > 4.0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your support!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Send us some feedback and tell us what we can do better.'),
          ),
        );
      }

      Navigator.of(context).pop();
    }
  }

  void _submitRating(double rating) {
    setState(() {
      _rating = rating;
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text("Rate our app!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () => _submitRating((index + 1).toDouble()),
                  icon: Icon(
                    Icons.star_border,
                    color: _rating >= (index + 1) ? Colors.yellow : Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _feedbackController,
                    decoration: const InputDecoration(
                      labelText: 'Your Feedback',
                      hintText: 'Please describe your experience...',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Feedback cannot be empty';
                      }
                      return null;
                    },
                    maxLines: 4,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email (Optional)',
                      hintText: 'Provide your email if you want a response',
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final emailRegex =
                            RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: _submitFeedback,
            child: const Text("Submit"),
          ),
        ],
      );
}
