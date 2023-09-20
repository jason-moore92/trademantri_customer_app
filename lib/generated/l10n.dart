// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Tap again to leave`
  String get tapAgainToLeave {
    return Intl.message(
      'Tap again to leave',
      name: 'tapAgainToLeave',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password ?`
  String get i_forgot_password {
    return Intl.message(
      'Forgot password ?',
      name: 'i_forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Should be a valid email`
  String get should_be_a_valid_email {
    return Intl.message(
      'Should be a valid email',
      name: 'should_be_a_valid_email',
      desc: '',
      args: [],
    );
  }

  /// `Should be a valid email or 10 digits phone number`
  String get should_be_a_valid_email_phone {
    return Intl.message(
      'Should be a valid email or 10 digits phone number',
      name: 'should_be_a_valid_email_phone',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get send_password_otp {
    return Intl.message(
      'Send OTP',
      name: 'send_password_otp',
      desc: '',
      args: [],
    );
  }

  /// `Password must have 1 letter, 1 digit and must be atleast 8 characters in length`
  String get should_password_input {
    return Intl.message(
      'Password must have 1 letter, 1 digit and must be atleast 8 characters in length',
      name: 'should_password_input',
      desc: '',
      args: [],
    );
  }

  /// `Should match the passwords`
  String get should_password_match {
    return Intl.message(
      'Should match the passwords',
      name: 'should_password_match',
      desc: '',
      args: [],
    );
  }

  /// `Please input name`
  String get should_be_a_name {
    return Intl.message(
      'Please input name',
      name: 'should_be_a_name',
      desc: '',
      args: [],
    );
  }

  /// `Input first name`
  String get input_first_name {
    return Intl.message(
      'Input first name',
      name: 'input_first_name',
      desc: '',
      args: [],
    );
  }

  /// `Input last name`
  String get input_last_name {
    return Intl.message(
      'Input last name',
      name: 'input_last_name',
      desc: '',
      args: [],
    );
  }

  /// `Should be 10 numbers`
  String get not_a_valid_phone {
    return Intl.message(
      'Should be 10 numbers',
      name: 'not_a_valid_phone',
      desc: '',
      args: [],
    );
  }

  /// `Should be more than 8 charactors`
  String get should_be_contact_reason {
    return Intl.message(
      'Should be more than 8 charactors',
      name: 'should_be_contact_reason',
      desc: '',
      args: [],
    );
  }

  /// `Should be address type`
  String get should_be_address_type {
    return Intl.message(
      'Should be address type',
      name: 'should_be_address_type',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get reset {
    return Intl.message(
      'Reset',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `Input reset password token`
  String get input_reset_password_token {
    return Intl.message(
      'Input reset password token',
      name: 'input_reset_password_token',
      desc: '',
      args: [],
    );
  }

  /// `Should be a valid address`
  String get notValidAddress {
    return Intl.message(
      'Should be a valid address',
      name: 'notValidAddress',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Log In Successfully`
  String get sign_in_successfully {
    return Intl.message(
      'Log In Successfully',
      name: 'sign_in_successfully',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Add Delivery Address`
  String get add_delivery_address {
    return Intl.message(
      'Add Delivery Address',
      name: 'add_delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Add new delivery address`
  String get add_new_delivery_address {
    return Intl.message(
      'Add new delivery address',
      name: 'add_new_delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get add_to_cart {
    return Intl.message(
      'Add to Cart',
      name: 'add_to_cart',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Addresses refreshed successfully`
  String get addresses_refreshed_successfuly {
    return Intl.message(
      'Addresses refreshed successfully',
      name: 'addresses_refreshed_successfuly',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `All Products`
  String get all_product {
    return Intl.message(
      'All Products',
      name: 'all_product',
      desc: '',
      args: [],
    );
  }

  /// `App Language`
  String get app_language {
    return Intl.message(
      'App Language',
      name: 'app_language',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get app_settings {
    return Intl.message(
      'App Settings',
      name: 'app_settings',
      desc: '',
      args: [],
    );
  }

  /// `Application Preferences`
  String get application_preferences {
    return Intl.message(
      'Application Preferences',
      name: 'application_preferences',
      desc: '',
      args: [],
    );
  }

  /// `Apply Filters`
  String get apply_filters {
    return Intl.message(
      'Apply Filters',
      name: 'apply_filters',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to cancel this order?`
  String get areYouSureYouWantToCancelThisOrder {
    return Intl.message(
      'Are you sure you want to cancel this order?',
      name: 'areYouSureYouWantToCancelThisOrder',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Order`
  String get cancelOrder {
    return Intl.message(
      'Cancel Order',
      name: 'cancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get cancelled {
    return Intl.message(
      'Canceled',
      name: 'cancelled',
      desc: '',
      args: [],
    );
  }

  /// `CARD NUMBER`
  String get card_number {
    return Intl.message(
      'CARD NUMBER',
      name: 'card_number',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Carts refreshed successfully`
  String get carts_refreshed_successfuly {
    return Intl.message(
      'Carts refreshed successfully',
      name: 'carts_refreshed_successfuly',
      desc: '',
      args: [],
    );
  }

  /// `Cash on delivery`
  String get cash_on_delivery {
    return Intl.message(
      'Cash on delivery',
      name: 'cash_on_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Category refreshed successfully`
  String get category_refreshed_successfuly {
    return Intl.message(
      'Category refreshed successfully',
      name: 'category_refreshed_successfuly',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Click on the product to get more details about it`
  String get clickOnTheProductToGetMoreDetailsAboutIt {
    return Intl.message(
      'Click on the product to get more details about it',
      name: 'clickOnTheProductToGetMoreDetailsAboutIt',
      desc: '',
      args: [],
    );
  }

  /// `Click to pay with RazorPay method`
  String get clickToPayWithRazorpayMethod {
    return Intl.message(
      'Click to pay with RazorPay method',
      name: 'clickToPayWithRazorpayMethod',
      desc: '',
      args: [],
    );
  }

  /// `Click on the stars below to leave comments`
  String get click_on_the_stars_below_to_leave_comments {
    return Intl.message(
      'Click on the stars below to leave comments',
      name: 'click_on_the_stars_below_to_leave_comments',
      desc: '',
      args: [],
    );
  }

  /// `Click to confirm your address and pay or Long press to edit your address`
  String get click_to_confirm_your_address_and_pay_or_long_press {
    return Intl.message(
      'Click to confirm your address and pay or Long press to edit your address',
      name: 'click_to_confirm_your_address_and_pay_or_long_press',
      desc: '',
      args: [],
    );
  }

  /// `Click to pay cash on delivery`
  String get click_to_pay_cash_on_delivery {
    return Intl.message(
      'Click to pay cash on delivery',
      name: 'click_to_pay_cash_on_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Click to pay on pickup`
  String get click_to_pay_on_pickup {
    return Intl.message(
      'Click to pay on pickup',
      name: 'click_to_pay_on_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Click to pay with your MasterCard`
  String get click_to_pay_with_your_mastercard {
    return Intl.message(
      'Click to pay with your MasterCard',
      name: 'click_to_pay_with_your_mastercard',
      desc: '',
      args: [],
    );
  }

  /// `Click to pay with your PayPal account`
  String get click_to_pay_with_your_paypal_account {
    return Intl.message(
      'Click to pay with your PayPal account',
      name: 'click_to_pay_with_your_paypal_account',
      desc: '',
      args: [],
    );
  }

  /// `Click to pay with your Visa Card`
  String get click_to_pay_with_your_visa_card {
    return Intl.message(
      'Click to pay with your Visa Card',
      name: 'click_to_pay_with_your_visa_card',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Closed`
  String get closed {
    return Intl.message(
      'Closed',
      name: 'closed',
      desc: '',
      args: [],
    );
  }

  /// `Complete your profile details to continue`
  String get completeYourProfileDetailsToContinue {
    return Intl.message(
      'Complete your profile details to continue',
      name: 'completeYourProfileDetailsToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Payment`
  String get confirm_payment {
    return Intl.message(
      'Confirm Payment',
      name: 'confirm_payment',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your delivery address`
  String get confirm_your_delivery_address {
    return Intl.message(
      'Confirm your delivery address',
      name: 'confirm_your_delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Confirmation`
  String get confirmation {
    return Intl.message(
      'Confirmation',
      name: 'confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Current location`
  String get current_location {
    return Intl.message(
      'Current location',
      name: 'current_location',
      desc: '',
      args: [],
    );
  }

  /// `CVC`
  String get cvc {
    return Intl.message(
      'CVC',
      name: 'cvc',
      desc: '',
      args: [],
    );
  }

  /// `CVV`
  String get cvv {
    return Intl.message(
      'CVV',
      name: 'cvv',
      desc: '',
      args: [],
    );
  }

  /// `Dark Mode`
  String get dark_mode {
    return Intl.message(
      'Dark Mode',
      name: 'dark_mode',
      desc: '',
      args: [],
    );
  }

  /// `Default Credit Card`
  String get default_credit_card {
    return Intl.message(
      'Default Credit Card',
      name: 'default_credit_card',
      desc: '',
      args: [],
    );
  }

  /// `Deliverable`
  String get deliverable {
    return Intl.message(
      'Deliverable',
      name: 'deliverable',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivery address outside the delivery range of this markets.`
  String get deliveryAddressOutsideTheDeliveryRangeOfThisMarkets {
    return Intl.message(
      'Delivery address outside the delivery range of this markets.',
      name: 'deliveryAddressOutsideTheDeliveryRangeOfThisMarkets',
      desc: '',
      args: [],
    );
  }

  /// `Delivery method not allowed!`
  String get deliveryMethodNotAllowed {
    return Intl.message(
      'Delivery method not allowed!',
      name: 'deliveryMethodNotAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address`
  String get delivery_address {
    return Intl.message(
      'Delivery Address',
      name: 'delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Address removed successfully`
  String get delivery_address_removed_successfully {
    return Intl.message(
      'Delivery Address removed successfully',
      name: 'delivery_address_removed_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Addresses`
  String get delivery_addresses {
    return Intl.message(
      'Delivery Addresses',
      name: 'delivery_addresses',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Fee`
  String get delivery_fee {
    return Intl.message(
      'Delivery Fee',
      name: 'delivery_fee',
      desc: '',
      args: [],
    );
  }

  /// `Delivery or Pickup`
  String get delivery_or_pickup {
    return Intl.message(
      'Delivery or Pickup',
      name: 'delivery_or_pickup',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Discover & Explorer`
  String get discover_explorer {
    return Intl.message(
      'Discover & Explorer',
      name: 'discover_explorer',
      desc: '',
      args: [],
    );
  }

  /// `Don't have any item in the notification list`
  String get dont_have_any_item_in_the_notification_list {
    return Intl.message(
      'Don\'t have any item in the notification list',
      name: 'dont_have_any_item_in_the_notification_list',
      desc: '',
      args: [],
    );
  }

  /// `D'ont have any item in your cart`
  String get dont_have_any_item_in_your_cart {
    return Intl.message(
      'D\'ont have any item in your cart',
      name: 'dont_have_any_item_in_your_cart',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get email_address {
    return Intl.message(
      'Email Address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `Email to reset password`
  String get email_to_reset_password {
    return Intl.message(
      'Email to reset password',
      name: 'email_to_reset_password',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Error! Verify email settings`
  String get error_verify_email_settings {
    return Intl.message(
      'Error! Verify email settings',
      name: 'error_verify_email_settings',
      desc: '',
      args: [],
    );
  }

  /// `Exp Date`
  String get exp_date {
    return Intl.message(
      'Exp Date',
      name: 'exp_date',
      desc: '',
      args: [],
    );
  }

  /// `EXPIRY DATE`
  String get expiry_date {
    return Intl.message(
      'EXPIRY DATE',
      name: 'expiry_date',
      desc: '',
      args: [],
    );
  }

  /// `Faq`
  String get faq {
    return Intl.message(
      'Faq',
      name: 'faq',
      desc: '',
      args: [],
    );
  }

  /// `Faqs refreshed successfully`
  String get faqsRefreshedSuccessfuly {
    return Intl.message(
      'Faqs refreshed successfully',
      name: 'faqsRefreshedSuccessfuly',
      desc: '',
      args: [],
    );
  }

  /// `Favorite Products`
  String get favorite_products {
    return Intl.message(
      'Favorite Products',
      name: 'favorite_products',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get favorites {
    return Intl.message(
      'Favorites',
      name: 'favorites',
      desc: '',
      args: [],
    );
  }

  /// `Favorites refreshed successfully`
  String get favorites_refreshed_successfuly {
    return Intl.message(
      'Favorites refreshed successfully',
      name: 'favorites_refreshed_successfuly',
      desc: '',
      args: [],
    );
  }

  /// `Featured Products`
  String get featured_products {
    return Intl.message(
      'Featured Products',
      name: 'featured_products',
      desc: '',
      args: [],
    );
  }

  /// `Fields`
  String get fields {
    return Intl.message(
      'Fields',
      name: 'fields',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `For more details, please chat with our managers`
  String get forMoreDetailsPleaseChatWithOurManagers {
    return Intl.message(
      'For more details, please chat with our managers',
      name: 'forMoreDetailsPleaseChatWithOurManagers',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Full Address`
  String get full_address {
    return Intl.message(
      'Full Address',
      name: 'full_address',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message(
      'Full name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message(
      'Guest',
      name: 'guest',
      desc: '',
      args: [],
    );
  }

  /// `Have Coupon Code?`
  String get haveCouponCode {
    return Intl.message(
      'Have Coupon Code?',
      name: 'haveCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `Help & Support`
  String get help_support {
    return Intl.message(
      'Help & Support',
      name: 'help_support',
      desc: '',
      args: [],
    );
  }

  /// `Help & Supports`
  String get help_supports {
    return Intl.message(
      'Help & Supports',
      name: 'help_supports',
      desc: '',
      args: [],
    );
  }

  /// `12 Street, City 21663, Country`
  String get hint_full_address {
    return Intl.message(
      '12 Street, City 21663, Country',
      name: 'hint_full_address',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Home Address`
  String get home_address {
    return Intl.message(
      'Home Address',
      name: 'home_address',
      desc: '',
      args: [],
    );
  }

  /// `How would you rate this market ?`
  String get how_would_you_rate_this_market {
    return Intl.message(
      'How would you rate this market ?',
      name: 'how_would_you_rate_this_market',
      desc: '',
      args: [],
    );
  }

  /// `I don't have an account?`
  String get i_dont_have_an_account {
    return Intl.message(
      'I don\'t have an account?',
      name: 'i_dont_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `I have account? Back to login`
  String get i_have_account_back_to_login {
    return Intl.message(
      'I have account? Back to login',
      name: 'i_have_account_back_to_login',
      desc: '',
      args: [],
    );
  }

  /// `I remember my password return to login.`
  String get i_remember_my_password_return_to_login {
    return Intl.message(
      'I remember my password return to login.',
      name: 'i_remember_my_password_return_to_login',
      desc: '',
      args: [],
    );
  }

  /// `Thanks for contacting us\nour help desk team will contact you.`
  String get contact_success_dlg {
    return Intl.message(
      'Thanks for contacting us\nour help desk team will contact you.',
      name: 'contact_success_dlg',
      desc: '',
      args: [],
    );
  }

  /// `You can't contact to support.\nPlease try tomorrow.`
  String get contact_count_over {
    return Intl.message(
      'You can\'t contact to support.\nPlease try tomorrow.',
      name: 'contact_count_over',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get forgot_otp_page_title {
    return Intl.message(
      'Enter OTP',
      name: 'forgot_otp_page_title',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send_button {
    return Intl.message(
      'Send',
      name: 'send_button',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend_button {
    return Intl.message(
      'Resend',
      name: 'resend_button',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get reset_password_page_title {
    return Intl.message(
      'Reset Password',
      name: 'reset_password_page_title',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
