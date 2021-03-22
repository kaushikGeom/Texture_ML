
using Random
using Images, ImageView
using FileIO



struct  Texture
  class::Int
  patch::Array{Gray{Normed{UInt8,8}},2}
end


function prepare_data_classification(path)

path1=path*"Poly_Controls//"
path2=path*"Poly_EH//" 
path3=path*"Poly_PA//"

files_controls=readdir(path1)
files_EH=readdir(path2)
files_PA=readdir(path3)


# Size of the database
#tsize=Int( (size(files_controls,1) + size(files_EH,1) +size(files_PA,1))/2)

textures = Array{Texture, 1}(undef, tsize) # 
#textures=Array{Texture, 1}(undef, )
# initialize the array elements using new constructor

f_bmp=filter(x -> endswith(x, ".bmp"), files_controls)
f_txt=filter(x -> endswith(x, ".txt"), files_controls)

ind=0

for i =1 : length(f_bmp)

     ind=ind+1
     im_controls=load(path1*files_controls[i])
     im_controls=im_controls[59:498,122:561] # cropping
     # for text file
     points=readdlm(path1*"$i.txt",skipstart=2)
     n=div(length(points),2)
     points=reshape(points,(2,n))
     #the exterior rectangle
     xmin=minimum(points[1,:]);
     xmax=maximum(points[1,:])
     ymin=minimum(points[2,:]);
     ymax=maximum(points[2,:])
     im=im_controls[Int.(ymin:ymax),Int.(xmin:xmax)]
 
     textures[ind]=Texture(1, im )
    
end

f_bmp=filter(x -> endswith(x, ".bmp"), files_EH)
f_txt=filter(x -> endswith(x, ".txt"), files_EH)

for j =1 : length(f_bmp)

      ind=ind+1
      im_EH=load(path2*files_EH[j])
      im_EH=im_EH[59:498,122:561] # cropping
       # for text file
      points=readdlm(path2*"$j.txt",skipstart=2)
      n=div(length(points),2)
      points=reshape(points,(2,n))
      #the exterior rectangle
      xmin=minimum(points[1,:]);
      xmax=maximum(points[1,:])
      ymin=minimum(points[2,:]);
      ymax=maximum(points[2,:])
      im=im_EH[Int.(ymin:ymax),Int.(xmin:xmax)]
      textures[ind]=Texture(2, im )
      
      
end

f_bmp=filter(x -> endswith(x, ".bmp"), files_PA)
f_txt=filter(x -> endswith(x, ".txt"), files_PA)

for k =1 : length(f_bmp)
      
      ind=ind+1
      im_PA=load(path3*files_PA[k])
      im_PA=im_PA[59:498,122:561] # cropping
      # for text file
      points=readdlm(path3*"$k.txt",skipstart=2)
      n=div(length(points),2)
      points=reshape(points,(2,n))
      #the exterior rectangle
      xmin=minimum(points[1,:]);
      xmax=maximum(points[1,:])
      ymin=minimum(points[2,:]);
      ymax=maximum(points[2,:])
      im=im_PA[Int.(ymin:ymax),Int.(xmin:xmax)]
      textures[ind]=Texture(1, im )
      textures[ind]=Texture(3,im_PA )
      
end

n=ind
textures = textures[randperm(length(textures))]
n_train=Int(round(0.75*n))
n_test=n-n_train
textures_train = textures[1:n_train]
textures_test  = textures[n_train:n]

return textures, textures_train, textures_test
end










#= To extract cordinates in the file
function extract_cords_text_file( numbers)

  inds=Array{CartesianIndex{2},1}()
  num=Array{Any,1}()
    
  # Remove the blank spaces
      for i=1 : length(numbers)
       
        if (numbers[i]=="" )
          continue
        else
          push!(num,numbers[i])
        end
    
      end
      
      #num=reverse(num, dims=1);
      
    for i= 4:2: Int((length(num)))  push!(inds, CartesianIndex(num[i] , num[i-1] )) end
    
    return inds
    
end
    =#






 

    