//
//  ViewController.m
//  CircleAnimation
//
//  Created by PC-LiuChunhui on 16/4/12.
//  Copyright © 2016年 Mr.Wendao. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CircleView *cirlcle = [[CircleView alloc] initWithFrame:CGRectMake(10, 100, kScreenWidth - 20, kScreenWidth - 20)];

    [self.view addSubview:cirlcle];
    
    
}

@end
