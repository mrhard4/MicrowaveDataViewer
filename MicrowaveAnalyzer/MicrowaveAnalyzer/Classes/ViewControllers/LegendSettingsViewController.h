//
//  LegendSettingsViewController.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseTableViewController.h"

@interface LegendSettingsViewController : BaseViewController <UITextFieldDelegate>

@property (nonatomic, copy) void(^willDismissCallback)(void);

@property (nonatomic) CGFloat minX;
@property (nonatomic) CGFloat minY;
@property (nonatomic) CGFloat maxX;
@property (nonatomic) CGFloat maxY;

@end
