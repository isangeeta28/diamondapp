
import '../data/data.dart';
import '../model/diamond.dart';
import '../model/filter_params.dart';

class DiamondRepository {
  final List<Diamond> _diamonds = getDiamondData();

  List<Diamond> getAllDiamonds() {
    return _diamonds;
  }

  // This method was causing an infinite recursion - fixed
  Map<String, List<String>> getFilterOptions() {
    // Extract unique values from diamond data
    final Set<String> labs = _diamonds.map((d) => d.lab).toSet();
    final Set<String> shapes = _diamonds.map((d) => d.shape).toSet();
    final Set<String> colors = _diamonds.map((d) => d.color).toSet();
    final Set<String> clarities = _diamonds.map((d) => d.clarity).toSet();

    return {
      'labs': labs.toList(),
      'shapes': shapes.toList(),
      'colors': colors.toList(),
      'clarities': clarities.toList(),
    };
  }

  List<Diamond> getFilteredDiamonds(FilterParams params) {
    if (params.isEmpty()) {
      return _diamonds;
    }

    return _diamonds.where((diamond) {
      bool matchesCarat = true;
      bool matchesLab = true;
      bool matchesShape = true;
      bool matchesColor = true;
      bool matchesClarity = true;

      if (params.caratFrom != null) {
        matchesCarat = diamond.carat >= params.caratFrom!;
      }

      if (params.caratTo != null) {
        matchesCarat = matchesCarat && diamond.carat <= params.caratTo!;
      }

      if (params.lab != null && params.lab!.isNotEmpty) {
        matchesLab = diamond.lab == params.lab;
      }

      if (params.shape != null && params.shape!.isNotEmpty) {
        matchesShape = diamond.shape == params.shape;
      }

      if (params.color != null && params.color!.isNotEmpty) {
        matchesColor = diamond.color == params.color;
      }

      if (params.clarity != null && params.clarity!.isNotEmpty) {
        matchesClarity = diamond.clarity == params.clarity;
      }

      return matchesCarat && matchesLab && matchesShape && matchesColor && matchesClarity;
    }).toList();
  }

  // Get diamonds based on filter parameters
  List<Diamond> getDiamonds(FilterParams params) {
    if (params.isEmpty()) {
      return _diamonds;
    }

    return _diamonds.where((diamond) {
      // Apply carat filter
      if (params.caratFrom != null && diamond.carat < params.caratFrom!) {
        return false;
      }
      if (params.caratTo != null && diamond.carat > params.caratTo!) {
        return false;
      }

      // Apply lab filter
      if (params.lab != null && params.lab!.isNotEmpty && diamond.lab != params.lab) {
        return false;
      }

      // Apply shape filter
      if (params.shape != null && params.shape!.isNotEmpty && diamond.shape != params.shape) {
        return false;
      }

      // Apply color filter
      if (params.color != null && params.color!.isNotEmpty && diamond.color != params.color) {
        return false;
      }

      // Apply clarity filter
      if (params.clarity != null && params.clarity!.isNotEmpty && diamond.clarity != params.clarity) {
        return false;
      }

      return true;
    }).toList();
  }
}