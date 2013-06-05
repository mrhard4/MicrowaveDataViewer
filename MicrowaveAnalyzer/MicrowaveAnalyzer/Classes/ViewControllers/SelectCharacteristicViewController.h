//
//  SelectCharacteristicViewController.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 03.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseTableViewController.h"

@interface SelectCharacteristicViewController : BaseTableViewController

@property (nonatomic, copy) void(^onComplete)(NSArray *selectedItems);

- (id)initWithCharacteristics:(NSArray *)characteristics selectedCharacteristics:(NSArray *)selectedCharacteristics;

@end
