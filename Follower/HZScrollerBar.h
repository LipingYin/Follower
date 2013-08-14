//
//  HZScrollerBar.h
//  Follower
//
//  Created by Liping Yin on 13-8-14.
//  Copyright (c) 2013年 Liping Yin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZScrollerItem.h"

typedef NS_ENUM(NSUInteger, HZAnimatedDirection){
    HZAnimatedNo,
    HZAnimatedLeft,
    HZAnimatedRight,
    HZAnimatedTop,
    HZAnimatedBottom,
};

@protocol HZScrollerBarDelegate;

@interface HZScrollerBar : UIView

@property (nonatomic, weak) id <HZScrollerBarDelegate> delegate;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, strong) HZScrollerItem *selectedItem;

- (void)setItems:(NSArray *)items animated:(BOOL)animated;
- (void)selectItemAtIndex:(NSUInteger)index animated:(BOOL)animated;
- (void)setTitleView:(UIView *)titleView animatedDirection:(HZAnimatedDirection)direction;
- (void)setPopTitle:(NSString *)title at:(NSUInteger)index;
- (void)highOpacity;
- (void)lowOpacity;

@end

@protocol HZScrollerBarDelegate <NSObject>

- (void)scrollerBar:(HZScrollerBar*)scrollerBar didSelectItem:(HZScrollerItem*)item atIndex:(NSUInteger)index;

@end