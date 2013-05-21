//
//  SettingViewController.h
//  iVoiceReminder
//
//  Created by iStig on 13-5-15.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMGlowLabel.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <ShareSDK/ShareSDK.h>

@interface SettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MFMailComposeViewControllerDelegate>{
    
    IBOutlet  UIView *headView;
    IBOutlet UITableView *settingTableView;
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UIButton *appCommentBtn;
    IBOutlet UIButton *feedbackBtn;
    

}

@property (retain, nonatomic) IBOutlet SMGlowLabel *ledTitle;

-(IBAction)returnToPreView:(id)sender;
-(IBAction)feedback:(id)sender;
-(IBAction)appComment:(id)sender;
-(IBAction)weiboAction:(id)sender;
@end
