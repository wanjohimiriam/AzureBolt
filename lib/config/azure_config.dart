class AzureConfig {
  static const String PAT = '7Vn7980ghhimNUM8ZBGWr0Ydw2A1XFFV3c9AtjC00fMTCqAB3T68JQQJ99BAACAAAAAbY0nVAAASAZDOd6cG';
  static const String ORGANIZATION = 'IMPAXRND';
  
  // Project configurations
  static const Map<String, ProjectConfig> PROJECTS = {
    'VMS': ProjectConfig(
      defaultAssignees: ['Jackline Jeroitich', 'Miriam Wanjohi', 'Adrian Thuo'],
      commonTags: ['VMS POrtalV1', 'VMS Mobile AppV!', 'VMS COTEX', 'VMS Api'],
      defaultState: ['Doing', 'Done', 'To Do'],
      commonSprints: ['Sprint/2', 'Sprint 4'],
    ),
    'Itrack': ProjectConfig(
      defaultAssignees: ['Miriam Wanjohi', 'Jackline Jeroitich', 'Adrian Thuo'],
      commonTags: ['Itrack Naivas', 'Itrack MyCredit', 'Itrack NCBA','Itrack Britam', 'Itrack Mobile App', 'Itrack Api'],
      defaultState: ['Doing', 'Done', 'To Do'],
      commonSprints: ['Sprint/2', 'Sprint 3'],
    ),
    'Mobile': ProjectConfig(
      defaultAssignees: ['Miriam Wanjohi', 'Jackline Jeroitich', 'Adrian Thuo'],
      commonTags: ['mobile', 'android', 'ios'],
      defaultState: ['Doing', 'Done', 'To Do'],
      commonSprints: ['Sprint/2', 'Sprint 4'],
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