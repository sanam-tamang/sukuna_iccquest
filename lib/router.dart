import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meeteri/features/chat/pages/chat_page.dart';
import 'package:meeteri/features/chat/pages/messaged_user.dart';
import 'package:meeteri/features/habit/pages/habit_page_main.dart';
import 'package:meeteri/features/habit/pages/habit_progress.dart';
import 'package:meeteri/features/note/pages/note_page.dart';
import 'package:meeteri/features/profile/pages/profile.dart';
import '/features/post/pages/create_post_page.dart';
import '/common/extensions.dart';
import '/features/auth/pages/sign_in.dart';
import '/features/auth/pages/sign_up.dart';
import '/features/home/pages/home_page.dart';
import 'common/bloc_listenable.dart';
import 'dependency_injection.dart';
import 'features/auth/blocs/auth_bloc/auth_bloc.dart';
import 'features/chat/models/chat_room.dart';

class AppRouteName {
  static const String home = "home";
  static const String signUp = "sign-up";
  static const String signIn = "sign-in";
  static const String createPost = "create-post";
  static const String showNote = "show-note";
  static const String chatPage = "chat-page";
  static const String taskPage = "task-page";
  static const String habitPage = "habit-page";
  static const String profilePage = "profile-page";
  static const String messagedUserPage = "message-user-page";
}

class AppRoute {
  static GoRouter call() {
    return GoRouter(
        initialLocation: AppRouteName.signIn.path,
        redirect: (context, state) {
          final currentPath = state.uri.path;
          bool isAuthPath = currentPath == AppRouteName.signIn.path ||
              currentPath == AppRouteName.signUp.path;
          if (isAuthPath) {
            return sl<AuthBloc>().state.maybeWhen(
                loaded: (_) => AppRouteName.home.rootPath, orElse: () => null);
          } else {
            return null;
          }
        },
        refreshListenable: BlocListenable(sl<AuthBloc>()),
        routes: [
          GoRoute(
            path: AppRouteName.home.rootPath,
            name: AppRouteName.home,
            pageBuilder: (context, state) {
              return _customPage(state, child: const HomePage());
            },
          ),
          GoRoute(
            path: AppRouteName.signUp.path,
            name: AppRouteName.signUp,
            pageBuilder: (context, state) {
              return _customPage(state, child: const SignUpPage());
            },
          ),
          GoRoute(
            path: AppRouteName.signIn.path,
            name: AppRouteName.signIn,
            pageBuilder: (context, state) {
              return _customPage(state, child: const SignInPage());
            },
          ),
          GoRoute(
            path: AppRouteName.createPost.path,
            name: AppRouteName.createPost,
            pageBuilder: (context, state) {
              final String postType = state.extra as String;
              return _customPage(state,
                  child: CreatePostPage(
                    postType: postType,
                  ));
            },
          ),
          GoRoute(
            path: AppRouteName.showNote.path,
            name: AppRouteName.showNote,
            pageBuilder: (context, state) {
              final String userId = state.extra as String;
              return _customPage(state,
                  child: NotesPage(
                    userId: userId,
                  ));
            },
          ),
          GoRoute(
            path: AppRouteName.chatPage.path,
            name: AppRouteName.chatPage,
            pageBuilder: (context, state) {
              final ChatRoomIndividual user = state.extra as ChatRoomIndividual;
              return _customPage(state,
                  child: ChatPage(
                    chatRoomIndividual: user,
                  ));
            },
          ),
          GoRoute(
            path: AppRouteName.habitPage.path,
            name: AppRouteName.habitPage,
            pageBuilder: (context, state) {
              return _customPage(state, child: const HabitPageMain());
            },
          ),

           GoRoute(
            path: AppRouteName.profilePage.path,
            name: AppRouteName.profilePage,
            pageBuilder: (context, state) {
              final String? userId = state.extra as String?;
              return _customPage(state, child:  UserProfilePage(
                userId: userId,
              ));
            },
          ),

           GoRoute(
            path: AppRouteName.messagedUserPage.path,
            name: AppRouteName.messagedUserPage,
            pageBuilder: (context, state) {
              final String? userId = state.extra as String?;
              return _customPage(state,
                  child: MessagedUserPage(
                 
                  ));
            },
          ),
        ]);
  }

  static Page<dynamic> _customPage(GoRouterState state,
      {required Widget child}) {
    return MaterialPage(key: state.pageKey, child: child);
  }
}
