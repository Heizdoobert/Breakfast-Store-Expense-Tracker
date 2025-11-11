import 'package:flutter/material.dart';

/// Quan ly cac appicons cung apptext mac dinh ma khong can phai goi lai nhieu lan
class AppText {
  static const String appTitle = 'Quản lý chi tiêu';
  static const String welcomeMessage = 'Chào mừng bạn đến với ứng dụng';
  static const String errorNetwork =
      'Không thể kết nối tới máy chủ. Vui lòng thử lại';
}

class AppIcons {
  // ============ AUTH ICONS ============
  static const IconData email = Icons.email;
  static const IconData password = Icons.lock;
  static const IconData visibility = Icons.visibility;
  static const IconData visibilityOff = Icons.visibility_off;
  static const IconData person = Icons.person;

  // ============ DASHBOARD ICONS ============
  static const IconData dashboard = Icons.dashboard;
  static const IconData home = Icons.home;
  static const IconData analytics = Icons.analytics;
  static const IconData assessment = Icons.assessment;
  static const IconData notifications = Icons.notifications;

  // ============ USER MANAGEMENT ICONS ============
  static const IconData users = Icons.people;
  static const IconData userAdd = Icons.person_add;
  static const IconData userEdit = Icons.edit;
  static const IconData userDelete = Icons.delete;

  // ============ FINANCIAL ICONS ============
  static const IconData money = Icons.attach_money;
  static const IconData payment = Icons.payment;
  static const IconData receipt = Icons.receipt;
  static const IconData wallet = Icons.wallet;

  // ============ NOTE ICONS ============
  static const IconData note = Icons.note;
  static const IconData noteAdd = Icons.note_add;
  static const IconData noteEdit = Icons.edit_note;
  static const IconData checklist = Icons.checklist;

  // ============ SYSTEM ICONS ============
  static const IconData settings = Icons.settings;
  static const IconData logout = Icons.logout;
  static const IconData menu = Icons.menu;
  static const IconData arrowBack = Icons.arrow_back;

  // ============ STATUS ICONS ============
  static const IconData success = Icons.check_circle;
  static const IconData error = Icons.error;
  static const IconData warning = Icons.warning;
  static const IconData info = Icons.info;

  // ============ CUSTOM ICONS (Nếu có) ============
  static const IconData customLogo = Icons.account_balance;

  static const IconData group = Icons.group;
}
