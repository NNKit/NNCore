//  NNDispatchQueuePool.m
//  Pods
//
//  Created by  XMFraker on 2017/12/13
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NNDispatchQueuePool
//  @version    <#class version#>
//  @abstract   <#class description#>

#import "NNDispatchQueuePool.h"

#import <UIKit/UIKit.h>
#import <libkern/OSAtomic.h>

/** default max queue count of queue pool */
static int const kNNDispatchQueuePoolMaxQueueCount = 32;

typedef struct {
    const char *name;
    void **queues;
    uint32_t queueCount;
    int32_t counter;
} NNDispatchContext;

/** Transform QOS to dispatch_queue_priority_t */
static inline dispatch_queue_priority_t NSQualityOfServiceToDispatchPriority(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUserInitiated: return DISPATCH_QUEUE_PRIORITY_HIGH;
        case NSQualityOfServiceUtility: return DISPATCH_QUEUE_PRIORITY_LOW;
        case NSQualityOfServiceBackground: return DISPATCH_QUEUE_PRIORITY_BACKGROUND;
        case NSQualityOfServiceDefault: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
        default: return DISPATCH_QUEUE_PRIORITY_DEFAULT;
    }
}

/** Transform QOS to qos_class_t */
static inline qos_class_t NSQualityOfServiceToQOSClass(NSQualityOfService qos) {
    switch (qos) {
        case NSQualityOfServiceUserInteractive: return QOS_CLASS_USER_INTERACTIVE;
        case NSQualityOfServiceUserInitiated: return QOS_CLASS_USER_INITIATED;
        case NSQualityOfServiceUtility: return QOS_CLASS_UTILITY;
        case NSQualityOfServiceBackground: return QOS_CLASS_BACKGROUND;
        case NSQualityOfServiceDefault: return QOS_CLASS_DEFAULT;
        default: return QOS_CLASS_UNSPECIFIED;
    }
}

/** Create and return a context or nil with name,queuecount,qos */
static NNDispatchContext *NNDispatchContextCreate(const char *name,
                                                  uint32_t queueCount,
                                                  NSQualityOfService qos) {
    NNDispatchContext *context = calloc(1, sizeof(NNDispatchContext));
    if (!context) return NULL;
    context->queues =  calloc(queueCount, sizeof(void *));
    if (!context->queues) {
        free(context);
        return NULL;
    }
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        dispatch_qos_class_t qosClass = NSQualityOfServiceToQOSClass(qos);
        for (NSUInteger i = 0; i < queueCount; i++) {
            dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, qosClass, 0);
            dispatch_queue_t queue = dispatch_queue_create(name, attr);
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    } else {
        long identifier = NSQualityOfServiceToDispatchPriority(qos);
        for (NSUInteger i = 0; i < queueCount; i++) {
            dispatch_queue_t queue = dispatch_queue_create(name, DISPATCH_QUEUE_SERIAL);
            dispatch_set_target_queue(queue, dispatch_get_global_queue(identifier, 0));
            context->queues[i] = (__bridge_retained void *)(queue);
        }
    }
    context->queueCount = queueCount;
    if (name) {
        context->name = strdup(name);
    }
    return context;
}

/** Release a context */
static void NNDispatchContextRelease(NNDispatchContext *context) {
    if (!context) return;
    if (context->queues) {
        for (NSUInteger i = 0; i < context->queueCount; i++) {
            void *queuePointer = context->queues[i];
            dispatch_queue_t queue = (__bridge_transfer dispatch_queue_t)(queuePointer);
            const char *name = dispatch_queue_get_label(queue);
            if (name) strlen(name); // avoid compiler warning
            queue = nil;
        }
        free(context->queues);
        context->queues = NULL;
    }
    if (context->name) free((void *)context->name);
}

static dispatch_queue_t NNDispatchContextGetQueue(NNDispatchContext *context) {
    uint32_t counter = (uint32_t)OSAtomicIncrement32(&context->counter);
    void *queue = context->queues[counter % context->queueCount];
    return (__bridge dispatch_queue_t)(queue);
}


static NNDispatchContext *NNDispatchContextGetForQOS(NSQualityOfService qos) {
    static NNDispatchContext *context[5] = {0};
    switch (qos) {
        case NSQualityOfServiceUserInteractive: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > kNNDispatchQueuePoolMaxQueueCount ? kNNDispatchQueuePoolMaxQueueCount : count;
                context[0] = NNDispatchContextCreate("com.xmfraker.nncore.user-interactive", count, qos);
            });
            return context[0];
        } break;
        case NSQualityOfServiceUserInitiated: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > kNNDispatchQueuePoolMaxQueueCount ? kNNDispatchQueuePoolMaxQueueCount : count;
                context[1] = NNDispatchContextCreate("com.xmfraker.nncore.user-initiated", count, qos);
            });
            return context[1];
        } break;
        case NSQualityOfServiceUtility: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > kNNDispatchQueuePoolMaxQueueCount ? kNNDispatchQueuePoolMaxQueueCount : count;
                context[2] = NNDispatchContextCreate("com.xmfraker.nncore.utility", count, qos);
            });
            return context[2];
        } break;
        case NSQualityOfServiceBackground: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = count < 1 ? 1 : count > kNNDispatchQueuePoolMaxQueueCount ? kNNDispatchQueuePoolMaxQueueCount : count;
                context[3] = NNDispatchContextCreate("com.xmfraker.nncore.background", count, qos);
            });
            return context[3];
        } break;
        case NSQualityOfServiceDefault:
        default: {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                int count = (int)[NSProcessInfo processInfo].activeProcessorCount;
                count = MIN(MAX(1, count), kNNDispatchQueuePoolMaxQueueCount);
                count = count < 1 ? 1 : count > kNNDispatchQueuePoolMaxQueueCount ? kNNDispatchQueuePoolMaxQueueCount : count;
                context[4] = NNDispatchContextCreate("com.xmfraker.nncore.default", count, qos);
            });
            return context[4];
        } break;
    }
}

@implementation NNDispatchQueuePool {
    @public
    NNDispatchContext *_context;
}

#pragma mark - Life Cycle

- (instancetype)initWithContext:(NNDispatchContext *)context {

    if (!context) return nil;
    if (self = [super init]) {
        _context = context;
        _name = context->name ? [NSString stringWithUTF8String:context->name] : nil;
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name queueCount:(NSUInteger)queueCount qos:(NSQualityOfService)qos {

    if (!queueCount || queueCount > kNNDispatchQueuePoolMaxQueueCount) return nil;
    if (self = [super init]) {
        _context = NNDispatchContextCreate(name.UTF8String, (uint32_t)queueCount, qos);
        _name = name;
    }
    return self;
}

+ (instancetype)defaultPoolForQOS:(NSQualityOfService)qos {
    return [[NNDispatchQueuePool alloc] initWithContext:NNDispatchContextGetForQOS(qos)];
}

- (void)dealloc {
    
    if (_context) {
        NNDispatchContextRelease(_context);
        _context = NULL;
    }
}

#pragma mark - Public Methods

- (dispatch_queue_t)queue {
    return NNDispatchContextGetQueue(_context);
}

@end

dispatch_queue_t NNDispatchQueueGetForQOS(NSQualityOfService qos) {
    return NNDispatchContextGetQueue(NNDispatchContextGetForQOS(qos));
}
