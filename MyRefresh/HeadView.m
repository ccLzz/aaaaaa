//
//  HeadView.m
//  MyRefresh
//
//  Created by 软通 on 16/4/20.
//  Copyright © 2016年 软通. All rights reserved.
//
#import "HeadView.h"

@interface HeadView ()
@property (strong,nonatomic) ActionBlock startBlock;
@property (strong, nonatomic) ActionBlock endBlock;
@end

@implementation HeadView
-(instancetype)initWithScrollView:(UIScrollView *)scrollView andStartBlock:(ActionBlock)startblock endBlock:(ActionBlock)endblock{
    self = [super init];
    if (self) {
        self.scrollView=scrollView;
        self.startBlock=startblock;
        self.endBlock=endblock;
        self.state=RefreshStateNomal;
        [scrollView addSubview:self];
        [self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}


-(void)endRefresh{
    self.endBlock();
    self.state=RefreshStateRefreshEnd;
}

-(void)startRefresh{
    self.startBlock();
    if (self.state!=RefreshStateRefreshing) {
        //如果直接调用此方法，self.subview还没创建
            [self setSelf];
        //如果直接调用此方法，那么并没有下拉，需手动设置offset；
        self.scrollView.contentOffset=CGPointMake(0, -(self.refreshingHeight+self.insetTop));
        self.state=RefreshStateRefreshing;
        //self.scrollView.contentInset=UIEdgeInsetsMake(self.refreshingHeight+self.insetTop,0,0,0);
        [self setScrollViewContentInset:UIEdgeInsetsMake(self.refreshingHeight+self.insetTop,0,0,0)];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (self.insetTop!=0) {
            [self contentOffsetDidChange:change];
        }
        
        return;
    }
    
    
    if ([keyPath isEqualToString:@"contentInset"]) {
        float insetTop =[change[@"new"] UIEdgeInsetsValue].top;
        NSLog(@"insettop=%f",insetTop);
        self.insetTop=insetTop;
        return;
    }
    

    if ([keyPath isEqualToString:@"state"]) {
        //NSLog(@"%@",change[@"new"]);
        switch ([change[@"new"] integerValue]) {
            case RefreshStatePulling:
                //if ([change[@"old"] integerValue] != RefreshStateRefreshing) {
                    [self refreshStatePullingAction];
                //}
                break;
            
            case RefreshStatePullEnough:{
                [self refreshStatePullEnoughAction];
                break;
            }
                
            case RefreshStateRefreshing:{
                [self refreshStateRefreshingAction];
                break;
            }
                
            case RefreshStateRefreshEnd:{
                [self refreshStateRefreshEndAction];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //self.scrollView.contentInset=UIEdgeInsetsMake(self.insetTop, 0, 0, 0);
                    [self setScrollViewContentInset:UIEdgeInsetsMake(self.insetTop, 0, 0, 0)];
                    self.state=RefreshStateNomal;
                });
                break;
            }
#warning releaseSelf
            case RefreshStateNomal:{
                [self releaseSelf];
                break;
            }
            default:
                break;
        }
    }
}


-(void)contentOffsetDidChange:(NSDictionary *)change{
    float offsetY =[change[@"new"] CGPointValue].y;
    NSLog(@"offsetY=%f",offsetY);
    static BOOL lastIsDraging=NO;
    if (offsetY<-self.refreshingHeight-self.insetTop) {
        //下拉足够距离
        self.state=RefreshStatePullEnough;//****
        
        //下拉足够距离，松开手，开始刷新
        
        if (!self.scrollView.dragging && lastIsDraging) {
            self.state=RefreshStateRefreshing;
            //self.scrollView.contentInset=UIEdgeInsetsMake(self.refreshingHeight+self.insetTop,0,0,0);
            [self setScrollViewContentInset:UIEdgeInsetsMake(self.refreshingHeight+self.insetTop,0,0,0)];
            [self startRefresh];
        }
        lastIsDraging = self.scrollView.dragging;
        return;
    }
    
    //下拉时
    if (offsetY<0-self.insetTop&&offsetY>-self.refreshingHeight-self.insetTop) {
       // NSLog(@"%f",self.scrollView.contentInset.top);
        if (self.state!=RefreshStateRefreshing) {
#warning setSelf
            if (self.state==RefreshStateNomal) {
                [self setSelf];
            }
            self.state=RefreshStatePulling;//******
        }
        if (!self.scrollView.dragging && lastIsDraging) {
            self.state=RefreshStateNomal;
        }
        lastIsDraging = self.scrollView.dragging;
        return;
    }

    //用户滑动到未下拉的位置
    if (offsetY>=self.insetTop) {
        if (self.state!=RefreshStateRefreshing) {
            self.state=RefreshStateNomal;
        }
    }
    
}

/**
 *  避免自己改动inset时候触发kvo
 */
-(void)setScrollViewContentInset:(UIEdgeInsets )insets{
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    self.scrollView.contentInset=insets;
    [self.scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
}


-(void)dealloc{
    [self removeObserver:self forKeyPath:@"contentInset"];
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"state"];
}



@end
