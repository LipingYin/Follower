//
//  HZScrollerItem.h
//  Follower
//
//  Created by Liping Yin on 13-8-14.
//  Copyright (c) 2013年 Liping Yin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZScrollerItem : UIButton

@property (strong, nonatomic) NSString *itemName;

+ (id)scrollerItemWithImage:(UIImage*)img hintImage:(UIImage*)hintImg;
@end
