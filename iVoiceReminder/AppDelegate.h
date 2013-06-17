//
//  AppDelegate.h
//  iVoiceReminder
//
//  Created by iStig on 13-4-17.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <ShareSDK/ShareSDK.h>
#import <AVFoundation/AVFoundation.h>

@class iVoiceController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
 AVAudioPlayer *player;


}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) iVoiceController *iVoiceController;
@property (retain, nonatomic) NSMutableArray *arrayList;
@property (nonatomic,retain) NSDate *dateForCompare;
@property (nonatomic,retain) NSString *note;


- (void)resetClock:(NSDate*)date  note:(NSString*)note;
- (void)refreshNotification;
@end
