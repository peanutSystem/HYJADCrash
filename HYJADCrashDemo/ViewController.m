//
//  ViewController.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/11/27.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "ViewController.h"

#import "HJYADCrash.h"
#import "HYJADCrashPeople.h"

#import "HYJADCrashTest.h"
#import "HYJADCrashTestTwo.h"

#import "HYJADCrashViewController.h"
#import "HYJADCrashLoginViewController.h"
#import "HYJADCrashTouchEventTestViewController.h"

#import "NSObject+HYJADCrashCancelDelayed.h"

#define HJY_DEVICE_WIDTH [UIScreen mainScreen].bounds.size.width

#define HJY_DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height

NSString * const tableViewIdentifier = @"HJYADCrash_Test_TableViewCell";

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, HYJADCrashCollectManagerDelegate>

/** tableView */
@property (nonatomic, strong) UITableView *tableView;

/** People */
@property (nonatomic, strong) HYJADCrashPeople *people;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //注册HYJADCrash
    [self initHJYADCrash];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initView];
    });
}

- (void)initView
{
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *))
    {
        self.tableView.frame = CGRectMake(0, 0, HJY_DEVICE_WIDTH, (HJY_DEVICE_HEIGHT - self.view.safeAreaInsets.top - self.view.safeAreaInsets.bottom));
    } else
    {
        self.tableView.frame = CGRectMake(0, 0, HJY_DEVICE_WIDTH, HJY_DEVICE_HEIGHT);
    }
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
}

- (void)initHJYADCrash
{
    //注册HJYADCrash
    [[HYJADCrashCollectManager shared] registerADCrash];
    //设置代理
    [HYJADCrashCollectManager shared].delegate = self;
}




#pragma mark - HYJADCrashCollectManagerDelegate
- (void)observerCrashLog:(NSString *_Nonnull)crashLog
{
    //字符串类型的日志
    NSLog(@"crashLog:%@ \n\n",crashLog);
}

- (void)observerCrashLogDictionary:(NSDictionary *_Nonnull)crashLogDictionary
{
    //字典类型的日志
    NSLog(@"crashLogDictionary:%@ \n\n",crashLogDictionary);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"野指针";
    } else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"消息转发";
    } else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"KVC";
    } else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"KVO";
    } else if (indexPath.row == 4)
    {
        cell.textLabel.text = @"跳转到HYJADCrashViewController";
    } else if (indexPath.row == 5)
   {
       cell.textLabel.text = @"MVVM";
   } else if (indexPath.row == 6)
   {
       cell.textLabel.text = @"响应链";
   }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        //野指针
        [self excBadAccess];
    } else if (indexPath.row == 1)
    {
        //消息转发
        [self msgSendCrash];
    } else if (indexPath.row == 2)
    {
        //KVC
        [self kvcCrash];
    } else if (indexPath.row == 3)
    {
        //kvo
        [self kvoCrash];
    } else if (indexPath.row == 4)
    {
        [self jumpToHYJADCrashViewController];
    } else if (indexPath.row == 5)
    {
        [self jumpToMVVM];
    } else if (indexPath.row == 6)
    {
        [self jumpToTouchEventTest];
    }
}

#pragma mark - ---------------------------------------------  Private Method  ---------------------------------------------

- (void)excBadAccess
{
    if (!self.people) {
        self.people = [HYJADCrashPeople new];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.people upGrade];
    });
    
    self.people = nil;
    
}


- (void)msgSendCrash
{
    if (arc4random()%2 == 1)
    {
        NSLog(@"msgSend Class Method");
        [HYJADCrashPeople randomPeopleName];
    } else
    {
        NSLog(@"msgSend Instance Method");
        HYJADCrashPeople *object = [HYJADCrashPeople new];
        [object randomGrowUp];
        NSLog(@"num");
    }
}

- (void)kvcCrash
{
    /* kvc 的 crash 有2种
    1.value or key 为空
     value 为空，  could not set nil as the value for the key.
     key为空， attempt to set a value for a nil key
     
    2.没有对应的key path
     [setValueSafe:forKey]-[setValue:forUndefinedKey:]: this class is not key value coding-compliant for the key
    */
    
    NSMutableArray *array = [NSMutableArray new];
        
        for (NSInteger i = 0; i < 50; i++) {
            HYJADCrashTest *test = [HYJADCrashTest new];
            
            //测试用例1 正常数据
    //        [test setValueSafe:@(10) forKey:@"age"];
    //        [test setValueSafe:[[NSString alloc] initWithFormat:@"%zd",i] forKey:@"str"];
    //        [test setValueSafe:@((i+1)*10+1) forKeyPath:@"two.age"];
            
            //测试用例2 类型错误数据
            [test setValue:@"测试1" forKey:@"age"];
            [test setValue:@(1.02f) forKey:@"str"];
            [test setValue:@"测试2" forKeyPath:@"two.age"];
            
            [array addObjectSafe:test];
        }
        
        NSArray *ageArra = [array valueForKey:@"age"];
        NSArray *strArra = [array valueForKey:@"str"];
        NSArray *ageArray = [array valueForKeyPath:@"two.age"];
        
    //    NSLog(@"ageArr:%@",ageArr);
        NSLog(@"ageArray:%@",ageArray);
}

- (void)kvoCrash
{
    /* kvo 的 crash 有3种
    1.注册了addObserver，但没有实现observeValueForKeyPath。导致crash
    An -observeValueForKeyPath:ofObject:change:context: message was received but not handled.
     
    2.没有对应的key path
    
    3.多次移除同一个KVO
    Cannot remove an observer <HYJADCrashTest 0x600000f50180> for the key path "age" from <HYJADCrashTestTwo 0x600000f501e0> because it is not registered as an observer.
    */
    HYJADCrashTest *test = [HYJADCrashTest new];
    //测试多次移除kvo的崩溃
    [test changeAge];
}

- (void)jumpToHYJADCrashViewController
{
    HYJADCrashViewController *vc = [HYJADCrashViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)jumpToMVVM
{
    HYJADCrashLoginViewController *vc = [HYJADCrashLoginViewController new];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)jumpToTouchEventTest
{
    HYJADCrashTouchEventTestViewController *vc = [HYJADCrashTouchEventTestViewController new];
       [self presentViewController:vc animated:YES completion:nil];
}

@end
