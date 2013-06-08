//
//  GraphsInfoViewController.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseTableViewController.h"

@interface GraphsInfoViewController : BaseTableViewController

@property (nonatomic, copy) void(^willDismissCallback)(void);

- (id)initWithCharacteristics:(NSMutableArray *)characteristics SmithMode:(BOOL)SmithMode;

@end
