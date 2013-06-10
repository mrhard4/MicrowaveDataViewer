//
//  SelectCharacteristicViewController.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 03.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "SelectCharacteristicViewController.h"
#import "BaseCharacteristic.h"
#import "PortCharacteristic.h"

@interface Section : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *items;

@property (nonatomic, strong) Option *option;
@property (nonatomic, strong) BaseCharacteristic *characteistic;

@end

@implementation Section

@end



@interface SelectCharacteristicViewController ()

@end

@implementation SelectCharacteristicViewController {
    NSArray *_allCharacteristics;
    NSMutableArray *_selectedCharacteristics;
    
    BOOL _inSmithMode;
    
    NSMutableArray *_sections;
}

- (id)initWithCharacteristics:(NSArray *)characteristics selectedCharacteristics:(NSArray *)selectedCharacteristics inSmith:(BOOL)isSmith {
    if ((self = [super initWithTableViewStyle:UITableViewStyleGrouped])) {
        _inSmithMode = isSmith;
        
        _allCharacteristics = characteristics;
        _selectedCharacteristics = [selectedCharacteristics mutableCopy];
        if (!_selectedCharacteristics) {
            _selectedCharacteristics = [NSMutableArray new];
        }
        
        _allCharacteristics = [_allCharacteristics sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
        if (_inSmithMode) {
            _allCharacteristics = [_allCharacteristics filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return [evaluatedObject isKindOfClass:[PortCharacteristic class]];
            }]];
        }
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                               target:self
                                                                                               action:@selector(onDoneTap:)];
        
        if (!IS_IPAD) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                   target:self
                                                                                                   action:@selector(onCancelTap:)];
        }        
    }
    return self;
}

- (void)onDoneTap:(id)sender {
    if (_onComplete) {
        _onComplete(_selectedCharacteristics);
    }
    if (!IS_IPAD) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)onCancelTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)reload {
    _sections = [NSMutableArray new];
    for (BaseCharacteristic *c in _allCharacteristics) {
        Section *s = [Section new];
        s.items = @[c.title];
        s.characteistic = c;
        [_sections addObject:s];
        
        if ([_selectedCharacteristics containsObject:c]) {
            for (Option *o in c.options) {
                if (!o.parentOption || [o.parentIndexes containsObject:@(o.parentOption.selectedValueIndex)] ) {
                    s = [Section new];
                    s.title = o.title;
                    s.items = o.values;
                    s.option = o;
                    if (!_inSmithMode || ( _inSmithMode && o.isUniversal)) {
                        [_sections addObject:s];
                    }
                }
            }
        }
    }
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_sections[section] items] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_sections[section] title];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"] ? : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                                                                             reuseIdentifier:@"cell"];
    Section *section = _sections[indexPath.section];
    cell.textLabel.text = section.items[indexPath.row];
    
    BOOL isSelected = NO;
    if (section.characteistic && [_selectedCharacteristics containsObject:section.characteistic]) {
        isSelected = YES;
    } else if (section.option) {
        isSelected = indexPath.row == section.option.selectedValueIndex;
    }
    
    cell.accessoryType = isSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Section *section = _sections[indexPath.section];
    
    if (section.characteistic) {
        if ([_selectedCharacteristics containsObject:section.characteistic]) {
            [_selectedCharacteristics removeObject:section.characteistic];
        } else {
            [_selectedCharacteristics addObject:section.characteistic];
        }        
    } else if (section.option) {
        section.option.selectedValueIndex = indexPath.row;
    }
    
    [self reload];
}

@end
