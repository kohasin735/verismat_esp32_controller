import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../backend/api_requests/api_calls.dart';
import '../../backend/schema/project_data.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'project_selection_model.dart';

class ProjectSelectionWidget extends StatefulWidget {
  const ProjectSelectionWidget({super.key});

  static const String routeName = '/project_selection';

  @override
  State<ProjectSelectionWidget> createState() => _ProjectSelectionWidgetState();
}

class _ProjectSelectionWidgetState extends State<ProjectSelectionWidget> {
  late ProjectSelectionModel _model;

  @override
  void initState() {
    super.initState();
    _model = ProjectSelectionModel();
    _model.initState(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _selectProject(ProjectItem projectItem) async {
    if (_model.isSelecting) return;

    final appState = Provider.of<FFAppState>(context, listen: false);
    final gradeNumber = appState.selectedGrade;
    final projectNumber = projectItem.project; // 1-based: 1 to 6

    setState(() {
      _model.isSelecting = true;
      _model.selectingProjectIndex = projectNumber;
    });

    try {
      // POST http://192.168.4.1/api/select
      // Body: {"grade": grade, "project": project}
      final response = await ESP32SelectCall.call(
        grade: gradeNumber,
        project: projectNumber,
      );

      final isOk = response.succeeded && ESP32SelectCall.ok(response.jsonBody) == true;

      if (!mounted) return;

      if (isOk) {
        // Update AppState
        appState.selectedProject = projectNumber;
        appState.selectedProjectName = projectItem.name;
        appState.currentGrade = gradeNumber;
        appState.currentProject = projectNumber;
        appState.currentProjectName = projectItem.name;
        appState.esp32Connected = true;

        // Navigate to Project Control Screen
        Navigator.of(context).pushNamed('/project_control');
      } else {
        _showSelectionFailedDialog();
      }
    } catch (_) {
      if (mounted) {
        _showSelectionFailedDialog();
      }
    } finally {
      if (mounted) {
        setState(() {
          _model.isSelecting = false;
          _model.selectingProjectIndex = null;
        });
      }
    }
  }

  void _showSelectionFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: Color(0xFFEF4444), width: 1.2),
        ),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Color(0xFFEF4444), size: 24.0),
            SizedBox(width: 10.0),
            Text(
              'Selection Failed',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        content: const Text(
          'The ESP32 could not receive the project selection.\n\nPlease ensure your Android device is connected to VeriSmat-ESP32 and the board is powered on.',
          style: TextStyle(
            color: Color(0xFFCBD5E1),
            fontSize: 14.0,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF38BDF8),
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final appState = Provider.of<FFAppState>(context);
    final gradeNumber = appState.selectedGrade == 0 ? 1 : appState.selectedGrade;
    final projects = ProjectCatalog.getProjectsForGrade(gradeNumber);

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.secondaryBackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.primaryText, size: 20.0),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Grade $gradeNumber Projects',
          style: theme.title2.override(fontSize: 20.0),
        ),
        centerTitle: true,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: theme.cardBorder,
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              color: theme.secondaryBackground.withOpacity(0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: theme.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          'GRADE $gradeNumber',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: theme.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        'Select a project to upload',
                        style: theme.bodyText2,
                      ),
                    ],
                  ),
                  Text(
                    '192.168.4.1',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: theme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20.0),
                itemCount: projects.length,
                separatorBuilder: (context, index) => const SizedBox(height: 14.0),
                itemBuilder: (context, index) {
                  final projectItem = projects[index];
                  final isCurrentSelected = _model.selectingProjectIndex == projectItem.project;
                  return _buildProjectCard(context, projectItem, theme, isCurrentSelected);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectCard(
    BuildContext context,
    ProjectItem projectItem,
    FlutterFlowTheme theme,
    bool isLoading,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _model.isSelecting ? null : () => _selectProject(projectItem),
        borderRadius: BorderRadius.circular(18.0),
        splashColor: projectItem.themeColor.withOpacity(0.2),
        child: Ink(
          decoration: BoxDecoration(
            color: theme.secondaryBackground,
            borderRadius: BorderRadius.circular(18.0),
            border: Border.all(
              color: isLoading ? theme.primary : theme.cardBorder,
              width: isLoading ? 1.8 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10.0,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Project Number Badge
                    Container(
                      width: 44.0,
                      height: 44.0,
                      decoration: BoxDecoration(
                        color: projectItem.themeColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(
                          color: projectItem.themeColor.withOpacity(0.4),
                          width: 1.0,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          projectItem.icon,
                          color: projectItem.themeColor,
                          size: 22.0,
                        ),
                      ),
                    ),

                    const SizedBox(width: 14.0),

                    // Title and number
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'PROJECT ${projectItem.project}',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                  color: projectItem.themeColor,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2.0),
                          Text(
                            projectItem.name,
                            style: theme.title3.override(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Loading or chevron
                    if (isLoading)
                      const SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                        decoration: BoxDecoration(
                          color: theme.primaryBackground,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'SELECT',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: theme.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            Icon(Icons.arrow_forward, size: 13.0, color: theme.primary),
                          ],
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 12.0),

                // Description
                Text(
                  projectItem.description,
                  style: theme.bodyText2.override(
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),

                const SizedBox(height: 12.0),

                // Components tags
                Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: projectItem.components.map((c) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                      decoration: BoxDecoration(
                        color: theme.primaryBackground,
                        borderRadius: BorderRadius.circular(6.0),
                        border: Border.all(color: theme.cardBorder),
                      ),
                      child: Text(
                        c,
                        style: const TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
