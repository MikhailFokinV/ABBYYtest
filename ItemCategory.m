//
//  Category.m
//  AbbyyTest
//
//  Created by Mikhail Fokin on 18.06.15.
//  Copyright (c) 2015 Mikhail Fokin. All rights reserved.
//

#import "ItemCategory.h"

@interface ItemCategory()

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *items;

@end

@implementation ItemCategory

+ (ItemCategory *)readFromArray:(NSArray *)array {
    ItemCategory *category = [ItemCategory new];
    category.name = array[0];
    for (NSString *name in array[1]) {
        [category.items addObject:[Item itemWithName:name]];
    }
    return category;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (NSInteger)itemsCount {
    return _items.count;
}

- (Item *)getItem:(NSInteger)index {
    return _items[index];
}

- (NSString *)getName {
    return _name;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (void)addItemsObject:(Item *)object {
    [_items addObject:object];
}

- (NSArray *)getItems {
    return _items;
}

- (void)setItems:(NSMutableArray *)items {
    _items = items;
}

- (NSArray *)asArray {
    NSMutableArray *array = [NSMutableArray new];
    [array addObject:_name];
    NSMutableArray *arrayItem = [NSMutableArray new];
    for (Item *item in _items) {
        [arrayItem addObject:[item getName]];
    }
    [array addObject:arrayItem];
    return array;
}

@end
