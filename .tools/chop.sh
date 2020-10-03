mkdir ../.splitcap -p

for file in ../.screencap/*.png
do
filename=$(basename -- "$file")
filename="${filename%.*}"

convert -crop 3840x2160 $file ../.splitcap/$filename-%d.png
done

