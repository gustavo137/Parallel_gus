!  Copyright 2014 NVIDIA Corporation
!  
!  Licensed under the Apache License, Version 2.0 (the "License");
!  you may not use this file except in compliance with the License.
!  You may obtain a copy of the License at
!  
!      http://www.apache.org/licenses/LICENSE-2.0
!  
!  Unless required by applicable law or agreed to in writing, software
!  distributed under the License is distributed on an "AS IS" BASIS,
!  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!  See the License for the specific language governing permissions and
!  limitations under the License.

program mandelbrot_main
use mandelbrot_mod
implicit none
integer, parameter   :: NUM_BLOCKS=8
integer(1) :: image(HEIGHT, WIDTH)
integer :: iy, ix
integer :: block, block_size, block_start
integer :: starty, endy
real :: startt, stopt

block_size = (HEIGHT*WIDTH)/NUM_BLOCKS

image = 0
call cpu_time(startt)
!$acc data copy(image(1:HEIGHT, 1:WIDTH))
!$acc parallel loop
do iy=1,WIDTH
  do ix=1,HEIGHT
    image(ix,iy) = min(max(int(mandelbrot(ix-1,iy-1)),0),MAXCOLORS)
  enddo
enddo
!$acc end data
call cpu_time(stopt)

print *,"Time:",(stopt-startt)

call write_pgm(image,'image.pgm')
end
