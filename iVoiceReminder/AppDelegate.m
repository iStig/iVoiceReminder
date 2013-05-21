//
//  AppDelegate.m
//  iVoiceReminder
//
//  Created by iStig on 13-4-17.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import "AppDelegate.h"

#import "iVoiceController.h"
#import "VoiceModel.h"
#import <ShareSDK/ShareSDK.h>

@implementation AppDelegate
@synthesize arrayList,dateForCompare,note;

- (void)dealloc
{
    [_window release];
    [_iVoiceController release];
    [arrayList release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    
    //sharesdk key
        [ShareSDK registerApp:@"3b4fd481d07"];
    
    
    arrayList=[[NSMutableArray alloc] init];
    dateForCompare=[[NSDate alloc] init];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.iVoiceController = [[[iVoiceController alloc] initWithNibName:@"iVoiceController" bundle:nil] autorelease];
    self.window.rootViewController = self.iVoiceController;
    [self.window makeKeyAndVisible];
    
    [NSThread sleepForTimeInterval:3];//延时3秒进入程序
    
    note=REMINDSTRING;
    [self cleanNotifications];
    [self refreshNotification];

    return YES;
}

- (void)cleanNotifications
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

-(void)refreshNotification{

    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * path = [doc stringByAppendingPathComponent:@"voiceList.sqlite"];
    
    //         [PathHelper documentDirectoryPathWithName:path];
    
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path] == NO) {//不存在就创建
        // create sqlite
        FMDatabase * db = [FMDatabase databaseWithPath:path];
        if ([db open]) {
            
            
            NSString * sql = [NSString stringWithFormat:@"CREATE TABLE 'VoiceList' %@ ",DATAMODEL];
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
                NSLog(@"succ to creating db table");
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }else{//存在则获取数据
        
        FMDatabase * db = [FMDatabase databaseWithPath:path];
        if ([db open]) {
            NSString * sql = @"select * from VoiceList";
            FMResultSet * rs = [db executeQuery:sql];
            while ([rs next]) {
                
                
                NSString *voiceStr=[rs stringForColumn:@"voice"];
                NSString *date=[rs stringForColumn:@"date"];
                int timeInterval=[[rs stringForColumn:@"timeInterval"] intValue];
                NSString *remindTime=[rs stringForColumn:@"remindTime"];
                NSString *notestr=[rs stringForColumn:@"note"];
                VoiceModel *v=[[VoiceModel alloc] init];
                v.VoiceStr=voiceStr;
                v.date=date;
                v.timeInterval=timeInterval;
                v.remindTime=remindTime;
                v.note=notestr;
                
                [arrayList addObject:v];
                [v release];
                
            }
            [db close];
        }
        
    }
              
    [self compareRemindTime];
    

}


