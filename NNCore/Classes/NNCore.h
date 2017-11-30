//
//  NNCore.h
//  NNCore
//
//  Created by XMFraker on 2017/11/10.
//

#ifndef NNCore_h
#define NNCore_h

#if __has_include(<NNCore/NNCore.h>)
    #import <NNCore/NNFPS.h>
    #import <NNCore/NNRouter.h>
    #import <NNCore/NNLogger.h>
    #import <NNCore/NNMutableArray.h>
    #import <NNCore/NNMutableDictionary.h>
    #import <NNCore/NNHalfLayoutConstraint.h>

    #import <NNCore/NSDate+NNExtension.h>
    #import <NNCore/NSData+NNExtension.h>
    #import <NNCore/NSTimer+NNExtension.h>
    #import <NNCore/NSArray+NNExtension.h>
    #import <NNCore/NSObject+NNExtension.h>
    #import <NNCore/NSString+NNExtension.h>
    #import <NNCore/NSNumber+NNExtension.h>
    #import <NNCore/NSDictionary+NNExtension.h>

    #import <NNCore/UIView+NNExtension.h>
    #import <NNCore/UIColor+NNExtension.h>
    #import <NNCore/UIDevice+NNExtension.h>
#else
    #import "NNFPS.h"
    #import "NNRouter.h"
    #import "NNLogger.h"
    #import "NNMutableArray"
    #import "NNMutableDictionary.h"
    #import "NNHalfLayoutConstraint.h"

    #import "NSDate+NNExtension.h"
    #import "NSData+NNExtension.h"
    #import "NSTimer+NNExtension.h"
    #import "NSArray+NNExtension.h"
    #import "NSObject+NNExtension.h"
    #import "NSString+NNExtension.h"
    #import "NSNumber+NNExtension.h"
    #import "NSDictionary+NNExtension.h"

    #import "UIDevice+NNExtension.h"
    #import "UIView+NNExtension.h"
    #import "UIColor+NNExtension.h"
#endif


/// ========================================
/// @name   三方库头文件引用
/// ========================================

#import <YYModel/YYModel.h>
#import <BeeHive/BeeHive.h>

#endif /* NNCore_h */
