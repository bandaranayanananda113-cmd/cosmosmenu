#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <string>

// KeyAuth C++ SDK library එක සහ skCrypt header එක ඔයාගේ project එකේ තිබිය යුතුය
#include "auth.hpp" 
#include "skStr.h"

// ---- ඔයාගේ සැබෑ KEYAUTH CREDENTIALS (image_2.png එකට අනුව) ----
std::string name = skCrypt("COSMOSDEMO").decrypt();
std::string ownerid = skCrypt("ZUkiQ5aVgy").decrypt();
std::string secret = skCrypt("b0ffff3c2299551401bdfcf35ea9be8283c0aab612cc0241c5d813e4f0f2a393").decrypt(); // මේක ඔයාගේ ඇත්තම secret එක විය යුතුය
std::string version = skCrypt("1.0").decrypt();
std::string url = skCrypt("https://keyauth.win/api/1.3/").decrypt(); // API 1.3 එක
std::string path = skCrypt("").decrypt();

// KeyAuth Object එක නිර්මාණය කිරීම
KeyAuth::api KeyAuthApp(name, ownerid, secret, version, url, path);

// UI Elements සඳහා Variables
UIView *menuView;
UITextField *keyTextField;

// Login Button එක එබූ විට ක්‍රියාත්මක වන කොටස
void onLoginPressed() {
    NSString *enteredKey = keyTextField.text;

    if (enteredKey.length == 0) {
        exit(0); // මුකුත් නොගහ Login එබුවොත් Close කරයි
    }

    // NSString එක C++ string එකකට හරවා ගැනීම
    std::string cppKey = [enteredKey UTF8String];

    // ---- KeyAuth Verification ----
    KeyAuthApp.license(cppKey);

    if (KeyAuthApp.response.success) {
        NSLog(@"[KeyAuth] Access Granted! Welcome to cosmosdemo.");
        
        // Key එක හරි නම් Menu එක Screen එකෙන් අයින් කරලා ඇප් එකට යන්න දෙනවා
        [UIView animateWithDuration:0.3 animations:^{
            menuView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [menuView removeFromSuperview];
        }];
    } else {
        NSLog(@"[KeyAuth] Access Denied!");
        // Key එක වැරදි නම් ඇප් එක වසා දමයි
        exit(0); 
    }
}

// Custom Menu එක screen එකට දාන function එක
void showCosmosMenu() {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            showCosmosMenu();
        });
        return;
    }

    // 1. Background Blur/Dim View
    menuView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    menuView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    // 2. මැද තියෙන ප්‍රධාන Menu Box එක
    UIView *alertBox = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 250)];
    alertBox.center = menuView.center;
    alertBox.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.14 alpha:1.0]; 
    alertBox.layer.cornerRadius = 15;
    alertBox.layer.masksToBounds = YES;
    alertBox.layer.borderWidth = 1.5;
    alertBox.layer.borderColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.81 alpha:1.0].CGColor;
    [menuView addSubview:alertBox];

    // 3. Menu Title එක -> "cosmosdemo"
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 300, 30)];
    titleLabel.text = @"cosmosdemo";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertBox addSubview:titleLabel];

    // 4. Input Box Placeholder Text -> "Paste your key"
    keyTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 85, 260, 45)];
    keyTextField.placeholder = @"Paste your key";
    keyTextField.backgroundColor = [UIColor colorWithRed:0.18 green:0.18 blue:0.20 alpha:1.0];
    keyTextField.textColor = [UIColor whiteColor];
    keyTextField.font = [UIFont systemFontOfSize:15];
    keyTextField.borderStyle = UITextBorderStyleRoundedRect;
    keyTextField.textAlignment = NSTextAlignmentCenter;
    keyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Paste your key" attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [alertBox addSubview:keyTextField];

    // 5. Login Button එක
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(20, 165, 260, 45)];
    loginButton.backgroundColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.81 alpha:1.0]; 
    [loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    loginButton.layer.cornerRadius = 10;
    
    UIAction *buttonAction = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        onLoginPressed();
    }];
    [loginButton addAction:buttonAction forControlEvents:UIControlEventTouchUpInside];
    [alertBox addSubview:loginButton];

    [keyWindow addSubview:menuView];
    
    menuView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        menuView.alpha = 1.0;
    }];
}

// Tweak/Dylib එක load වූ සැනින් ක්‍රියාත්මක වන කොටස
static __attribute__((constructor)) void initialize() {
    // KeyAuth API එක Initialize කිරීම
    KeyAuthApp.init();

    // UI එක සූදානම් වන තෙක් තත්පර 1ක් රැඳී සිට Menu එක පෙන්වයි
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        showCosmosMenu();
    });
}