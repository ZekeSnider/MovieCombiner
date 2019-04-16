# Movie Combiner

## About
This Mac Application makes it easy to combine multi-part movies into one file using ffmpeg. If you've ever downloaded a movie that has multiple parts like:

Movie-part1.mp4
Movie-part2.mp4
Movie-part3.mp4

This makes it faster to convert it to just Movie.mp4.

## Setup
1. You must have ffmpeg installed.
2. Run the Application.

## Usage

Choose the first part of the movie you would like to combine. It must be named in the format of: ... 

There are two options for combining videos, using video filter or demuxer. These options are detailed on the [ffmpeg wiki](https://trac.ffmpeg.org/wiki/Concatenate). Generally, you will want to use video filter if it's compatible because it's much faster, although less flexible. Otherwise, use demuxer.

When you click "Combine", a file will be written to the directory in which the file exists, and you will be prompted to copy the ffmpeg command to your clipboard. Open terminal, paste the command, and hit enter. The files will start combining. Afterwards, **verify that the output file is complete** before the deleting the originals. You may also delete the compilation text file.

There is also an option to trim the video, if you wish to cut out something from it.
