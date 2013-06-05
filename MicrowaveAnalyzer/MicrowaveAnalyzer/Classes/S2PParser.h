//
//  S2PParser.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 02.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Measurements;

@interface S2PParser : NSObject

+ (NSDictionary *)parse:(NSString *)contentOfFile;

@end
