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

/**
 *　　　　　　　　┏┓　　　┏┓+ +
 *　　　　　　　┏┛┻━━━┛┻┓ + +
 *　　　　　　　┃　　　　　　　┃
 *　　　　　　　┃　　　━　　　┃ ++ + + +
 *　　　　　　 ████━████ ┃+
 *　　　　　　　┃　　　　　　　┃ +
 *　　　　　　　┃　　　┻　　　┃
 *　　　　　　　┃　　　　　　　┃ + +
 *　　　　　　　┗━┓　　　┏━┛
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃ + + + +
 *　　　　　　　　　┃　　　┃　　　　Code is far away from bug with the animal protecting
 *　　　　　　　　　┃　　　┃ + 　　　　神兽保佑,代码无bug
 *　　　　　　　　　┃　　　┃
 *　　　　　　　　　┃　　　┃　　+
 *　　　　　　　　　┃　 　　┗━━━┓ + +
 *　　　　　　　　　┃ 　　　　　　　┣┓
 *　　　　　　　　　┃ 　　　　　　　┏┛
 *　　　　　　　　　┗┓┓┏━┳┓┏┛ + + + +
 *　　　　　　　　　　┃┫┫　┃┫┫
 *　　　　　　　　　　┗┻┛　┗┻┛+ + + +
 */


#import "NinaBaseView.h"
#import "UIParameter.h"

@implementation NinaBaseView
{
    UIView *lineBottom;
    UIView *topTabBottomLine;
    NSMutableArray *btnArray;
    NSInteger topTabType;
    UIView *ninaMaskView;
}


- (instancetype)initWithFrame:(CGRect)frame WithTopTabType:(NSInteger)topTabNum
{
    self = [super initWithFrame:frame];
    topTabType = topTabNum;
    return self;
    
}

#pragma mark - SetMethod
- (void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    [self baseViewLoadData];
}

- (void)setBaseDefaultPage:(NSInteger)baseDefaultPage {
    _baseDefaultPage = baseDefaultPage;
}

- (void)setTitleScale:(CGFloat)titleScale {
    _titleScale = titleScale;
}

- (void)setBlockHeight:(CGFloat)blockHeight {
    _blockHeight = blockHeight;
}

- (void)setBottomLinePer:(CGFloat)bottomLinePer {
    _bottomLinePer = bottomLinePer;
}

- (void)setBottomLineHeight:(CGFloat)bottomLineHeight {
    _bottomLineHeight = bottomLineHeight;
}

- (void)setSliderCornerRadius:(CGFloat)sliderCornerRadius {
    _sliderCornerRadius = sliderCornerRadius;
}

- (void)setTitlesFont:(CGFloat)titlesFont {
    _titlesFont = titlesFont;
}

- (void)setTopTabUnderLineHidden:(BOOL)topTabUnderLineHidden {
    _topTabUnderLineHidden = topTabUnderLineHidden;
}

- (void)setTopHeight:(CGFloat)topHeight {
    _topHeight = topHeight;
}

- (void)setBtnUnSelectColor:(UIColor *)btnUnSelectColor {
    _btnUnSelectColor = btnUnSelectColor;
}

- (void)setBtnSelectColor:(UIColor *)btnSelectColor {
    _btnSelectColor = btnSelectColor;
}

- (void)setUnderlineBlockColor:(UIColor *)underlineBlockColor {
    _underlineBlockColor = underlineBlockColor;
}

- (void)setTopTabColor:(UIColor *)topTabColor {
    _topTabColor = topTabColor;
}

