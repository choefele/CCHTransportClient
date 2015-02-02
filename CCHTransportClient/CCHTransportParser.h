//
//  CCHTransportParser.h
//  Departures
//
//  Created by Hoefele, Claus on 07.08.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CCHTransportParser <NSObject>

- (id)parseResponseWithData:(NSData *)data;

@end
