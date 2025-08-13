import 'package:flutter/material.dart';
import 'package:guidey/services/gemini_services.dart';
import 'package:url_launcher/url_launcher.dart'; // إضافة استيراد url_launcher

class RoadmapScreen extends StatefulWidget {
  final String? careerName;
  final String? roadmapData;

  RoadmapScreen({this.careerName, this.roadmapData});

  @override
  _RoadmapScreenState createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  late GeminiService _geminiService;
  String? roadmap;
  bool isLoading = false;
  String? error;
  int completedLevels = 0;
  int totalLevels = 5;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService();

    if (widget.roadmapData == null || widget.roadmapData!.isEmpty) {
      if (widget.careerName != null && widget.careerName!.trim().isNotEmpty) {
        _fetchRoadmap(widget.careerName!.trim());
      }
    } else {
      roadmap = widget.roadmapData;
    }
  }

  void _fetchRoadmap(String careerName) async {
    setState(() {
      isLoading = true;
      error = null;
      roadmap = null;
    });

    try {
      final result = await _geminiService.getCareerRoadmap(careerName);
      setState(() {
        roadmap = result;
        totalLevels = result.split('##').where((s) => s.trim().isNotEmpty).length;
      });
    } catch (e) {
      setState(() {
        error = '❌ فشل في الحصول على الخريطة. حاول مرة أخرى.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _completeLevel() {
    setState(() {
      if (completedLevels < totalLevels) {
        completedLevels++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final trackToShow = widget.careerName ?? 'No track selected';

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Learning Roadmap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.careerName ?? 'Software Engineer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '$completedLevels of $totalLevels completed',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: totalLevels > 0 ? completedLevels / totalLevels : 0.0,
                        backgroundColor: Colors.white24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        toolbarHeight: 120,
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
          ? Center(child: Text(error!))
          : (roadmap == null || roadmap!.isEmpty)
          ? Center(
        child: Text(
          'No roadmap data available for "$trackToShow".',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: _buildRoadmap(roadmap!),
      ),
    );
  }

  Widget _buildRoadmap(String roadmap) {
    if (roadmap.isEmpty || roadmap.contains('Failed')) {
      return Text(roadmap);
    }

    List<String> sections = roadmap.split('##');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sections.asMap().entries.map((entry) {
        int index = entry.key;
        String section = entry.value;
        if (section.trim().isEmpty) return SizedBox.shrink();

        List<String> lines = section.trim().split('\n');
        String level = lines[0].trim().replaceAll('#', '').trim();
        if (level.isEmpty) return SizedBox.shrink();

        bool isCompleted = index < completedLevels;

        return Container(
          margin: EdgeInsets.only(top: 20),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isCompleted ? Icons.check_circle_outline : Icons.circle_outlined,
                      color: isCompleted ? Colors.green : Colors.grey[400],
                      size: 30,
                    ),
                    onPressed: index < completedLevels ? null : _completeLevel,
                    padding: EdgeInsets.all(8),
                    constraints: BoxConstraints(),
                    splashRadius: 24,
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.play_arrow_outlined, color: Colors.green),
                  Text(
                    level,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '4-6 weeks',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ...lines.sublist(1).map((line) {
                if (line.contains('Topics:')) {
                  return Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      'Skills you\'ll learn:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  );
                } else if (line.contains('Resources:')) {
                  return Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      'Learning Resources:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  );
                } else if (line.contains('Projects:')) {
                  return Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 8),
                    child: Text(
                      'Practice Projects:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  );
                } else if (line.trim().isNotEmpty) {
                  bool isResource = lines.any((l) => l.contains('Resources:'));
                  List<String> parts = line.trim().split(' ');
                  String text = parts.sublist(1).join(' ');
                  if (isResource && parts[0].startsWith('http')) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, top: 6),
                      child: InkWell(
                        onTap: () async {
                          final url = parts[0];
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.book,
                              size: 16,
                              color: Color(0xFF3B82F6),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF3B82F6),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Text(
                              'FREE',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (isResource) {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, top: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.book,
                            size: 16,
                            color: Color(0xFF3B82F6),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              line.trim().replaceFirst(RegExp(r'^\d+\.\s*'), ''),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            'FREE',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.only(left: 16, top: 6),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: Color(0xFF3B82F6),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              line.trim().replaceFirst(RegExp(r'^\d+\.\s*'), ''),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }
                return SizedBox.shrink();
              }).toList(),
            ],
          ),
        );
      }).toList(),
    );
  }
}