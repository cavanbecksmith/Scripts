
cd "/home/user"

# RESOLUTION
# -s 640x512

ffmpeg -i "2021-08-23 21-09-53.mkv" -r 24  -c:v libx264 -ac 2 -c:a aac -strict -2 -b:a 128k -crf 28 -acodec mp2 "video_output.mp4"

# VERY SLOW COMPRESSION
# ffmpeg -i "2021-08-23 21-09-53.mkv" -c:v libx264 -crf 18 -preset veryslow -c:a copy "/home/user/Videos/cs_comp.mp4"

# BEST WORKING
# ffmpeg -i "2021-08-23 21-09-53.mkv" -codec copy /home/user/Videos/cs.mp4


# ffmpeg -i input.mkv -vf "scale=iw/2:ih/2" -c:v libx265 -crf 28 half_the_frame_size.mkv
# ffmpeg -i "2021-08-23 21-09-53.mkv" -vf "scale=iw/2:ih/2" -c:v libx265 -crf "csgo_compressed.mkv"


# Reduce File size
# ffmpeg -i cs.mp4 -b 8507k cs1.mp4