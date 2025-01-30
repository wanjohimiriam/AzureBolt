class AzureConfig {
  static const String PAT = '7Vn7980ghhimNUM8ZBGWr0Ydw2A1XFFV3c9AtjC00fMTCqAB3T68JQQJ99BAACAAAAAbY0nVAAASAZDOd6cG';
  static const String ORGANIZATION = 'IMPAXRND';
  
  // Project configurations
  static const Map<String, ProjectConfig> PROJECTS = {
    'VMS': ProjectConfig(
      defaultAssignees: ['Jackline Jeroitich', 'Miriam Wanjohi', 'Adrian Thuo'],
      commonTags: ['VMS POrtalV!', 'VMS Mobile AppV!', 'VMS COTEX', 'VMS Api'],
      defaultState: ['Doing', 'Done', 'To Do'],
      commonSprints: ['Sprint 23', 'Sprint 24'],
    ),
    'Itrack': ProjectConfig(
      defaultAssignees: ['', 'api.developer@company.com'],
      commonTags: ['', 'api', 'server-side'],
      defaultState: ['Doing', 'Done', 'To Do'],
      commonSprints: ['Sprint 23', 'Sprint 24'],
    ),
    'Mobile': ProjectConfig(
      defaultAssignees: ['mobile.lead@company.com', 'app.developer@company.com'],
      commonTags: ['mobile', 'android', 'ios'],
     defaultState: ['Doing', 'Done', 'To Do'],
      commonSprints: ['Sprint 23', 'Sprint 24'],
    ),
  };
}

class ProjectConfig {
  final List<String> defaultAssignees;
  final List<String> commonTags;
  final List<String> defaultState;
  final List<String> commonSprints;

  const ProjectConfig({
    required this.defaultAssignees,
    required this.commonTags,
    required this.defaultState,
    required this.commonSprints,
  });
}