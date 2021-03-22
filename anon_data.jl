using Images
using ImageView
using ImageDraw
using DelimitedFiles

#get file extension
#function gfe(filename)
 #   return filename[findlast(isequal('.'),filename):end]
#end

#get file name
gfn(path) = splitext(basename(path))[1]
gfe(path) = splitext(basename(path))[2]

root_path="C://Users//HP//Desktop//alternativeproject//hodnocenisonoobrzk//Haralickovy_priznaky//Sono_zakreslene_polygony//"

dir=root_path*"Kontrolni_soubor//"
sdir="C://Users//HP//Desktop//testControls//"

dir=root_path*"EH//"
sdir="C://Users//HP//Desktop//testEH//"

dir=root_path*"PA//"
sdir="C://Users//HP//Desktop//testPA//"


# This section of code extracts bmps and texts from the subfolders in "dir//" and saves them in pairs
# anonymously numbered at the location-> "sdir//"
# It also saves the files and their anonymous numbered in .txt (see at line 60)

rd=readdir(dir)
c=0;
numbers=[];
for i =1: length(rd)
    println(rd[i])
    files=readdir(dir*rd[i])
    f_bmp=filter(x -> endswith(x, ".bmp"), files)
    f_txt=filter(x -> endswith(x, ".txt"), files)
     println(files)
     push!(numbers, rd[i])
    for ii=1: length(f_txt)
        for jj=1: length(f_bmp)

            if gfn(f_txt[ii])== gfn(f_bmp[jj])
            
              c=c+1
               a=[c   gfn(f_txt[ii])]
               push!(numbers, a  )
             # push!(numbers, gfn(f_txt[ii]))
              

              save(sdir*"$c.bmp", load(dir*rd[i]*"//"*f_bmp[ii])) 
              cp(dir*rd[i]*"//"*f_txt[ii], sdir*"$c.txt", force=true);

            end
        end
         
    end
    
    writedlm("PA.txt", numbers)
   
end

# For renumbering (in order ) the image files in the folder after deleting (manually) the files 
# which are not required (e.g.. text in ultrasound region/ signal displayed in ultrasound region too far)

src_dir="C://Users//HP//Desktop//testPA//"
dest_dir="C://Users//HP//Desktop//HyperTension//PA//"
ff=readdir(src_dir)
f_bmp=filter(x -> endswith(x, ".bmp"), ff)
f_txt=filter(x -> endswith(x, ".txt"), ff)

for ii=1: length(f_bmp)
             
            save(dest_dir*"$ii.bmp", load(src_dir*"//"*f_bmp[ii])) 
            cp(src_dir*"//"*f_txt[ii], dest_dir*"$ii.txt", force=true);
end
     













