//
//  MTRUnderlineSegmentView.m
//  DPUIHD
//
//  Created by Danyow on 2016/12/6.
//  Copyright © 2016年 LACHESIS 联新. All rights reserved.
//

#import "MTRUnderlineSegmentView.h"
//#import "ImageHelper.h"
#import "Masonry.h"

@interface SegmentButton : UIButton

@property (nonatomic, strong) UIImage *originalImage;

@end

@implementation SegmentButton

- (void)setTintColor:(UIColor *)tintColor
{
    [super setTintColor:tintColor];
    if (self.currentImage) {
//        [self setImage:[ImageHelper imageWithColor:tintColor baseImage:self.originalImage] forState:UIControlStateNormal];
    }
    [self setTitleColor:tintColor forState:UIControlStateNormal];
    if (!self.currentAttributedTitle.length) {
        return;
    }
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:self.titleLabel.attributedText];
    [string enumerateAttributesInRange:NSMakeRange(0, self.titleLabel.attributedText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        [string addAttributes:@{NSForegroundColorAttributeName : tintColor} range:range];
    }];
    [self setAttributedTitle:string forState:UIControlStateNormal];
}

@end


NSString * const kUnderlineSegmentViewImageName = @"name";
NSString * const kUnderlineSegmentViewTitleText = @"text";
NSString * const kIdentifierForNoneDelegate     = @"ID";

@interface MTRUnderlineSegmentView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray <SegmentButton *>*segmentButtons;
@property (nonatomic, strong) UIImageView *underLineImageView;

@property (nonatomic, assign) CGFloat normalR;
@property (nonatomic, assign) CGFloat normalG;
@property (nonatomic, assign) CGFloat normalB;
@property (nonatomic, assign) CGFloat normalA;

@property (nonatomic, assign) CGFloat selectedR;
@property (nonatomic, assign) CGFloat selectedG;
@property (nonatomic, assign) CGFloat selectedB;
@property (nonatomic, assign) CGFloat selectedA;

@property (nonatomic, assign) BOOL endDragging;             //!< 手指离开, 减速结束复位
@property (nonatomic, assign) BOOL lastForward;             //!< 上次是否向前
@property (nonatomic, assign) BOOL pressed;                 //!< 是否在点击 调用代理
@property (nonatomic, assign) NSInteger willSelectedIndex;  //!< 将要移动到

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;
- (void)setSelectedIndexRate:(CGFloat)indexRate forward:(BOOL)isForword;

/** 没有代理的时候自己创建一个collectionView来代替使用 */
@property (nonatomic, strong) UICollectionView *noneDelegateCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *noneDelegateFlowLayout;

@end

@implementation MTRUnderlineSegmentView

#pragma mark -
#pragma mark  public method

- (void)setNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor
{
    self.normalColor   = normalColor;
    self.selectedColor = selectedColor;
}

- (void)setNormalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont
{
    self.normalFont   = normalFont;
    self.selectedFont = selectedFont;
}

