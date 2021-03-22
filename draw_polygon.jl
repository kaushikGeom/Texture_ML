

#using Main.HyperTension
using TimerOutputs
timer = TimerOutput()
using StatsBase
using  FileIO
using Plots
using LinearAlgebra
using DelimitedFiles
using ImageDraw
using Images, ImageView
include("utilities.jl")




# This part of code displays polygon on bmps by obtaining coordinates of the polygons from txt files 

root_path="C://Users//HP//Desktop//HyperTension//"
path=root_path*"controls"
path=root_path*"EH"
path=root_path*"PA"

rd=readdir(path)
f=0;
for f =1: Int(length(rd))

path_bmp=joinpath(path,"$f.bmp")
img=load(path_bmp);
img_crop=img[60:499, 121:560] #59:498,122:561
#img=img[60:466, 121:560]
path_txt=joinpath(path,"$f.txt")
inds =readdlm(path_txt, skipstart=2);
n=div(length(inds),2)
inds=reshape(inds,(2,n))
p=Polygon([Point(inds[1,i],inds[2,i]) for i=1:n])

#p=Polygon(inds) 
display(draw!(img_crop, p,colorant"yellow"))
#save("C://Users//HP//Desktop//HyperTension//Poly_EH//$f.bmp", img_crop)
save("C://Users//HP//Desktop//HyperTension//Poly_PA//$f.bmp", img_crop)
#save("C://Users//HP//Desktop//HyperTension//Poly_controls//$f.bmp", img_crop)


end

# This part of the code picks the white dots and replace them with the neighbouring pixel intensities

#im=load("C://Users//HP//Desktop//HyperTension//crop_controls_92//20.bmp") # pick any image to get the positions
# of white dots
rmind=Array{CartesianIndex{2},1}()
n1=45; n2=154; n3=264;n4=376;


rmind=[CartesianIndex(14, n1),  CartesianIndex(219, n1), CartesianIndex(330, n1),
       CartesianIndex(109, n1), CartesianIndex(13, n2),  CartesianIndex(60, n2),  
       CartesianIndex(108, n2), CartesianIndex(169, n2), CartesianIndex(223, n2), 
       CartesianIndex(281, n2),  CartesianIndex(333, n2), CartesianIndex(391, n2),
       CartesianIndex(14, n3),  CartesianIndex(108, n3),  CartesianIndex(221, n3), 
       CartesianIndex(331, n3), CartesianIndex(13, n4),   CartesianIndex(108, n4), 
       CartesianIndex(220, n4), CartesianIndex(334, n4) ]


path_c="C://Users//HP//Desktop//HyperTension//process_controls_88//"
path_c="C://Users//HP//Desktop//HyperTension//process_EH_50//"
path_c="C://Users//HP//Desktop//HyperTension//process_PA_117//"

rd=readdir(path_c)
win=3; # neighbour window=winxwin
    # To remove white dots in a pattern at ind
    for f =1: Int(length(rd))
        path_bmp=joinpath(path_c,"$f.bmp")
        im=load(path_bmp);
        # Pick the neighbouring pixels around ind
         for ii=1 : length(rmind)
             index= Tuple(rmind[ii])
             win1=win
               for k=-win1: win1
                    for l=-win1: win1
                     
                          im[index[1]+k+1, index[2]+l+1] = StatsBase.mean(im[index[1]-win:2:index[1]+win, index[2]-win:2:index[2]-win])              
                      
                    end
               end

               
        end
                            
        #save("C://Users//HP//Desktop//HyperTension//controls//$f.bmp", im)  
        #save("C://Users//HP//Desktop//HyperTension//EH//$f.bmp", im)  
        save("C://Users//HP//Desktop//HyperTension//PA//$f.bmp", im)   

    end
    





