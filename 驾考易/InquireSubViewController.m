//
//  InquireSubViewController.m
//  驾考易
//
//  Created by 曹修远 on 18/06/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

#import "InquireSubViewController.h"
#import "InquireViewController.h"
extern int myInquireSelectedNum;
extern NSMutableArray *myInquireDataArray;
extern BOOL shouldDisplayImage;
@interface InquireSubViewController ()
@property (weak, nonatomic) IBOutlet UITextView *myInquireSubViewTextView;
@property (weak, nonatomic) IBOutlet UIImageView *myInquireSubViewImageView;

@end

@implementation InquireSubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%d",(unsigned)myInquireSelectedNum);
    [self myInquireSubViewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)myInquireSubViewInit{
    _myInquireSubViewTextView.text = myInquireDataArray[myInquireSelectedNum];
    if (shouldDisplayImage) {
        int temp = myInquireSelectedNum + 1;
        NSString *path = [NSString stringWithFormat:@"%d",temp];
        NSString *ImgString = [[NSBundle mainBundle]pathForResource:path ofType:@".png"];
        _myInquireSubViewImageView.image = [UIImage imageNamed:ImgString];
    }
    self.navigationItem .title = @"查询";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(myShare)];
    self.navigationItem.rightBarButtonItem =rightBtn;
    
}
- (void)myShare{
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
