//
//  GYAnimationRefresh.m
//  shuaxin
//
//  Created by Zhang on 11.1.22.
//

#import "GYAnimationRefresh.h"
#import <Lottie/Lottie.h>
#import "Masonry.h"
@interface GYAnimationRefresh ()
@property(nonatomic, strong) LOTAnimationView *loadingView;

@end
@implementation GYAnimationRefresh
+(instancetype)GYAnimationRefreshWithScrollView:(UIScrollView *)scrollView mainView:(UIView *)mainView{
    GYAnimationRefresh *gyanimationRefresh = [[self alloc] initWithFrame:CGRectMake(0, scrollView.frame.origin.y, scrollView.frame.size.width, 0) mainView:mainView];
    gyanimationRefresh.scrollView = scrollView;
//    [mainView bringSubviewToFront:scrollView];
    [mainView sendSubviewToBack:gyanimationRefresh];
    mainView.backgroundColor = scrollView.backgroundColor;
    scrollView.backgroundColor = [UIColor clearColor];
    return gyanimationRefresh;
}
- (instancetype)initWithFrame:(CGRect)frame mainView:(UIView *)mainView
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        [mainView addSubview:self];
        [self addSubview:self.containerToolView];
        [self.containerToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(@0);
        }];
        [self.containerToolView addSubview:self.loadingView];
        [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.centerX.equalTo(self.containerToolView.mas_centerX);
            make.centerY.equalTo(self.containerToolView.mas_centerY);
        }];
        self.state = GYIdleOne;
        self.refreshH = 100;
    }
    return self;
}
-(UIView *)containerToolView
{
    if (_containerToolView == nil) {
        _containerToolView = [[UIView alloc] init];
    }
    return _containerToolView;
}
- (LOTAnimationView *)loadingView {
    if(_loadingView == nil) {
        _loadingView = [[LOTAnimationView alloc] init];
        _loadingView.loopAnimation = YES;
        _loadingView.contentMode = UIViewContentModeScaleAspectFit;
        _loadingView.animationSpeed = 1.0;
    }
    return _loadingView;
}
//滚动视图发生滚动操作时
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<0) {
        self.frame = CGRectMake(0, 0, scrollView.frame.size.width, -scrollView.contentOffset.y);
        if (self.gyOnce.length != 0) {
            self.hidden = NO;
        }
        self.gyOnce = @"0";
    }else
    {
        self.hidden = YES;
    }
    if (self.state == GYIdleOne) {
        CGFloat percent = -scrollView.contentOffset.y / ([UIScreen mainScreen].bounds.size.height / 3.0);
        percent = MAX(0, MIN(1, percent));
        self.loadingView.animationProgress = percent;
    }
}
//松开回调
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.state = GYReleaseRefreshTwo;
    [self pullDownRefresh];
}
//下拉刷新
-(void)pullDownRefresh{
    if (-self.scrollView.contentOffset.y>self.refreshH) {
        self.loadingView.animationProgress = 0;
        [self.loadingView play];
        self.scrollView.contentInset = UIEdgeInsetsMake(self.refreshH, 0, 0, 0);
        self.hidden = NO;
        self.state = GYRefreshingThree;
    }else
    {
        self.state = GYIdleOne;
    }
}
-(void)endRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);;
             self.hidden = YES;
            self.state = GYIdleOne;
        }];
    });
}
-(void)setState:(GYRefreshState)state
{
    _state = state;
    if (state == GYRefreshingThree) {
        if (self.block) {//先判断
            self.block();
        }
    }
}
- (void)setGyanimationRefreshBackgroundColor:(UIColor *)gyanimationRefreshBackgroundColor
{
    _gyanimationRefreshBackgroundColor = gyanimationRefreshBackgroundColor;
    self.backgroundColor = gyanimationRefreshBackgroundColor;
}
-(void)setRefreshH:(NSInteger)refreshH
{
    _refreshH = refreshH;
}
-(void)setAnimationNamedJson:(NSString *)animationNamedJson
{
    _animationNamedJson = animationNamedJson;
    self.loadingView.animation = animationNamedJson;
}
-(void)setAnimationNamedJsonUrl:(NSString *)animationNamedJsonUrl
{
    _animationNamedJsonUrl = animationNamedJsonUrl;
    self.loadingView = [self.loadingView initWithContentsOfURL:[NSURL URLWithString:animationNamedJsonUrl]];
}
@end
