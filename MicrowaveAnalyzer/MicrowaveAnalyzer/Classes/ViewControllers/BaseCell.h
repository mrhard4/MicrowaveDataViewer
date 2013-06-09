//
//  BaseCell.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier;
+ (CGFloat)cellHeight;

@end
