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
    CGFloat _lastSubViewAngle;
    
}
@property (nonatomic, strong) UIView *centerView;
@end
@implementation CircleView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self customUI];
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}
- (void)customUI {
    
    CGFloat centerX = CGRectGetWidth(self.frame) * 0.5f;
    CGFloat centerY = centerX;
    _centerPoint = CGPointMake(centerX, centerY);
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _centerView.center = _centerPoint;
    _centerView.backgroundColor = [UIColor blueColor];
    [self addSubview:_centerView];
    
    UIView *subView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    subView1.backgroundColor = [UIColor redColor];
    [_centerView addSubview:subView1];
    
    
    _deltaAngle = M_PI / 3.0f;
    CGFloat currentAngle = 0;
    CGFloat subViewCenterX = 0;
    CGFloat subViewCenterY = 0;
    CGFloat subViewW = 50;
    CGFloat subViewH = subViewW;
    _radius = centerX - subViewW * 0.5f;
    _lastSubViewAngle = 0;
    for (int i = 0; i < 6; i++) {
        currentAngle = _deltaAngle * i;
        subViewCenterX = centerX + _radius * sin(currentAngle);
        subViewCenterY = centerY - _radius * cos(currentAngle);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, subViewW, subViewH)];
        imgView.tag = kTag + i;
        imgView.center = CGPointMake(subViewCenterX, subViewCenterY);
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
    
    _centerView.transform = CGAffineTransformRotate(_centerView.transform, angle);
    
    _lastSubViewAngle = fmod(_lastSubViewAngle + angle, 2 * M_PI);
    NSLog(@"%f", _lastSubViewAngle);
    
    CGFloat currentAngle = 0;
    CGFloat subViewCenterX = 0;
    CGFloat subViewCenterY = 0;
    for (int i = 0; i < 6; i++) {
        UIImageView *subImgView = [self viewWithTag:kTag];
        currentAngle = _deltaAngle * i + _lastSubViewAngle;
        subViewCenterX = _centerPoint.x + _radius * sin(currentAngle);
        subViewCenterY = _centerPoint.x - _radius * cos(currentAngle);
        subImgView = [self viewWithTag:kTag + i];
        subImgView.center = CGPointMake(subViewCenterX, subViewCenterY);
    }
    
    _lastPoint = currentPoint;
}
@end
