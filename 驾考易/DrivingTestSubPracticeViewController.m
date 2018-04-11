//
//  DrivingTestSubPracticeViewController.m
//  驾考易
//
//  Created by 曹修远 on 18/06/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

#import "DrivingTestSubPracticeViewController.h"

#import "DrivingTestViewController.h"

extern NSMutableArray *myStandarAnswerArray;//标准答案
extern NSMutableArray *myExaminationArray;//题目

@interface DrivingTestSubPracticeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myRightOrWrongLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myRightOrWrongImage;
@property (weak, nonatomic) IBOutlet UITextView *myExaminationLabel;
@property (nonatomic,assign) int myindex;
@property (weak, nonatomic) IBOutlet UILabel *myStandarAnswerLabel;
@property (nonatomic,retain) NSMutableArray *myUserPracticeAnswerArray;//用户练习的答案
@end

@implementation DrivingTestSubPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myindex = 0;
    // Do any additional setup after loading the view.
    [self myDTPracticeInit];
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
-(void)myDTPracticeInit{
    self.navigationItem .title = @"练习";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(myShare)];
    self.navigationItem.rightBarButtonItem =rightBtn;
    
    _myRightOrWrongLabel.text = @"";
    _myStandarAnswerLabel.text = @"";
    _myExaminationLabel.text = myExaminationArray[_myindex];
    _myUserPracticeAnswerArray = [[NSMutableArray alloc]init];
}
- (IBAction)myViewAnswerBtn:(id)sender {
    _myStandarAnswerLabel.text = myStandarAnswerArray[_myindex];
//    _myRightOrWrongImage.image = nil;
//    _myRightOrWrongLabel.text = @"";
}
- (IBAction)myNext:(id)sender {
    _myStandarAnswerLabel.text = @"";
    _myindex += 1;
    
    if ([_myUserPracticeAnswerArray count] < _myindex) {
        _myUserPracticeAnswerArray[_myindex-1] = @"0";
    }
    if (_myindex < [myStandarAnswerArray count]) {
        _myExaminationLabel.text = myExaminationArray[_myindex];
        _myRightOrWrongLabel.text = @"";
        _myRightOrWrongImage.image = nil;
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你已经做完题目，点击按钮返回。" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"返回");
            
            [self mySaveXML];
        }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
}

- (void)mySaveXML{
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documents = [array lastObject];
    NSString *myUserPracticeAnswerPath = [documents stringByAppendingPathComponent:@"myPracticeUserAnswer.xml"];
    [_myUserPracticeAnswerArray writeToFile:myUserPracticeAnswerPath atomically:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)myA:(id)sender {
    [_myUserPracticeAnswerArray addObject:@"A"];
    [self myUserAnswerJudge:@"A"];
    
}
- (IBAction)myB:(id)sender {
    [_myUserPracticeAnswerArray addObject:@"B"];
    [self myUserAnswerJudge:@"B"];
    
}
- (IBAction)myC:(id)sender {
    [_myUserPracticeAnswerArray addObject:@"C"];
    [self myUserAnswerJudge:@"C"];
    
}
- (IBAction)myD:(id)sender {
    [_myUserPracticeAnswerArray addObject:@"D"];
    [self myUserAnswerJudge:@"D"];
    
}
- (void)myUserAnswerJudge:(NSString *)userAnswer{
    
    if ([_myUserPracticeAnswerArray[_myindex] isEqualToString: myStandarAnswerArray[_myindex]]) {//比较字符串是否相等
        _myRightOrWrongImage.image = [UIImage imageNamed:@"right.png"];
        _myRightOrWrongLabel.text = @"正确";
    }else{
        _myRightOrWrongImage.image = [UIImage imageNamed:@"wrong.png"];
        NSString *temp = [NSString stringWithFormat:@"标准答案为%@",myStandarAnswerArray[_myindex]];
        _myRightOrWrongLabel.text = temp;
        
    }
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
