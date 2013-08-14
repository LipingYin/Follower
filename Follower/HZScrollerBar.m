//
//  HZScrollerBar.m
//  Follower
//
//  Created by Liping Yin on 13-8-14.
//  Copyright (c) 2013年 Liping Yin. All rights reserved.
//

#import "HZScrollerBar.h"
#import <QuartzCore/QuartzCore.h>

const static CGFloat kItemWidth = 20.0f;
const static CGFloat kitemDistance = 3.0f;
const static CGFloat kItemHeight = 20.0f;
const static CGFloat kMargin = 12.0f;

@interface HZScrollerBar ()
{
    NSString *_popTitle;
    NSUInteger _index;
}

@property (nonatomic, strong) NSNumber *selectedItemIndex;
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) CALayer *shadowLayer;
// about pop view
@property (nonatomic, strong) UIImageView *popView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImage *resizeableImage;

@end

@implementation HZScrollerBar

- (void)doInitBar
{
    // background color
    self.backgroundColor = [UIColor whiteColor];
    
    // title view's container
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, self.frame.size.height)];
    _containerView.backgroundColor = self.backgroundColor;
    _containerView.clipsToBounds = YES;
    [self addSubview:_containerView];
    
    // title in pop view
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 18, 56, 18)];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.opaque = YES;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // indicaotr pop view
    _popView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Bg_NewTip"]];
    [_popView addSubview:_titleLabel];
    _popView.hidden = YES;
    
    [self addSubview:_popView];
    
    // bottom shadow
    UIImage *shadowImage = [UIImage imageNamed:@"Shadow_Tabbar"];
    
    _shadowLayer = [CALayer layer];
    _shadowLayer.contentsScale = self.layer.contentsScale;
    _shadowLayer.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, shadowImage.size.height);
    _shadowLayer.contents = (__bridge id)([shadowImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 4)].CGImage);
    _shadowLayer.opacity = 0.4f;
    
    [self.layer insertSublayer:_shadowLayer atIndex:0];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self doInitBar];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self doInitBar];
}

