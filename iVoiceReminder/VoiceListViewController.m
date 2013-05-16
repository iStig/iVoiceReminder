//
//  VoiceListViewController.m
//  iVoiceReminder
//
//  Created by iStig on 13-4-22.
//  Copyright (c) 2013年 iStig. All rights reserved.
//

#import "VoiceListViewController.h"
#import "AppDelegate.h"

@interface VoiceListViewController ()

@end

@implementation VoiceListViewController
@synthesize arrayList;

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
    
    arrayList=[[NSMutableArray alloc] init];
    
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    [self loadData];
    
}

-(void)loadData{
    
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
                NSString *note=[rs stringForColumn:@"note"];
                VoiceModel *v=[[VoiceModel alloc] init];
                v.VoiceStr=voiceStr;
                v.date=date;
                v.timeInterval=timeInterval;
                v.remindTime=remindTime;
                v.note=note;
                
                [arrayList addObject:v];
                [v release];
                
            }
            [db close];
        }
        
    }
}






#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [arrayList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"VoiceCell";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell==nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VoiceCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    
    VoiceModel *V=(VoiceModel*)[arrayList objectAtIndex:indexPath.row];
    
    UIButton *VoiceBtn=(UIButton*)[cell viewWithTag:1];
    VoiceBtn.showsTouchWhenHighlighted=YES;
    [VoiceBtn addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *date=(UILabel*)[cell viewWithTag:2];
    date.text=V.date;
    
    
    UILabel *remindTime=(UILabel*)[cell viewWithTag:3];
    remindTime.text=V.remindTime;
    
    UILabel *timeInterval=(UILabel*)[cell viewWithTag:4];
    timeInterval.text=[NSString stringWithFormat:@"%d″",V.timeInterval];
    
    
    UILabel *note=(UILabel*)[cell viewWithTag:5];
    note.text=V.note;
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * path = [doc stringByAppendingPathComponent:@"voiceList.sqlite"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
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
        }else{
            
            FMDatabase * db = [FMDatabase databaseWithPath:path];
            VoiceModel *V=(VoiceModel*)[arrayList objectAtIndex:indexPath.row];
            
            if([db open]){
                
                BOOL res =  [db executeUpdate:@"DELETE FROM VoiceList WHERE voice = ?",V.VoiceStr];
                if (!res) {
                    NSLog(@"error to delete data");
                } else {
                    NSLog(@"succ to delete data");
                    [arrayList removeObjectAtIndex:indexPath.row];
                }
                
                [db commit];
            }
            [db close];
            
            
        }
        
        // Delete the row from the data source.
        [VoiceTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [delegate  refreshNotification];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark button operation
-(IBAction)returnToPreView:(id)sender{
    
    [self dismissModalViewControllerAnimated:YES];
}
-(IBAction)canEdit:(id)sender{
    
    
    
}
-(IBAction)playAudio:(id)sender{
    UITableViewCell *cell=(UITableViewCell*)[[sender superview] superview];
    
    VoiceModel *V=(VoiceModel*)[arrayList objectAtIndex:[VoiceTableView indexPathForCell:cell].row];
    
    NSString *s = V.VoiceStr;
    
    
    
    NSData* voiceData=[GTMBase64 decodeString:s];
    //  NSData* voiceData = [s dataUsingEncoding:NSUTF8StringEncoding];
    AVAudioPlayer *audioPlay=   [[AVAudioPlayer alloc]  initWithData:voiceData error:nil];
    
    if (audioPlayer) {//中断当前播放 进行新音频播放
        [audioPlayer stop];
    }
    
    audioPlayer=audioPlay;
    [audioPlayer setDelegate:self];
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    if ([audioPlayer isPlaying]) {
        
        // Stop playing audio and change text of button
        
        [audioPlayer stop];
        //  [sender setTitle:@"Play Audio File"    forState:UIControlStateNormal];
    }    else {
        
        // Start playing audio and change text of button so
        // user can tap to stop playback
        [audioPlayer play];
        
        // [sender setTitle:@"Stop Audio File"  forState:UIControlStateNormal];
        
    }
    
    
    
}

#pragma mark avaudioplayerDelegate
//这个类对应的AVAudioPlayerDelegate有两个委托方法。一个是 audioPlayerDidFinishPlaying:successfully: 当音频播放完成之后触发。当播放完成之后，可以将播放按钮的文本重新回设置成：Play Audio File

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player   successfully:(BOOL)flag  {
    //[audioButton setTitle:@"Play Audio File"   forState:UIControlStateNormal];
    
}

//另一个是audioPlayerEndInterruption:，当程序被应用外部打断之后，重新回到应用程序的时候触发。在这里当回到此应用程序的时候，继续播放音乐。

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player{
    //[audioPlayer play];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    [audioPlayer release];
    [arrayList release];
    [super dealloc];
}

@end
