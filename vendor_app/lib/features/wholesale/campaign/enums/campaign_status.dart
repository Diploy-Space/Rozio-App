enum CampaignStatus {
  notJoined,
  pending,
  approved,
  denied;

  static CampaignStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'approved':
        return CampaignStatus.approved;
      case 'denied':
      case 'rejected':
        return CampaignStatus.denied;
      case 'pending':
        return CampaignStatus.pending;
      default:
        return CampaignStatus.notJoined;
    }
  }

  String? get apiValue {
    switch (this) {
      case CampaignStatus.approved:
        return 'approved';
      case CampaignStatus.denied:
        return 'denied';
      case CampaignStatus.pending:
        return 'pending';
      case CampaignStatus.notJoined:
        return null;
    }
  }

  String get translationKey {
    switch (this) {
      case CampaignStatus.approved:
        return 'approved';
      case CampaignStatus.denied:
        return 'denied';
      case CampaignStatus.pending:
        return 'pending';
      case CampaignStatus.notJoined:
        return 'join';
    }
  }
}
