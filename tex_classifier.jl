using StatsBase
using  FileIO
using Plots
using LinearAlgebra
using DelimitedFiles
using ImageDraw
using Images, ImageView
using LIBSVM
using Statistics
using ImageFeatures

include("utilities.jl")
path="C://Users//HP//Desktop//HyperTension//"
textures, textures_train, textures_test=prepare_data_classification(path);



n=6 # Harlick features
ntrain = length(textures_train)
struct  Feature_Train
    
   # X::MVector{n, Float64}
    X::Array{Float64}
    #X::Array{Float64, 1}(n)
    y::Float64
end


  
features_train = Array{Feature_Train, 1}(undef, ntrain )

for i = 1:ntrain
    
      features_train[i] =Feature_Train([textures_train[i].patch], textures_train[i].class);
    
end

glc=glcm_norm(im, d, ang, 16)
glc=glcm_symmetric(img, distances, angles, mat_size=16)

prop = glcm_prop(glm, property)
prop = glcm_prop(glc[1,1], max_prob)

#=
Various properties: `mean`, `variance`, `correlation`, `contrast`, `IDM` (Inverse Difference Moment),
 `ASM` (Angular Second Moment), `entropy`, `max_prob` (Max Probability), `energy` and `dissimilarity`.
=#

ntest = length(textures_test)
struct  Feature_Test
    
   # X::MVector{n, Float64}
    X::Array{Float64}
    #X::Array{Float64, 1}(n)
    y::Float64
end


  
features_test = Array{Feature_Test, 1}(undef, ntest )

for i = 1:ntest
    
      features_test[i] =Feature_Train([textures_test[i].patch], textures_test[i].class);
    
end

