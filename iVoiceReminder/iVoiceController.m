//
//  ViewController.m
//  iVoiceReminder
//
//  Created by iStig on 13-4-17.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import "iVoiceController.h"
#import "ASDepthModalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "VoiceModel.h"
#import "SettingViewController.h"
@interface iVoiceController ()

@end

@implementation iVoiceController
@synthesize popTextFeildView,popTimingView,startTime,recorder,note,datePicker,dateSelect,arrayList,dateForCompare;

//-(void)viewWillAppear:(BOOL)animated{
//
//    datePicker=[[UIDatePicker alloc]init];
//    note=[[UITextField alloc] init];
//
//}

-(void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
     arrayList=[[NSMutableArray alloc] init];
    dateForCompare=[[NSDate alloc] init];
    
    // 设置popTextFeildView
    self.popTextFeildView.layer.cornerRadius = 4;//圆角弧度
    self.popTextFeildView.layer.borderColor =[UIColor colorWithRed:91.0 green:194.0 blue:127.0 alpha:1.0].CGColor;
    self.popTextFeildView.layer.borderWidth = 2;
   // self.popTextFeildView.layer.shadowOpacity = 0.7;//阴影透明度
  //  self.popTimingView.layer.shadowColor=[UIColor colorWithRed:91.0 green:194.0 blue:127.0 alpha:1.0].CGColor;

    //self.popTextFeildView.layer.shadowOffset = CGSizeMake(6, 6);//阴影尺寸
    self.popTextFeildView.layer.rasterizationScale=[[UIScreen mainScreen] scale];//光栅化 使得背景变暗淡
    
    
    
    // 设置popTimingView
    self.popTimingView.layer.cornerRadius = 4;//圆角弧度
    self.popTimingView.layer.borderColor =[UIColor colorWithRed:91.0 green:194.0 blue:127.0 alpha:1.0].CGColor;
    self.popTimingView.layer.borderWidth = 2;
    
   // self.popTimingView.layer.shadowOpacity = 0.7;//阴影透明度
   // self.popTimingView.layer.shadowOffset = CGSizeMake(6, 6);
    self.popTimingView.layer.rasterizationScale=[[UIScreen mainScreen] scale];
    
   // self.startTime=[[NSString alloc] init];
    
}

#pragma mark -Btn Actions

- (IBAction)showPopTimingViewAction:(id)sender{
    UIColor *color = nil;
    ASDepthModalAnimationStyle style = ASDepthModalAnimationDefault;
    UIImage *image;
    image = [UIImage imageNamed:@"grey_wash_wall.png"];
    color = [UIColor colorWithPatternImage:image];
    //style = ASDepthModalAnimationShrink;
    style = ASDepthModalAnimationShrink;
    [ASDepthModalViewController presentView:self.popTimingView withBackgroundColor:color popupAnimationStyle:style];
}
- (IBAction)showPopTextFeildViewAction:(id)sender{
    [note becomeFirstResponder];
    UIColor *color = nil;
    ASDepthModalAnimationStyle style = ASDepthModalAnimationDefault;
    UIImage *image;
    image = [UIImage imageNamed:@"grey_wash_wall.png"];
    color = [UIColor colorWithPatternImage:image];
    style = ASDepthModalAnimationShrink;
 // style = ASDepthModalAnimationNone;
    [ASDepthModalViewController presentView:self.popTextFeildView withBackgroundColor:color popupAnimationStyle:style];
}
- (IBAction)closePopViewAction:(id)sender{
     [ASDepthModalViewController dismiss];
}


