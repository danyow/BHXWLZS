//
//  MTRUnderlineSegmentView.h
//  DPUIHD
//
//  Created by Danyow on 2016/12/6.
//  Copyright © 2016年 LACHESIS 联新. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kUnderlineSegmentViewImageName;
UIKIT_EXTERN NSString * const kUnderlineSegmentViewTitleText;

@class MTRUnderlineSegmentView;

@protocol MTRUnderlineSegmentViewDelegate <NSObject>

/** 在方法里面滑动ScrollView即可 */
- (void)underlineSegmentView:(MTRUnderlineSegmentView *)segmentView didPressedWithselectedIndex:(NSInteger)selectedIndex;

@end

@interface MTRUnderlineSegmentView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray<NSDictionary <NSString *, id>*> *segments;
@property (nonatomic, weak  ) id<MTRUnderlineSegmentViewDelegate> delegate;
@property (nonatomic, copy) void (^selectedIndexBlock)(NSInteger selectedIndex);
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIFont  *selectedFont;        //!< 没做动画处理
@property (nonatomic, strong) UIFont  *normalFont;          //!< 没做动画处理
@property (nonatomic, assign) UIEdgeInsets underlineEdge;

/** 属性设置 */
- (void)setNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;
- (void)setNormalFont:(UIFont *)normalFont selectedFont:(UIFont *)selectedFont;
- (void)setNormalFontSize:(CGFloat)normalFontSize selectedFontSize:(CGFloat)selectedFontSize;




/** 在对应的里面必须调用 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end
