//
//  SettingViewController.m
//  驾考易
//
//  Created by 曹修远 on 18/06/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

#import "SettingViewController.h"
#import <MessageUI/MessageUI.h>
@interface SettingViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)myMail:(id)sender {
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"反馈"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"caocaodajiang@163.com"];
    
    
    [picker setToRecipients:toRecipients];
    
    // Attach an image to the email
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"" ofType:@"png"];
//    NSData *myData = [NSData dataWithContentsOfFile:path];
//    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@""];
    
    
    
    [self presentModalViewController:picker animated:YES];
    
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    
    [self dismissModalViewControllerAnimated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
