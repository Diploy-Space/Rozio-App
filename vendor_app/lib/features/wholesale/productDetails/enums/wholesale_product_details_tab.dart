enum WholesaleProductDetailsTab {
  overview,
  reviews,
  faq;

  String get translationKey {
    switch (this) {
      case WholesaleProductDetailsTab.overview:
        return 'overview';
      case WholesaleProductDetailsTab.reviews:
        return 'reviews';
      case WholesaleProductDetailsTab.faq:
        return 'faq';
    }
  }

  String get fallbackLabel {
    switch (this) {
      case WholesaleProductDetailsTab.overview:
        return 'Overview';
      case WholesaleProductDetailsTab.reviews:
        return 'Reviews';
      case WholesaleProductDetailsTab.faq:
        return 'FAQ';
    }
  }
}
