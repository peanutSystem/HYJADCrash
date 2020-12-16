//
//  HYJADCrashViewController.m
//  HYJADCrashDemo
//
//  Created by 何宇佳 on 2020/12/2.
//  Copyright © 2020 何宇佳. All rights reserved.
//

#import "HYJADCrashViewController.h"

@interface HYJADCrashViewController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HYJADCrashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"self.class:%@",self.class);
//    self.titleLabel = [UILabel new];
//    [self.view addSubview:self.titleLabel];
//    self.titleLabel.frame = CGRectMake(10, 50, 20, 20);
//    [self.titleLabel addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
//    [self.titleLabel addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionNew context:nil];
//    _titleLabel.backgroundColor = [UIColor blueColor];
    
    self.imageView = [UIImageView new];
    [self.view addSubview:self.imageView];
    
//    UIImage *image = [UIImage imageNamed:@"smlxs"];
//    UIEdgeInsets insets = UIEdgeInsetsMake(50, 50, 50, 50);
//    UIImage *newImage =  [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
//    [self.imageView setImage:newImage];
    
//    NSString *imageStr = [[NSBundle mainBundle] pathForResource:@"smlxs2" ofType:@"jpeg"];
//    NSData *imageData = [NSData dataWithContentsOfFile:imageStr];
//    [self.imageView setImage:[UIImage imageWithData:imageData]];
//    [self.imageView setImage:[UIImage imageWithContentsOfFile:imageStr]];
    
//    [self.imageView setImage:[UIImage imageNamed:@"smlxs"]];
    self.imageView.bounds = CGRectMake(0, 0, 200, 200);
    self.imageView.center = self.view.center;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.titleLabel = nil;
//        [self.titleLabel removeObserver:self forKeyPath:@"backgroundColor"];
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


- (void)dealloc
{
    NSLog(@"HYJADCrashViewController------dealloc");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"backgroundColor"]) {
        NSLog(@"颜色改变了");
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
