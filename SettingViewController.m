//
//  SettingViewController.m
//  iVoiceReminder
//
//  Created by iStig on 13-5-15.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import "SettingViewController.h"
//#import "ThanksViewController.h"
//#import "AboutViewController.h"

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
    
  //  [self ledText];
    
  //  mainScrollView.contentOffset=CGPointMake(0, 0);
    mainScrollView.contentSize=CGSizeMake(320, 492);

    
}
-(IBAction)feedback:(id)sender{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass !=nil) {
        if ([mailClass canSendMail]) {
            [self displayMailComposerSheet];
        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"设备不支持邮件功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }else{
        
    }
}

-(void)displayMailComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    
    picker.mailComposeDelegate =self;
    [picker setSubject:@"应用意见反馈"];
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"istigapp@gmail.com"];
   // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@qq.com",@"third@qq.com", nil];
  //  NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@qq.com"];
    
    [picker setToRecipients:toRecipients];
   // [picker setCcRecipients:ccRecipients];
   // [picker setBccRecipients:bccRecipients];
    //发送图片附件
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    //[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy.jpg"];
    //发送txt文本附件
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"MyText" ofType:@"txt"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    //[picker addAttachmentData:myData mimeType:@"text/txt" fileName:@"MyText.txt"];
    //发送doc文本附件
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"MyText" ofType:@"doc"];
    //NSData *myData = [NSData dataWithContentsOfFile:path];
    //[picker addAttachmentData:myData mimeType:@"text/doc" fileName:@"MyText.doc"];
    //发送pdf文档附件
    /*
     NSString *path = [[NSBundlemainBundle] pathForResource:@"CodeSigningGuide"ofType:@"pdf"];
     NSData *myData = [NSDatadataWithContentsOfFile:path];
     [pickeraddAttachmentData:myData mimeType:@"file/pdf"fileName:@"rainy.pdf"];
     */
    // Fill out the email body text
    NSString *emailBody =@"意见反馈：" ;
    [picker setMessageBody:emailBody isHTML:NO];
    [self presentModalViewController:picker animated:YES];
    [picker release];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    switch (result)
    {
        caseMFMailComposeResultCancelled:
            NSLog(@"Result: Mail sending canceled");
            break;
        caseMFMailComposeResultSaved:
            NSLog(@"Result: Mail saved");
            break;
        caseMFMailComposeResultSent:
            NSLog(@"Result: Mail sent");
            break;
        caseMFMailComposeResultFailed:
            NSLog(@"Result: Mail sending failed");
            break;
        default:
            NSLog(@"Result: Mail not sent");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)appComment:(id)sender{}

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

//#pragma mark TableViewDelegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 4;
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *CellIdentifier = @"VoiceCell";
//    
//    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if(cell==nil)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoiceCell" owner:nil options:nil] objectAtIndex:1];
//    }
//    
//    UILabel *title=(UILabel*)[cell viewWithTag:2];
//    
//    if (indexPath.row==0) {
//        title.text=@"鸣   谢";
//    }
//    if (indexPath.row ==1) {
//        title.text=@"意见反馈";
//    }
//    if (indexPath.row==3) {
//       title.text=@"关于应用使用";
//    }
//    if (indexPath.row==2) {
//        title.text=@"社交分享";
//    }
////    
////    VoiceModel *V=(VoiceModel*)[arrayList objectAtIndex:indexPath.row];
////    
////    UIButton *VoiceBtn=(UIButton*)[cell viewWithTag:1];
////    VoiceBtn.showsTouchWhenHighlighted=YES;
////    [VoiceBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
////    
////    UILabel *date=(UILabel*)[cell viewWithTag:2];
////    date.text=V.date;
////    
////    
////    UILabel *remindTime=(UILabel*)[cell viewWithTag:3];
////    remindTime.text=V.remindTime;
////    
////    UILabel *timeInterval=(UILabel*)[cell viewWithTag:4];
////    timeInterval.text=[NSString stringWithFormat:@"%d″",V.timeInterval];
////    
////    
////    UILabel *note=(UILabel*)[cell viewWithTag:5];
////    note.text=V.note;
//    
//    
//    return cell;
//    
//    
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.row==0) {
//        
//    }
//    if (indexPath.row==1) {
//        
//    }
//    if (indexPath.row==2) {
//        
//    }
//    if (indexPath.row==3) {
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//}



@end
