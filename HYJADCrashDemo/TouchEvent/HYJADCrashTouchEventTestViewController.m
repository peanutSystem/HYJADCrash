//
//  HYJADCrashTouchEventTestViewController.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/20.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashTouchEventTestViewController.h"

#import "AView.h"
#import "BView.h"
#import "CView.h"
#import "DView.h"


@interface HYJADCrashTouchEventTestViewController ()

/** self.View的子视图AView */
@property (nonatomic, strong) AView *aView;

/** AView的子视图BView */
@property (nonatomic, strong) BView *bView;

/** AView的子视图CView */
@property (nonatomic, strong) CView *cView;

/** CView的子视图DView */
@property (nonatomic, strong) DView *dView;

@end

@implementation HYJADCrashTouchEventTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initView];
    });
}

- (void)initView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    //aView
    self.aView = [[AView alloc] initWithFrame:CGRectMake(50, 50, width-100, height-100)];
    [self.view addSubview:self.aView];
    
    //bView
    self.bView = [[BView alloc] initWithFrame:CGRectMake(50, 50, width-200, (height-200)/2)];
    [self.aView addSubview:self.bView];
    
    //cView
    self.cView = [[CView alloc] initWithFrame:CGRectMake(50, (height-200)/2, width-200, (height-200)/2)];
    [self.aView addSubview:self.cView];
    
    //dView
    self.dView = [[DView alloc] init];
    self.dView.center = CGPointMake((width-200)/2, 0);
    self.dView.bounds = CGRectMake(0, 0, (width-200)/2, (width-200)/2);
    [self.cView addSubview:self.dView];
    
    
    
}

#pragma mark -
//- hittest


#pragma mark - UIResponder
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self.view), __func__);
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%s,%s",object_getClassName(self.view), __func__);
    [super touchesMoved:touches withEvent:event];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self.view), __func__);
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%s,%s",object_getClassName(self.view), __func__);
    [super touchesCancelled:touches withEvent:event];
}


@end
