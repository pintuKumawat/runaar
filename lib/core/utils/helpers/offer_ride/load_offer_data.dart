class LoadOfferData {
  final int userId;
  final String originLat;
  final String originLong;
  final String originAddress;
  final String originCity;
  final String destinationLat;
  final String destinationLong;
  final String destinationAddress;
  final String destinationCity;
  final String deptDate;
  final String arrivalDate;
  final String deptTime;
  final String arrivalTime;
  final int vehicleId;

  const LoadOfferData({
    required this.userId,
    required this.originLat,
    required this.originLong,
    required this.originAddress,
    required this.originCity,
    required this.destinationLat,
    required this.destinationLong,
    required this.destinationAddress,
    required this.destinationCity,
    required this.deptDate,
    required this.arrivalDate,
    required this.deptTime,
    required this.arrivalTime,
    required this.vehicleId,
  });
}
