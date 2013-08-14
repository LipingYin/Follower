//
//  HZScrollerController.h
//  Follower
//
//  Created by Liping Yin on 13-8-14.
//  Copyright (c) 2013年 Liping Yin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZScrollerBar.h"

@protocol  HZScrollerControllerDelegate;

@interface HZScrollerController : UIViewController

@property (nonatomic, weak) id <HZScrollerControllerDelegate> delegate;
@property (nonatomic, strong) IBOutlet HZScrollerBar *scrollerBar;
@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic) NSInteger selectedIndex;

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated;
@end

@protocol HZScrollerControllerDelegate <NSObject>

@optional
- (BOOL)scrollerController:(HZScrollerController*)scrollerController shouldSelectViewController:(UIViewController*)viewController;
- (void)scrollerController:(HZScrollerController*)scrollerController didSelectViewController:(UIViewController*)viewController;

@end