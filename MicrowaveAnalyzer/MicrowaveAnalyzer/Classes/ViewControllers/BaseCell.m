//
//  BaseCell.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 08.06.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseCell.h"

@interface BaseCell ()

@property (nonatomic, copy) NSString *reuseId;

@end

@implementation BaseCell

+ (CGFloat)cellHeight {
    return 60.f;
}

+ (id)cellWithReuseIdentifier:(NSString *)reuseIdentifier {
    NSArray *result = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    for (id object in result) {
        if ([object isKindOfClass:[UIView class]]) {
            [object setReuseId:reuseIdentifier];
            return object;
        }
    }
    return nil;
}

- (NSString *)reuseIdentifier {
    return _reuseId;
}

@end
