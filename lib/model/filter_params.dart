
class FilterParams {
  final double? caratFrom;
  final double? caratTo;
  final String? lab;
  final String? shape;
  final String? color;
  final String? clarity;

  FilterParams({
    this.caratFrom,
    this.caratTo,
    this.lab,
    this.shape,
    this.color,
    this.clarity,
  });

  bool isEmpty() {
    return caratFrom == null &&
        caratTo == null &&
        lab == null &&
        shape == null &&
        color == null &&
        clarity == null;
  }

  FilterParams copyWith({
    double? caratFrom,
    double? caratTo,
    String? lab,
    String? shape,
    String? color,
    String? clarity,
  }) {
    return FilterParams(
      caratFrom: caratFrom ?? this.caratFrom,
      caratTo: caratTo ?? this.caratTo,
      lab: lab ?? this.lab,
      shape: shape ?? this.shape,
      color: color ?? this.color,
      clarity: clarity ?? this.clarity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'caratFrom': caratFrom,
      'caratTo': caratTo,
      'lab': lab,
      'shape': shape,
      'color': color,
      'clarity': clarity,
    };
  }

  factory FilterParams.fromJson(Map<String, dynamic> json) {
    return FilterParams(
      caratFrom: json['caratFrom'] != null ? json['caratFrom'] as double : null,
      caratTo: json['caratTo'] != null ? json['caratTo'] as double : null,
      lab: json['lab'] as String?,
      shape: json['shape'] as String?,
      color: json['color'] as String?,
      clarity: json['clarity'] as String?,
    );
  }
}