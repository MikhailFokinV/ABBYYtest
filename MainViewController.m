//
//  MainViewController.m
//  AbbyyTest
//
//  Created by Mikhail Fokin on 18.06.15.
//  Copyright (c) 2015 Mikhail Fokin. All rights reserved.
//

#import "MainViewController.h"
#import "ItemCategory.h"
#import "Item.h"

@interface MainViewController() <UITabBarDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _defaults = [NSUserDefaults standardUserDefaults];
    self.categories = [NSMutableArray arrayWithArray:[self loadCategories]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddItem"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"AddItem"];
            cell.textLabel.text = @"Tap to add new Item";
            cell.textLabel.textColor = [UIColor redColor];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"Cell"];
        }
        ItemCategory *category = _categories[indexPath.section];
        Item *item = [category getItem:indexPath.row - 1];
        cell.textLabel.text = item.getName;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ItemCategory *category = _categories[section];
    return category.itemsCount + 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_categories[section] getName];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    ItemCategory *sourceCategory = [_categories objectAtIndex:sourceIndexPath.section];
    Item *item = [sourceCategory getItem:sourceIndexPath.row - 1];
    
    NSMutableArray *items = [NSMutableArray arrayWithArray:[sourceCategory getItems]];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [items exchangeObjectAtIndex:sourceIndexPath.row - 1 withObjectAtIndex:destinationIndexPath.row - 1];
        [sourceCategory setItems:items];
        
    }else {
        [items removeObject:item];
        [sourceCategory setItems:items];
        
        ItemCategory *destinationCategory = [_categories objectAtIndex:destinationIndexPath.section];
        items = [NSMutableArray arrayWithArray:[destinationCategory getItems]];
        [items insertObject:item atIndex:destinationIndexPath.row - 1];
        [destinationCategory setItems:items];
    }
    [self deleteEmptySection:sourceIndexPath tableView:tableView];
    [self saveCategories];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ItemCategory *sourceCategory = [_categories objectAtIndex:indexPath.section];
        Item *item = [sourceCategory getItem:indexPath.row - 1];
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[sourceCategory getItems]];
        [tempArray removeObject:item];
        [sourceCategory setItems:tempArray];
        
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [tableView endUpdates];
        [self deleteEmptySection:indexPath tableView:tableView];
        [self saveCategories];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    return proposedDestinationIndexPath.row == 0 ? sourceIndexPath : proposedDestinationIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ItemCategory *category = [_categories objectAtIndex:indexPath.section];
        
        NSMutableArray *items = nil;
        
        items = [category getItems] ? [NSMutableArray arrayWithArray:[category getItems]] : [NSMutableArray array];
        
        NSInteger newItemIndex = 0;
        
        [items  insertObject:[Item randomItem] atIndex:newItemIndex];
        [category setItems:items];
        
        [self.tableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:newItemIndex + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        
        [self deleteEmptySection:indexPath tableView:tableView];
        [self saveCategories];
    }
}

- (IBAction)addNewCategory:(id)sender {
    ItemCategory *category = [ItemCategory new];
    [category setName:[NSString stringWithFormat:@"Group #%lu", (unsigned long)[_categories count]]];
    [category addItemsObject:[Item randomItem]];
    
    NSInteger firstSection = 0;
    [_categories insertObject:category atIndex:firstSection];
    
    [self.tableView beginUpdates];
    NSIndexSet *insertSection = [NSIndexSet indexSetWithIndex:firstSection];
    [self.tableView insertSections:insertSection withRowAnimation:UITableViewRowAnimationLeft];
    [self.tableView endUpdates];
    [self saveCategories];
}

- (IBAction)editActivation:(id)sender {
    BOOL isEditing = self.tableView.editing;
    [self.tableView setEditing:!isEditing animated:YES];
    UIBarButtonSystemItem item = UIBarButtonSystemItemEdit;
    
    if(self.tableView.editing) {
        item = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:item target:self action:@selector(editActivation:)];
    
    [self.navigationItem setRightBarButtonItem:editButton animated:YES];
    
}

- (void)saveCategories {
    NSMutableArray *array = [NSMutableArray new];
    for (ItemCategory *category in _categories) {
        [array addObject:[category asArray]];
        }
    [_defaults setObject:array forKey:@"categories"];
    [_defaults synchronize];
}

- (NSArray *)loadCategories {
    NSMutableArray *categories = [NSMutableArray new];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[_defaults objectForKey:@"categories"]];
    for (NSArray *arrayCategory in array) {
        [categories addObject:[ItemCategory readFromArray:arrayCategory]];
    }
    return categories;
}

- (void)deleteEmptySection:(NSIndexPath *)indexPath tableView:(UITableView *)tableView {
    if ([_categories[indexPath.section] getItems].count == 0) {
        [self.tableView beginUpdates];
        NSIndexSet *insertSection = [NSIndexSet indexSetWithIndex:indexPath.section];
        [_categories removeObjectAtIndex:indexPath.section];
        [tableView deleteSections:insertSection withRowAnimation:UITableViewRowAnimationRight];
       [self.tableView endUpdates];
        [tableView reloadData];
    }
}
@end
