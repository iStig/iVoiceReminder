//
//  VoiceListViewController.h
//  iVoiceReminder
//
//  Created by iStig on 13-4-22.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "VoiceModel.h"
#import "GTMBase64.h"
#import "SMGlowLabel.h"
@interface VoiceListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate>
{

      IBOutlet  UIView *headView;
    
    IBOutlet  UITableView *VoiceTableView;
    
     AVAudioPlayer *audioPlayer;
}

@property(nonatomic,retain)NSMutableArray *arrayList;
@property (retain, nonatomic) IBOutlet SMGlowLabel *ledTitle;
-(IBAction)returnToPreView:(id)sender;
-(IBAction)playAudio:(id)sender;
-(IBAction)canEdit:(id)sender;

@end
