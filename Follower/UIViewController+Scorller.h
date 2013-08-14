//
//  UIViewController+Scorller.h
//  Follower
//
//  Created by Liping Yin on 13-8-14.
//  Copyright (c) 2013年 Liping Yin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZScrollerController.h"
#import "HZScrollerItem.h"
#import "HZScrollerBar.h"

@interface UIViewController (Scorller)
@property (strong, nonatomic) HZScrollerController *scrollerController;
@property (strong, nonatomic) HZScrollerItem *scrollerItem;
@property (strong, nonatomic) UIView *scrollerTitleView;

- (void)setScollerPopTitle:(NSString *)title at:(NSUInteger)index;
- (void)viewDidSelected:(BOOL)animated;
- (void)highScrollerBarShadow;
- (void)lowScrollerBarShadow;
- (BOOL)isModal;
- (BOOL)onModal;

@end
