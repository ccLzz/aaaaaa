//
//  HeadView.h
//  MyRefresh
//
//  Created by 软通 on 16/4/20.
//  Copyright © 2016年 软通. All rights reserved.
//
#define screenSize  [UIScreen mainScreen].bounds.size
//#define refreshingHeight 80.0
#import <UIKit/UIKit.h>


/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, RefreshState) {
    RefreshStateNomal,//0
    RefreshStatePulling,
    RefreshStatePullEnough,
    RefreshStateRefreshing,
    RefreshStateRefreshEnd
};
typedef void(^ActionBlock)(void);
@interface HeadView : UIView
@property (weak,nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) float insetTop;
@property (assign, nonatomic)  RefreshState state;
#warning 如果下拉要求的高度不等于下拉刷新时保留的高度，还需设置另一个属性
@property (assign, nonatomic) float refreshingHeight;
-(void)endRefresh;
-(void)startRefresh;
/**
 *  u must set refreshingHeight here , whitch means the height of headView showing when refreshing
 *
 *  @param scrollView whitch u want to add headView
 *
 */
-(instancetype)initWithScrollView:(UIScrollView *)scrollView andStartBlock:(ActionBlock)startblock endBlock:(ActionBlock)endblock;

/**
 *  creat all views here
 *
 */
-(void)setSelf;


/**
 *  release your views and vars to free memories
 */
-(void)releaseSelf;

/**
 *  add actions when pulling
 */
-(void)refreshStatePullingAction;

/**
 *  add actions when pull enough
 */
-(void)refreshStatePullEnoughAction;

/**
 *  add actions when refreshing
 */
-(void)refreshStateRefreshingAction;

/**
 *  add actions when refresh end
 */
-(void)refreshStateRefreshEndAction;



@end
