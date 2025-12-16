import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotify/common/helpers/is_dark.dart';
import 'package:spotify/common/widgets/appbar/app_bar.dart';
import 'package:spotify/core/configs/assets/app_images.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/core/configs/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/presentation/pages/home/widgets/new_songs.dart';
import 'package:spotify/presentation/pages/home/widgets/play_list.dart';
import 'package:spotify/presentation/pages/profile/profile.dart';
import 'package:spotify/features/ai_dj/presentation/cubit/ai_dj_cubit.dart';
import 'package:spotify/features/ai_dj/presentation/cubit/ai_dj_state.dart';
import 'package:spotify/features/snap_to_song/data/datasources/ml_service.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hidebackbtn: true,
        action: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProfilePage()));
        },icon: const Icon(Icons.person),),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 40,
          width: 40,
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            _homeArtistcard(),
            const SizedBox(
              height: 25,
            ),
            _tabs(),
            const SizedBox(
              height: 25,
            ),
            SizedBox(
              height: 260,
              child: TabBarView(
                controller: tabController,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: NewSongs(),
                  ),
                  Container(),
                  Container(),
                  Container(),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const PlayList(),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () => _showImageSourceDialog(context),
            heroTag: "cam_btn",
            backgroundColor: Colors.white,
            child: const Icon(Icons.camera_alt, color: Colors.black),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () => _showAiDjDialog(context),
            heroTag: "sparkle_btn",
            backgroundColor: const Color(0xFFCCFF00),
            child: const Icon(Icons.auto_awesome, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0xFFCCFF00), width: 2)),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFCCFF00)),
                title: const Text("Take Photo", style: TextStyle(color: Colors.white)),
                onTap: () => _handleImageResult(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFCCFF00)),
                title: const Text("Pick from Gallery", style: TextStyle(color: Colors.white)),
                onTap: () => _handleImageResult(context, ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleImageResult(BuildContext context, ImageSource source) async {
    Navigator.pop(context); // Close sheet
    try {
      final labels = await ImageLabelingService().pickAndAnalyzeImage(source);
      if (labels.isNotEmpty) {
        final String visualMood = "I see: ${labels.join(', ')}";
        if (context.mounted) {
          _showAiDjDialog(context, initialMood: visualMood, mlLabels: labels);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not identify anything! Try again.")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: Snap-to-Song only works on Mobile! ($e)")),
        );
      }
    }
  }

  void _showAiDjDialog(BuildContext context, {String? initialMood, List<String>? mlLabels}) {
    final TextEditingController moodController = TextEditingController(text: initialMood);
    // In a real app, use a secure API key or env variable
    // For this demo, we'll use a placeholder or ask the user
    const String apiKey = "AIzaSyAPX41_xSvld5zIHHf9XgNhnbIhZxTjEWo"; 

    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider(
          create: (_) => AiDjCubit(apiKey: apiKey),
          child: Builder(
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.black,
                shape: Border.all(color: const Color(0xFFCCFF00), width: 2),
                title: const Text(
                  "AI DJ 💿",
                  style: TextStyle(color: Color(0xFFCCFF00), fontFamily: 'monospace'),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "What's the vibe?",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: moodController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "e.g., Sad, Party, Study",
                        hintStyle: TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFCCFF00)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<AiDjCubit, AiDjState>(
                      builder: (context, state) {
                        if (state is AiDjLoading) {
                          return const CircularProgressIndicator(color: Color(0xFFCCFF00));
                        }
                        if (state is AiDjError) {
                          return Text(
                            "Error: ${state.message}",
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        if (state is AiDjLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: state.songs.map((song) => Text(
                              "🎵 $song",
                              style: const TextStyle(color: Colors.white),
                            )).toList(),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close", style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () async {
                      // Fetch available songs (Simplified for demo - fetching all titles)
                      // Ideally inject a repository to get these
                      final songs = [
                         "Digital Dreams", 
                         "Neon Nights", 
                         "Glitch Horizon", 
                         "Synthwave Sunrise", 
                         "Terminal Velocity",
                         "Happier Than Ever" // Adding the legacy one too
                      ];
                      
                      context.read<AiDjCubit>().getRecommendations(
                        moodController.text, 
                        songs,
                        detectedLabels: mlLabels
                      );
                    },
                    child: const Text(
                      "Mix It",
                      style: TextStyle(color: Color(0xFFCCFF00), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _homeArtistcard() {
    return Center(
      child: SizedBox(
        child: SizedBox(
          height: 170,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: SvgPicture.asset(AppVectors.frame),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 60.0),
                  child: Image.asset(
                    AppImages.billieHome,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    return TabBar(
        controller: tabController,
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        indicatorColor: AppColors.primary,
        dividerColor: Colors.transparent,
        labelColor: context.isDarkMode ? Colors.white : Colors.black,
        tabs: const [
          Text('New',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          Text('English',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          Text('Bollywood',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          Text('Bengali',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
        ]);
  }
}
