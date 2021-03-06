# Copyright (C) 2009 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := rctgstplayer


LOCAL_C_INCLUDES += $(LOCAL_PATH)/../../native


LOCAL_SRC_FILES :=  RCTGstPlayerJNI.c \
                    ../../native/gst_player.c


LOCAL_LDLIBS := -llog -landroid

LOCAL_SHARED_LIBRARIES := gstreamer_android libc++_shared

include $(BUILD_SHARED_LIBRARY)


ifeq ($(TARGET_ARCH_ABI),armeabi)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/arm
else ifeq ($(TARGET_ARCH_ABI),armeabi-v7a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/armv7
else ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/arm64
else ifeq ($(TARGET_ARCH_ABI),x86)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/x86
else ifeq ($(TARGET_ARCH_ABI),x86_64)
GSTREAMER_ROOT        := $(GSTREAMER_ROOT_ANDROID)/x86_64
else
$(error Target arch ABI not supported: $(TARGET_ARCH_ABI))
endif

ifndef GSTREAMER_ROOT
    ifndef GSTREAMER_ROOT_ANDROID
        $(error GSTREAMER_ROOT_ANDROID is not defined!)
    endif
    GSTREAMER_ROOT            := $(GSTREAMER_ROOT_ANDROID)
endif

GSTREAMER_NDK_BUILD_PATH  := $(GSTREAMER_ROOT)/share/gst-android/ndk-build

include $(GSTREAMER_NDK_BUILD_PATH)/plugins.mk
    GSTREAMER_PLUGINS     := $(GSTREAMER_PLUGINS_CORE)      \
                             $(GSTREAMER_PLUGINS_PLAYBACK)  \
                             $(GSTREAMER_PLUGINS_CODECS)    \
                             $(GSTREAMER_PLUGINS_NET)       \
                             $(GSTREAMER_PLUGINS_SYS)       \
                             $(GSTREAMER_PLUGINS_CODECS_RESTRICTED) \
                             $(GSTREAMER_CODECS_GPL)        \
                             $(GSTREAMER_PLUGINS_ENCODING)  \
                             $(GSTREAMER_PLUGINS_VIS)       \
                             $(GSTREAMER_PLUGINS_EFFECTS)   \
                             $(GSTREAMER_PLUGINS_NET_RESTRICTED)

G_IO_MODULES              := gnutls
GSTREAMER_EXTRA_DEPS      := gstreamer-video-1.0 json-glib-1.0

include $(GSTREAMER_NDK_BUILD_PATH)/gstreamer-1.0.mk