//
//  GYAnimationRefresh.h
//  shuaxin
//
//  Created by Zhang on 11.1.22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^refreshCallback)(void);
/** 刷新控件的状态 */
typedef NS_ENUM(NSInteger, GYRefreshState) {
    /** 普通闲置状态 */
    GYIdleOne = 1,
    /** 松开就可以进行刷新的状态 */
    GYReleaseRefreshTwo,
    /** 正在刷新中的状态 */
    GYRefreshingThree,
};
@interface GYAnimationRefresh : UIView
///初始化下拉刷新
+(instancetype)GYAnimationRefreshWithScrollView:(UIScrollView *)scrollView mainView:(UIView *)mainView;
///初始化界面
- (instancetype)initWithFrame:(CGRect)frame mainView:(UIView *)mainView;
///下拉刷新
-(void)pullDownRefresh;
///结束刷新
-(void)endRefresh;
///拖拽事件
-(void)scrollViewDidScroll:(UIScrollView *)scrollView;
///松开事件
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
///回调刷新
@property(nonatomic, strong) refreshCallback block;
///自定义界面
@property(nonatomic, strong) UIView *containerToolView;
///动画数据
@property(nonatomic, strong) NSString *dataJson;
//背景颜色
@property(nonatomic, strong) UIColor *gyanimationRefreshBackgroundColor;
//刷新状态
@property(nonatomic, assign) GYRefreshState state;

//监听scrollView的位置
@property(nonatomic, strong) UIScrollView *scrollView;
//触发刷新的高度
@property(nonatomic, assign) NSInteger refreshH;
//本地json动画
@property(nonatomic, strong) NSString *animationNamedJson;
//urljson动画
@property(nonatomic, strong) NSString *animationNamedJsonUrl;
//第一次
@property(nonatomic, strong) NSString *gyOnce;
@end

NS_ASSUME_NONNULL_END
