//
//  CCHTransportDEBahnBhftafelParser.h
//  Departures
//
//  Created by Claus Höfele on 12.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportParser.h"

@interface CCHTransportDEBahnBhftafelParser : NSObject<CCHTransportParser>

- (NSArray *)parseResponseWithData:(NSData *)data;

@end
