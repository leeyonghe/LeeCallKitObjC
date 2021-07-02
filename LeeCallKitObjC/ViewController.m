//
//  ViewController.m
//  LeeCallKitObjC
//
//  Created by ios-dev on 2021/07/01.
//

#import "ViewController.h"

@interface ViewController ()<UNUserNotificationCenterDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestPushNotificationPermissions];
    // Do any additional setup after loading the view.
}



- (void)requestPushNotificationPermissions {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
        switch (settings.authorizationStatus) {
            case UNAuthorizationStatusNotDetermined: {
                center.delegate = self;
                [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error)
                 {
                    if(granted) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] registerForRemoteNotifications];
                        });
                    } else {
                        
                    }
                }];
                break;
            }
            case UNAuthorizationStatusDenied: {
                break;
            }
            case UNAuthorizationStatusAuthorized: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
                break;
            }
            default:
                break;
        }
    }];
}


@end
