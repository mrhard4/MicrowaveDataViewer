//
//  GraphViewController.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.04.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseViewController.h"

@interface GraphViewController : BaseViewController <CPTPlotSpaceDelegate>

- (id)initWithMeasurements:(NSDictionary *)measurements;

@end
