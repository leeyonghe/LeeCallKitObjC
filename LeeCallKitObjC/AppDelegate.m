//
//  AppDelegate.m
//  LeeCallKitObjC
//
//  Created by ios-dev on 2021/07/01.
//

#import "AppDelegate.h"
#import <CallKit/CallKit.h>
#import <PushKit/PushKit.h>

@interface AppDelegate ()<PKPushRegistryDelegate, CXProviderDelegate>{
    CXProvider *provider;
}
    
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self voipRegistration];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {

}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
}

- (void) voipRegistration{
    
    PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue: dispatch_get_main_queue()];
    voipRegistry.delegate = self;
    voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
    
    CXProviderConfiguration *configuration = [[CXProviderConfiguration alloc] init];
    configuration.includesCallsInRecents = NO;
    configuration.supportsVideo = YES;
    configuration.supportedHandleTypes = [[NSSet alloc] initWithObjects:[NSNumber numberWithInt:(int)CXHandleTypePhoneNumber], nil];
//    configuration.maximumCallGroups = 1;
//    configuration.maximumCallsPerCallGroup = 5;
    provider = [[CXProvider alloc] initWithConfiguration:configuration];
    [provider setDelegate:self queue:dispatch_get_main_queue()];
    
}

- (void)pushRegistry:(nonnull PKPushRegistry *)registry didUpdatePushCredentials:(nonnull PKPushCredentials *)pushCredentials forType:(nonnull PKPushType)type {
    
}

- (void)providerDidReset:(nonnull CXProvider *)provider {

}

- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void (^)(void))completion{
    
    [self CallView];
    
}

- (void)CallView{
    CXCallUpdate *update = [[CXCallUpdate alloc] init];
    update.remoteHandle = [[CXHandle alloc]initWithType:CXHandleTypePhoneNumber value:@"010-1111-2222"];
//    update.hasVideo = true;
    update.supportsHolding = YES;
    NSUUID * uuid = [NSUUID UUID];
    [provider reportNewIncomingCallWithUUID:uuid update:update completion:^(NSError * _Nullable error) { NSLog(@"reportNewIncomingCall error : %@" , error); }];
}

@end