//设定localNotification
-(void)compareRemindTime{
    
    
//    for (i = 0; i < count; i++) {
//	    temp = clockDays[i] - weekday;
//		days = (temp >= 0 ? temp : temp + 7);
//		NSDate *newFireDate = [[calendar dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
//		
//		UILocalNotification *newNotification = [[UILocalNotification alloc] init];
//		if (newNotification) {
//			newNotification.fireDate = newFireDate;
//			newNotification.alertBody = clockRemember;
//			newNotification.soundName = [NSString stringWithFormat:@"%@.caf", clockMusic];
//			newNotification.alertAction = @"查看闹钟";
//			newNotification.repeatInterval = NSWeekCalendarUnit;
//			NSDictionary *userInfo = [NSDictionary dictionaryWithObject:clockID forKey:@"ActivityClock"];
//			newNotification.userInfo = userInfo;
//			[[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
//		}
//		NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
//		[newNotification release];
//		
//	}
    
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    for (int i=0; i<[arrayList count]; i++) {
        NSDate *dateNow=[NSDate date];
        VoiceModel *v=[arrayList objectAtIndex:i];
        NSString *remindTimeStr=v.remindTime;
        //NSString *notestr=v.note;
        NSLog(@"%d",i);
        if ([remindTimeStr length]==0) {
            continue;
        }
        else{
            NSDateFormatter *formate = [[NSDateFormatter alloc] init];
            [formate setTimeZone:[NSTimeZone defaultTimeZone]];
            [formate setDateFormat:(@"yyyy-MM-dd HH:mm:ss")];
            NSDate *remindDate = [formate dateFromString:remindTimeStr];
            [formate release];
            if ( [remindDate  isEqualToDate:[remindDate earlierDate:dateNow]]) {
                continue;
            }
            else{
                UILocalNotification *newNotification = [[UILocalNotification alloc] init];
                if (newNotification) {
                    
                    newNotification.fireDate = remindDate;
                    newNotification.timeZone = [NSTimeZone defaultTimeZone];
                    newNotification.alertBody = v.note;
                    newNotification.soundName = @"皮卡丘的短信铃声_铃声之家cnwav.mp3";
                    newNotification.alertAction = @"查看语音提醒";
                    // 下面属性仅在提示框状态时的有效，在横幅时没什么效果
                    newNotification.hasAction = NO;
                    //newNotification.repeatInterval = NSWeekCalendarUnit;
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:v.remindTime forKey:@"ActivityClock"];
                    newNotification.userInfo = userInfo;
                    newNotification.applicationIconBadgeNumber = 1;
                    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
                }
                NSLog(@"Post new localNotification:%@", [newNotification fireDate]);
                [newNotification release];
            }
        }
    }
    
    
   /*
    // 试图取消以前的通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    if (date == nil) {
        return;
    }
        // 设置新的通知
    UILocalNotification* noti = [[[UILocalNotification alloc] init] autorelease];
    // 设置响应时间
    noti.fireDate = date;
    // 设置时区，默认即可
    noti.timeZone = [NSTimeZone defaultTimeZone];
    
    // 重复提醒，这里设置一分钟提醒一次，只有启动应用，才会停止提醒。不设置不激发
    //  noti.repeatInterval = NSMinuteCalendarUnit;
    //noti.repeatInterval=0;
    //  noti.repeatCalendar = nil;
    
    // 提示时的显示信息
    noti.alertBody = notestr;
    // 下面属性仅在提示框状态时的有效，在横幅时没什么效果
    noti.hasAction = NO;
    noti.alertAction = @"关闭";
    
    // 这里可以设置从通知启动的启动界面，类似Default.png的作用。
    //noti.alertLaunchImage = @"lunch.png";
    
    // 提醒时播放的声音
    // 这里用系统默认的声音。也可以自己把声音文件加到工程中来，把文件名设在下面。最后可以播放时间长点，闹钟啊
    noti.soundName = UILocalNotificationDefaultSoundName;
    
    // 这里是桌面上程序右上角的数字图标，设0的话，就没有。类似QQ的未读消息数。
    noti.applicationIconBadgeNumber = 1;

    noti.userInfo = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
    
    // 生效
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];

    */
    
 
    /*
    dateForCompare=nil;
    
    NSDate *dateNow=[NSDate date];
    if ([arrayList count]==0) {
        return;
        
    }else
    {
        
        NSLog(@"%d",[arrayList count]);
        
        for (int i=0; i<[arrayList count]; i++) {
            VoiceModel *v=[arrayList objectAtIndex:i];
            NSString *remindTimeStr=v.remindTime;
            NSString *notestr=v.note;
            
            NSLog(@"%d",i);
            
            if ([remindTimeStr length]==0) {
                
            }
            else{
                NSDateFormatter *formate = [[NSDateFormatter alloc] init];
                [formate setTimeZone:[NSTimeZone defaultTimeZone]];
                [formate setDateFormat:(@"yyyy-MM-dd HH:mm:ss")];
                NSDate *remindDate = [formate dateFromString:remindTimeStr];
                [formate release];
                
                
                
                if ( [remindDate  isEqualToDate:[remindDate earlierDate:dateNow]]) {
                    continue;
                }
                
                if (!dateForCompare) {
                    dateForCompare=remindDate;
                    if ([notestr length]!=0) {
                        note=notestr;
                    }
                
                    
                }else{
                    
                    if (![dateForCompare isEqualToDate:[dateForCompare earlierDate:remindDate]]) {
                        note=notestr;
                        
                    }
                    dateForCompare=[dateForCompare earlierDate:remindDate];
                }
            }
        }
        

        [self resetClock:self.dateForCompare note:note];
        
        
    }
    [arrayList removeAllObjects];
    
     [self resetClock:self.dateForCompare note:note];
    */

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self cleanNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// 应用收到通知时，会调到下面的回调函数里，当应用在启动状态，收到通知时不会自动弹出提示框，而应该由程序手动实现。
// 只有在退出应用后，收到本地通知，系统才会弹出提示。
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (application.applicationState == UIApplicationStateActive) {
        // 如不加上面的判断，点击通知启动应用后会重复提示
        // 这里暂时用简单的提示框代替。
        // 也可以做复杂一些，播放想要的铃声。
        UIAlertView* alert = [[[UIAlertView alloc] initWithTitle:@""
                                                         message:REMINDSTRING
                                                        delegate:self
                                               cancelButtonTitle:@"关闭"
                                               otherButtonTitles:nil, nil] autorelease];
        [alert show];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [self refreshNotification];
    }
}






