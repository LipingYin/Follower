//
//  HZScrollerController.m
//  Follower
//
//  Created by Liping Yin on 13-8-14.
//  Copyright (c) 2013年 Liping Yin. All rights reserved.
//

#import "HZScrollerController.h"

@interface HZScrollerController () <UIScrollViewDelegate, UINavigationControllerDelegate, HZScrollerBarDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *maskView;
@end

@implementation HZScrollerController

- (void)dealloc
{
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"%@ - awake from nib", NSStringFromClass([self class]));
    _selectedIndex = -1;
    [self configureViewControllersFromStoryboard];
    self.scrollerBar.delegate = self;
}

- (void)configureViewControllersFromStoryboard
{
    // TODO: may use auto set
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"FollowerStoryboard" bundle:nil];
    self.viewControllers = @[[storyboard instantiateViewControllerWithIdentifier:@"loginVc"],
                             [storyboard instantiateViewControllerWithIdentifier:@"indexTc"],
                             [storyboard instantiateViewControllerWithIdentifier:@"settingTc"]];
    
}

- (UIView *)maskView
{
    if (_maskView == nil)
    {
        _maskView = [[UIView alloc] initWithFrame:self.view.bounds];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    
    return _maskView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"I'm in...");
    }
    return self;
}

- (void)resetScrollViewHeight
{
    CGRect scrollViewFrame = self.scrollView.frame;
    CGFloat deltaHeight = 0;
    if (self.scrollerBar.hidden == NO)
    {
        deltaHeight = self.scrollerBar.frame.size.height;
    }
    scrollViewFrame.size.height = self.view.frame.size.height - deltaHeight;
    scrollViewFrame.origin.y = deltaHeight;
    self.scrollView.frame= scrollViewFrame;
}

- (void)initTheHeaderViewItems
{
    NSMutableArray *items = [NSMutableArray array];
    [self.viewControllers enumerateObjectsUsingBlock:^(id vc, NSUInteger idx, BOOL *stop){
        
        [vc setScrollerController:self];
        
        HZScrollerItem *item = nil;
        
        if ([vc isKindOfClass:[UINavigationController class]])
        {
            [[vc topViewController] setScrollerController:self];
            [vc setDelegate:self];
            
            item = [[vc topViewController] scrollerItem];
        }
        else
        {
            item = [vc scrollerItem];
        }
        
        if (item)
        {
            [items addObject:item];
        }
        else
        {
            [items addObject:[HZScrollerItem scrollerItemWithImage:nil hintImage:nil]];
        }
    }];
    
    [self.scrollerBar setItems:items animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@ - view did load", NSStringFromClass([self class]));
    
    self.scrollerBar.delegate = self;
    
    [self initTheHeaderViewItems];
    
    self.scrollView.contentSize = CGSizeMake(self.viewControllers.count*self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    [self setSelectedIndex:1 animated:NO];
}

- (void)hideScorllerBar:(BOOL)hide
{
    self.scrollerBar.hidden = hide;
    [self resetScrollViewHeight];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
//    if (_selectedIndex != selectedIndex)
//    {
//        
//        UIViewController *vc = self.viewControllers[selectedIndex];
//        self.selectedViewController = vc;
//        
//        UIViewController *topVC = nil;
//        
//        if ([vc respondsToSelector:@selector(topViewController)])
//        {
//            topVC = [(id)vc topViewController];
//        }
//        else
//        {
//            topVC = vc;
//        }
//        
//        [self.scrollerBar setTitleView:[topVC scrollerTitleView] animatedDirection:(selectedIndex > _selectedIndex) ? HZAnimatedRight : HZAnimatedLeft];
//        
//        
//        if (vc.view.superview == nil)
//        {
//            [self addViewControllerToScroller:vc];
//            // TODO: trigger didselect method
//        }
//        else
//        {
//            [topVC viewDidSelected:YES];
//        }
//        
//        [self.scrollView scrollRectToVisible:vc.view.frame animated:animated];
//        [self.scrollerBar selectItemAtIndex:selectedIndex animated:animated];
//        
//        _selectedIndex = selectedIndex;
//    }
}

- (void)addViewControllerToScroller:(UIViewController*)viewController
{
    if (viewController.view.superview == nil)
    {
        NSUInteger index = [self.viewControllers indexOfObject:viewController];
        viewController.view.frame = CGRectMake(self.scrollView.frame.size.width*index, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:viewController.view];
        NSLog(@"add viewcontroller view success.");
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@ - view will appear", NSStringFromClass([self class]));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@ - view did appear", NSStringFromClass([self class]));
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    NSLog(@"%@ - view will disappear", NSStringFromClass([self class]));
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"%@ - view did disappear", NSStringFromClass([self class]));
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}


# pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([self.scrollView isEqual:scrollView])
    {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self setSelectedIndex:page animated:NO];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat currentLeftX = self.selectedViewController.view.frame.origin.x;
    
    CGFloat delta = ABS(offsetX - currentLeftX);
    if (delta > 10)
    {
        if (![self.maskView.superview isEqual:self.selectedViewController.view])
        {
            [self.selectedViewController.view addSubview:self.maskView];
        }
        self.maskView.alpha = 0.6*(delta/self.selectedViewController.view.frame.size.width);
    }
    else
    {
        if (self.maskView.superview)
        {
            [self.maskView removeFromSuperview];
        }
    }
}

#pragma mark - uinavigationcontroller delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    NSUInteger count = navigationController.viewControllers.count;
//    
//    self.scrollView.scrollEnabled = (count == 1); // 第一页可滑动
//    
//    viewController.scrollerController = self;
//    
//    if (count > 1 && [self.scrollerBar.superview isEqual:self.view])
//    {
//        [self.scrollerBar removeFromSuperview];
//        [[navigationController.viewControllers[0] view] addSubview:self.scrollerBar];
//    }
//    
    NSLog(@"view contller will show: %@", viewController);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSUInteger count = navigationController.viewControllers.count;
    
    if (count == 1 && ![self.scrollerBar.superview isEqual:self.view])
    {
        [self.scrollerBar removeFromSuperview];
        [self.view addSubview:self.scrollerBar];
    }
    
    NSLog(@"view contller did show: %@", viewController);
}

#pragma mark - scroller selected
- (void)scrollerBar:(HZScrollerBar *)scrollerBar didSelectItem:(HZScrollerItem *)item atIndex:(NSUInteger)index
{
    if ([scrollerBar isEqual:self.scrollerBar])
    {
        [self setSelectedIndex:index animated:YES];
    }
}
@end
