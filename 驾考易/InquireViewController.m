//
//  InquireViewController.m
//  驾考易
//
//  Created by 曹修远 on 18/06/2017.
//  Copyright © 2017 曹修远. All rights reserved.
//

#import "InquireViewController.h"
#import "InquireSubViewController.h"
#import "AppDelegate.h"
int myInquireSelectedNum;
NSMutableArray *myInquireDataArray;
BOOL shouldDisplayImage;
@interface InquireViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *myInquireSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *myInquireTableView;
@property (nonatomic,assign) NSString *myInquirePath;
@property (nonatomic,retain) NSMutableArray *myInquireNameArray;
@end

@implementation InquireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    shouldDisplayImage = NO;
    [self myInquireInit];
    
    self.myInquireTableView.dataSource = self;
    self.myInquireTableView.delegate = self;
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
#pragma mark --Inquire
- (void)myInquireInit{
    
    switch (_myInquireSegmentedControl.selectedSegmentIndex) {
        case 0:{
            NSString *XMLString = [[NSBundle mainBundle]pathForResource:@"myRule" ofType:@".xml"];
            _myInquirePath = XMLString;
            NSLog(@"XMLString: %@",XMLString);
            break;
        }
        case 1:{
            NSString *XMLString = [[NSBundle mainBundle]pathForResource:@"myTechnique" ofType:@".xml"];
            _myInquirePath = XMLString;
            NSLog(@"XMLString: %@",XMLString);
            break;
        }
        case 2:{
            NSString *XMLString = [[NSBundle mainBundle]pathForResource:@"mySymbol" ofType:@".xml"];
            _myInquirePath = XMLString;
            NSLog(@"XMLString: %@",XMLString);
            break;
        }
            
        default:
            break;
    }
    switch (_myInquireSegmentedControl.selectedSegmentIndex) {
        case 0:{
            _myInquireNameArray = [[NSMutableArray alloc]initWithObjects:@"第一章　总则", @"第二章　车辆和驾驶人",@"第三章　道路通行条件",@"第四章　道路通行规定",@"第五章　交通事故处理",@"第六章　执法监督",@"第七章　法律责任",@"第八章　附则",nil];
            break;
        }
        case 1:{
            _myInquireNameArray = [[NSMutableArray alloc]initWithObjects:@"坡起", @"侧方停车",@"曲线行驶",@"直角转弯",@"倒车入库",nil];
            break;
        }
        case 2:{
            _myInquireNameArray = [[NSMutableArray alloc]initWithObjects:@"1 前方变窄", @"2 禁止掉头",@"3 禁止驶入",@"4 高速入口",nil];
            shouldDisplayImage = YES;
            break;
        }
            
        default:
            break;
    }
    
    myInquireDataArray = [[NSMutableArray alloc]initWithContentsOfFile:_myInquirePath];

    [_myInquireSegmentedControl addTarget:self action:@selector(myInquireInit) forControlEvents:UIControlEventValueChanged];
    
    [_myInquireTableView reloadData];
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark -- table data source --

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return [myInquireDataArray count];
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableSampleIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:TableSampleIdentifier];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [_myInquireNameArray objectAtIndex:row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;// 跳转指示图标
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.0f]; //设置cell背景透明
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:15];
    return cell;
    
}


#pragma mark -- table events --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected %d,%d",(int)indexPath.section,(int)indexPath.row);
    
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InquireSubViewController *subVC = [stroyBoard instantiateViewControllerWithIdentifier:@"InquireSubViewController"];
    [self.navigationController pushViewController:subVC animated:YES];

    myInquireSelectedNum = (int)indexPath.row;
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.myInquireTableView reloadData];
}


@end