- (void)setNormalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize
{
    self.normalFont   = [UIFont systemFontOfSize:normalFontSize];
    self.selectedFont = [UIFont systemFontOfSize:selectedFontSize];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX < 0 || offsetX > scrollView.contentSize.width - scrollView.frame.size.width) {
        /** 弹簧时复位 */
        if (offsetX < 0) {
            [self setSelectedIndexRate:0 forward:self.lastForward];
        } else {
            [self setSelectedIndexRate:(scrollView.contentSize.width - scrollView.frame.size.width) / scrollView.frame.size.width forward:self.lastForward];
        }
        return;
    } else {
        CGFloat indexRate = offsetX / scrollView.frame.size.width;
        UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
        /** velocity < 0 为 滑动到右边 */
        CGFloat velocity = [pan velocityInView:scrollView].x;
        if (scrollView.dragging && !self.endDragging) {
            BOOL isForward = velocity < 0;
            [self setSelectedIndexRate:indexRate forward:isForward];
            self.lastForward = isForward;
        } else if (velocity != 0) {
            [self setSelectedIndexRate:indexRate forward:velocity < 0];
            self.lastForward = velocity < 0;
        } else {
            if (self.pressed) {
                if (self.willSelectedIndex == self.selectedIndex) {
                    [self setSelectedIndexRate:indexRate forward:self.lastForward];
                } else {
                    self.lastForward = self.willSelectedIndex > self.selectedIndex;
                    [self setSelectedIndexRate:indexRate forward:self.willSelectedIndex > self.selectedIndex];
                }
            } else {
                [self setSelectedIndexRate:indexRate forward:self.lastForward];
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.endDragging = YES;
    if (scrollView.contentOffset.x < (*targetContentOffset).x) {
        if (!self.lastForward) {
            self.lastForward = !self.lastForward;
        }
    } else {
        if (self.lastForward) {
            self.lastForward = !self.lastForward;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.endDragging = NO;
    [self setSelectedIndex:scrollView.contentOffset.x / scrollView.frame.size.width + 0.5 animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
    self.pressed = NO;
}

#pragma mark -
#pragma mark  private method

- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated
{
    /** 复位 */
    self.selectedIndex = index;
    [self.segmentButtons enumerateObjectsUsingBlock:^(SegmentButton *segment, NSUInteger idx, BOOL *stop) {
        if (index == idx) {
            [segment setTintColor:self.selectedColor];
        } else {
            [segment setTintColor:self.normalColor];
        }
    }];
}

- (void)setSelectedIndexRate:(CGFloat)indexRate forward:(BOOL)isForword
{
    NSInteger moveToIndex = isForword ? ceil(indexRate) : floor(indexRate);
    NSInteger curretIndex = isForword ? floor(indexRate) : ceil(indexRate);
    CGFloat rate = 0;
    if (isForword) {
        rate = indexRate - curretIndex;
    } else {
        rate = (moveToIndex - indexRate) + 1;
    }
    
    /** SelectedColor */
    self.selectedIndex = moveToIndex;
    CGFloat mr = self.normalR + (ABS(self.selectedR - self.normalR)) * (self.selectedR > self.normalR ? rate : -rate);
    CGFloat mg = self.normalG + (ABS(self.selectedG - self.normalG)) * (self.selectedG > self.normalG ? rate : -rate);
    CGFloat mb = self.normalB + (ABS(self.selectedB - self.normalB)) * (self.selectedB > self.normalB ? rate : -rate);
    
    CGFloat cr = self.selectedR + (ABS(self.selectedR - self.normalR)) * (self.selectedR > self.normalR ? -rate : rate);
    CGFloat cg = self.selectedG + (ABS(self.selectedG - self.normalG)) * (self.selectedG > self.normalG ? -rate : rate);
    CGFloat cb = self.selectedB + (ABS(self.selectedB - self.normalB)) * (self.selectedB > self.normalB ? -rate : rate);
    
    [self.segmentButtons[curretIndex] setTintColor:[UIColor colorWithRed:cr green:cg blue:cb alpha:1]];
    if (curretIndex == moveToIndex) {
        [self.segmentButtons[moveToIndex] setTintColor:self.selectedColor];
    } else {
        [self.segmentButtons[moveToIndex] setTintColor:[UIColor colorWithRed:mr green:mg blue:mb alpha:1]];
    }
    
    /** underLineImageView */
    CGFloat currentWidth = self.segmentButtons[curretIndex].frame.size.width;
    CGFloat movetToWidth = self.segmentButtons[moveToIndex].frame.size.width;
    CGFloat width = currentWidth + ABS(currentWidth - movetToWidth) * (currentWidth > movetToWidth ? -rate : rate);
    [self.underLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).multipliedBy((CGFloat)(indexRate * 2 + 1) / self.segments.count);
        make.width.mas_offset(width - self.underlineEdge.left + self.underlineEdge.right);
        make.bottom.equalTo(self).offset(self.underlineEdge.bottom);
        make.height.mas_equalTo(1 + self.underlineEdge.top);
    }];
}

#pragma mark -
#pragma mark  event handle

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    /** 空白区域点击处理 */
    CGPoint point = [touches.anyObject locationInView:self];
    CGFloat floatIndex = point.x / (self.frame.size.width / self.segments.count);
    NSInteger index = floor(floatIndex);
    [self segmentPressed:self.segmentButtons[index]];
}

- (void)segmentPressed:(SegmentButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(underlineSegmentView:didPressedWithselectedIndex:)]) {
        self.willSelectedIndex = [self.segmentButtons indexOfObject:sender];
        self.pressed = YES;
        [self.delegate underlineSegmentView:self didPressedWithselectedIndex:self.willSelectedIndex];
    } else {
        if (!self.noneDelegateCollectionView.superview) {
            [self insertSubview:self.noneDelegateCollectionView atIndex:0];
            [self.noneDelegateCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            [self layoutIfNeeded];
        }
        self.willSelectedIndex = [self.segmentButtons indexOfObject:sender];
        self.pressed = YES;
        [self.noneDelegateCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.willSelectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        if (self.selectedIndexBlock) {
            self.selectedIndexBlock(self.willSelectedIndex);
        }
    }
}

#pragma mark -  None Delegate Collection View DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.segments.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kIdentifierForNoneDelegate forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}

#pragma mark -
#pragma mark  setter

- (void)setSegments:(NSArray<NSDictionary <NSString *, NSString *>*>*)segments
{
    _segments = segments;
    [self addSubview:self.underLineImageView];
    [self.segmentButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.segmentButtons removeAllObjects];
    [segments enumerateObjectsUsingBlock:^(NSDictionary<NSString *,NSString *> *segmentDict, NSUInteger idx, BOOL *stop) {
        SegmentButton *button = [[SegmentButton alloc] init];
        [segmentDict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL * _Nonnull stop) {
            if ([key isEqualToString:kUnderlineSegmentViewTitleText]) {
                if ([value isKindOfClass:[NSAttributedString class]]) {
                    [button setAttributedTitle:(NSAttributedString *)value forState:UIControlStateNormal];
                } else {
                    [button setTitle:value forState:UIControlStateNormal];
                }
            }
            if ([key isEqualToString:kUnderlineSegmentViewImageName]) {
                [button setOriginalImage:[UIImage imageNamed:value]];
                [button setImage:button.originalImage forState:UIControlStateNormal];
            }
        }];
        [button addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.segmentButtons addObject:button];
        if (button.currentImage) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];            
        }
        [button sizeToFit];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.centerX.equalTo(self).multipliedBy((CGFloat)(idx * 2 + 1) / self.segments.count);
            make.size.mas_equalTo(CGSizeMake(button.frame.size.width + 20, button.frame.size.height));
        }];
        if (self.selectedIndex == idx) {
            [self.underLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self).multipliedBy((CGFloat)(self.selectedIndex * 2 + 1) / self.segments.count);
                make.width.equalTo(button).offset(-self.underlineEdge.left + self.underlineEdge.right);
                make.bottom.equalTo(self).offset(self.underlineEdge.bottom);
                make.height.mas_equalTo(1 + self.underlineEdge.top);
            }];
        }
    }];
}

