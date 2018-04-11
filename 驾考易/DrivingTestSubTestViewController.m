//
//  DrivingTestSubTestViewController.m
//  驾考易
//
//  Created by 曹修远 on 18/06/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

#import "DrivingTestSubTestViewController.h"

#import "DrivingTestViewController.h"

extern NSMutableArray *myStandarAnswerArray;//标准答案
extern NSMutableArray *myExaminationArray;//题目

@interface DrivingTestSubTestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myRightOrWrongLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myRightOrWrongImage;
@property (weak, nonatomic) IBOutlet UILabel *myRemainingTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *myExaminationLabel;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) int myTotalTime;
@property (nonatomic,assign) int myPastTime;
@property (nonatomic,assign) int myRemainingTime;
@property (nonatomic,assign) int myindex;
@property (nonatomic,retain) NSMutableArray *myUserTestAnswerArray;//用户模考的答案
@end

@implementation DrivingTestSubTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myindex = 0;
    _myTotalTime = 60;//剩余时间
    [self myDTTestInit]; 
    // Do any additional setup after loading the view.
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myJudge) userInfo:nil repeats:YES];
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
-(void)myDTTestInit{
    self.navigationItem .title = @"模考";
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(myShare)];
    self.navigationItem.rightBarButtonItem =rightBtn;
    
    _myRightOrWrongLabel.text = @"";
    _myExaminationLabel.text = myExaminationArray[_myindex];
    _myUserTestAnswerArray = [[NSMutableArray alloc]init];
    
    
}
- (IBAction)myNext:(id)sender {
    _myindex += 1;
    
    if ([_myUserTestAnswerArray count] < _myindex) {
        _myUserTestAnswerArray[_myindex-1] = @"0";
    }
    if (_myindex < [myStandarAnswerArray count]) {
        _myExaminationLabel.text = myExaminationArray[_myindex];
        _myRightOrWrongLabel.text = @"";
        _myRightOrWrongImage.image = nil;
        
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"你已经做完题目，点击按钮返回。" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"返回" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"返回");
            [self.navigationController popViewControllerAnimated:YES];
            [self mySaveXML];
            
        }];
        
        [alertController addAction:okAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
}
- (void)myJudge{
    [self myTimePast];
    if (_myRemainingTime <= 0) {
        [self.navigationController popViewControllerAnimated:YES];
        [self mySaveXML];
    }
}
- (void)myTimePast{//已经做了多久
    
    _myPastTime +=1;
    _myRemainingTime = _myTotalTime - _myPastTime;
    NSString *temp = [self myFormatTime:_myRemainingTime];
    _myRemainingTimeLabel.text = [NSString stringWithFormat:@"%@", temp];

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
- (void)mySaveXML{
    NSArray *array =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    //得到文件的具体路径(默认在数组的最后一个)
    NSString *documents = [array lastObject];
    //拼接我们自己创建的文件的路径
    NSString *documentPath = [documents stringByAppendingPathComponent:@"myTestUserAnswer.xml"];
    [_myUserTestAnswerArray writeToFile:documentPath atomically:YES];
    
    NSString *myTestTimePath = [documents stringByAppendingPathComponent:@"myTestTime.xml"];
    NSString *temp = [NSString stringWithFormat:@"%d",_myPastTime];
    NSArray *tempArray = [NSArray arrayWithObject:temp];
    [tempArray writeToFile:myTestTimePath atomically:YES];
}
- (IBAction)myA:(id)sender {
    [_myUserTestAnswerArray addObject:@"A"];
    [self myUserAnswerJudge:@"A"];
    
}
- (IBAction)myB:(id)sender {
    [_myUserTestAnswerArray addObject:@"B"];
    [self myUserAnswerJudge:@"B"];
    
}
- (IBAction)myC:(id)sender {
    [_myUserTestAnswerArray addObject:@"C"];
    [self myUserAnswerJudge:@"C"];
    
}
- (IBAction)myD:(id)sender {
    [_myUserTestAnswerArray addObject:@"D"];
    [self myUserAnswerJudge:@"D"];
    
}
- (void)myUserAnswerJudge:(NSString *)userAnswer{
    
    if ([_myUserTestAnswerArray[_myindex] isEqualToString: myStandarAnswerArray[_myindex]]) {//比较字符串是否相等
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
