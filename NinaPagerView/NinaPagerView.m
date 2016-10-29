// The MIT License (MIT)
//
// Copyright (c) 2015-2016 RamWire ( https://github.com/RamWire )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#import "NinaPagerView.h"
#import "UIParameter.h"
#import "NinaBaseView.h"
#import "UIView+ViewController.h"

#define MaxNums  10 //Max limit number,recommand below 10.
static NSString *const kObserverPage = @"currentPage";

@interface NinaPagerView()<NSCacheDelegate>
@property (nonatomic, strong)NSCache *limitControllerCache; /**<  缓存限制   **/
@end

@implementation NinaPagerView
{
    NinaBaseView *pagerView;
    NSArray *titlesArray;
    NSArray *classArray;
    NSMutableArray *viewNumArray;
    NSMutableArray *vcsTagArray;
    NSMutableArray *vcsArray;
    BOOL viewAlloc[MaxNums];
    UIViewController *firstVC;
    BOOL pagerLoadWhole;
    BOOL ableLoadData;
}

- (instancetype)initWithFrame:(CGRect)frame WithTitles:(NSArray *)titles WithVCs:(NSArray *)childVCs
{
    if (self = [super init]) {
        self.frame = frame;
        titlesArray = titles;
        classArray = childVCs;
    }
    return self;
}

#pragma mark - SetMethod
- (void)setTitleScale:(CGFloat)titleScale {
    _titleScale = titleScale;
}

- (void)setTitleFont:(CGFloat)titleFont {
    _titleFont = titleFont;
}

- (void)setNina_navigationBarHidden:(BOOL)nina_navigationBarHidden {
    _nina_navigationBarHidden = nina_navigationBarHidden;
}

- (void)setNinaDefaultPage:(NSInteger)ninaDefaultPage {
    _ninaDefaultPage = ninaDefaultPage;
    _ninaDefaultPage = (_ninaDefaultPage > 0 && _ninaDefaultPage < titlesArray.count)?_ninaDefaultPage:0;
}

- (void)setLoadWholePages:(BOOL)loadWholePages {
    _loadWholePages = loadWholePages;
}

- (void)setNinaPagerStyles:(NinaPagerStyle)ninaPagerStyles {
    _ninaPagerStyles = ninaPagerStyles;
}

- (void)setSliderHeight:(CGFloat)sliderHeight {
    _sliderHeight = sliderHeight;
}

- (void)setSelectBottomLinePer:(CGFloat)selectBottomLinePer {
    _selectBottomLinePer = selectBottomLinePer;
}

- (void)setSelectBottomLineHeight:(CGFloat)selectBottomLineHeight {
    _selectBottomLineHeight = selectBottomLineHeight;
}

- (void)setSlideBlockCornerRadius:(CGFloat)slideBlockCornerRadius {
    _slideBlockCornerRadius = slideBlockCornerRadius;
}

- (void)setUnderLineHidden:(BOOL)underLineHidden {
    _underLineHidden = underLineHidden;
}

- (void)setTopTabHeight:(CGFloat)topTabHeight {
    _topTabHeight = topTabHeight;
}

- (void)setUnSelectTitleColor:(UIColor *)unSelectTitleColor {
    _unSelectTitleColor = unSelectTitleColor;
}

- (void)setSelectTitleColor:(UIColor *)selectTitleColor {
    _selectTitleColor = selectTitleColor;
}

- (void)setUnderlineColor:(UIColor *)underlineColor {
    _underlineColor = underlineColor;
}


-(void)setIsAutoUnderLineWidth:(BOOL)isAutoUnderLineWidth{
    _isAutoUnderLineWidth = isAutoUnderLineWidth;
}

- (void)setSliderBlockColor:(UIColor *)sliderBlockColor {
    _sliderBlockColor = sliderBlockColor;
}

- (void)setTopTabBackGroundColor:(UIColor *)topTabBackGroundColor {
    _topTabBackGroundColor = topTabBackGroundColor;
}

#pragma mark - LayOutSubViews
- (void)layoutSubviews {
    [super layoutSubviews];
    [self loadDataForView];
}

