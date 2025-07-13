import 'package:flutter/material.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/authentication_screen/authentication_screen.dart';
import '../presentation/authentication_screen/registration_screen.dart';
import '../presentation/ai_chat_assistant/ai_chat_assistant.dart';
import '../presentation/agribusiness_dashboard/agribusiness_dashboard.dart';
import '../presentation/real_estate_properties/real_estate_properties.dart';
import '../presentation/community_forum/community_forum.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String homeDashboard = '/home-dashboard';
  static const String authenticationScreen = '/authentication-screen';
  static const String registrationScreen = '/registration-screen';
  static const String aiChatAssistant = '/ai-chat-assistant';
  static const String agribusinessDashboard = '/agribusiness-dashboard';
  static const String realEstateProperties = '/real-estate-properties';
  static const String communityForum = '/community-forum';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const AuthenticationScreen(),
    homeDashboard: (context) => const HomeDashboard(),
    authenticationScreen: (context) => const AuthenticationScreen(),
    registrationScreen: (context) => const RegistrationScreen(),
    aiChatAssistant: (context) => const AiChatAssistant(),
    agribusinessDashboard: (context) => const AgribusinessDashboard(),
    realEstateProperties: (context) => const RealEstateProperties(),
    communityForum: (context) => const CommunityForum(),
    // TODO: Add your other routes here
  };
}
