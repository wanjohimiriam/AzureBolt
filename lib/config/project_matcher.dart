class ProjectMatcher {
  static final Map<String, List<String>> _projectKeywords = {
    'Frontend': ['ui', 'interface', 'design', 'css', 'html', 'react', 'vue', 'frontend'],
    'Backend': ['api', 'database', 'server', 'endpoint', 'service', 'backend'],
    'Mobile': ['android', 'ios', 'app', 'mobile', 'responsive'],
  };

  static String identifyProject(String description) {
    description = description.toLowerCase();
    Map<String, int> matches = {};
    
    _projectKeywords.forEach((project, keywords) {
      matches[project] = 0;
      for (var keyword in keywords) {
        if (description.contains(keyword)) {
          matches[project] = (matches[project] ?? 0) + 1;
        }
      }
    });

    // Get project with most keyword matches
    String bestMatch = 'Frontend'; // Default to Frontend if no matches
    int maxMatches = 0;
    
    matches.forEach((project, count) {
      if (count > maxMatches) {
        maxMatches = count;
        bestMatch = project;
      }
    });

    return bestMatch;
  }
}