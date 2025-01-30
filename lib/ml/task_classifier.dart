import 'dart:math';

class TaskClassifier {
  bool isInitialized = true;
  final Map<String, List<String>> _priorityKeywords = {
    'high': ['urgent', 'asap', 'critical', 'important', 'immediate'],
    'medium': ['soon', 'needed', 'required', 'necessary'],
    'low': ['whenever', 'backlog', 'eventually', 'nice to have']
  };

  final Map<String, List<String>> _complexityKeywords = {
    'high': ['complex', 'difficult', 'challenging', 'major', 'significant'],
    'medium': ['moderate', 'regular', 'normal', 'standard'],
    'low': ['simple', 'easy', 'minor', 'quick', 'small']
  };

  final Map<String, List<String>> _componentKeywords = {
    'frontend': ['ui', 'interface', 'design', 'css', 'html', 'react', 'vue'],
    'backend': ['api', 'database', 'server', 'endpoint', 'service'],
    'mobile': ['android', 'ios', 'app', 'mobile', 'responsive'],
    'devops': ['pipeline', 'deployment', 'ci/cd', 'build', 'infrastructure']
  };

  Map<String, double> classifyText(String text) {
    text = text.toLowerCase();
    
    return {
      'priority': _calculateScore(text, _priorityKeywords),
      'complexity': _calculateScore(text, _complexityKeywords),
      'component': _identifyComponent(text),
      'risk': _calculateRiskScore(text),
    };
  }

  double _calculateScore(String text, Map<String, List<String>> keywords) {
    double score = 0.0;
    int matches = 0;

    keywords.forEach((level, words) {
      for (var word in words) {
        if (text.contains(word)) {
          matches++;
          switch (level) {
            case 'high':
              score += 0.8;
              break;
            case 'medium':
              score += 0.5;
              break;
            case 'low':
              score += 0.2;
              break;
          }
        }
      }
    });

    if (matches == 0) return 0.5; // Default to medium if no matches
    return min(1.0, score / matches);
  }

  double _identifyComponent(String text) {
    Map<String, int> matches = {};
    
    _componentKeywords.forEach((component, keywords) {
      matches[component] = 0;
      for (var keyword in keywords) {
        if (text.contains(keyword)) {
          matches[component] = (matches[component] ?? 0) + 1;
        }
      }
    });

    // Return confidence score for most matched component
    var maxMatches = matches.values.fold(0, max);
    return maxMatches > 0 ? min(1.0, maxMatches / 3) : 0.5;
  }

  double _calculateRiskScore(String text) {
    final riskKeywords = {
      'high': ['security', 'critical', 'production', 'sensitive', 'deadline'],
      'medium': ['testing', 'validation', 'review', 'update'],
      'low': ['documentation', 'minor', 'internal']
    };

    return _calculateScore(text, riskKeywords);
  }
}