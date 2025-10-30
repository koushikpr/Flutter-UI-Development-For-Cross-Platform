import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item_model.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  static const _storageKey = 'cart_state_v1';

  CartCubit()
      : super(CartState(
          items: const [],
          isGiftEnabled: false,
          giftEmail: '',
          tipOption: TipOption.noTip,
          customTipAmount: 0,
          paymentMethod: const PaymentMethodModel(
            id: '1',
            type: 'card',
            lastFourDigits: '4568',
            email: 'example@email.com',
            billingAddress: '1226 University Dr, Menlo Park, CA 94025-4221',
            cardBrand: 'Mastercard',
          ),
        )) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        emit(CartState.fromJson(map));
      } catch (_) {}
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    emit(state.copyWith(items: [], tipOption: TipOption.noTip, customTipAmount: 0));
    await _save();
  }

  Future<void> setItems(List<CartItemModel> items) async {
    emit(state.copyWith(items: items));
    await _save();
  }

  Future<void> addItem(CartItemModel item) async {
    final updated = List<CartItemModel>.from(state.items)..add(item);
    emit(state.copyWith(items: updated));
    await _save();
  }

  Future<void> removeItem(String id) async {
    final updated = state.items.where((e) => e.id != id).toList();
    emit(state.copyWith(items: updated));
    await _save();
  }

  Future<void> replaceWithSingleItem(CartItemModel item) async {
    emit(state.copyWith(items: [item]));
    await _save();
  }

  Future<void> setGift(bool enabled, String email) async {
    emit(state.copyWith(isGiftEnabled: enabled, giftEmail: email));
    await _save();
  }

  Future<void> setTip(TipOption option, {double? customAmount}) async {
    emit(state.copyWith(
      tipOption: option,
      customTipAmount: customAmount ?? state.customTipAmount,
    ));
    await _save();
  }

  Future<void> setPaymentMethod(PaymentMethodModel method) async {
    emit(state.copyWith(paymentMethod: method));
    await _save();
  }
}

