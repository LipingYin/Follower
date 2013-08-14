//
//  HZScrollerItem.m
//  Follower
//
//  Created by Liping Yin on 13-8-14.
//  Copyright (c) 2013年 Liping Yin. All rights reserved.
//

#import "HZScrollerItem.h"

@implementation HZScrollerItem

+ (id)scrollerItemWithImage:(UIImage*)img hintImage:(UIImage*)hintImg
{
    HZScrollerItem *item = [[self class] buttonWithType:UIButtonTypeCustom];
    
    [item setBackgroundImage:img forState:UIControlStateNormal];
    [item setBackgroundImage:hintImg forState:UIControlStateHighlighted];
    [item setBackgroundImage:hintImg forState:UIControlStateSelected];
    
    return item;
}

@end
