//
//  ViewController.h
//  iVoiceReminder
//
//  Created by iStig on 13-4-17.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceListViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "GTMBase64.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "PathHelper.h"

@interface iVoiceController: UIViewController<AVAudioRecorderDelegate,UITextFieldDelegate>
{
  
     NSURL *recordedTmpFile;
     AVAudioRecorder *recorder;
     FMDatabase *dataBase;
     NSString *startTime;
     int s;
   
    
    
    

}
@property(nonatomic,retain)IBOutlet  UIView *popTextFeildView;
@property(nonatomic,retain)IBOutlet  UIView *popTimingView;
@property(nonatomic,retain)IBOutlet  UITextField *note;
@property(nonatomic,retain)IBOutlet  UIDatePicker *datePicker;
@property(nonatomic,retain) NSString *startTime;
@property(nonatomic,retain) AVAudioRecorder *recorder;
@property(nonatomic,retain) NSString *dateSelect;
@property(nonatomic,retain) NSMutableArray *arrayList;

@property(nonatomic,retain) NSDate *dateForCompare;




- (IBAction)showPopTextFeildViewAction:(id)sender;
- (IBAction)showPopTimingViewAction:(id)sender;
- (IBAction)closePopViewAction:(id)sender;

- (IBAction)recordVoice:(id)sender;
- (IBAction)stop:(id)sender;
- (IBAction)popToVoiceList:(id)sender;
- (IBAction)timeSure:(id)sender;

@end