- (void)resetClock:(NSDate*)date  note:(NSString*)notestr
{
  
    
    
    
    
    
    
    
    /*
     
    // 试图取消以前的通知
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
   // [self saveDate:date];
    
    
    if (date == nil) {
        return;
    }
    
    
// 判断是否是当前时间 之前的提醒时间  如果是 则忽略了
//    NSDate *dateNow=[NSDate date];
//
//    if ( [date  isEqualToDate:[date earlierDate:dateNow]]) {
//        return;
//    }
    
 

    // 设置新的通知
    UILocalNotification* noti = [[[UILocalNotification alloc] init] autorelease];
    // 设置响应时间
    noti.fireDate = date;
    // 设置时区，默认即可
    noti.timeZone = [NSTimeZone defaultTimeZone];
    
    // 重复提醒，这里设置一分钟提醒一次，只有启动应用，才会停止提醒。不设置不激发
  //  noti.repeatInterval = NSMinuteCalendarUnit;
    //noti.repeatInterval=0;
      //  noti.repeatCalendar = nil;
    
    // 提示时的显示信息
    noti.alertBody = notestr;
    // 下面属性仅在提示框状态时的有效，在横幅时没什么效果
    noti.hasAction = NO;
    noti.alertAction = @"关闭";
    
    // 这里可以设置从通知启动的启动界面，类似Default.png的作用。
    //noti.alertLaunchImage = @"lunch.png";
    
    // 提醒时播放的声音
    // 这里用系统默认的声音。也可以自己把声音文件加到工程中来，把文件名设在下面。最后可以播放时间长点，闹钟啊
    noti.soundName = UILocalNotificationDefaultSoundName;
    
    // 这里是桌面上程序右上角的数字图标，设0的话，就没有。类似QQ的未读消息数。
    noti.applicationIconBadgeNumber = 1;
    
    // 这个属性设置了以后，在通过本应用通知启动应用时，在下面回调中
    // - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    // lanuchOptions里面会含有这里的userInfo.
    // 正常点击应用图标进入应用，这个属性就用不到了
    noti.userInfo = [NSDictionary dictionaryWithObject:@"value" forKey:@"key"];
    
    // 生效
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
     
     */
    
    
    
    
    
    
    
}













//- (BOOL)shouldAutorotate {
//    return NO;
//}
//- (NSInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


@end