#pragma mark - LazyLoad
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.tag = 318;
        _scrollView.backgroundColor = UIColorFromRGB(0xfafafa);
        _scrollView.contentSize = CGSizeMake(FUll_VIEW_WIDTH * _titleArray.count, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

- (UIScrollView *)topTab {
    if (!_topTab) {
        _topTab = [[UIScrollView alloc] init];
        _topTab.delegate = self;
        if (_topTabColor) {
            _topTab.backgroundColor = _topTabColor;
        }else {
            _topTab.backgroundColor = [UIColor whiteColor];
        }
        _topTab.tag = 917;
        _topTab.scrollEnabled = YES;
        _topTab.alwaysBounceHorizontal = YES;
        _topTab.showsHorizontalScrollIndicator = NO;
        _topTab.bounces = NO;
        _topTab.scrollsToTop = NO;
        CGFloat additionCount = 0;
        if (_titleArray.count > 5) {
            additionCount = (_titleArray.count - 5.0) / 5.0;
        }
        _topTab.contentSize = CGSizeMake((1 + additionCount) * FUll_VIEW_WIDTH, _topHeight - TabbarHeight);
        if (_baseDefaultPage > 2 && _baseDefaultPage < _titleArray.count) {
            if (_titleArray.count >= 5) {
                _topTab.contentOffset = CGPointMake(1.0 / 5.0 * FUll_VIEW_WIDTH * (_baseDefaultPage - 2), 0);
            }else {
                _topTab.contentOffset = CGPointMake(1.0 / _titleArray.count * FUll_VIEW_WIDTH * (_baseDefaultPage - 2), 0);
            }
        }
        btnArray = [NSMutableArray array];
        for (NSInteger i = 0; i < _titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i;
            button.titleLabel.font = [UIFont systemFontOfSize:_titlesFont];
            if ([_titleArray[i] isKindOfClass:[NSString class]]) {
                [button setTitle:_titleArray[i] forState:UIControlStateNormal];
                button.titleLabel.numberOfLines = 0;
                button.titleLabel.textAlignment = NSTextAlignmentCenter;
            }else {
                NSLog(@"Your title%li not fit for topTab,please correct it to NSString!",(long)i + 1);
            }
            if (_titleArray.count > 5) {
                button.frame = CGRectMake(More5LineWidth * i, 0, More5LineWidth, _topHeight);
            }else {
                button.frame = CGRectMake(FUll_VIEW_WIDTH / _titleArray.count * i, 0, FUll_VIEW_WIDTH / _titleArray.count, _topHeight);
            }
            [_topTab addSubview:button];
            [button addTarget:self action:@selector(touchAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnArray addObject:button];
            if (i == 0 && (topTabType == 0 || topTabType == 2)) {
                if (_btnSelectColor) {
                    [button setTitleColor:_btnSelectColor forState:UIControlStateNormal];
                }else {
                    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
                if (_titleScale > 0) {
                    button.transform = CGAffineTransformMakeScale(_titleScale, _titleScale);
                }
            } else {
                if (_btnUnSelectColor) {
                    [button setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
                }else {
                    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
        }
        //Create Toptab underline.
        if (!_topTabUnderLineHidden) {
            topTabBottomLine = [UIView new];
            topTabBottomLine.backgroundColor = UIColorFromRGB(0xcecece);
            [_topTab addSubview:topTabBottomLine];
        }
        //Create Toptab bottomline.
        lineBottom = [UIView new];
        if (_underlineBlockColor) {
            lineBottom.backgroundColor = _underlineBlockColor;
        }else {
            lineBottom.backgroundColor = UIColorFromRGB(0xff6262);
        }
        lineBottom.clipsToBounds = YES;
        lineBottom.userInteractionEnabled = YES;
        [_topTab addSubview:lineBottom];
        //Create ninaMaskView.
        if (topTabType == 1) {
            ninaMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (1 + additionCount) * FUll_VIEW_WIDTH, _blockHeight)];
            ninaMaskView.backgroundColor = [UIColor clearColor];
            for (NSInteger j = 0; j < _titleArray.count; j++) {
                UILabel *maskLabel = [UILabel new];
                if (_titleArray.count > 5) {
                    maskLabel.frame = CGRectMake(More5LineWidth * j - More5LineWidth * (1 - _bottomLinePer) / 2, 0, More5LineWidth, _blockHeight);
                }else {
                    CGFloat labelOrginX = FUll_VIEW_WIDTH / _titleArray.count * j - FUll_VIEW_WIDTH /  _titleArray.count * (1 - _bottomLinePer) / 2;
                    CGFloat labelWidth = FUll_VIEW_WIDTH / _titleArray.count;
                    maskLabel.frame = CGRectMake(labelOrginX, 0,labelWidth , _blockHeight);
                }
                maskLabel.text = _titleArray[j];
                maskLabel.textColor = _btnSelectColor?_btnSelectColor:[UIColor whiteColor];
                maskLabel.numberOfLines = 0;
                maskLabel.textAlignment = NSTextAlignmentCenter;
                maskLabel.font = [UIFont systemFontOfSize:_titlesFont];
                [ninaMaskView addSubview:maskLabel];
            }
            [lineBottom addSubview:ninaMaskView];
        }
        if (topTabType == 2) {
            lineBottom.hidden = YES;
        }
    }
    return _topTab;
}

#pragma mark - BtnMethod
- (void)touchAction:(UIButton *)button {
    [_scrollView setContentOffset:CGPointMake(FUll_VIEW_WIDTH * button.tag, 0) animated:YES];
    self.currentPage = (FUll_VIEW_WIDTH * button.tag + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 318) {
        self.currentPage = (NSInteger)((scrollView.contentOffset.x + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 318) {
        NSInteger yourPage = (NSInteger)((scrollView.contentOffset.x + FUll_VIEW_WIDTH / 2) / FUll_VIEW_WIDTH);
        CGFloat yourCount = 1.0 / _titleArray.count;
        if (_titleArray.count > 5) {
            yourCount = 1.0 / 5.0;
        }
        CGFloat lineBottomDis = yourCount * FUll_VIEW_WIDTH * (1 -_bottomLinePer) / 2;
        if (topTabType == 1) {
            CGPoint maskCenter = ninaMaskView.center;
            if (_titleArray.count >= 5) {
                maskCenter.x = ninaMaskView.frame.size.width / 2.0 - (scrollView.contentOffset.x * 0.2);
            }else {
                maskCenter.x = ninaMaskView.frame.size.width / 2.0 - (scrollView.contentOffset.x * yourCount);
            }
            ninaMaskView.center = maskCenter;
        }
        if (_titleArray.count > 5) {
            switch (topTabType) {
                case 0:
                    if (_bottomLineHeight >= 3) {
                        CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
                        CGFloat lineBottomOrginX = scrollView.contentOffset.x / 5 + lineBottomDis;
                        CGRect rect = [self getCurrentOrginXAndWidth:yourPage orginX:lineBottomOrginX width:lineBottomWidth];
                        lineBottom.frame = CGRectMake(rect.origin.x, _topHeight - 3, rect.size.width, 3);
                        break;
                    }else{
                        CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
                        CGFloat lineBottomOrginX = scrollView.contentOffset.x / 5 + lineBottomDis;
                        CGRect rect = [self getCurrentOrginXAndWidth:yourPage orginX:lineBottomOrginX width:lineBottomWidth];
                        lineBottom.frame = CGRectMake(rect.origin.x, _topHeight - _bottomLineHeight, rect.size.width, _bottomLineHeight);
                    }
                    break;
                case 1:
                {
                    CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
                    CGFloat lineBottomOrginX = scrollView.contentOffset.x / 5 + lineBottomDis;
                    CGRect rect = [self getCurrentOrginXAndWidth:yourPage orginX:lineBottomOrginX width:lineBottomWidth];
                    lineBottom.frame = CGRectMake(rect.origin.x, (_topHeight - _blockHeight) / 2.0, rect.size.width, _blockHeight);
                }
                    break;
                default:
                    break;
            }
        }else {
            switch (topTabType) {
                case 0:
                    if (_bottomLineHeight >= 3) {
                        CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
                        CGFloat lineBottomOrginX = scrollView.contentOffset.x / _titleArray.count + lineBottomDis;
                        CGRect rect = [self getCurrentOrginXAndWidth:yourPage orginX:lineBottomOrginX width:lineBottomWidth];
                        lineBottom.frame = CGRectMake(rect.origin.x, _topHeight - 3, rect.size.width, 3);
                    }else {
                        CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
                        CGFloat lineBottomOrginX = scrollView.contentOffset.x / _titleArray.count +  lineBottomDis;
                        CGRect rect = [self getCurrentOrginXAndWidth:yourPage orginX:lineBottomOrginX width:lineBottomWidth];
                        lineBottom.frame = CGRectMake(rect.origin.x, _topHeight - _bottomLineHeight, rect.size.width, _bottomLineHeight);
                    }
                    break;
                case 1:
                {
                    CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
                    CGFloat lineBottomOrginX = scrollView.contentOffset.x / _titleArray.count + lineBottomDis;
                    CGRect rect = [self getCurrentOrginXAndWidth:yourPage orginX:lineBottomOrginX width:lineBottomWidth];
                    lineBottom.frame = CGRectMake(rect.origin.x, (_topHeight - _blockHeight) / 2.0, rect.size.width, _blockHeight);
                }
                    break;
                default:
                    break;
            }
        }
        for (NSInteger i = 0;  i < btnArray.count; i++) {
            if (topTabType == 0 || topTabType == 2) {
                if (_btnUnSelectColor) {
                    [btnArray[i] setTitleColor:_btnUnSelectColor forState:UIControlStateNormal];
                }else {
                    [btnArray[i] setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                }
            }
            UIButton *changeButton = btnArray[i];
            [UIView animateWithDuration:0.3 animations:^{
                changeButton.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
        if (topTabType == 0 || topTabType == 2) {
            if (_btnSelectColor) {
                [btnArray[yourPage] setTitleColor:_btnSelectColor forState:UIControlStateNormal];
            }else {
                [btnArray[yourPage] setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            UIButton *changeButton = btnArray[yourPage];
            if (_titleScale > 0) {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(_titleScale, _titleScale);
                }];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    changeButton.transform = CGAffineTransformMakeScale(1.15, 1.15);
                }];
            }
        }
    }
}

#pragma mark -计算底线的位置和宽度
- (CGRect)getCurrentOrginXAndWidth:(NSInteger)currentPage orginX:(CGFloat)orginX width:(CGFloat)lineBottomWidth {
    CGFloat currentOrginX = orginX;
    CGFloat currentBottomWidth = lineBottomWidth;
    if (_isAutoUnderLineWidth) {
        NSString *titleString = _titleArray[currentPage];
        UIFont *labelFont = [UIFont systemFontOfSize:_titlesFont];
        CGRect rect = [titleString boundingRectWithSize:CGSizeMake(currentBottomWidth, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:labelFont} context:nil];
        if (rect.size.width < lineBottomWidth) {
            currentOrginX += ((lineBottomWidth - rect.size.width)/2.0);
            currentBottomWidth = rect.size.width;
        }
    }
    return CGRectMake(currentOrginX, 0, currentBottomWidth, 0);
}

#pragma mark - LoadData
- (void)baseViewLoadData {
    self.topTab.frame = CGRectMake(0, 0, FUll_VIEW_WIDTH, _topHeight);
    self.scrollView.frame = CGRectMake(0, _topHeight, FUll_VIEW_WIDTH, self.frame.size.height - _topHeight);
    [self addSubview:self.topTab];
    [self addSubview:self.scrollView];
}

#pragma mark - LayOutSubViews
- (void)layoutSubviews {
    [super layoutSubviews];
    [self initUI];
}

- (void)initUI {
    CGFloat yourCount = 1.0 / _titleArray.count;
    CGFloat additionCount = 0;
    if (_titleArray.count > 5) {
        additionCount = (_titleArray.count - 5.0) / 5.0;
        yourCount = 1.0 / 5.0;
    }
    CGFloat lineBottomDis = yourCount * FUll_VIEW_WIDTH * (1 -_bottomLinePer) / 2;
    NSInteger defaultPage = (_baseDefaultPage > 0 && _baseDefaultPage < _titleArray.count)?_baseDefaultPage:0;
    switch (topTabType) {
        case 0:
            if (_bottomLineHeight >= 3) {
                CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
                CGFloat lineBottomOrginX = lineBottomDis;
                CGRect rect = [self getCurrentOrginXAndWidth:defaultPage orginX:lineBottomOrginX width:lineBottomWidth];
                lineBottom.frame = CGRectMake(rect.origin.x, _topHeight - 3, rect.size.width, 3);
            }else {
                CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
                CGFloat lineBottomOrginX = lineBottomDis + FUll_VIEW_WIDTH * yourCount * defaultPage;
                CGRect rect = [self getCurrentOrginXAndWidth:defaultPage orginX:lineBottomOrginX width:lineBottomWidth];
                lineBottom.frame = CGRectMake(rect.origin.x, _topHeight - _bottomLineHeight, rect.size.width, _bottomLineHeight);
            }
            break;
        case 1: {
            CGFloat lineBottomWidth = yourCount * FUll_VIEW_WIDTH * _bottomLinePer;
            CGFloat lineBottomOrginX = lineBottomDis + FUll_VIEW_WIDTH * yourCount * defaultPage;
            CGRect rect = [self getCurrentOrginXAndWidth:defaultPage orginX:lineBottomOrginX width:lineBottomWidth];
            lineBottom.frame = CGRectMake(rect.origin.x, (_topHeight - _blockHeight) / 2.0, rect.size.width, _blockHeight);
            if (_sliderCornerRadius > 0) {
                lineBottom.layer.cornerRadius = _blockHeight / _sliderCornerRadius;
            }
        }
            break;
        default:
            break;
    }
    if (!_topTabUnderLineHidden) {
        topTabBottomLine.frame = CGRectMake(0, _topHeight - 1, (1 + additionCount) * FUll_VIEW_WIDTH, 1);
    }
}

@end
