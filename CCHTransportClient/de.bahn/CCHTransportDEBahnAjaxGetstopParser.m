//
//  CCHTransportDEBahnAjaxGetstopParser.m
//  Departures
//
//  Created by Hoefele, Claus on 21.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnAjaxGetstopParser.h"

#import "CCHTransportStation.h"

@implementation CCHTransportDEBahnAjaxGetstopParser

- (NSArray *)parseResponseWithData:(NSData *)data
{
    // Remove Javascript padding
    NSMutableString *dataAsString = [[NSMutableString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    NSRange startPadding = [dataAsString rangeOfString:@"SLs.sls=" options:NSAnchoredSearch];
    if (startPadding.location != NSNotFound) {
        [dataAsString deleteCharactersInRange:startPadding];
    }
    NSRange endPadding = [dataAsString rangeOfString:@";SLs.showSuggestion();" options:NSAnchoredSearch | NSBackwardsSearch];
    if (endPadding.location != NSNotFound) {
        [dataAsString deleteCharactersInRange:endPadding];
    }
    NSData *dataFixed = [dataAsString dataUsingEncoding:NSUTF8StringEncoding];

    NSDictionary *dataAsJSON = [NSJSONSerialization JSONObjectWithData:dataFixed options:0 error:NULL];
    
    NSMutableArray *stations = [NSMutableArray array];
    NSArray *stationsAsJSON = dataAsJSON[@"suggestions"];
    for (NSDictionary *stationAsJSON in stationsAsJSON) {
        NSString *stationID = [stationAsJSON valueForKey:@"extId"];
        NSString *name = [stationAsJSON valueForKey:@"value"];
        double longitude = [[stationAsJSON valueForKey:@"xcoord"] doubleValue] / 1E6;
        double latitude = [[stationAsJSON valueForKey:@"ycoord"] doubleValue] / 1E6;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

        CCHTransportStation *station = [[CCHTransportStation alloc] initWithStationID:stationID name:name coordinate:coordinate];
        [stations addObject:station];
    }
    
    return stations;
}

@end
