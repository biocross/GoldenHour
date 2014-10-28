//
//  ViewController.m
//  GoldenHour
//
//  Created by Siddharth on 28/10/14.
//  Copyright (c) 2014 Siddharth Gupta. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Check for BLUETOOTH HERE
    [self startMonitoringBeacons];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//This is called in the starting for everyone. It starts scanning for beacons.
- (void)startMonitoringBeacons {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"747F684A-A8C8-47AC-8900-97F1C17240A4"];
    self.myBeaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid major:1 minor:1 identifier:@"goldenHour"];
    [self.locationManager startMonitoringForRegion:self.myBeaconRegion];
    NSLog(@"Now Scanning Beacons!");
}

- (void)stopMonitoringBeacons{
    [self.locationManager stopMonitoringForRegion:self.myBeaconRegion];
}

- (void)startBroadcastingIncident{
    [self stopMonitoringBeacons];
    if (!self.peripheralManager)
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    if (self.peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Peripheral manager is off.");
        return;
    }
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:self.myBeaconRegion.proximityUUID
                                                                     major:1
                                                                     minor:1
                                                                identifier:self.myBeaconRegion.identifier];
    NSDictionary *beaconPeripheralData = [region peripheralDataWithMeasuredPower:nil];
    [self.peripheralManager startAdvertising:beaconPeripheralData];
    
    NSLog(@"Turning on broadcasting for incident: %@.", region);
    
}

#pragma mark - Location manager delegate methods
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheralManager
{
    if (peripheralManager.state != CBPeripheralManagerStatePoweredOn) {
        NSLog(@"Peripheral manager is off.");
        return;
    }
    
    NSLog(@"Peripheral manager is on.");
    [self startMonitoringBeacons];
}

@end