- (IBAction)recordVoice:(id)sender{
    //Begin the recording session.
    //Error handling removed.  Please add to your own code.
    
    //Setup the dictionary object with all the recording settings that this
    //Recording sessoin will use
    //Its not clear to me which of these are required and which are the bare minimum.
    //This is a good resource: http://www.totodotnet.net/tag/avaudiorecorder/
  //设置录制音频参数
    NSMutableDictionary *recordSetting=[[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44110.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt: AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
   
    
    recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@",[NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];

    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
	//Setup the audioSession for playback and record.
	//We could just use record and then switch it to playback leter, but
	//since we are going to do both lets set it up once.
	[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
	//Activate the session
	[audioSession setActive:YES error: nil];
    
 
    
    
    //开始录音时间
    
    [self getCurrentTime];
    recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:nil];
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    //[recorder peakPowerForChannel:0];
    [recorder record];


}

//获取当前录音时间
-(NSString*)getCurrentTime{
    //初始化时间
    startTime=nil;
    s=0;
    
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     self.startTime=[formatter stringFromDate:[NSDate date]];
   
    return startTime;
    
 
}

-(IBAction)stop:(id)sender{

    NSLog(@"stop");
    
    [recorder stop];
       
    recorder =nil;
    
    [[AVAudioSession sharedInstance] setActive: NO error: nil];
    //停止录音时间
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1=[formatter dateFromString:startTime];
    [formatter release];
    NSDate *date2=[NSDate date];
    NSTimeInterval aTimer=[date2 timeIntervalSinceDate:date1];

    
    s=aTimer ;



}

//定时提醒设置
- (IBAction)timeSure:(id)sender{
    
    
    NSLog(@"sure");

     NSDate *localDate=[NSDate date];
    NSDateFormatter *formatter= [[NSDateFormatter alloc] init];
     
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   // datePicker.timeZone=[NSTimeZone systemTimeZone];
    NSDate *dateP=datePicker.date;
    
    
    self.dateSelect=[formatter stringFromDate:dateP];
    //比较所选时间与当前时间判断是否正确
    
   // NSDate *localDate=[NSDate date];
  //  NSDate *date = [NSDate dateWithTimeIntervalSinceNow: +(8*60*60)];

    //NSTimeZone *zone = [NSTimeZone systemTimeZone];
   // NSInteger interval = [zone secondsFromGMTForDate: currentDate];
  //  NSDate *localDate = [currentDate  dateByAddingTimeInterval: interval];
    
    NSDate *comparedate=  [dateP  earlierDate:localDate];
    
    [formatter release];
    
    if ([comparedate isEqualToDate:dateP] ) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请确保所选时间在当前时间之后，如无需定时提醒可点击阴影区域" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    [ASDepthModalViewController dismiss];
    
}

#pragma mark TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    if ([note.text length]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"备注为空，如无需备注可点击阴影区域" delegate:self cancelButtonTitle:@"了解" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
  [ASDepthModalViewController dismiss];
  
    return YES;
}
#pragma mark AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    NSLog(@"AVAudioRecorderDelegate");
    
    if (!flag) {
        [recordedTmpFile release];
        recordedTmpFile=nil;
        return;
    }
    else{
        NSData *vedioDate = [NSData dataWithContentsOfURL:recordedTmpFile];
        NSString *vedioStr= [GTMBase64 stringByEncodingData:vedioDate];
        NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * path = [doc stringByAppendingPathComponent:@"voiceList.sqlite"];
        NSFileManager * fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path] == NO) {//不存在就创建
            // create sqlite
            FMDatabase * db = [FMDatabase databaseWithPath:path];
            if ([db open]) {
                
         
                
                
                NSString * sql =[NSString stringWithFormat:@"CREATE TABLE 'VoiceList' %@ ",DATAMODEL];
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
        }
        
        if ([vedioStr length]>0) {
            //存在则存储录音字符串
            FMDatabase * db = [FMDatabase databaseWithPath:path];  
            if([db open]){
                
                
                NSString *noteStr=nil;
                NSString *remindTimeStr=nil;
                //判断是否设置时间和备注
                if ([note.text length]==0) {
                    noteStr=nil;
                }else{
                    noteStr=note.text;
                }
                if ([dateSelect length]==0) {
                    remindTimeStr=nil;
                }
                else{
                    remindTimeStr=dateSelect;
                }
                
                
                NSString * sql = @"insert into VoiceList (voice,date,timeInterval,note,remindTime) values(?,?,?,?,?) ";
                BOOL res = [db executeUpdate:sql,vedioStr,startTime,[NSNumber numberWithInt:s],noteStr,remindTimeStr];
                
                if (!res) {
                    NSLog(@"error to insert data");
                } else {
                    NSLog(@"succ to insert data");
                    
                    dateSelect=nil;
                    note.text=nil;
                    
                    
                    
                    //获取sqlite数据库数据
                    NSString * sql = @"select * from VoiceList";
                    FMResultSet * rs = [db executeQuery:sql];
                    while ([rs next]) {
                        
                        
                        NSString *voiceStr=[rs stringForColumn:@"voice"];
                        NSString *date=[rs stringForColumn:@"date"];
                        int timeInterval=[[rs stringForColumn:@"timeInterval"] intValue];
                        NSString *remindTime=[rs stringForColumn:@"remindTime"];
                        NSString *noteStr=[rs stringForColumn:@"note"];
                        VoiceModel *v=[[VoiceModel alloc] init];
                        v.VoiceStr=voiceStr;
                        v.date=date;
                        v.timeInterval=timeInterval;
                        v.remindTime=remindTime;
                        v.note=noteStr;
                        [arrayList addObject:v];
                        [v release];
                    }
                    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                        [delegate  refreshNotification];
                    
              //  [self compareRemindTime];
                }
                
                [db commit];
            }
            [db close];
            
        }
            
    }
 
}