#pragma mark - LoadData
- (void)loadDataForView {
    [self createPagerView:titlesArray WithVCs:classArray];
    pagerView.btnUnSelectColor = _unSelectTitleColor;
    pagerView.btnSelectColor = _selectTitleColor;
    pagerView.isAutoUnderLineWidth = _isAutoUnderLineWidth;
    pagerView.underlineBlockColor = (_ninaPagerStyles == 1)?_sliderBlockColor:_underlineColor;
    pagerView.topTabColor = _topTabBackGroundColor;
    CGFloat tabHeight = _topTabHeight > 25?_topTabHeight:40;
    pagerView.topHeight = tabHeight;
    pagerView.baseDefaultPage = _ninaDefaultPage;
    pagerView.titleScale = _titleScale > 0?_titleScale:1.15;
    pagerView.titlesFont = _titleFont > 0?_titleFont:14;
    pagerView.topTabUnderLineHidden = _underLineHidden;
    pagerView.blockHeight = _sliderHeight > 0?_sliderHeight:tabHeight;
    pagerView.bottomLinePer = _selectBottomLinePer > 0?_selectBottomLinePer:1;
    pagerView.bottomLineHeight = _selectBottomLineHeight > 0?_selectBottomLineHeight:2;
    pagerView.sliderCornerRadius = _slideBlockCornerRadius > 0?_slideBlockCornerRadius:0;
    pagerView.titleArray = titlesArray;
    if (_nina_navigationBarHidden == YES) {
        self.viewController.automaticallyAdjustsScrollViewInsets = NO;
        pagerView.topTab.frame = CGRectMake(0, 20, FUll_VIEW_WIDTH, tabHeight);
        pagerView.scrollView.frame = CGRectMake(0, tabHeight + 20, FUll_VIEW_WIDTH, self.frame.size.height - tabHeight);
    }
    if (_ninaDefaultPage > 0) {
        pagerView.scrollView.contentOffset = CGPointMake(FUll_VIEW_WIDTH * _ninaDefaultPage, 0);
    }
    if (classArray.count > 0 && titlesArray.count > 0 && ableLoadData) {
        if (_loadWholePages) {
            for (NSInteger i = 0; i< classArray.count; i++) {
                [self loadWholeOrNotWithTag:i WithMode:1];
            }
        }else {
            [self loadWholeOrNotWithTag:_ninaDefaultPage WithMode:0];
        }
    }
    if (_loadWholePages) {
        for (NSInteger i = 0; i < vcsArray.count; i++) {
            [self.viewController addChildViewController:vcsArray[i]];
        }
    }else {
        if (firstVC != nil) {
            [self.viewController addChildViewController:firstVC];
        }
    }
    self.viewController.navigationController.navigationBar.translucent = NO;
}

#pragma mark - NSCache
- (NSCache *)limitControllerCache {
    if (!_limitControllerCache) {
        _limitControllerCache = [NSCache new];
        _limitControllerCache.delegate = self;
    }
    /**< Set max of controller's number   **/
    _limitControllerCache.countLimit = 5;
    return _limitControllerCache;
}

