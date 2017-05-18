//
//  DeviceSelector.m
//  DiagramEditor
//
//  Created by MISO on 16/5/17.
//  Copyright © 2017 Diego Vaquero Melchor. All rights reserved.
//

#import "DeviceSelector.h"
#import "Reachability.h"

@implementation DeviceSelector

-(NSString *) TypeToReturn: (NSString*) string{
    if([string isEqualToString:@"dev.date"]){
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"dd/MM/YYYY HH:mm:ss"];
        return [format stringFromDate:[NSDate date]];
    }else if([string isEqualToString:@"dev.hour"]){
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitSecond) fromDate: date];
        
        NSInteger hour = [components hour];
        
        return [NSString stringWithFormat:@"%i", hour];
    }else if([string isEqualToString:@"dev.minutes"]){
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
        
        NSInteger minutes = [components minute];
        
        return [NSString stringWithFormat:@"%i", minutes];
    }else if([string isEqualToString:@"dev.seconds"]){
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
        
        NSInteger seconds = [components second];
    
        return [NSString stringWithFormat:@"%i", seconds];
    }else if([string isEqualToString:@"dev.model"]){
        UIDevice *device = [UIDevice currentDevice];
        NSString *model = [device model];
        return model;
    }else if([string isEqualToString:@"dev.name"]){
        UIDevice *myDevice = [UIDevice currentDevice];
        NSString *name = [myDevice name];
        return name;
    }else if([string isEqualToString:@"dev.identifier"]){
        UIDevice *device = [UIDevice currentDevice];
        NSString *identifier = [[device identifierForVendor] description];
        return identifier;
    }else if([string isEqualToString:@"dev.battery"]){
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];
        
        double batLeft = (float)[myDevice batteryLevel];
        int percent = batLeft*100;
        return [NSString stringWithFormat:@"%i", percent];
    }else if([string isEqualToString:@"dev.connectivity"]){
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        if (status == ReachableViaWiFi)
        {
            return @"Wifi";
        }
        else if (status == ReachableViaWWAN)
        {
            return @"3G";
        }
        return @"Nothing reachable";
    }else if([string isEqualToString:@"dev.status"]){
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];
        int state = [myDevice batteryState];
        switch(state){
            case 0: return @"unknown";
            case 1: return @"charging";
            case 2: return @"full";
        }
    }
    return nil;
}

@end
