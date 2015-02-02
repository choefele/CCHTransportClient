//
//  CCHTransportDEBahnAjaxGetstopParser.h
//  Departures
//
//  Created by Hoefele, Claus on 21.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CCHTransportParser.h"

@interface CCHTransportDEBahnAjaxGetstopParser : NSObject<CCHTransportParser>

- (NSArray *)parseResponseWithData:(NSData *)data;

@end
