//
//  VoiceModel.h
//  iVoiceReminder
//
//  Created by iStig on 13-4-22.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoiceModel : NSObject{


    NSString *VoiceStr;
    NSString *date;
    int timeInterval;
    NSString *note;
    NSString *remindTime;
    

}

@property(nonatomic,retain)NSString *VoiceStr;
@property(nonatomic,retain)NSString *date;
@property(nonatomic,assign)int timeInterval;
@property(nonatomic,retain)NSString *note;
@property(nonatomic,retain)NSString *remindTime;

@end
