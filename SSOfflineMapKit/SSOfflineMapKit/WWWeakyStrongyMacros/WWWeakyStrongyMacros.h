//  WWWeakyStrongyMacros.h
//  WildWalks
//
//  Created by Sergiy Shevchuk on 7/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#define WWWeakify(variable) \
__weak __typeof(variable) __WWWeakified_##variable = variable

// you should only call this method after you called weakify for that same variable
#define WWStrongify(variable) \
__strong __typeof(variable) variable = __WWWeakified_##variable \

