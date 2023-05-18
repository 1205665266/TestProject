class FirstOrderFreeState {
  bool isLoading = false;
  bool firstOrderFreeDeliveryFee = false;

  FirstOrderFreeState copy() {
    return FirstOrderFreeState()
      ..firstOrderFreeDeliveryFee = firstOrderFreeDeliveryFee
      ..isLoading = isLoading;
  }
}
