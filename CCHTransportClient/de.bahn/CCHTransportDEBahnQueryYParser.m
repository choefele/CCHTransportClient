//
//  CCHTransportDEBahnQueryYParser.m
//  CCHTransportClient
//
//  Copyright (C) 2015 Claus Höfele
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CCHTransportDEBahnQueryYParser.h"

#import "CCHTransportStation.h"

@implementation CCHTransportDEBahnQueryYParser

- (NSArray *)parseResponseWithData:(NSData *)data
{
    // Convert from ISO 8859-1 to UTF-8
    NSString *dataAsString = [[NSString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    NSData *dataAsUTF8 = [dataAsString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dataAsJSON = [NSJSONSerialization JSONObjectWithData:dataAsUTF8 options:0 error:NULL];
    
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