- (void)setItems:(NSArray *)items animated:(BOOL)animated
{
    if (![_items isEqualToArray:items])
    {
        // clear the old item
        [_items enumerateObjectsUsingBlock:^(HZScrollerItem *item, NSUInteger idx, BOOL *stop){
            [item removeFromSuperview];
        }];
        
        // add the new items
        _items = items;
        
        CGFloat x = self.frame.size.width - (kMargin + kItemWidth*items.count + kitemDistance*(items.count-1));
        
        // set container view width
        CGRect containerFrame = self.containerView.frame;
        containerFrame.size.width = x;
        self.containerView.frame = containerFrame;
        
        [items enumerateObjectsUsingBlock:^(HZScrollerItem *item, NSUInteger idx, BOOL *stop){
            
            item.frame = CGRectMake(x+(kItemWidth+kitemDistance)*idx, (self.frame.size.height-kItemHeight)/2, kItemWidth, kItemHeight);
            
            [item addTarget:self action:@selector(itemAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:item];
        }];
    }
}

- (void)itemAction:(HZScrollerItem*)item
{
    
    NSUInteger index = [self.items indexOfObject:item];
    
    [self setSelectedItemIndex:@(index)];
    
    if ([self.delegate respondsToSelector:@selector(scrollerBar:didSelectItem:atIndex:)])
    {
        [self.delegate scrollerBar:self didSelectItem:item atIndex:index];
    }
}

- (void)setSelectedItemIndex:(NSNumber*)selectedItemIndex
{
    if (![_selectedItemIndex isEqualToNumber:selectedItemIndex])
    {
        _selectedItemIndex = selectedItemIndex;
        
        self.selectedItem.selected = NO;
        
        HZScrollerItem *item = self.items[selectedItemIndex.integerValue];
        item.selected = YES;
        
        self.selectedItem = item;
    }
}

- (void)selectItemAtIndex:(NSUInteger)index animated:(BOOL)animated
{
    self.selectedItemIndex = @(index);
}

- (void)setTitleView:(UIView *)titleView animatedDirection:(HZAnimatedDirection)direction
{
    if (!titleView)
    {
        return;
    }
    
    CGAffineTransform newViewTransform;
    newViewTransform = CGAffineTransformMakeTranslation(kMargin, (self.frame.size.height-titleView.frame.size.height)/2);
    
    if (!_titleView || direction == HZAnimatedNo)
    {
        [_titleView removeFromSuperview];
        
        titleView.transform = newViewTransform;
        [self.containerView addSubview:titleView];
        
        _titleView = titleView;
    }
    else
    {
        CGAffineTransform oldViewTransform;
        CGFloat newViewY = (self.containerView.frame.size.height-titleView.frame.size.height)/2;
        
        switch (direction) {
            case HZAnimatedLeft:
                oldViewTransform = CGAffineTransformMakeTranslation(self.containerView.frame.size.width, _titleView.frame.origin.y);
                titleView.transform = CGAffineTransformMakeTranslation(-titleView.frame.size.width, newViewY);
                break;
                
            case HZAnimatedRight:
                oldViewTransform = CGAffineTransformMakeTranslation(-_titleView.frame.size.width, _titleView.frame.origin.y);
                titleView.transform = CGAffineTransformMakeTranslation(self.containerView.frame.size.width, newViewY);
                break;
                
            case HZAnimatedTop:
                oldViewTransform = CGAffineTransformMakeTranslation(kMargin, self.containerView.frame.size.height);
                titleView.transform = CGAffineTransformMakeTranslation(kMargin, -titleView.frame.size.height);
                break;
                
            case HZAnimatedBottom:
                oldViewTransform = CGAffineTransformMakeTranslation(kMargin, -_titleView.frame.size.height);
                titleView.transform = CGAffineTransformMakeTranslation(kMargin, self.containerView.frame.size.height);
                break;
                
            default:
                break;
        }
        
        titleView.alpha = 0.25;
        [self.containerView addSubview:titleView];
        
        [UIView animateWithDuration:0.36
                         animations:^{
                             _titleView.transform = oldViewTransform;
                             _titleView.alpha = 0.25;
                             titleView.transform = newViewTransform;
                             titleView.alpha = 0.7;
                         }
                         completion:^(BOOL finished){
                             [_titleView removeFromSuperview];
                             _titleView = titleView;
                             
                             [UIView animateWithDuration:0.2
                                              animations:^{
                                                  titleView.alpha = 1.0;
                                              }];
                         }];
    }
    
}

#pragma mark - pop view
- (UIImage *)resizeableImage
{
    if (_resizeableImage == nil)
    {
        _resizeableImage = [[UIImage imageNamed:@"Bg_NewTip"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 50)];
    }
    
    return _resizeableImage;
}

- (void)setPopTitle:(NSString *)title at:(NSUInteger)index
{
    
    if (![_popTitle isEqualToString:title])
    {
        _popTitle = title;
        
        CGSize titleSize = [title sizeWithFont:self.titleLabel.font];
        CGFloat popWidth = MIN(320.f, MAX(titleSize.width+36.f, 92.f));
        CGRect popFrame = self.popView.frame;
        popFrame.size.width = popWidth;
        self.popView.frame = popFrame;
        self.titleLabel.text = title;
        self.popView.image = self.resizeableImage;
    }
    
    if (_index != index)
    {
        _index = index;
        
        HZScrollerItem *item = self.items[index];
        CGRect popFrame = self.popView.frame;
        popFrame.origin.x = item.center.x - (self.popView.frame.size.width - 41.f);
        popFrame.origin.y = item.center.y + 2.f;
        self.popView.frame = popFrame;
    }
    
    self.popView.hidden = (!title);
    
}

#pragma mark - shadow
- (void)highOpacity
{
    if (self.shadowLayer.opacity < 1.f)
    {
        self.shadowLayer.opacity = 1.f;
    }
}

- (void)lowOpacity
{
    if (self.shadowLayer.opacity > 0.4f)
    {
        self.shadowLayer.opacity = 0.4f;
    }
}
@end
