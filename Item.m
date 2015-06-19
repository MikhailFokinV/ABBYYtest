//
//  Item.m
//  AbbyyTest
//
//  Created by Mikhail Fokin on 18.06.15.
//  Copyright (c) 2015 Mikhail Fokin. All rights reserved.
//

#import "Item.h"

@interface Item()

@property (nonatomic, strong) NSString *name;

@end

@implementation Item

+ (Item *)randomItem {
    Item *item = [Item new];
    item.name = [NSString stringWithFormat:@"#%u", arc4random()];
    return  item;
}

+ (Item *)itemWithName:(NSString *)name {
    Item *item = [Item new];
    item.name = name;
    return item;
}

- (NSString *)getName {
    return _name;
}

@end
