
class Diamond {
  final String lotId;
  final String size;
  final double carat;
  final String lab;
  final String shape;
  final String color;
  final String clarity;
  final String cut;
  final String polish;
  final String symmetry;
  final String fluorescence;
  final double discount;
  final double perCaratRate;
  final double finalAmount;
  final String keyToSymbol;
  final String labComment;

  Diamond({
    required this.lotId,
    required this.size,
    required this.carat,
    required this.lab,
    required this.shape,
    required this.color,
    required this.clarity,
    required this.cut,
    required this.polish,
    required this.symmetry,
    required this.fluorescence,
    required this.discount,
    required this.perCaratRate,
    required this.finalAmount,
    required this.keyToSymbol,
    required this.labComment,
  });

  factory Diamond.fromJson(Map<String, dynamic> json) {
    return Diamond(
      lotId: json['lotId'] as String,
      size: json['size'] as String,
      carat: json['carat'] is int ? (json['carat'] as int).toDouble() : json['carat'] as double,
      lab: json['lab'] as String,
      shape: json['shape'] as String,
      color: json['color'] as String,
      clarity: json['clarity'] as String,
      cut: json['cut'] as String,
      polish: json['polish'] as String,
      symmetry: json['symmetry'] as String,
      fluorescence: json['fluorescence'] as String,
      discount: json['discount'] is int ? (json['discount'] as int).toDouble() : json['discount'] as double,
      perCaratRate: json['perCaratRate'] is int ? (json['perCaratRate'] as int).toDouble() : json['perCaratRate'] as double,
      finalAmount: json['finalAmount'] is int ? (json['finalAmount'] as int).toDouble() : json['finalAmount'] as double,
      keyToSymbol: json['keyToSymbol'] as String,
      labComment: json['labComment'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lotId': lotId,
      'size': size,
      'carat': carat,
      'lab': lab,
      'shape': shape,
      'color': color,
      'clarity': clarity,
      'cut': cut,
      'polish': polish,
      'symmetry': symmetry,
      'fluorescence': fluorescence,
      'discount': discount,
      'perCaratRate': perCaratRate,
      'finalAmount': finalAmount,
      'keyToSymbol': keyToSymbol,
      'labComment': labComment,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Diamond &&
              runtimeType == other.runtimeType &&
              lotId == other.lotId;

  @override
  int get hashCode => lotId.hashCode;
}