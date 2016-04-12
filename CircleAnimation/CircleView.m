//
//  CircleView.m
//  CircleAnimation
//
//  Created by PC-LiuChunhui on 16/4/12.
//  Copyright © 2016年 Mr.Wendao. All rights reserved.
//

#import "CircleView.h"
#define kTag 100
@interface CircleView() {
    CGPoint _lastPoint;
    CGPoint _centerPoint;
    CGFloat _deltaAngle;
    CGFloat _radius;
    CGFloat _lastImgViewAngle;
    
}
@property (nonatomic, strong) UIView *blueView;
@end
@implementation CircleView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customUI];
//        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}
- (void)customUI {
    
    CGFloat centerX = CGRectGetWidth(self.frame) * 0.5f;
    CGFloat centerY = centerX;
    _centerPoint = CGPointMake(centerX, centerY);//中心点
    _blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];//蓝色view
    _blueView.center = _centerPoint;
    _blueView.backgroundColor = [UIColor blueColor];
    [self addSubview:_blueView];
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];//红色view
    redView.backgroundColor = [UIColor redColor];
    [_blueView addSubview:redView];
    
    _deltaAngle = M_PI / 3.0f;//6个imgView的间隔角度
    CGFloat currentAngle = 0;
    CGFloat imgViewCenterX = 0;
    CGFloat imgViewCenterY = 0;
    CGFloat imgViewW = 80;
    CGFloat imgViewH =imgViewW;
    _radius = centerX - imgViewW * 0.5f;//imgView.center到self.center的距离
    for (int i = 0; i < 6; i++) {
        currentAngle = _deltaAngle * i;
        imgViewCenterX = centerX + _radius * sin(currentAngle);
        imgViewCenterY = centerY - _radius * cos(currentAngle);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgViewW, imgViewH)];
        imgView.tag = kTag + i;
        imgView.center = CGPointMake(imgViewCenterX, imgViewCenterY);
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"circle%d", i]];
        [self addSubview:imgView];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    _lastPoint = [touch locationInView:self];
    
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    //1.计算当前点相对于y轴的角度
    CGFloat currentPointRadius = sqrt(pow(currentPoint.y - _centerPoint.y, 2) + pow(currentPoint.x - _centerPoint.x, 2));
    if (currentPointRadius == 0) {//当点在中心点时，被除数不能为0
        return;
    }
    CGFloat pointAngle = acos((currentPoint.x - _centerPoint.x) / currentPointRadius);
    if (currentPoint.y > _centerPoint.y) {
        pointAngle = 2 * M_PI - pointAngle;
    }
    
    //2.计算上一个点相对于y轴的角度
    CGFloat lastPointRadius = sqrt(pow(_lastPoint.y - _centerPoint.y, 2) + pow(_lastPoint.x - _centerPoint.x, 2));
    if (lastPointRadius == 0) {
        return;
    }
    CGFloat lastAngle = acos((_lastPoint.x - _centerPoint.x) / lastPointRadius);
    if (_lastPoint.y > _centerPoint.y) {
        lastAngle = 2 * M_PI - lastAngle;
    }
    //3.变化的角度
    CGFloat angle = lastAngle - pointAngle;
    
    _blueView.transform = CGAffineTransformRotate(_blueView.transform, angle);
    
    _lastImgViewAngle = fmod(_lastImgViewAngle + angle, 2 * M_PI);
    NSLog(@"%f", _lastImgViewAngle);
    
    CGFloat currentAngle = 0;
    CGFloat imgViewCenterX = 0;
    CGFloat imgViewCenterY = 0;
    for (int i = 0; i < 6; i++) {
        UIImageView *imgView = [self viewWithTag:kTag];
        currentAngle = _deltaAngle * i + _lastImgViewAngle;
        imgViewCenterX = _centerPoint.x + _radius * sin(currentAngle);
        imgViewCenterY = _centerPoint.x - _radius * cos(currentAngle);
        imgView = [self viewWithTag:kTag + i];
        imgView.center = CGPointMake(imgViewCenterX, imgViewCenterY);
    }
    
    _lastPoint = currentPoint;
}
@end
