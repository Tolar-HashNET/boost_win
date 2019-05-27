include_pattern = "src/boost/%s/"

hdrs_patterns = [
    "src/boost/%s.h",
    "src/boost/%s_fwd.h",
    "src/boost/%s.hpp",
    "src/boost/%s_fwd.hpp",
    "src/boost/%s/**/*.hpp",
    "src/boost/%s/**/*.ipp",
    "src/boost/%s/**/*.h",
    "src/libs/%s/src/*.ipp",
]

srcs_patterns = [
    "src/libs/%s/src/*.cpp",
    "src/libs/%s/src/*.hpp",
]

# Building boost results in many warnings for unused values. Downstream users
# won't be interested, so just disable the warning.
default_copts = select({
    "@boost//:linux": ["-Wno-unused-value"],
    "//conditions:default": [],
})

default_defines = select({
    "@boost//:windows": [
        "BOOST_USE_WINDOWS_H",
        "WIN32_LEAN_AND_MEAN",
    ],
    "//conditions:default": [],
})

def srcs_list(library_name, exclude):
    return native.glob(
        [p % (library_name,) for p in srcs_patterns],
        exclude = exclude,
    )

def includes_list(library_name):
    return ["src", include_pattern % library_name]

def hdr_list(library_name):
    return native.glob([p % (library_name,) for p in hdrs_patterns])

def boost_library(
        name,
        defines = None,
        includes = None,
        hdrs = None,
        srcs = None,
        deps = None,
        copts = None,
        exclude_src = [],
        linkopts = None,
        visibility = ["//visibility:public"]):
    if defines == None:
        defines = []
    defines += default_defines 

    if includes == None:
        includes = []

    if hdrs == None:
        hdrs = []

    if srcs == None:
        srcs = []

    if deps == None:
        deps = []

    if copts == None:
        copts = []

    if linkopts == None:
        linkopts = []

    return native.cc_library(
        name = name,
        visibility = visibility,
        defines = defines,
        includes = includes_list(name) + includes,
        hdrs = hdr_list(name) + hdrs,
        srcs = srcs_list(name, exclude_src) + srcs,
        deps = deps,
        copts = default_copts + copts,
        linkopts = linkopts,
        licenses = ["notice"],
    )
