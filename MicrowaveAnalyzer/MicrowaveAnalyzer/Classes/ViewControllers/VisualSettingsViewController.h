//
//  VisualSettingsViewController.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseTableViewController.h"

@class BaseCharacteristic;

@interface VisualSettingsViewController : BaseTableViewController

- (id)initWithCharacteristic:(BaseCharacteristic *)characteristic;

@end
