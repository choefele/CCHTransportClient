//
//  CCHTransportDEBahnAjaxGetstopParser.m
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
