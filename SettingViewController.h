//
//  SettingViewController.h
//  iVoiceReminder
//
//  Created by iStig on 13-5-15.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMGlowLabel.h"

@interface SettingViewController : UIViewController{
    
    IBOutlet  UIView *headView;
    

}

@property (retain, nonatomic) IBOutlet SMGlowLabel *ledTitle;

-(IBAction)returnToPreView:(id)sender;
@end
