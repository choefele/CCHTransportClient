# CCHTransportClient

A library for iOS and OS X that retrieves real-time data for departures, stations and trip routing from various transportation APIs.

Need to talk to a human? [I'm @claushoefele on Twitter](https://twitter.com/claushoefele).

## Installation

Use [CocoaPods](http://cocoapods.org) to integrate `CCHTransportClient` into your project. Minimum deployment targets are 7.0 for iOS and 10.9 for OS X.

```ruby
platform :ios, '7.0'
pod "CCHTransportClient"
```

```ruby
platform :osx, '10.9'
pod "CCHTransportClient"
```

On iOS 9 and later, you have to configure exceptions to your app's [application transport security settings](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html#//apple_ref/doc/uid/TP40009251-SW33) because some of the REST endpoints don't use secure connections:

```XML
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSExceptionDomains</key>
	<dict>
		<key>demo.hafas.de</key>
		<dict>
			<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
			<true/>
		</dict>
		<key>reiseauskunft.bahn.de</key>
		<dict>
			<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
			<true/>
		</dict>
	</dict>
</dict>
```

## Current Implementations
API | Departures for date | Stations near coordinate | Stations for search string | Trips for date
--- | :-----------------: | :----------------------: | :------------------------: | :------------:
[bahn.de](http://reiseauskunft.bahn.de) [1] | Yes | Yes | Yes | Yes
[VBB](http://www.vbb.de/de/article/webservices/schnittstellen-fuer-webentwickler/5070.html#rest-schnittstelle) [2] | Yes | | | Yes

[1]: Covers public transport in Germany and some parts of Europe; inofficial API.

[2]: Covers the German states Berlin and Brandenburg. [Requires access ID to use](http://www.vbb.de/de/article/webservices/schnittstellen-fuer-webentwickler/5070.html#testserver).

## Example

```Objective-C
CCHTransportDEBahnClient *transportClient = [[CCHTransportDEBahnClient alloc] init];    
CCHTransportLocation *from = [[CCHTransportLocation alloc] initWithName:nil coordinate:CLLocationCoordinate2DMake(52.519953, 13.348262)];
CCHTransportLocation *to = [[CCHTransportLocation alloc] initWithName:nil coordinate:CLLocationCoordinate2DMake(52.421053, 13.179336)];
  
[transportClient retrieveTripsForDate:nil fromLocation:from toLocation:to transportModeMask:CCHTransportClientModeAll maxNumberOfResults:10 completionHandler:^(NSArray *trips, id context, NSError *error) {
    if (trips.count > 0) {
        CCHTransportTrip *trip = trips[0];
        CCHTransportTripLeg *tripLeg = trip.legs[0];
        // ...
    }
}];
```

## License (MIT)

Copyright (C) 2015 Claus Höfele

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
