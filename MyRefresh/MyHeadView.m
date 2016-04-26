//
//  MyHeadView.m
//  MyRefresh
//
//  Created by 软通 on 16/4/22.
//  Copyright © 2016年 软通. All rights reserved.
//

#import "MyHeadView.h"


@interface MyHeadView()
@property (strong, nonatomic) UIImageView *imageV;
@property (strong, nonatomic) NSMutableArray * imageArr;
@end
@implementation MyHeadView


-(instancetype)initWithScrollView:(UIScrollView *)scrollView andStartBlock:(ActionBlock)startblock endBlock:(ActionBlock)endblock{
    self=[super initWithScrollView:scrollView andStartBlock:startblock endBlock:endblock];
    if (self) {
        self.refreshingHeight=80;
    }
    return self;
}
-(void)setSelf{
    self.frame=CGRectMake(0, -300, screenSize.width, 300);
    self.backgroundColor=[UIColor grayColor];
    UIImageView *imageV=[[UIImageView alloc]initWithFrame:CGRectMake(screenSize.width/2-40,220 , 80, 80)];
    [self addSubview:imageV];
    self.imageV=imageV;
    imageV.transform=CGAffineTransformMakeScale(0.1, 0.1);
    imageV.layer.anchorPoint=CGPointMake(0.5, 1);
    imageV.layer.position=CGPointMake(screenSize.width/2,300);
    self.imageArr=[NSMutableArray array];
    for (int i=1; i<5; i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",i] ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [self.imageArr addObject:image];
    }
}
-(void)releaseSelf{
    self.imageArr=nil;
    [self.imageV removeFromSuperview];
    self.imageV=nil;
}

-(void)refreshStatePullingAction{
    [self.imageV stopAnimating];
    self.imageV.transform=CGAffineTransformMakeScale((self.scrollView.contentOffset.y+self.insetTop)/(-self.refreshingHeight), (self.scrollView.contentOffset.y+self.insetTop)/(-self.refreshingHeight));
    self.imageV.image=self.imageArr[(int)((-self.scrollView.contentOffset.y-self.insetTop)/6)%4];
}
-(void)refreshStatePullEnoughAction{
    self.imageV.transform=CGAffineTransformMakeScale(1.0, 1.0);
    if (![self.imageV isAnimating]) {
        [self startGitWithDuration:0.6];
    }
}
-(void)refreshStateRefreshingAction{
        self.imageV.transform=CGAffineTransformMakeScale(1.0, 1.0);
        [self startGitWithDuration:0.3];
}
-(void)refreshStateRefreshEndAction{
    if ([self.imageV isAnimating]) {
        [self.imageV stopAnimating];
        self.imageV.image=[UIImage imageNamed:@"ok.jpg"];
    }
}

/**
 *  动画的设置
 */
-(void)startGitWithDuration:(float)duration{
    self.imageV.animationImages = self.imageArr; //动画图片数组
    self.imageV.animationDuration = duration; //执行一次完整动画所需的时长
    self.imageV.animationRepeatCount = 999;  //动画重复次数
    [self.imageV startAnimating];
}

@end
