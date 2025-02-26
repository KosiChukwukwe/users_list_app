import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:technical_assessment/l10n/l10n.dart';
import 'package:technical_assessment/src/features/users/users.dart';

class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {

  final FocusNode _focusNode = FocusNode();
  String? lastErrorMessage;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (mounted) {
        ref.read(userControllerImplProvider.notifier).getUsers(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n;
    final userState = ref.watch(userControllerImplProvider);
    final userController = ref.watch(userControllerImplProvider.notifier);

    if (userController.errorMessage != null &&
        userController.errorMessage != lastErrorMessage) {
      lastErrorMessage = userController.errorMessage;

      Future.microtask(() {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(userController.errorMessage!),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:Text(
         locale.appTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          await ref.read(userControllerImplProvider.notifier).getUsers(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: locale.searchUsers,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (value) {
                    ref
                        .read(userControllerImplProvider.notifier)
                        .setSearchQuery(value);

                    if (value.isEmpty) {
                      _focusNode.unfocus();
                    }
                  },
                ),
              ),
              Expanded(
                child: userState.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  ),
                  data: (_) {
                    final users = ref
                            .watch(userControllerImplProvider.notifier)
                            .filteredUsers ??
                        [];

                    if (users.isEmpty) {
                      return Center(
                        child: Text(
                          locale.noUsers,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            top: (user == users.first) ? 30.0 : 10.0,
                            bottom: (user == users.last) ? 30.0 : 10.0,
                          ),
                          child: UserWidget(
                            name: user.name ?? locale.userDemoText,
                            email: user.email ?? locale.emailDemoText,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Colors.grey.withOpacity(0.1),
                        );
                      },
                    );
                  },
                  error: (_, __) => Center(child: Text(userController.errorMessage!),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
