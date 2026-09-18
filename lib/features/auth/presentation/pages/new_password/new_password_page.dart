import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:social_media_app/core/routes/app_routes.dart';
import 'package:social_media_app/core/utils/context_extension.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:social_media_app/features/auth/presentation/bloc/auth/auth_state.dart';
import 'package:social_media_app/features/auth/presentation/validators/auth_validators.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_button.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_description.dart';
import 'package:social_media_app/features/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:social_media_app/features/auth/presentation/widgets/password_requirements.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  GlobalKey<FormState> formstate = GlobalKey();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  late String email;
  late String resetToken;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;

    email = extra['email'];
    resetToken = extra['resetToken'];
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Password')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go(AppRoutes.auth);
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) => state is AuthLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: formstate,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 14),
                              const CustomDescription(
                                text: "Please enter your new password with confirmation and don't share it with others!",
                              ),
                              SizedBox(height: context.h(107)),
                              CustomTextFormField(
                                label: 'New Password',
                                controller: passwordController,
                                obscureText: obscurePassword,
                                validator: (value) {
                                  return AuthValidators.password(value);
                                },
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: obscurePassword
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                              ),
                              const SizedBox(height: 14),
                              CustomTextFormField(
                                label: 'Confirm Password',
                                controller: confirmPasswordController,
                                obscureText: obscureConfirmPassword,
                                validator: (value) {
                                  return AuthValidators.confirmPassword(
                                    value,
                                    passwordController.text,
                                  );
                                },
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureConfirmPassword =
                                          !obscureConfirmPassword;
                                    });
                                  },
                                  icon: obscureConfirmPassword
                                      ? Icon(Icons.visibility_off)
                                      : Icon(Icons.visibility),
                                ),
                              ),
                              const SizedBox(height: 10),
                              PasswordRequirements(),
                              const SizedBox(height: 20),
                              CustomButton(
                                text: 'Update',
                                onPressed: () {
                                  if (formstate.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      ResetPasswordRequested(
                                        email: email,
                                        resetToken: resetToken,
                                        newPassword: passwordController.text,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
