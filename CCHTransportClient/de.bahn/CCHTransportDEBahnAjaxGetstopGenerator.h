//
//  CCHTransportDEBahnAjaxGetstopGenerator.h
//  Departures
//
//  Created by Claus Höfele on 20.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportGenerator.h"

@interface CCHTransportDEBahnAjaxGetstopGenerator : NSObject<CCHTransportGenerator>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithSearchString:(NSString *)searchString maxNumberOfResults:(NSUInteger)maxNumberOfResults NS_DESIGNATED_INITIALIZER;
- (NSURLRequest *)generateRequest;

@end
