//
//  DrivingTestViewController.m
//  驾考易
//
//  Created by 曹修远 on 18/06/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

#import "DrivingTestViewController.h"
#import "DrivingTestSubTestViewController.h"

NSMutableArray *myStandarAnswerArray;//标准答案
NSMutableArray *myExaminationArray;//题目

@interface DrivingTestViewController ()

@end

@implementation DrivingTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self myInit];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)myInit{
    NSString *myStandarAnswerPath = [[NSBundle mainBundle]pathForResource:@"myExamStandard Answer" ofType:@".xml"];
    myStandarAnswerArray = [NSMutableArray arrayWithContentsOfFile:myStandarAnswerPath];
    
    NSString *myExaminationPath = [[NSBundle mainBundle]pathForResource:@"myExamination" ofType:@".xml"];
    myExaminationArray = [NSMutableArray arrayWithContentsOfFile:myExaminationPath];
    
    
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

#pragma mark --DrivingTest
- (IBAction)myDrivingTestBtn:(id)sender {
    
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"即将进入模考，如果中途退出成绩将丢失，是否继续？" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *myDrivingTestSubTestViewController = [stroyBoard instantiateViewControllerWithIdentifier:@"DrivingTestSubTestView"];
        [self.navigationController pushViewController:myDrivingTestSubTestViewController animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertController addAction:okAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (IBAction)myDrivingPracticeBtn:(id)sender {
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myDrivingTestSubPracticeViewController = [stroyBoard instantiateViewControllerWithIdentifier:@"DrivingTestSubPracticeView"];
    [self.navigationController pushViewController:myDrivingTestSubPracticeViewController animated:YES];
}
- (IBAction)myGradeBtn:(id)sender {
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *myDrivingTestGradeViewController = [stroyBoard instantiateViewControllerWithIdentifier:@"DrivingTestGrade"];
    [self.navigationController pushViewController:myDrivingTestGradeViewController animated:YES];

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
