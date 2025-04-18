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
use openacc
implicit none
integer, parameter   :: NUM_BLOCKS=8
integer(1), ALLOCATABLE :: image(:,:)
integer :: iy, ix
integer :: block, block_size, block_start
integer :: starty, endy
real :: startt, stopt

block_size = (HEIGHT*WIDTH)/NUM_BLOCKS
allocate(image(1:HEIGHT, 1:WIDTH))
image = 0

call acc_init(acc_device_nvidia)

call cpu_time(startt)
!$acc data create(image(1:HEIGHT, 1:WIDTH))
do block=0,(num_blocks-1)
  starty = block  * (WIDTH/NUM_BLOCKS) + 1
  endy   = min(starty + (WIDTH/NUM_BLOCKS), WIDTH)
  !$acc parallel loop
  do iy=starty,endy
    do ix=1,HEIGHT
      image(ix,iy) = min(max(int(mandelbrot(ix-1,iy-1)),0),MAXCOLORS)
    enddo
  enddo
  !$acc update self(image(:,starty:endy))
enddo
!$acc end data
call cpu_time(stopt)

print *,"Time:",(stopt-startt)

call write_pgm(image,'image.pgm')

deallocate(image)
end
