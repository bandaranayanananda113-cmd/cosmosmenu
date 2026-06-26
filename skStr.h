#import <UIKit/UIKit.h>
#import "skStr.h"
#import "auth.hpp"

// සර්වර් එකට ලස්සනට Compile කරන්න පුළුවන් විදියට සකස් කර ඇති කොටස
void initKeyAuth() {
    std::string name = skCrypt("COSMOSDEMO");
    std::string ownerid = skCrypt("ZUkIqSaHgy");
    std::string secret = skCrypt("b0ffff3c2299551401bdfcf35ea9be8283c0aab612cc0241c5d813e4f0f2a393");
    std::string version = skCrypt("1.0");
    std::string url = skCrypt("https://keyauth.win/api/1.2/");

    KeyAuth::api KeyAuthApp(name, ownerid, secret, version, url);
}

%hook UIViewController

- (void)viewDidLoad {
    %orig;

    initKeyAuth();

    // iOS 13+ වලට ගැළපෙන විදියට keyWindow එක ලබාගැනීම
    UIWindow *keyWindow = nil;
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in scene.windows) {
                    if (window.isKeyWindow) {
                        keyWindow = window;
                        break;
                    }
                }
            }
        }
    } else {
        keyWindow = [UIApplication sharedApplication].keyWindow;
    }

    // Login Button එක නිර්මාණය (වරහන් වැරදි සියල්ල නිවැරදි කර ඇත)
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, 165, 280, 45);
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor blueColor];
    
    if (keyWindow) {
        [keyWindow addSubview:loginButton];
    }
}

%end
