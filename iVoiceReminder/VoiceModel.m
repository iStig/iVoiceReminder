//
//  VoiceModel.m
//  iVoiceReminder
//
//  Created by iStig on 13-4-22.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import "VoiceModel.h"

@implementation VoiceModel
@synthesize VoiceStr,date,timeInterval,note,remindTime;
- (void)dealloc{
    [date release];
    [VoiceStr release];
    [note release];
    [remindTime release];
   
    [super dealloc];
   
}
@end
