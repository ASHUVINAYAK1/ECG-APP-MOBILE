import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _changePassword(BuildContext context) async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Change Password"),
            content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: currentPasswordController,
                      decoration: const InputDecoration(
                        labelText: "Current Password",
                      ),
                      obscureText: true,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? "Enter current password"
                                  : null,
                    ),
                    TextFormField(
                      controller: newPasswordController,
                      decoration: const InputDecoration(
                        labelText: "New Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Enter new password";
                        if (value.length < 6)
                          return "Password must be at least 6 characters";
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        labelText: "Confirm New Password",
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return "Confirm new password";
                        if (value != newPasswordController.text)
                          return "Passwords do not match";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null && user.email != null) {
                      try {
                        final credential = EmailAuthProvider.credential(
                          email: user.email!,
                          password: currentPasswordController.text.trim(),
                        );
                        await user.reauthenticateWithCredential(credential);
                        await user.updatePassword(
                          newPasswordController.text.trim(),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Password changed successfully"),
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: ${e.toString()}")),
                        );
                      }
                    }
                  }
                },
                child: const Text("Update"),
              ),
            ],
          ),
    );
  }

  void _logout(BuildContext context) async {
    final AuthController authController = AuthController();
    await authController.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/auth/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[50],
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Account Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.lock_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: const Text(
                  'Change Password',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Update your account password'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[600],
                ),
                onTap: () => _changePassword(context),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.notifications_none,
                    color: Colors.amber[700],
                  ),
                ),
                title: const Text(
                  'Notifications',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Manage notification preferences'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[600],
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications tapped')),
                  );
                },
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.privacy_tip_outlined,
                    color: Colors.green[700],
                  ),
                ),
                title: const Text(
                  'Privacy',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Manage privacy settings'),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[600],
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Privacy tapped')),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: OutlinedButton(
                onPressed: () => _logout(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.red[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