- (void)setNormalFont:(UIFont *)normalFont
{
    _normalFont = normalFont;
    [self.segmentButtons enumerateObjectsUsingBlock:^(SegmentButton *segment, NSUInteger idx, BOOL *stop) {
        if (self.selectedIndex != idx) {
            segment.titleLabel.font = normalFont;
        }
    }];
}

- (void)setSelectedFont:(UIFont *)selectedFont
{
    _selectedFont = selectedFont;
    [self.segmentButtons enumerateObjectsUsingBlock:^(SegmentButton *segment, NSUInteger idx, BOOL *stop) {
        if (self.selectedIndex == idx) {
            segment.titleLabel.font = selectedFont;
            *stop = YES;
            return ;
        }
    }];
}

- (void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
    [normalColor getRed:&(_normalR) green:&(_normalG) blue:&(_normalB) alpha:&(_normalA)];
    [self.segmentButtons enumerateObjectsUsingBlock:^(SegmentButton *segment, NSUInteger idx, BOOL *stop) {
        if (self.selectedIndex != idx) {
            [segment setTintColor:normalColor];
        }
    }];
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
    [selectedColor getRed:&(_selectedR) green:&(_selectedG) blue:&(_selectedB) alpha:&(_selectedA)];
    [self.segmentButtons enumerateObjectsUsingBlock:^(SegmentButton *segment, NSUInteger idx, BOOL *stop) {
        if (self.selectedIndex == idx) {
            [segment setTintColor:selectedColor];
        }
        [segment setTitleColor:selectedColor forState:UIControlStateHighlighted];
    }];
    self.underLineImageView.backgroundColor = selectedColor;
}

- (void)setUnderlineEdge:(UIEdgeInsets)underlineEdge
{
    _underlineEdge = underlineEdge;
    [self.underLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).multipliedBy((CGFloat)(self.selectedIndex * 2 + 1) / self.segments.count);
        make.width.equalTo(self.segmentButtons[self.selectedIndex]).offset(-self.underlineEdge.left + self.underlineEdge.right);
        make.bottom.equalTo(self).offset(self.underlineEdge.bottom);
        make.height.mas_equalTo(1 + self.underlineEdge.top);
    }];
    if (!self.delegate) {
        [self.noneDelegateCollectionView reloadData];
    }
}


#pragma mark -
#pragma mark  lazy load
- (NSMutableArray<SegmentButton *> *)segmentButtons
{
    if (!_segmentButtons) {
        _segmentButtons = [[NSMutableArray alloc] init];
    }
    return _segmentButtons;
}

- (UIImageView *)underLineImageView
{
    if (!_underLineImageView) {
        _underLineImageView = [[UIImageView alloc] init];
    }
    return _underLineImageView;
}

- (UICollectionView *)noneDelegateCollectionView
{
    if (!_noneDelegateCollectionView) {
        _noneDelegateCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.noneDelegateFlowLayout];
        _noneDelegateCollectionView.dataSource = self;
        _noneDelegateCollectionView.delegate = self;
        [_noneDelegateCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kIdentifierForNoneDelegate];
        _noneDelegateCollectionView.backgroundColor = self.backgroundColor;
        _noneDelegateCollectionView.userInteractionEnabled = NO;
    }
    return _noneDelegateCollectionView;
}

- (UICollectionViewFlowLayout *)noneDelegateFlowLayout
{
    if (!_noneDelegateFlowLayout) {
        _noneDelegateFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _noneDelegateFlowLayout.minimumLineSpacing = 0;
        _noneDelegateFlowLayout.minimumInteritemSpacing = 0;
        _noneDelegateFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _noneDelegateFlowLayout;
}

@end
