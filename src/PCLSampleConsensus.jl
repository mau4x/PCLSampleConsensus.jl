module PCLSampleConsensus

using LibPCL
using PCLCommon
using Cxx

const libpcl_sample_consensus = LibPCL.find_library_e("libpcl_sample_consensus")
try
    Libdl.dlopen(libpcl_sample_consensus, Libdl.RTLD_GLOBAL)
catch e
    warn("You might need to set DYLD_LIBRARY_PATH to load dependencies proeprty.")
    rethrow(e)
end

cxx"""
#include <pcl/sample_consensus/model_types.h>
#include <pcl/sample_consensus/method_types.h>
#include <pcl/sample_consensus/sac_model_plane.h>
"""

for enumname in [
    :SACMODEL_PLANE,
    :SACMODEL_LINE,
    :SACMODEL_CIRCLE2D,
    :SACMODEL_CIRCLE3D,
    :SACMODEL_SPHERE,
    :SACMODEL_CYLINDER,
    :SACMODEL_CONE,
    :SACMODEL_TORUS,
    :SACMODEL_PARALLEL_LINE,
    :SACMODEL_PERPENDICULAR_PLANE,
    :SACMODEL_PARALLEL_LINES,
    :SACMODEL_NORMAL_PLANE,
    :SACMODEL_NORMAL_SPHERE,
    :SACMODEL_REGISTRATION,
    :SACMODEL_REGISTRATION_2D,
    :SACMODEL_PARALLEL_PLANE,
    :SACMODEL_NORMAL_PARALLEL_PLANE,
    :SACMODEL_STICK
    ]
    # build icxx expr
    ex = Expr(:macrocall, Symbol("@icxx_str"), string("pcl::", enumname, ";"))
    cppname = string("pcl::", enumname)
    @eval begin
        enumtyp = $ex
        isa(enumtyp, Cxx.CppEnum)
        @doc """
        $($cppname)
        """ global const $enumname = enumtyp
        export $enumname
    end
end

for intname in [
    :SAC_RANSAC,
    :SAC_LMEDS,
    :SAC_MSAC,
    :SAC_RRANSAC,
    :SAC_RMSAC,
    :SAC_MLESAC,
    :SAC_PROSAC,
    ]
    ex = Expr(:macrocall, Symbol("@icxx_str"), string("pcl::", intname, ";"))
    cppname = string("pcl::", intname)
    @eval begin
        @doc """
        $($cppname)
        """ global const $intname = $ex
        @assert isa($intname, Cint)
        export $intname
    end
end

abstract SampleConsensusModel

end # module
