//
//  NNDefines.h
//  Pods
//
//  Created by XMFraker on 2017/11/10.
//

#ifndef NNDefines_h
#define NNDefines_h


#pragma mark - 相关宏定义

/// ========================================
/// @name   个人使用的打印日志
/// ========================================

#ifndef NNTick
    #if DEBUG
    static NSDate *kNNTickDate = nil;
        #define NNTick  kNNTickDate = [NSDate date];
        #define NNTock  NSLog(@"Time Cost: %f", -[kNNTickDate timeIntervalSinceNow]);
    #else
        #define NNTick
        #define NNTock
    #endif
#endif

#ifndef NSLog
    #if DEBUG
        #define NSLog(...) NSLog(__VA_ARGS__)
    #else
        #define NSLog(...) {}
    #endif
#endif

/// ========================================
/// @name   相关尺寸宏
/// ========================================

#ifndef SCREEN_WIDTH
    #define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#endif

#ifndef SCREEN_HEIGHT
    #define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef VIEW_SAFE_AREA_INSETS
    #define VIEW_SAFE_AREA_INSETS(view) ({UIEdgeInsets i; if(@available(iOS 11.0, *)) {i = view.safeAreaInsets;} else {i = UIEdgeInsetsZero;} i;})
#endif

/**
 *  判断设备是否是4s机型
 *
 *  @return YES or NO
 */
#ifndef iPhone4s
    #define iPhone4s (((int)SCREEN_HEIGHT == 480) ? YES : NO)
#endif

/**
 *  判断设备是否是5s机型
 *
 *  @return YES or NO
 */
#ifndef iPhone5s
    #define iPhone5s (((int)SCREEN_HEIGHT == 568) ? YES : NO)
#endif

/**
 *  判断设备是否是6s机型
 *
 *  @return YES or NO
 */
#ifndef iPhone6s
    #define iPhone6s (((int)SCREEN_HEIGHT == 667) ? YES : NO)
#endif

/**
 *  判断设备是否是Plus机型
 *
 *  @return YES or NO
 */
#ifndef iPhonePlus
    #define iPhonePlus (((int)SCREEN_HEIGHT == 736) ? YES : NO)
#endif

#ifndef iPhoneX
    #define iPhoneX (((int)SCREEN_HEIGHT == 812) ? YES : NO)
#endif


#if defined(__cplusplus)
#define NNEXTERN extern "C"
#else
#define NNEXTERN extern
#endif


/// ========================================
/// @name   NNWeak,NNStrong
/// ========================================

#define NNWeak(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#define NNStrong(o) autoreleasepool{} __strong typeof(o) o = o##Weak;

/// ========================================
/// @name   NSBundle,UIImage 相关宏
/// ========================================

#ifndef NNBoard
    #define NNBoard(name, bundle) [UIStoryboard storyboardWithName:name bundle:bundle]
    #define NNMainBoard(name) [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]]
    #define NNBoardVC(name) [[UIStoryboard storyboardWithName:name bundle:NNLocalBundle] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])]
#endif

#ifndef NNBundle
    #define NNBundle(clazz)       [NSBundle bundleForClass:clazz]
    #define NNLocalBundle         [NSBundle bundleForClass:[self class]]
    #define NNMainBundle          [NSBundle mainBundle]
#endif

#ifndef NNImage
    #define NNImage(name) [UIImage imageNamed:name]
    #define NNBunldeImage(name) [UIImage imageNamed:name inBundle:NNLocalBundle compatibleWithTraitCollection:nil]
#endif

#ifndef NNLocalized
    #define NNLocalized(key,tab) NNLocalizedString(key,@"",tab)
    #define NNLocalizedString(key,val,tab) NSLocalizedStringWithDefaultValue(key, tab, [NSBundle bundleForClass:[self class]], val, @"")
#endif

#endif /* NNDefines_h */