#pragma mark - CreateView
- (void)createPagerView:(NSArray *)titles WithVCs:(NSArray *)childVCs {
    viewNumArray = [NSMutableArray array];
    vcsArray = [NSMutableArray array];
    vcsTagArray = [NSMutableArray array];
    if (titles.count > 0 && childVCs.count > 0) {
        pagerView = [[NinaBaseView alloc] initWithFrame:self.bounds WithTopTabType:_ninaPagerStyles];
        [pagerView addObserver:self forKeyPath:kObserverPage options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        [self addSubview:pagerView];
        //First ViewController present to the screen
        ableLoadData = YES;
    }else {
        NSLog(@"You should correct titlesArray or childVCs count!");
    }
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (object == pagerView && [keyPath isEqualToString:kObserverPage]) {
        NSInteger page = [change[@"new"] integerValue];
        if (isDebugging) {
            NSLog(@"It's controller %li",(long)page + 1);
        }
        self.PageIndex = @(page).stringValue;
        if ([self.delegate respondsToSelector:@selector(ninaCurrentPageIndex:)]) {
            [self.delegate ninaCurrentPageIndex:self.PageIndex];
        }
        if (titlesArray.count > 5) {
            CGFloat topTabOffsetX = 0;
            if (page >= 2) {
                if (page <= titlesArray.count - 3) {
                    topTabOffsetX = (page - 2) * More5LineWidth;
                }
                else {
                    if (page == titlesArray.count - 2) {
                        topTabOffsetX = (page - 3) * More5LineWidth;
                    }else {
                        topTabOffsetX = (page - 4) * More5LineWidth;
                    }
                }
            }
            else {
                if (page == 1) {
                    topTabOffsetX = 0 * More5LineWidth;
                }else {
                    topTabOffsetX = page * More5LineWidth;
                }
            }
            [pagerView.topTab setContentOffset:CGPointMake(topTabOffsetX, 0) animated:YES];
        }
        if (!_loadWholePages) {
            for (NSInteger i = 0; i < titlesArray.count; i++) {
                if (page == i && i <= classArray.count - 1) {
                    if ([classArray[i] isKindOfClass:[NSString class]]) {
                        NSString *className = classArray[i];
                        Class class = NSClassFromString(className);
                        if ([class isSubclassOfClass:[UIViewController class]] && viewAlloc[i] == NO) {
                            UIViewController *ctrl = nil;
                            ctrl = class.new;
                            [self createOtherViewControllers:ctrl WithControllerTag:i];
                        }else if ([class isSubclassOfClass:[UIView class]]) {
                            UIView *singleView =class.new;
                            singleView.frame = CGRectMake(FUll_VIEW_WIDTH * i, 0, FUll_VIEW_WIDTH, self.frame.size.height - _topTabHeight);
                            [pagerView.scrollView addSubview:singleView];
                        }else if (!class) {
                            NSLog(@"Your Vc%li is not found in this project!",(long)i + 1);
                        }
                    }else {
                        if ([classArray[i] isKindOfClass:[UIViewController class]]) {
                            UIViewController *ctrl = classArray[i];
                            if (ctrl && viewAlloc[i] == NO) {
                                [self createOtherViewControllers:ctrl WithControllerTag:i];
                            }else if (!ctrl) {
                                NSLog(@"Your Vc%li is not found in this project!",(long)i + 1);
                            }
                        }else if ([classArray[i] isKindOfClass:[UIView class]]) {
                            UIView *singleView = classArray[i];
                            singleView.frame = CGRectMake(FUll_VIEW_WIDTH * i, 0, FUll_VIEW_WIDTH, self.frame.size.height - _topTabHeight);
                            [pagerView.scrollView addSubview:singleView];
                        }
                    }
                }else if (page == i && i > classArray.count - 1) {
                    NSLog(@"You are not set title%li 's controller.",(long)i + 1);
                }else {
                    /**<  The number of controllers max is 5.   **/
                    if ([self.delegate respondsToSelector:@selector(deallocVCsIfUnnecessary)] && !_loadWholePages && _ninaDefaultPage == 0) {
                        if (vcsArray.count > 5 && [self.delegate deallocVCsIfUnnecessary] == YES) {
                            UIViewController *deallocVC = [vcsArray firstObject];
                            NSInteger deallocTag = [[vcsTagArray firstObject] integerValue];
                            if (![self.limitControllerCache objectForKey:@(deallocTag)]) {
                                [self.limitControllerCache setObject:deallocVC forKey:@(deallocTag)];
                            };
                            [deallocVC.view removeFromSuperview];
                            deallocVC.view = nil;
                            [deallocVC removeFromParentViewController];
                            deallocVC = nil;
                            [vcsArray removeObjectAtIndex:0];
                            viewAlloc[deallocTag] = NO;
                            [vcsTagArray removeObjectAtIndex:0];
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - Dealloc
- (void)dealloc {
    [pagerView removeObserver:self forKeyPath:kObserverPage context:nil];
}

#pragma mark - NSCacheDelegate
/**<  NSCache delegate method，print current dealloc object. **/
- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    if (isDebugging) {
        NSLog(@"Dealloc -------> %@", obj);
    }
}

#pragma mark - Private Method
/**
 *  Create first controller or views.
 *
 *  @param ctrl first controller.
 */
- (void)createFirstViewController:(UIViewController *)ctrl {
    firstVC = ctrl;
    ctrl.view.frame = CGRectMake(FUll_VIEW_WIDTH * _ninaDefaultPage, 0, FUll_VIEW_WIDTH, self.frame.size.height - _topTabHeight);
    [pagerView.scrollView addSubview:ctrl.view];
    /**<  Add new test cache   **/
    if (![self.limitControllerCache objectForKey:@(0)]) {
        [self.limitControllerCache setObject:ctrl forKey:@(0)];
    };
    viewAlloc[_ninaDefaultPage] = YES;
    [vcsArray addObject:ctrl];
    NSString *transString = [NSString stringWithFormat:@"%li",(long)_ninaDefaultPage];
    [vcsTagArray addObject:transString];
    if (isDebugging) {
        NSLog(@"Controller or view %@",transString);
        NSLog(@"Use new created controller or view %@",transString);
    }
    self.PageIndex = @"1";
}

/**
 *  Create other controllers or views.
 *
 *  @param ctrl controllers.
 *  @param i    controller's tag.
 */
- (void)createOtherViewControllers:(UIViewController *)ctrl WithControllerTag:(NSInteger)i {
    [self.viewController addChildViewController:ctrl];
    [vcsArray addObject:ctrl];
    NSString *tagStr = @(i).stringValue;
    [vcsTagArray addObject:tagStr];
    if (isDebugging) {
        NSLog(@"Use new created controller or view%li",(long)i + 1);
    }
    /**<  The number of controllers max is 5.   **/
    if ([self.delegate respondsToSelector:@selector(deallocVCsIfUnnecessary)] && !_loadWholePages && _ninaDefaultPage == 0) {
        if (vcsArray.count > 5 && [self.delegate deallocVCsIfUnnecessary] == YES) {
            UIViewController *deallocVC = [vcsArray firstObject];
            NSInteger deallocTag = [[vcsTagArray firstObject] integerValue];
            if (![self.limitControllerCache objectForKey:@(deallocTag)]) {
                [self.limitControllerCache setObject:deallocVC forKey:@(deallocTag)];
            };
            [deallocVC.view removeFromSuperview];
            deallocVC.view = nil;
            [deallocVC removeFromParentViewController];
            deallocVC = nil;
            [vcsArray removeObjectAtIndex:0];
            viewAlloc[deallocTag] = NO;
            if (isDebugging) {
                NSLog(@"Controller or view %li is dealloced",(long)deallocTag + 1);
            }
            [vcsTagArray removeObjectAtIndex:0];
        }
    }
    ctrl.view.frame = CGRectMake(FUll_VIEW_WIDTH * i, 0, FUll_VIEW_WIDTH, self.frame.size.height - _topTabHeight);
    [pagerView.scrollView addSubview:ctrl.view];
    viewAlloc[i] = YES;
}

/**
 *  Load whole page or not.
 *
 *  @param ninaTag Viewcontroller or view tag.
 *  @param mode Load whole page mode.
 */
- (void)loadWholeOrNotWithTag:(NSInteger)ninaTag WithMode:(NSInteger)mode {
    if ([classArray[ninaTag] isKindOfClass:[NSString class]]) {
        NSString *className = classArray[ninaTag];
        Class class = NSClassFromString(className);
        if ([class isSubclassOfClass:[UIViewController class]]) {
            UIViewController *ctrl = class.new;
            if (mode == 0) {
                [self createFirstViewController:ctrl];
            }else {
                [self createOtherViewControllers:ctrl WithControllerTag:ninaTag];
            }
        }else if ([class isSubclassOfClass:[UIView class]]) {
            UIView *singleView =class.new;
            singleView.frame = CGRectMake(FUll_VIEW_WIDTH * ninaTag, 0, FUll_VIEW_WIDTH, self.frame.size.height - _topTabHeight);
            [pagerView.scrollView addSubview:singleView];
        }
    }else {
        if ([classArray[ninaTag] isKindOfClass:[UIViewController class]]) {
            UIViewController *ctrl = classArray[ninaTag];
            if (mode == 0) {
                [self createFirstViewController:ctrl];
            }else {
                [self createOtherViewControllers:ctrl WithControllerTag:ninaTag];
            }
        }else if ([classArray[ninaTag] isKindOfClass:[UIView class]]) {
            UIView *singleView = classArray[ninaTag];
            singleView.frame = CGRectMake(FUll_VIEW_WIDTH * ninaTag, 0, FUll_VIEW_WIDTH, self.frame.size.height - _topTabHeight);
            [pagerView.scrollView addSubview:singleView];
        }
    }
}

@end
