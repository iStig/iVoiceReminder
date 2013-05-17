//
//  SettingViewController.m
//  iVoiceReminder
//
//  Created by iStig on 13-5-15.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize ledTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self ledText];
    
}


-(void)ledText{


   // [ledTitle setText:[NSString stringWithFormat:@"%i", 0]];
    ledTitle.glowColor = [UIColor colorWithRed:(62.0/255.0) green:(136.0/255.0) blue:(255.0/255.0) alpha:0.75f];
	ledTitle.glowOffset = CGSizeMake(0.0f, 5.0f);
	ledTitle.glowRadius = 30.0f;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark button operation
-(IBAction)returnToPreView:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"VoiceCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoiceCell" owner:nil options:nil] objectAtIndex:1];
    }
    
//    
//    VoiceModel *V=(VoiceModel*)[arrayList objectAtIndex:indexPath.row];
//    
//    UIButton *VoiceBtn=(UIButton*)[cell viewWithTag:1];
//    VoiceBtn.showsTouchWhenHighlighted=YES;
//    [VoiceBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *date=(UILabel*)[cell viewWithTag:2];
//    date.text=V.date;
//    
//    
//    UILabel *remindTime=(UILabel*)[cell viewWithTag:3];
//    remindTime.text=V.remindTime;
//    
//    UILabel *timeInterval=(UILabel*)[cell viewWithTag:4];
//    timeInterval.text=[NSString stringWithFormat:@"%d″",V.timeInterval];
//    
//    
//    UILabel *note=(UILabel*)[cell viewWithTag:5];
//    note.text=V.note;
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



@end
