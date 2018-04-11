//
//  DrivingTestGradeViewController.m
//  驾考易
//
//  Created by 曹修远 on 18/06/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

#import "DrivingTestGradeViewController.h"

#import "DrivingTestViewController.h"
extern NSMutableArray *myUserTestAnswerArray;//用户模考的答案
extern NSMutableArray *myUserPracticeAnswerArray;//用户练习的答案
extern NSMutableArray *myStandarAnswerArray;//标准答案

@interface DrivingTestGradeViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *myGradeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *myRightCount;
@property (weak, nonatomic) IBOutlet UILabel *myWrongCount;
@property (weak, nonatomic) IBOutlet UILabel *myRate;
@property (weak, nonatomic) IBOutlet UILabel *myTimeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *myTimeLabel;

@end

@implementation DrivingTestGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self myDTGradeInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)myDTGradeInit{
    self.navigationItem .title = @"我的成绩";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(myShare)];
    self.navigationItem.rightBarButtonItem =rightBtn;
    
    switch (_myGradeSegmentedControl.selectedSegmentIndex) {
        case 0:{
            NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *documents = [array lastObject];
            NSLog(@"%@",documents);
            NSString *myUserTestAnswerPath = [documents stringByAppendingPathComponent:@"myTestUserAnswer.xml"];
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithContentsOfFile:myUserTestAnswerPath];
            int right = 0;
            int didNotAnswer = 0;
            for (int i = 0; i < [myStandarAnswerArray count]; i++) {
                if (tempArray[i] != 0) {
                    if (tempArray[i] == myStandarAnswerArray[i]) {
                        right += 1;
                    }
                }else{
                    didNotAnswer += 1;
                }
            }
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL result = [fileManager fileExistsAtPath:myUserTestAnswerPath];
            if (result) {
                _myRightCount.text = [NSString stringWithFormat:@"%d",right];
                _myWrongCount.text = [NSString stringWithFormat:@"%lu",[myStandarAnswerArray count] - right -didNotAnswer];
                _myRate.text = [NSString stringWithFormat:@"%d/%lu",right,(unsigned long)[myStandarAnswerArray count]];
            }

            //读取时间
            NSString *myUserTestTimePath = [documents stringByAppendingPathComponent:@"myTestTime.xml"];
            NSArray *tempTimeArray = [NSArray arrayWithContentsOfFile:myUserTestTimePath];
            NSInteger tempInteger = [tempTimeArray[0] integerValue];
            NSString *temp = [self myFormatTime:tempInteger];
            
            
            result = [fileManager fileExistsAtPath:myUserTestTimePath];
            if (result) {
                _myTimeNameLabel.text = @"做题时间";
                _myTimeLabel.text = temp;
            }
            
            break;
        }
        case 1:{
            NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *documents = [array lastObject];
            NSString *myUserPracticeAnswerPath = [documents stringByAppendingPathComponent:@"myPracticeUserAnswer.xml"];
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithContentsOfFile:myUserPracticeAnswerPath];
            int right = 0;
            int didNotAnswer = 0;
            for (int i = 0; i < [myStandarAnswerArray count]; i++) {
                if (tempArray[i] != 0) {
                    if (tempArray[i] == myStandarAnswerArray[i]) {
                        right += 1;
                    }
                }else{
                    didNotAnswer += 1;
                }
            }
            NSFileManager *fileManager = [NSFileManager defaultManager];
            BOOL result = [fileManager fileExistsAtPath:myUserPracticeAnswerPath];
            if (result) {
                _myRightCount.text = [NSString stringWithFormat:@"%d",right];
                _myWrongCount.text = [NSString stringWithFormat:@"%lu",[myStandarAnswerArray count] - right -didNotAnswer];
                _myRate.text = [NSString stringWithFormat:@"%d/%lu",right,(unsigned long)[myStandarAnswerArray count]];

            }
            _myTimeNameLabel.text = @"";
            _myTimeLabel.text = @"";
            break;
        }
        default:
            break;
    }
    
    [_myGradeSegmentedControl addTarget:self action:@selector(myDTGradeInit) forControlEvents:UIControlEventValueChanged];
}
//时间格式化
- (NSString *)myFormatTime:(NSInteger)myUnFormatTime{
    NSInteger m = myUnFormatTime / 60;
    NSInteger s = myUnFormatTime % 60;
    NSString *formatTime = [[NSString alloc] init];
    formatTime = [NSString stringWithFormat:@"%ld:%ld",m,s];
    if (m<10 && s<10) {
        formatTime = [NSString stringWithFormat:@"0%ld:0%ld",m,s];
    }
    else if (m<10){
        formatTime = [NSString stringWithFormat:@"0%ld:%ld",m,s];
    }else if (s<10){
        formatTime = [NSString stringWithFormat:@"%ld:0%ld",m,s];
    }
    else
        formatTime = [NSString stringWithFormat:@"%ld:%ld",m,s];
    
    return formatTime;
}
- (IBAction)myReset:(id)sender {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *documents = [array lastObject];
    NSString *uniquePath=[documents stringByAppendingPathComponent:@"myPracticeUserAnswer.xml"];
    [fileManager removeItemAtPath:uniquePath error:nil];

    documents = [array lastObject];
    uniquePath=[documents stringByAppendingPathComponent:@"myTestUserAnswer.xml"];
    [fileManager removeItemAtPath:uniquePath error:nil];
    
    documents = [array lastObject];
    uniquePath=[documents stringByAppendingPathComponent:@"myTestTime.xml"];
    [fileManager removeItemAtPath:uniquePath error:nil];

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
