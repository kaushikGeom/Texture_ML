#using ScikitLearn
#using ScikitLearn.CrossValidation: cross_val_predict
#using MLBase
using StatsBase
using Plots
using LinearAlgebra
#using DelimitedFiles
#using ImageDraw
using Images, ImageView
using LIBSVM
#using Statistics
using MLJ
include("wavelet.jl")
include("scale.jl")
include("utilities.jl")


path="C://Users//HP//Desktop//HyperTension//"
textures =prepare_data_classification(path);

# To split the data into test and training sets
n=length(textures)
textures = textures[randperm(n)];
n_train=Int(round(0.75*n));
n_test=n-n_train
textures_train = textures[1:n_train]
textures_test  = textures[n_train+1:n]



h=40# Haralick features
#maxlevel=3; h=3*maxlevel+1 # Wavelet features
total_instances=zeros(n, h)
total_labels=zeros(Int64,n)

for i = 1:n
     
      total_instances[i,:] .= haralick_features( textures[i].patch )
      #total_instances[i,:] .= waveletdescr( textures[i].patch, 3)
      total_labels[i]=textures[i].class
     
     
end



ntrain = length(textures_train)

#instances=Array{Float64}
train_instances=zeros(ntrain, h)
train_labels=zeros(Int64,ntrain)
#labels=Array{UInt8}


for i = 1:ntrain
     
      train_instances[i,:] .= haralick_features( textures_train[i].patch )
     # train_instances[i,:] .= waveletdescr( textures_train[i].patch, 3 )
      train_labels[i]=textures_train[i].class
     
     
end


ntest = length(textures_test)
test_instances=zeros(ntest, h)
test_labels=zeros(Int64,ntest)

for i = 1:n_test
     
      train_instances[i,:] .= haralick_features( textures_train[i].patch )
      #test_instances[i,:] .= waveletdescr( textures_test[i].patch, 3)
      test_labels[i]=textures_test[i].class
   
end

model=svmtrain(train_instances', train_labels);

# Test model on the test data.
(predicted_labels, decision_values) = svmpredict(model, test_instances');
# Compute accuracy
println( "Accuracy:\t", mean((predicted_labels .== test_labels))*100)

###################
#=

cv=CV(nfolds=5)
cv = CV( ; nfolds=6,  shuffle=true, rng=nothing)
train_test_pairs(cv, rows)
SVM = @load SVC pkg=LIBSVM
model_svm = SVM()
mach_svm = machine(model_svm, total_instances, total_labels )
evaluate!(mach_svm, resampling=cv,  measure=[rms], verbosity=0)


model_regress = (@load RidgeRegressor pkg=MultivariateStats verbosity=0)()
mach_regress = machine(model_regress, total_instances, total_labels )
evaluate!(mach_regress, resampling=cv,  measure=[rms], verbosity=0)






test_labels=Int.(test_labels); predicted_labels=Int.(predicted_labels)
rr=correctrate(Int.(predicted_labels) , Int.(test_labels))

confusmat(3,test_labels,  predicted_labels)
roc(test_labels,  predicted_labels)

#=cv = CV( ; nfolds=6,  shuffle=true, rng=nothing)
SVM = @load SVC pkg=LIBSVM
svm = SVM()
evaluate!(mach, resampling=cv, measure=l2, verbosity=0)
=#
