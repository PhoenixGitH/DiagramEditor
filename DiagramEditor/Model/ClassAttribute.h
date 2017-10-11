//
//  ClassAttribute.h
//  DiagramEditor
//
//  Created by Diego on 22/1/16.
//  Copyright © 2016 Diego Vaquero Melchor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassAttribute : NSObject<NSCoding, NSCopying>


@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSNumber * min;
@property (nonatomic,copy) NSNumber * max;
@property (nonatomic,copy) NSString * defaultValue;
@property (nonatomic,copy) NSString * currentValue;
@property (nonatomic,copy) NSDictionary * annotations;

@property BOOL isLabel;

@end