//UIModalTransitionStyleCoverVertical = 0,
//UIModalTransitionStyleFlipHorizontal,
//UIModalTransitionStyleCrossDissolve,
//UIModalTransitionStylePartialCurl,

- (IBAction)popToVoiceList:(id)sender{

    VoiceListViewController *V=[[VoiceListViewController alloc] initWithNibName:@"VoiceListViewController" bundle:nil];
      
    V.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:V animated:YES];
    [V release];


}


- (IBAction)popToSettingList:(id)sender{
    
    SettingViewController *V=[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    
    V.modalTransitionStyle=UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:V animated:YES];
    [V release];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////设定localNotification
//-(void)compareRemindTime{
//   
//      dateForCompare=nil;
//    
//     NSDate *dateNow=[NSDate date];
//    if ([arrayList count]==0) {
//        return;
//        
//    }else
//    {
//        
//        NSLog(@"%d",[arrayList count]);
//        
//        for (int i=0; i<[arrayList count]; i++) {
//            VoiceModel *v=[arrayList objectAtIndex:i];
//            NSString *remindTimeStr=v.remindTime;
//            
//            NSLog(@"%d",i);
//            
//            if ([remindTimeStr length]==0) {
//                
//            }
//            else{
//                NSDateFormatter *formate = [[NSDateFormatter alloc] init];
//                [formate setTimeZone:[NSTimeZone defaultTimeZone]];
//                [formate setDateFormat:(@"yyyy-MM-dd HH:mm:ss")];
//                NSDate *remindDate = [formate dateFromString:remindTimeStr];
//                [formate release];
//        
//               
//                
//                if ( [remindDate  isEqualToDate:[remindDate earlierDate:dateNow]]) {
//                    continue;
//                }
//                
//                if (!dateForCompare) {
//                    dateForCompare=remindDate;
//                }else{
//                    dateForCompare=[dateForCompare earlierDate:remindDate];
//                }
//            }
//        }
//        
//        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//        [delegate resetClock:self.dateForCompare];
//   
//        
//    }
//     [arrayList removeAllObjects];
//}

-(void)dealloc{
    [startTime release];
    [recorder release];
    [popTextFeildView release];
    [popTimingView release];
    [note release];
    [datePicker release];
    [dateSelect release];
    [arrayList release];
    [dateForCompare release];
    [super dealloc];
}
@end
