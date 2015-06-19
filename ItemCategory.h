//
//  Category.h
//  AbbyyTest
//
//  Created by Mikhail Fokin on 18.06.15.
//  Copyright (c) 2015 Mikhail Fokin. All rights reserved.
//

#import "Item.h"

@interface ItemCategory : NSObject

+ (ItemCategory *)readFromArray:(NSArray *)array;
- (NSInteger)itemsCount;
- (Item *)getItem:(NSInteger)number;
- (NSString *)getName;
- (void)setName:(NSString *)name;
- (void)addItemsObject:(Item *)object;
- (NSArray *)getItems;
- (void)setItems:(NSMutableArray *)items;
- (NSArray *)asArray;

@end
