//
//  WWBlockTypeDef.h
//  WildWalks
//
//  Created by Sergiy Shevchuk on 7/21/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#ifndef WWBlockTypeDef_h
#define WWBlockTypeDef_h

typedef void (^WWVoidBlock)(void);
typedef void (^WWResultBlock)(id result);
typedef void (^WWArrayBlock)(NSArray *array);
typedef void (^WWDictionaryBlock)(NSDictionary *dictionary);
typedef void (^WWErrorBlock)(NSError *error);

#endif /* WWBlockTypeDef_h */
