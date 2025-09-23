import 'package:eventlyapp/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IntroductionScreen(
          key: introKey,
          
          globalHeader: Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.star,
                  color: const Color(0xFF5669FF),
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Evently",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5669FF),
                  ),
                ),
              ],
            ),
          ),

          pages: [
            PageViewModel(
              title: "Personalize Your Experience",
              body: "Choose your preferred themes and get started with a comfortable, tailored experience that suits your style.",
              image: Container(
                height: 320,
                child: Image.asset(
                  AppAssets.onbording1,
                  fit: BoxFit.contain,
                ),
              ),
              decoration: _getPageDecoration(),
              footer: _buildFooter(0),
            ),

            PageViewModel(
              title: "Find Events That Inspire You",
              body: "Dive into a world of events crafted to fit your unique interests. Whether you're into live music, art exhibitions, sports, or workshops, we have something for everyone. Our curated recommendations will help you explore, discover, and connect with exciting opportunity around you.",
              image: Container(
                height: 320,
                child: Image.asset(
                  AppAssets.onbording2,
                  fit: BoxFit.contain,
                ),
              ),
              decoration: _getPageDecoration(),
              footer: _buildFooter(1),
            ),

            PageViewModel(
              title: "Effortless Event Organization", 
              body: "Take the hassle out of organizing events with our all-in-one planning tools. From setting up RSVPs to managing budgets, handling templates and coordinating details, we've got you covered. Plan with ease and focus on what matters most - creating unforgettable experiences for you and your guests.",
              image: Container(
                height: 320,
                child: Image.asset(
                  AppAssets.onbording3,
                  fit: BoxFit.contain,
                ),
              ),
              decoration: _getPageDecoration(),
              footer: _buildFooter(2),
            ),

            PageViewModel(
              title: "Connect with Friends & Share",
              body: "Make every event memorable by sharing the experience with others. Our platform lets you invite friends, keep everyone in the loop, and celebrate moments together. Capture and share your favorite highlights and create lasting memories.",
              image: Container(
                height: 320,
                child: Image.asset(
                  AppAssets.onbording4,
                  fit: BoxFit.contain,
                ),
              ),
              decoration: _getPageDecoration(),
              footer: _buildFooter(3),
            ),
          ],

          showDoneButton: false,
          showSkipButton: false, 
          showNextButton: false,

          onChange: (page) {
            setState(() {
              currentPage = page;
            });
          },

          dotsDecorator: DotsDecorator(
            size: const Size(8.0, 8.0),
            color: Colors.grey.shade300,
            activeSize: const Size(24.0, 8.0),
            activeColor: const Color(0xFF5669FF),
            activeShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
            spacing: const EdgeInsets.symmetric(horizontal: 4.0),
          ),

          globalBackgroundColor: Colors.white,
          curve: Curves.easeInOut,
          controlsMargin: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildFooter(int pageIndex) {
    bool isLastPage = pageIndex == 3;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        children: [
          if (pageIndex == 0)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Language"),
                  const SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.red,
                    ),
                    child: const Center(
                      child: Text(
                        "🇺🇸",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 24,
                    height: 16,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Text(
                        "🇫🇷",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          
          // Bottom navigation row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Skip button (hidden on last page)
              if (!isLastPage)
                TextButton(
                  onPressed: () {
                    // Navigate to main app
                    _completeOnboarding();
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      color: Color(0xFF5669FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              else
                const SizedBox.shrink(),

              // Page indicators
              Row(
                children: List.generate(4, (index) {
                  bool isActive = index <= pageIndex;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF5669FF) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),

              // Next/Let's Start button
              ElevatedButton(
                onPressed: () {
                  if (isLastPage) {
                    _completeOnboarding();
                  } else {
                    introKey.currentState?.next();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5669FF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  isLastPage ? "Let's Start" : "Next",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Complete onboarding navigation
  void _completeOnboarding() {
    print("Onboarding completed!");

  }

  // Page decoration matching your Figma design
  PageDecoration _getPageDecoration() {
    return PageDecoration(
      titleTextStyle: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1F2937),
        height: 1.3,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16.0,
        color: Colors.grey.shade600,
        height: 1.5,
        fontWeight: FontWeight.w400,
      ),
      titlePadding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 12.0),
      bodyPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
      imagePadding: const EdgeInsets.only(top: 20.0, bottom: 16.0),
      pageColor: Colors.white,
      fullScreen: false,
    );
  }
}