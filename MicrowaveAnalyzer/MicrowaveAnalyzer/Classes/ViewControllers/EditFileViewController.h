//
//  EditFileViewController.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 05.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseViewController.h"

@interface EditFileViewController : BaseViewController <UITextViewDelegate>

- (id)initWithFileName:(NSString *)fileName;

@end
