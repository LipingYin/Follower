//
//  UIViewController+Scorller.m
//  Follower
//
//  Created by Liping Yin on 13-8-14.
//  Copyright (c) 2013年 Liping Yin. All rights reserved.
//

#import "UIViewController+Scorller.h"

#import <objc/runtime.h>

static const void *ScrollerControllerKey = &ScrollerControllerKey;
static const void *ScrollerItemKey = &ScrollerItemKey;
static const void *ScrollerTitleViewKey = &ScrollerTitleViewKey;

@implementation UIViewController (Scorller)
@dynamic scrollerController, scrollerItem;

- (HZScrollerController*)scrollerController
{
    return objc_getAssociatedObject(self, ScrollerControllerKey);
}

- (void)setScrollerController:(HZScrollerController *)scrollerController
{
    objc_setAssociatedObject(self, ScrollerControllerKey, scrollerController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HZScrollerItem *)scrollerItem
{
    return objc_getAssociatedObject(self, ScrollerItemKey);
}

- (void)setScrollerItem:(HZScrollerItem *)scrollerItem
{
    objc_setAssociatedObject(self, ScrollerItemKey, scrollerItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)scrollerTitleView
{
    return objc_getAssociatedObject(self, ScrollerTitleViewKey);
}

- (void)setScrollerTitleView:(UIView *)scrollerTitleView
{
    objc_setAssociatedObject(self, ScrollerTitleViewKey, scrollerTitleView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - extension method
// call this method when view did load
- (void)viewDidSelected:(BOOL)animated
{
    NSLog(@"Do Nothing");
}

- (BOOL)isModal
{
    
    BOOL isModal = ((self.parentViewController && self.parentViewController.modalViewController == self) ||
                    //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                    ( self.navigationController && self.navigationController.parentViewController && self.navigationController.parentViewController.modalViewController == self.navigationController) ||
                    //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                    [[[self tabBarController] parentViewController] isKindOfClass:[UITabBarController class]]);
    
    //iOS 5+
    if (!isModal && [self respondsToSelector:@selector(presentingViewController)]) {
        
        isModal = ((self.presentingViewController && self.presentingViewController.modalViewController == self) ||
                   //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                   (self.navigationController && self.navigationController.presentingViewController && self.navigationController.presentingViewController.modalViewController == self.navigationController) ||
                   //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                   [[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]]);
        
    }
    
    return YES;
    
}

#pragma mark - set pop view title
- (void)setScollerPopTitle:(NSString *)title at:(NSUInteger)index
{
    [self.scrollerController.scrollerBar setPopTitle:title at:index];
}

#pragma mark - shadow of scroller bar
- (void)highScrollerBarShadow
{
    [self.scrollerController.scrollerBar highOpacity];
}

- (void)lowScrollerBarShadow
{
    [self.scrollerController.scrollerBar lowOpacity];
}

- (BOOL)onModal
{
    return YES;
}

#pragma mark - scroll view delegate if viewcontroller have
// QQ: 是否有必要为了方便, 将这些东东放着
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self lowScrollerBarShadow];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self lowScrollerBarShadow];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self highScrollerBarShadow];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self highScrollerBarShadow];
}
@end
