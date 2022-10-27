 
import 'package:blink_comparison/ui/cubit/error_report_cubit.dart';
import 'package:blink_comparison/ui/widget/page_icon.dart';
import 'package:blink_comparison/ui/widget/progress_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../locale.dart';
import '../../logger.dart';
import '../theme.dart';
import 'auth_cubit.dart';

class SignInButton extends StatelessWidget {
  final TextEditingController passwordFieldController;

  const SignInButton({
    Key? key,
    required this.passwordFieldController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          key: const ValueKey('sign_in_button'),
          onPressed: _handleSubmitCallbackState(
            context,
            state,
            passwordFieldController,
          ),
          label: state.maybeWhen(
            authInProgress: (info) => const ProgressFab(),
            orElse: () => Text(S.of(context).signIn),
          ),
        );
      },
    );
  }
}

VoidCallback? _handleSubmitCallbackState(
  BuildContext context,
  AuthState state,
  TextEditingController passwordFieldController,
) {
  return state.maybeWhen(
    passwordLoaded: (info) => _auth(context, passwordFieldController),
    authFailed: (info, reason) => _auth(context, passwordFieldController),
    orElse: () => null,
  );
}

VoidCallback _auth(
  BuildContext context,
  TextEditingController passwordFieldController,
) {
  void doAuth() {
    FocusScope.of(context).unfocus();
    context.read<AuthCubit>().auth(passwordFieldController.text);
  }

  return doAuth;
}

class SignInPage extends StatelessWidget {
  final TextEditingController passwordFieldController;

  const SignInPage({
    Key? key,
    required this.passwordFieldController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const PageIcon(icon: Icons.lock_outline_rounded),
        const SizedBox(height: 32.0),
        Text(
          S.of(context).signInDescription,
          textAlign: TextAlign.center,
          style: AppTheme.pageHeadlineText(context),
        ),
        const SizedBox(height: 32.0),
        _PasswordField(passwordFieldController: passwordFieldController),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController passwordFieldController;

  const _PasswordField({
    Key? key,
    required this.passwordFieldController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.maybeWhen(
          passwordNotLoaded: () {
            context.read<AuthCubit>().loadPassword();
          },
          loadPasswordFailed: (e, stackTrace) {
            _loadPasswordFailedMsg(context, e, stackTrace);
          },
          authFailed: (info, reason) => passwordFieldController.clear(),
          orElse: () {},
        );
      },
      builder: (context, state) {
        return TextField(
          controller: passwordFieldController,
          decoration: InputDecoration(
            hintText: S.of(context).enterPassword,
            errorText: state.maybeWhen(
              authFailed: (info, reason) => reason.when(
                emptyPassword: () => S.of(context).emptyPasswordError,
                wrongPassword: () => S.of(context).wrongPassword,
              ),
              orElse: () => null,
            ),
          ),
          enableSuggestions: false,
          autocorrect: false,
          obscureText: true,
          onSubmitted: (_) => _handleSubmitCallbackState(
            context,
            state,
            passwordFieldController,
          )?.call(),
        );
      },
    );
  }
}

void _loadPasswordFailedMsg(
  BuildContext context,
  Exception? exception,
  StackTrace? stackTrace,
) {
  const msg = 'Failed to load storage password';
  log().e(msg, exception, stackTrace);

  final reportCubit = context.read<ErrorReportCubit>();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(S.of(context).error),
        content: Text(S.of(context).loadPasswordFailed),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              MaterialLocalizations.of(context).okButtonLabel,
              textAlign: TextAlign.end,
            ),
          ),
          if (exception != null)
            TextButton(
              onPressed: () {
                reportCubit.sendReport(
                  error: exception,
                  stackTrace: stackTrace,
                  message: msg,
                );
              },
              child: Text(
                S.of(context).crashDialogReport,
                textAlign: TextAlign.end,
              ),
            ),
        ],
      );
    },
  );
}
