using StatsBase
using Plots
using LinearAlgebra
using DelimitedFiles
#using ImageDraw
using Images, ImageView
using LIBSVM
using MLBase
using MLJ
include("utilities.jl")
include("wavelet.jl")
include("scale.jl")

path="C://Users//HP//Desktop//alternativeproject//visionbook_Matlab_Code//15Texture//images_texture//"
#textures =prepare_data_classification(path);

#=struct  Texture
    class::Int64
   #patch::AbstractArray{Float64,2}
    patch::Array{Gray{Normed{UInt8,8}},2}
end
=#

 textures=[]
 files=readdir(path)
 
 patchsize = 100;
 
 for i = 1:length(files)
    img=load(path*"$i.png")
    img=Gray.(img);
    ny = size(img,1);
    nx = size(img,2);
   for ox = 1:patchsize-1:nx-patchsize+1
     for oy = 1:patchsize-1:ny-patchsize+1
         push!(textures,Texture(i, img[oy:oy+patchsize-1, ox:ox+patchsize-1 ] ) )
       #textures[i]=Texture(i, img[oy:oy+patchsize-1, ox:ox+patchsize-1 ]);
      # display(img[oy:oy+patchsize-1, ox:ox+patchsize-1 ])           
     end
   end
  
 end
n=length(textures)
textures = textures[randperm(n)];
n_train=Int(round(0.80*n))
n_test=n-n_train
textures_train = textures[1:n_train]
textures_test  = textures[n_train+1:n]



#h=320# Haralick features
maxlevel=3; h=3*maxlevel+1 # Wavelet features
#h=2
#=
total_instances=zeros(n, h)
total_labels=zeros(Int64,1,n)

X=zeros(n, h);y=zeros(Int64,n)
for i = 1:n
     
      #total_instances[i,:] .= haralick_features( textures[i].patch )
      total_instances[i,:] .= waveletdescr( textures[i].patch, maxlevel)
      total_labels[i]=textures[i].class
     
     
end
=#

ntrain = length(textures_train)
#instances=Array{Float64}
train_instances=zeros(ntrain, h)
train_labels=zeros(Int64,1,ntrain)
#labels=Array{UInt8}


for i = 1:ntrain
     
      train_instances[i,:] .= haralick_features( textures_train[i].patch )
      #train_instances[i,:] .= waveletdescr( textures_train[i].patch, maxlevel )
     # v=[StatsBase.var( textures_train[i].patch), StatsBase.mean( textures_train[i].patch)];
     # train_instances[i,:] .= (v .- minimum(v)) ./(maximum(v)-minimum(v));
      train_labels[i]=textures_train[i].class
     
     
end


ntest = length(textures_test)
test_instances=zeros(ntest, h)
test_labels=zeros(Int64,1,ntest)

for i = 1:n_test
     
      #test_instances[i,:] .= haralick_features( textures_test[i].patch )
      test_instances[i,:] .= waveletdescr( textures_test[i].patch, maxlevel)
     #  v=[StatsBase.var( textures_test[i].patch), StatsBase.mean( textures_test[i].patch)];
      # test_instances[i,:] .= (v .- minimum(v)) ./(maximum(v)-minimum(v));
       test_labels[i]=textures_test[i].class
   
end

train_instances=Matrix(train_instances)';
test_instances=Matrix(test_instances)';

model=svmtrain(train_instances, train_labels[:]);

# Test model on the test data.
(predicted_labels, decision_values) = svmpredict(model, test_instances);
# Compute accuracy
println( "Accuracy:\t", mean((predicted_labels .== test_labels))*100)

correctrate(test_labels[:], predicted_labels[:])
C=confusmat(10, test_labels[:], predicted_labels[:])

##############################################333
X=zeros(n, h);y=zeros(n)
#X=[]
#y=[]

for i = 1:n
     
    #total_instances[i,:] .= haralick_features( textures[i].patch )
    v=waveletdescr( textures[i].patch, maxlevel)
    v .= (v .- minimum(v)) ./(maximum(v)-minimum(v));
    X[i,:] .= v
    #push!(X,waveletdescr( textures[i].patch, maxlevel))
    y[i]=textures[i].class
    #push!(y,textures[i].class)
   
   
end
X = MLJ.table(X)
y = categorical(y);

train, test = partition(eachindex(y), .9, rng=333);

###########

#@load SVC pkg=LIBSVM
SVM = @load SVC pkg=LIBSVM
model_svm = SVM()
svc = machine(model_svm, X, y)
MLJ.fit!(svc);
MLJ.fit!(svc, rows=train)
ypred = MLJ.predict(svc, rows=test)
misclassification_rate(ypred, y[test])







#= 
cv=CV(nfolds=5)
model_regress = (@load RidgeRegressor pkg=MultivariateStats verbosity=1)()
mach_regress = machine(model_regress, total_instances, total_labels )
evaluate!(mach_regress, resampling=cv,  measure=[rms], verbosity=0)

@load("LinearRegressor", pkg="MLJLinearModels");
m= LinearRegressor();
mach = machine(m, X, y);
MLJ.fit!(mach, rows=train)
fitted_params(mach)
ypred= MLJ.predict(mach, rows=test)
rms(ypred, y[test])





SVM = @load SVC pkg=LIBSVM
model_svm = SVM()
mach_svm = machine(model_svm, X, y )
evaluate!(mach_svm, resampling=cv,  measure=[rms], verbosity=0)

=#


