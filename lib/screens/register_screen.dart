import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // AuthService import ediliyor

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  // TextEditingController'lar ekleniyor
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange.shade100,
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', height: 100),
                SizedBox(height: 100),
                Container(
                  padding: const EdgeInsets.all(24),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Creating new account',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        SizedBox(height: 24),

                        // İsim
                        TextFormField(
                          controller: firstNameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Soyisim
                        TextFormField(
                          controller: lastNameController,
                          decoration: InputDecoration(
                            labelText: 'Surname',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Surname is required';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Doğum tarihi
                        TextFormField(
                          controller: birthDateController,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                            labelText: 'Birth Date (DD/MM/YYYY)',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Date is required!';
                            } else if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
                              return 'Date format is invalid (DD/MM/YYYY)';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'E-mail',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!value.contains('@')) {
                              return 'Please enter a valid e-mail address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),

                        // Şifre
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters.';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 24),

                        // Kayıt Ol butonu
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Form geçerli, verileri AuthService ile gönder
                              final success = await AuthService().register(
                                firstNameController.text,
                                lastNameController.text,
                                birthDateController.text,
                                emailController.text,
                                passwordController.text,
                              );
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Registration successful!')),
                                );
                                Navigator.pop(context); // Kayıt başarılı ise geri dön
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Registration failed!')),
                                );
                              }
                            }
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
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
