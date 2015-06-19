//
//  Item.h
//  AbbyyTest
//
//  Created by Mikhail Fokin on 18.06.15.
//  Copyright (c) 2015 Mikhail Fokin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

- (NSString *)getName;
+ (Item *)randomItem;
+ (Item *)itemWithName:(NSString *)name;

@end
