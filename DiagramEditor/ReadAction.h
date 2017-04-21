//
//  ReadAction.h
//  TriggersV2
//
//  Created by Diego on 5/12/16.
//  Copyright © 2016 Diego. All rights reserved.
//

#import "Action.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface ReadAction : Action{
    
}

@property NSString * information;
@property NSString * name;

-(id)getValue;


@end
