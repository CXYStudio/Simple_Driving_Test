//
//  CommunityViewController.m
//  驾考易
//
//  Created by 曹修远 on 18/06/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

#import "CommunityViewController.h"

@interface CommunityViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *myCommunitySegmentedControl;
@property (weak, nonatomic) IBOutlet UIWebView *myCommunityWebView;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self myCommunityWebViewViewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --设置和分享，四个View均要有
- (IBAction)myShare:(id)sender {
    UIGraphicsBeginImageContext(self.view.bounds.size);   //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSLog(@"image:%@",image); //至此已拿到image
    
    //数组中放入分享的内容
    
    NSArray *activityItems = [NSArray arrayWithObject:image];
    
    // 实现服务类型控制器
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
    // 分享类型
    
    
    [activityViewController setCompletionWithItemsHandler:^(NSString * __nullable activityType, BOOL completed, NSArray * __nullable returnedItems, NSError * __nullable activityError){
        
        // 显示选中的分享类型
        
        NSLog(@"当前选择分享平台 %@",activityType);
        
        if (completed) {
            
            NSLog(@"分享成功");
            
        }else {
            
            NSLog(@"分享失败");
            
        }
    }];
    
}

- (IBAction)mySetting:(id)sender {
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *mySettingViewController = [stroyBoard instantiateViewControllerWithIdentifier:@"SettingViewController"];
    [self.navigationController pushViewController:mySettingViewController animated:YES];
    
}
#pragma mark --UIWebView
- (void)myCommunityWebViewViewInit{
    
    switch (_myCommunitySegmentedControl .selectedSegmentIndex) {
        case 0:{
            NSURL *drivingSchoolURL = [[NSURL alloc] initWithString:@"http://m.58.com/cd/jiaxiaopx/?PGTID=0d005a2f-0000-02c0-f504-7b1ad72b8522&ClickID=1"];
            NSURLRequest *drivingSchoolRequest = [[NSURLRequest alloc]initWithURL:drivingSchoolURL];
            [_myCommunityWebView loadRequest:drivingSchoolRequest];
            break;
        }
        case 1:{
            NSURL *messageBoardURL = [[NSURL alloc] initWithString:@"http://club.m.autohome.com.cn"];
            NSURLRequest *messageBoardRequest = [[NSURLRequest alloc]initWithURL:messageBoardURL];
            [_myCommunityWebView loadRequest:messageBoardRequest];
            break;
        }
        default:
            break;
    }
    
    [_myCommunitySegmentedControl addTarget:self action:@selector(myCommunityWebViewViewInit) forControlEvents:UIControlEventValueChanged];
    
    
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
