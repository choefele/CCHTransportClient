//
//  CCHTransportDEBahnQueryYParser.m
//  Departures
//
//  Created by Claus Höfele on 19.07.14.
//  Copyright (c) 2014 Option-U Software. All rights reserved.
//

#import "CCHTransportDEBahnQueryYParser.h"

#import "CCHTransportStation.h"

@implementation CCHTransportDEBahnQueryYParser

- (NSArray *)parseResponseWithData:(NSData *)data
{
    NSDictionary *dataAsJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    
    NSMutableArray *stations = [NSMutableArray array];
    NSArray *stationsAsJSON = dataAsJSON[@"stops"];
    for (NSDictionary *stationAsJSON in stationsAsJSON) {
        NSInteger stopWeight = [[stationAsJSON valueForKey:@"stopweight"] integerValue];
        if (stopWeight != 0) {
            NSString *stationID = [stationAsJSON valueForKey:@"extId"];
            NSString *name = [stationAsJSON valueForKey:@"name"];
            double longitude = [[stationAsJSON valueForKey:@"x"] doubleValue] / 1E6;
            double latitude = [[stationAsJSON valueForKey:@"y"] doubleValue] / 1E6;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);

            CCHTransportStation *station = [[CCHTransportStation alloc] initWithStationID:stationID name:name coordinate:coordinate];
            [stations addObject:station];
        }
    }
    
    return stations;
}

@end
